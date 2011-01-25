// Copyright (C) 2011 European Central Bank. All rights reserved.
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
	import eu.ecb.core.util.helper.SeriesColors;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	import mx.containers.HBox;
	import mx.controls.CheckBox;
	import mx.controls.VRule;
	
	import org.sdmx.model.v2.base.LocalisedString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	
	/**
	 * This component displays codes for certain dimension and supports
	 * filtering according to given dimension. It is visually represented as
	 * as check box.
	 *  
	 * @author Rok Povse
	 */
	public class CheckBoxDimensionFilter extends DimensionFilter
	{
		/*==============================Fields================================*/
		
		private var _checkBoxes:ArrayCollection;
		private var _checkBoxesContainers:ArrayCollection;
		private var _coloredCheckboxes:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function CheckBoxDimensionFilter(direction:String="vertical")
		{
			super(direction);
			_checkBoxes = new ArrayCollection();
			_checkBoxesContainers = new ArrayCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function get allowMultipleSelection():Boolean{
			return true;
		}
		
		
		/**
		 * Whether a vertical color bar should be added to the checkbox, 
		 * thereby making it act as a legend.
		 *  
		 * @param value
		 */
		public function set colouredCheckBoxes(value:Boolean):void {
			_coloredCheckboxes = value;
		}		
		
		/*==========================Protected methods========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function drawComponent(codes:CodeList,
			displayCodes:ArrayCollection):void {				
			addCheckBoxesWithItems(codes,displayCodes);
		}
		
		/**
		 * Cleans the LinkBar or Checkboxes
		 */ 
		override protected function cleanAll():void 
		{
			//clean all checkboxes
			if (_checkBoxes.length > 0) {
					
				for each (var cb:CheckBox in _checkBoxes) {
					cb.removeEventListener(MouseEvent.CLICK,
						checkBoxClickHandler);
				}
				
				for each (var container:Box in _checkBoxesContainers) {
					cb.removeEventListener(MouseEvent.CLICK,
						checkBoxClickHandler);
					container.removeAllChildren();
					this.removeChild(container);
				}
				
				_checkBoxes.removeAll();
				_checkBoxesContainers.removeAll();
			}			
		}
		
		/*===========================Private methods==========================*/
		
		/**
		 * Adds checkboxes representing displayedCodes
		 */ 
		private function addCheckBoxesWithItems(codes:CodeList,
		 displayCodes:ArrayCollection = null):void {
			
			var checkBox:CheckBox;
			var index:uint = 0;
			
			for each (var displayedCode:String in displayCodes) {
				var code:Code = codes.codes.getCode(displayedCode);
		
				if (code != null) {
					var container:Box = new HBox();		
					container.setStyle("verticalAlign","middle");
					
					checkBox = new CheckBox();
					checkBox.label = (code.description.
						localisedStrings.getItemAt(0) as LocalisedString).label;
					checkBox.styleName = "textBox";
					checkBox.addEventListener(MouseEvent.CLICK,
						checkBoxClickHandler,false,0,true);
					
					if (_selectedCodes.contains(displayedCode)) {
						checkBox.selected = true;
					}
					
					if (_coloredCheckboxes) {
						
						//TODO: coloring should rely on series key rather than
						//indexes in case the series are sorted differently
						var codeColor:uint = SeriesColors.getColors().
						getItemAt(index) as uint;
						
						var verticalLine:VRule = new VRule();
						verticalLine.setStyle("strokeColor",codeColor);
						verticalLine.setStyle("shadowColor",codeColor);
						verticalLine.opaqueBackground = codeColor;
						verticalLine.setStyle("strokeWidth",4);
						verticalLine.height=19;
						container.addChild(verticalLine);
					}
					
					_checkBoxes.addItem(checkBox);
					container.addChild(checkBox);
					_checkBoxesContainers.addItem(container);
					
					this.addChild(container);
					
					index++;
				}
				else {
					throw new ArgumentError("Unknown code " + displayedCode);
				}
			}
		}
		
		private function checkBoxClickHandler(event:MouseEvent):void {
			event.stopImmediatePropagation();
			
			_selectedCodes = new ArrayCollection();
			
			for (var i:int=0;i<_checkBoxes.length;i++) {
				if ((_checkBoxes.getItemAt(i) as CheckBox).selected) {
					_selectedCodes.addItem(_displayedCodes.getItemAt(i));
				}
			}
			
			if (_selectedCodes.length == 0) {
				_selectedCodes.addItem(_displayedCodes.getItemAt(
					_checkBoxes.getItemIndex(event.currentTarget as CheckBox)));
				(event.currentTarget as CheckBox).selected = true;
			}
			else {
				dispachFilterEvent();
			}
		}
	}
}