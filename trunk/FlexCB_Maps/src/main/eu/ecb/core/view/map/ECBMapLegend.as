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
package eu.ecb.core.view.map
{
	import eu.ecb.core.util.helper.EUCountries;
	
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.controls.Label;
	import mx.core.IToolTip;
	import mx.core.UIComponent;
	import mx.managers.ToolTipManager;
	import mx.styles.StyleManager;
	
	import org.sdmx.model.v2.reporting.dataset.CodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.UncodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.reporting.dataset.XSObservation;
	
	/**
	 * The legend for ECB visualisation tools that display country data on a map
	 * of the European Union.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class ECBMapLegend extends BaseMapComponent
	{
		/*==============================Fields================================*/
		private var _grid:Grid;
		private var _obsPerCategory:Object;
		private var _euCountries:EUCountries;
		private var _toolTip:IToolTip;
		private var _displayEuroAreaData:Boolean;
		private var _displayEUData:Boolean;
		private var _displayUSData:Boolean;
		private var _euroAreaObs:XSObservation;
		private var _euObs:XSObservation;
		private var _usObs:XSObservation;
		private var _minEuroAreaObs:XSObservation;
		private var _maxEuroAreaObs:XSObservation;
		private var _euroAreaCode:String;
		private var _referenceValue:String;
		private var _useAbsoluteValue:Boolean;
		private var _euroAreaOnly:Boolean;
		private var _euroAreaMinMaxOnly:Boolean;
		private var _euroAreaOnlyChanged:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function ECBMapLegend(direction:String="vertical")
		{
			super(direction);
			_euCountries = EUCountries.getInstance();
			_displayEuroAreaData = true;	
			_displayEUData = true;
			_displayUSData = true;
			_euroAreaCode = "U2";	
			_euroAreaMinMaxOnly = true;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Whether a label with euro area data should be displayed.
		 * 
		 * @param flag 
		 */		
		public function set displayEuroAreaData(flag:Boolean):void
		{
			_displayEuroAreaData = flag;
		}
		
		/**
		 * Whether a label with european union data should be displayed.
		 * 
		 * @param flag 
		 */ 
		public function set displayEUData(flag:Boolean):void
		{
			_displayEUData = flag;
		}
		
		/**
		 * Whether a label with US data should be displayed.
		 * 
		 * @param flag 
		 */ 
		public function set displayUSData(flag:Boolean):void
		{
			_displayUSData = flag;
		}
		
		/**
		 * The code used for the euro area (U2, I5, etc).
		 * 
		 * @param code 
		 */
		public function set euroAreaCode(code:String):void
		{
			_euroAreaCode = code;
		}
		
		/**
		 * The reference value to be added in the legend.
		 * 
		 * @param value 
		 */
		public function set referenceValue(value:String):void
		{
			_referenceValue = value;
		}
		
		/**
		 * Whether or not the absolute value of the observation should be used
		 * when finding minimum and maximum values.
		 */ 
		public function set useAbsoluteValue(flag:Boolean):void
		{
			_useAbsoluteValue = flag;
		}
		
		/**
		 * Whether only euro area countries should be displayed or all countries
		 * of the European Union. Default to false.
		 */ 
		public function set euroAreaOnly(flag:Boolean):void
		{
			_euroAreaOnly = flag;
			if (null != _dataSet) {
				_dataSetChanged = true;
				commitProperties();
			}
		}
		
		/**
		 * Whether only  the minimum and maximum values of the euro area 
		 * countries should be displayed. Defaults to true; 
		 */ 
		public function set euroAreaMinMaxOnly(flag:Boolean):void
		{
			_euroAreaMinMaxOnly = flag;
			if (null != _dataSet) {
				_dataSetChanged = true;
				commitProperties();
			}
		}
		
		/*===========================Public methods===========================*/
		
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
			_dataSetChanged = true;
			commitProperties();
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitProperties():void
		{
			if (_dataSetChanged) {
				_dataSetChanged = false;
				
				if ((_dataSet as XSDataSet).groups.length > 1) {
					throw new ArgumentError("This cross-sectional view cannot" + 
						" handle more than one period at a time");
				} else if ((_dataSet as XSDataSet).groups.length == 0) {
					throw new ArgumentError("No data to be displayed");
				} else if (((_dataSet as XSDataSet).groups.getItemAt(0) as 
					XSGroup).sections.length > 1) {
					throw new ArgumentError("This cross-sectional view cannot" + 
						" handle more than one indicator at a time");
				} else if (((_dataSet as XSDataSet).groups.getItemAt(0) as 
					XSGroup).sections.length == 0) {
					throw new ArgumentError("No data to be displayed");	
				} else if ((((_dataSet as XSDataSet).groups.getItemAt(0) as 
					XSGroup).sections.getItemAt(0) as Section).observations.
					length == 0) {
					throw new ArgumentError("No data to be displayed");
				}
				_obsPerCategory = new Object();
				if (null == _helper) {
					throw new ArgumentError("The map component helper cannot " + 
						"be null");
				}
				var minValue:Number;
				var maxValue:Number;	
				_minEuroAreaObs = null;
				_maxEuroAreaObs = null;
				_euObs = null;
				_euroAreaObs = null;
				_usObs = null;
				for each (var obs:XSObservation in (((_dataSet as 
					XSDataSet).groups.getItemAt(0) as XSGroup).sections.
					getItemAt(0) as Section).observations) {
					var countryCode:String;
					if (obs is UncodedXSObservation) {
						countryCode = 
							(obs as UncodedXSObservation).measure.code.id; 
					} else if (obs is CodedXSObservation) {
						countryCode = 
							(obs as CodedXSObservation).measure.code.id;
					}
					if (null == countryCode) {
						throw new ArgumentError("Reference area code not" + 
							" found");
					}
					if (_displayEuroAreaData && countryCode == _euroAreaCode) {
						_euroAreaObs = obs;
					}
					if (_displayEUData && countryCode == "D0") {
						_euObs = obs;
					}
					if (_displayUSData && countryCode == "US") {
						_usObs = obs;
					}
					if ((_euroAreaOnly && _euCountries.belongsToEuroArea(
						countryCode, _selectedDate)) || (!_euroAreaOnly && 
						_euCountries.belongsToEuropeanUnion(countryCode))) {
						var realValue:Number = Number(getObsValue(obs));
						var cmpValue:Number = _useAbsoluteValue ?  
							Math.abs(realValue) : realValue;  
						var category:MapCategory = 
							_helper.getCategory(realValue);
						if (!(_obsPerCategory.hasOwnProperty(
							category.styleName))){
							_obsPerCategory[category.styleName] = new Object();
							_obsPerCategory[category.styleName]["count"] = 0;
							_obsPerCategory[category.styleName]["countries"] =
								new ArrayCollection();
						}	
						_obsPerCategory[category.styleName]["count"]++;
						(_obsPerCategory[category.styleName]["countries"] as
							ArrayCollection).addItem(getCountryName(obs));	
						if (_displayEuroAreaData && ((_euroAreaMinMaxOnly &&
							_euCountries.belongsToEuroArea(countryCode, 
							_selectedDate)) || (!_euroAreaMinMaxOnly && 
							_euCountries.belongsToEuropeanUnion(countryCode))) 
							&& (isNaN(minValue) || minValue > cmpValue)) {
							minValue = cmpValue;	
							_minEuroAreaObs = obs;	
						}
						if (_displayEuroAreaData && ((_euroAreaMinMaxOnly &&
							_euCountries.belongsToEuroArea(countryCode, 
							_selectedDate)) || (!_euroAreaMinMaxOnly && 
							_euCountries.belongsToEuropeanUnion(countryCode)))
							&& (isNaN(maxValue) || maxValue < cmpValue)) {
							maxValue = cmpValue;	
							_maxEuroAreaObs = obs;	
						}				
					}	
				}	
				removeAllChildren();
				_grid = new Grid();	
				_grid.width = 159;	
				_grid.styleName = "mapLegend";
				addChild(_grid);
				createHeaderCell("Legend", "Countries");
				createDataCells();
				
				if (null != _referenceValue) {
					_grid.addChild(createLegendRow("Reference value: " + 
							_referenceValue + (_isPercentage ? "%" : "")));
				}
				
				if (_displayEuroAreaData) {
					if (null != _euroAreaObs) {
						_grid.addChild(createLegendRow("Euro area: " + 
							getObsValue(_euroAreaObs) + 
							((_isPercentage) ? "%" : "") + 
							((_displayEUData && null != _euObs) ? 
							" (EU: " + getObsValue(_euObs) + ((_isPercentage) ? 
							"%" : "") + ")" : "")));
					}
					
					if (null != _minEuroAreaObs) {
						_grid.addChild(createLegendRow("Min.: "  
							+ getObsValue(_minEuroAreaObs) + 
							((_isPercentage) ? "%" : "") + " (" +
							getCountryName(_minEuroAreaObs) + ")", 7));
					}
					
					if (null != _maxEuroAreaObs) {
						_grid.addChild(createLegendRow("Max.: " 
							+ getObsValue(_maxEuroAreaObs) + 
							((_isPercentage) ? "%" : "") + " (" + 
							getCountryName(_maxEuroAreaObs) + ")", 7));
					}
				}
				
				if (_displayUSData) {
					_grid.addChild(createLegendRow((null == _usObs) ? "" : 
						"USA: " + getObsValue(_usObs) + 
						((_isPercentage) ? "%" : "")));
				}					 
			}
		}
		
		/*==========================Private methods===========================*/
		
		private function createHeaderCell(string1:String, string2:String):void
		{
			var row:GridRow = new GridRow();
			//row.width = 153;
			row.styleName = "mapLegendHeader";
			
			var item1:GridItem = new GridItem();
			var label1:Label = new Label();
			label1.text = string1;
			item1.addChild(label1);
			row.addChild(item1);
			
			var item2:GridItem = new GridItem();
			var label2:Label = new Label();
			label2.text = string2;
			item2.addChild(label2);
			row.addChild(item2);
			
			_grid.addChild(row);
		}
		
		private function createDataCells():void
		{
			
			for each (var category:MapCategory in _helper.categories) {
				var row:GridRow = new GridRow();
				row.styleName = "mapLegendCell";
			
				var item1:GridItem = new GridItem();
				var uicomponent:UIComponent = new UIComponent();
					
				uicomponent.graphics.beginFill(uint(StyleManager.
					getStyleDeclaration("." + 
					category.styleName).getStyle("fill")));
				uicomponent.graphics.drawCircle(6, 8, 4);
				item1.addChild(uicomponent);
					
				var label1:Label = new Label();
				label1.text = category.label;
				label1.setStyle("paddingLeft", 5);
				item1.addChild(label1);
				row.addChild(item1);
				
				var item2:GridItem = new GridItem();
				item2.id = category.styleName;
				item2.setStyle("horizontalAlign", "center");
				item2.addEventListener(MouseEvent.MOUSE_OVER, 
					handleMouseOverTitle);
				item2.addEventListener(MouseEvent.MOUSE_OUT, 
					handleMouseOutTitle);
				var label2:Label = new Label();
				label2.text = 
					_obsPerCategory.hasOwnProperty(category.styleName) ? 
						_obsPerCategory[category.styleName]["count"] : "0";
				item2.addChild(label2);
				row.addChild(item2);
				
				_grid.addChild(row);
			}
		}
		
		private function handleMouseOverTitle(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			if (_obsPerCategory.hasOwnProperty(event.currentTarget.id) && 
				0 < (_obsPerCategory[event.currentTarget.id]["countries"] as 
				ArrayCollection).length) {
				var text:String = "";
				for each (var country:String in 
					_obsPerCategory[event.currentTarget.id]["countries"]) {
					text = text + country + ", ";
				}
				text = text.substring(0, text.length - 2);
				_toolTip = ToolTipManager.createToolTip(text, event.stageX, 
					event.stageY);	
			}
			event = null;
		}
		
		private function handleMouseOutTitle(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event = null;
			if (null != _toolTip) {
				ToolTipManager.destroyToolTip(_toolTip);
				_toolTip = null;
			}
		}
		
		private function getObsValue(obs:XSObservation):String
		{
			return ((obs is UncodedXSObservation) ? 
				(obs as UncodedXSObservation).value :
				(obs as CodedXSObservation).value.id);
		}
		
		private function getCountryName(obs:XSObservation):String
		{
			return ((obs is UncodedXSObservation) ? 
						(obs as UncodedXSObservation).measure.code.description.
							localisedStrings.getDescriptionByLocale("en") : 
						(obs as CodedXSObservation).measure.code.description.
							localisedStrings.getDescriptionByLocale("en"));
		}
		
		private function createLegendRow(text:String, padding:uint = 0):GridRow
		{
			var row:GridRow = new GridRow();
			row.styleName = "mapLegendCell";
			var gridItem:GridItem = new GridItem();
			var label:Label = new Label();
			label.text = text;
			if (0 != padding) {
				label.setStyle("paddingLeft", padding);
			} 
			gridItem.addChild(label);
			gridItem.colSpan = 2;
			row.addChild(gridItem);
			return row;
		}
	}
}