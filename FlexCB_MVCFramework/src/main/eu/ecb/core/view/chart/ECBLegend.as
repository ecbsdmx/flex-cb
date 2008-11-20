// ECB/SIS Public License, version 1.0, document reference SIS/2001/116
//
// Copyright (C) 2008 European Central Bank. All rights reserved.
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
package eu.ecb.core.view.chart
{
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.UncodedAttributeValue;
	import mx.charts.LegendItem;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import eu.ecb.core.util.helper.SeriesColors;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import mx.containers.Box;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import eu.ecb.core.view.SDMXViewAdapter;

	/**
	 * The chart legend
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class ECBLegend extends SDMXViewAdapter
	{
		
		/*==============================Fields================================*/
		
		private var _attributeTitle:String;
		
		private var _alwaysDisplay:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function ECBLegend(direction:String = "vertical")
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */
		public function set attributeTitle(attributeTitle:String):void
		{
			_attributeTitle = attributeTitle;
		}
		
		/**
		 * The id of the attribute to be used for the series title. 
		 */ 
		public function get attributeTitle():String
		{
			if (null == _attributeTitle) {
				_attributeTitle = "TITLE_COMPL";
			}
			return _attributeTitle;
		}
		
		/**
		 * @private
		 */
		public function set alwaysDisplay(alwaysDisplay:Boolean):void
		{
			_alwaysDisplay = alwaysDisplay;
		}
		
		/**
		 * Whether or not the legend should always be displayed. By default,
		 * it will only be displayed if there is more than one series in the
		 * dataset.
		 */ 
		public function get alwaysDisplay():Boolean
		{
			return _alwaysDisplay;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @private
		 */ 
		override protected function commitProperties():void
	 	{
	 		if (_dataSetChanged) {
	 			_dataSetChanged = false;
		 		removeAllChildren();
				if (alwaysDisplay || _dataSet.timeseriesKeys.length > 1) {
					for (var i:uint = 0; i < _dataSet.timeseriesKeys.length; 
						i++) {
						var series:TimeseriesKey = _dataSet.timeseriesKeys.
							getItemAt(i) as TimeseriesKey;
						var titlePos:uint;
						var titleType:uint;
						var titleFound:Boolean;
						var titleGroup:GroupKey;
						if (!(isNaN(titleType)) && titleType ==2) {
							titleFound = false;
						}
						if (i == 0) {
							for each (var dimension:Dimension in 
								series.valueFor) {
								if (dimension.conceptIdentity.id 
									== attributeTitle) {
									titleType = 0;
									titleFound = true;
									titlePos = 
										series.valueFor.getItemIndex(dimension);
									break;
								}
							}
							if (!titleFound) {
								for each (var attribute:AttributeValue in 
									series.attributeValues){
									if (attribute is CodedAttributeValue && 
										(attribute as CodedAttributeValue).
										valueFor.conceptIdentity.id == 
										attributeTitle) {
										titleType = 1;
										titleFound = true;
										titlePos = 
											series.attributeValues.getItemIndex(
												attribute);
										break;
									} else if (attribute is 
										UncodedAttributeValue && (attribute as 
										UncodedAttributeValue).valueFor.
										conceptIdentity.id == attributeTitle) {
										titleType = 1;
										titleFound = true;
										titlePos = series.attributeValues.
											getItemIndex(attribute);
										break;
									}	
								}
							}
						}
						if (!titleFound) {
							for each (var groupKey:GroupKey in _dataSet.
							 groupKeys.getGroupsForTimeseries(series)) {
								for each (var groupAttribute:AttributeValue in 
									groupKey.attributeValues){
									if (groupAttribute is CodedAttributeValue && 
										(groupAttribute as CodedAttributeValue).
										valueFor.conceptIdentity.id == 
											attributeTitle) {
										titleType = 2;		
										titleFound = true;
										titleGroup = groupKey;	
										titlePos = 
											groupKey.attributeValues.
												getItemIndex(groupAttribute);
										break;
									} else if (groupAttribute is 
										UncodedAttributeValue && (groupAttribute 
										as UncodedAttributeValue).valueFor.
										conceptIdentity.id == attributeTitle) {
										titleType = 2;	
										titleFound = true;
										titleGroup = groupKey;										
										titlePos = groupKey.attributeValues.
											getItemIndex(groupAttribute);
										break;
									}	
								}
								if (titleFound) {
									break;
								}
							}
						}
						if (!titleFound) {
							throw new ArgumentError("Could not find the " + 
								"dimension or attribute to use as title for " +
								"the legend item.");	
						}
						var uicomponent:UIComponent = new UIComponent();
						if (i < SeriesColors.getColors().length) {
							uicomponent.graphics.beginFill(uint(SeriesColors.
								getColors().getItemAt(i)));
						} else {
							uicomponent.graphics.beginFill(
								Math.random()*0xFFFFFF, Math.random());
						}		
						uicomponent.graphics.drawCircle(5, 11, 5);
						addChild(uicomponent);
						var legendItem:Label = new Label();
						legendItem.setStyle("paddingLeft", 12);
						switch(titleType) {
							case 0:
								legendItem.text = (series.keyValues.getItemAt(
									titlePos) as KeyValue).value.description.
									localisedStrings.
									getDescriptionByLocale("en");
								break;
							case 1:
								legendItem.text = ((series.attributeValues.
									getItemAt(titlePos) is CodedAttributeValue)? 
									(series.attributeValues.getItemAt(titlePos) 
									as CodedAttributeValue).value.description.
									localisedStrings.
									getDescriptionByLocale("en") : (series.
									attributeValues.getItemAt(titlePos) as 
									UncodedAttributeValue).value);
								break;
							case 2:
								legendItem.text = ((titleGroup.attributeValues.
									getItemAt(titlePos) is CodedAttributeValue)? 
									(titleGroup.attributeValues.
									getItemAt(titlePos) 
									as CodedAttributeValue).value.description.
									localisedStrings.
									getDescriptionByLocale("en") : 
									(titleGroup.attributeValues.getItemAt(
									titlePos) as UncodedAttributeValue).value);
								break;		
						}
						addChild(legendItem);
					}
				}
	 		}
	 	}
	}
}