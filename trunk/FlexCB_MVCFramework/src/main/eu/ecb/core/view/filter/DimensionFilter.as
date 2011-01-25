// Copyright (C) 2010 European Central Bank. All rights reserved.
//
// Redistribution and use in source and binary forms,
// with or without modification, are permitted
// provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// Neither the name of the European Central Bank
// nor the names of its contributors may be used to endorse or promote products
// derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
package eu.ecb.core.view.filter
{
	import eu.ecb.core.view.BaseSDMXView;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.CheckBox;
	import mx.controls.Label;
	import mx.controls.LinkBar;
	import mx.controls.LinkButton;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.ItemClickEvent;
	
	import org.sdmx.model.v2.base.LocalisedString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	
	/**
	 * 
	 * Event triggered when a item has been selected or unselected
	 * 
	 * @eventType eu.ecb.core.view.filter.PeriodZoomBox.DIMENSION_FILTER_CHANGED
	 */
	[Event(name="dimensionFilterUpdated", type="flash.events.Event")]

	/**
	 * This component displays codes for certain dimension and supports
	 * filtering according to given dimension. The component can have
	 * different representations (i.e. LinkBar for exclusive selection
	 * and Checkboxes for multiple items selection). What items component
	 * displays can be controlled via displayed Codes and selected Codes.
	 *  
	 * @author Rok Povse
	 */
	public class DimensionFilter extends BaseSDMXView implements IDimensionFilter
	{
		
		/*=============================Constants==============================*/
		
		/**
		 * The PeriodZoomBox.DIMENSION_FILTER_UPDATED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>dimensionFilterUpdated</code> event.
		 * 
		 * @eventType dimensionFilterUpdated
		 */  
		public static const DIMENSION_FILTER_UPDATED:String = 
			"dimensionFilterUpdated";
			
		/**
		 * Constant REPRESENTATION_TYPE_LINKBAR representet a link bar
		 * component representation
		 */ 
		public static const REPRESENTATION_TYPE_LINKBAR:String = "linkbar";
		
		/**
		 * Constant REPRESENTATION_TYPE_LINKBAR representet a link bar
		 * component representation
		 */ 
		public static const REPRESENTATION_TYPE_CHECKBOX:String = "checkbox";
		
		/*==============================Fields===============================*/

		/**
		 * @private
		 */ 		
		protected var _selectedCodes:ArrayCollection;
		
		/**
		 * @private
		 */ 
		protected var _displayedCodes:ArrayCollection;
		
		/**
		 * @private
		 */
		protected var _dimensionId:String;
		
		private var _displayedCodesChanged:Boolean;
		private var _codeList:CodeList;		
		private var _label:Label;
		private var _labelText:String;		
		private var _updateDisplayCodes:Boolean;
		
		/*===========================Constructor=============================*/
		
		public function DimensionFilter(direction:String="vertical")
		{
			super(direction);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function set dimensionId(id:String):void
		{
			_dimensionId = id;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get dimensionId():String
		{
			return _dimensionId;
		}
				
		/**
		 * @inheritDoc
		 */  
		public function set displayedCodes(codes:ArrayCollection):void
		{
			if (_updateDisplayCodes) {
				_displayedCodes = new ArrayCollection(codes.toArray());
				_selectedCodes = new ArrayCollection(_displayedCodes.toArray());
				_displayedCodesChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */  
		public function get displayedCodes():ArrayCollection
		{
			return _displayedCodes;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set selectedCodes(codes:ArrayCollection):void
		{
			_selectedCodes = new ArrayCollection(codes.toArray());
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get selectedCodes():ArrayCollection
		{
			return _selectedCodes;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get allowMultipleSelection():Boolean{
			throw new ArgumentError("This method must be implemented by " + 
					"subclasses");
		}
		
		/**
		 * @inheritDoc
		 */
		public function set labelText(value:String):void {
			_labelText = value;
			
			if (_label != null) {
				_label.text = _labelText;
				
				if (_label.text == null || _label.text == "") {
					_label.includeInLayout = false;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function set updateDisplayCodes(value:Boolean):void {
			_updateDisplayCodes = value;
		}
		
		/*==========================Protected methods========================*/
		
		/**
		 * @inheritDoc
		 */ 		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			setStyle("paddingLeft","0");
			setStyle("verticalAlign","middle");
			
			_label = new Label();
			_label.styleName="textSummaryTitle";
			_label.text = _labelText;
			
			this.addChild(_label);
			
			if (_label.text == null || _label.text == "") {
				_label.includeInLayout = false;
			}
		}
		
		/**
		 * inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_keyFamiliesChanged) {
				_keyFamiliesChanged=false;
				
				_codeList = getCodeListForDimension();
					
				if (_displayedCodes == null) {
					
					_displayedCodes = new ArrayCollection();
					
					for each (var c:Code in _codeList.codes) {		
						_displayedCodes.addItem(c.id);
					}	
				}
				
				cleanAll();
				drawComponent(_codeList,_displayedCodes);
			}
			
			if (_displayedCodesChanged) {
				_displayedCodesChanged = false;
				
				if (_codeList != null) {
					
					cleanAll();
					drawComponent(_codeList,_displayedCodes);
				}
			}
		}
		
		/**
		 * Adds a new component based on full CodeList and codes to display
		 */ 
		protected function drawComponent(codes:CodeList,
			displayCodes:ArrayCollection):void {
			throw new ArgumentError("This method must be implemented by" + 
					" subclasses");	
		}
		
		/**
		 * Returns the Dimension object according to specified KeyFamily and
		 * Dimension id
		 */ 
		protected function findDimensionByDimensionId(kf:KeyFamily, id:String):Dimension {
			var found:Boolean;
			var dim:Dimension;
			
			for each (dim in kf.keyDescriptor) {
				if (dim.id ==  id) {
					found = true;
					break;
				}
			}
			
			return dim;
		}
		
		/**
		 * Dispatches new filter event
		 */ 
		protected function dispachFilterEvent():void {
			dispatchEvent(new Event(DIMENSION_FILTER_UPDATED,true, false));
		}
		
		/**
		 * Cleans the LinkBar or Checkboxes
		 */ 
		protected function cleanAll():void 
		{
			new ArgumentError("This method must be implemented by subclasses");
		}
		
		/*==========================Private methods========================*/
		
		/**
		 * Returns the codeList for specified dimension 
		 */
		private function getCodeListForDimension():CodeList {
			
			var items:ArrayCollection = new ArrayCollection();
			var kf:KeyFamily = _keyFamilies.getItemAt(0) as KeyFamily;
			
			
			var dim:Dimension = findDimensionByDimensionId(kf,_dimensionId);
			if (dim == null) {
				throw new ArgumentError("Could not find dimension " +
				 dimensionId + " in KeyFamily " + kf.id);
			}
			
			return dim.localRepresentation as CodeList;;
		}
	}
}