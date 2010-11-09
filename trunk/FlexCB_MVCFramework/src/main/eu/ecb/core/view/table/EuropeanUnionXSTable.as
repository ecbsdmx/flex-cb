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
package eu.ecb.core.view.table
{
	import eu.ecb.core.event.XSMeasureSelectionEvent;
	import eu.ecb.core.util.helper.EUCountries;
	
	import flash.events.DataEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.ListEvent;
	
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.SectionsCollection;
	import org.sdmx.model.v2.reporting.dataset.UncodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.reporting.dataset.XSGroupsCollection;
	import org.sdmx.model.v2.reporting.dataset.XSObservationsCollection;
	
	/**
	 * A table containing cross-sectional data, with one row per country
	 * of the European Union.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class EuropeanUnionXSTable extends XSTable
	{
		/*==============================Fields================================*/
		
		private var _euCountries:EUCountries;
		private var _statusBar:Label;
		private var _euroAreaOnly:Boolean;
		private var _euroAreaOnlyChanged:Boolean;
		private var _fullXSDataSet:XSDataSet;
		
		/*===========================Constructor==============================*/
		
		public function EuropeanUnionXSTable(direction:String="vertical")
		{
			super(direction);
			_euCountries = new EUCountries();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Whether the table should display euro area countries only.
		 */ 
		public function set euroAreaOnly(flag:Boolean):void
		{
			_euroAreaOnly = flag;
			if (null != _dataSet) {
				_euroAreaOnlyChanged = true;
				commitProperties();
			}
		}
		
		/**
		 * Whether the fixed euro area composition should be used.
		 */ 
		public function set useFixedEuroAreaComposition(flag:Boolean):void
		{
			_euCountries.useFixedEuroAreaComposition = flag;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Handles the event that specifies whether only the euro area countries
		 * should be displayed. 
		 * 
		 * @param event 
		 */
		public function handleEuroAreaOnlyUpdated(event:DataEvent):void
		{
			var flag:Boolean = (event.data == "true") ? true : false;
			_euroAreaOnly = flag;
			_euroAreaOnlyChanged = true;
			commitProperties();
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (null == _statusBar) {
				_statusBar = new Label();
				_statusBar.text = "(*) Euro area country"; 
				addChild(_statusBar);
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitProperties():void
		{
			if (_dataSetChanged) {
				_fullXSDataSet = _dataSet as XSDataSet;
				if (_euroAreaOnly) {
					_dataSet = createFilteredXSDataSet();
				}
			}
			if (_euroAreaOnlyChanged) {
				_euroAreaOnlyChanged = false;
				_dataSet = 
					_euroAreaOnly ? createFilteredXSDataSet() : _fullXSDataSet;
				_dataSetChanged = true;	
			}
			super.commitProperties();
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function formatIndicator(item:Object, 
			column:DataGridColumn):String 
		{
			var label:String = 
				(_euCountries.belongsToEuroArea(item.measure, _selectedDate)) ?
					item.measureDescription + " * " :
					item.measureDescription; 
			if (item.measure == "D0") {
				label = "European Union";
			}		
			return label; 
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function handleItemSelected(event:ListEvent):void
		{
			event.stopImmediatePropagation();
			if (_measureMap.hasOwnProperty(event.itemRenderer.data.measure) &&
				_euCountries.belongsToEuropeanUnion(event.itemRenderer.data.
				measure)) {
				_dispatchedEvent = new XSMeasureSelectionEvent(
					_measureMap[event.itemRenderer.data.measure]["xsMeasure"], 
					(event.currentTarget as DataGrid).selectedItems.length > 1, 
					"measureSelected");
			} else {
				_dispatchedEvent = null;
			}
			event = null;
		}
		
		private function createFilteredXSDataSet():XSDataSet 
		{
			var tmpDataSet:XSDataSet = new XSDataSet();
			tmpDataSet.groups = new XSGroupsCollection();
			var group:XSGroup = new XSGroup();
			group.keyValues = ((_dataSet as XSDataSet).
				groups.getItemAt(0) as XSGroup).keyValues;
			tmpDataSet.groups.addItem(group);
			group.sections = new SectionsCollection();
			var section:Section = new Section();
			section.keyValues = (((_dataSet as XSDataSet).
				groups.getItemAt(0) as XSGroup).sections.getItemAt(0) as 
				Section).keyValues;
			group.sections.addItem(section);
			section.observations = new XSObservationsCollection();
			for each (var obs:UncodedXSObservation in (((_dataSet as XSDataSet).
				groups.getItemAt(0) as XSGroup).sections.getItemAt(0) as 
				Section).observations) {
				if (_euCountries.belongsToEuroArea(obs.measure.code.id, 
					_selectedDate)) {
					section.observations.addItem(obs);	
				}
			}
			return tmpDataSet;
		}
	}
}