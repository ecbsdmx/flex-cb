// ECB/SIS Public License, version 1.0, document reference SIS/2001/116
//
// Copyright (C) 2009 European Central Bank. All rights reserved.
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
package eu.ecb.core.view.summary
{
	import eu.ecb.core.view.BaseSDMXView;
	
	import mx.containers.HBox;
	import mx.controls.Text;
	
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.AttributeValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.UncodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;

	/**
	 * This component displays a panel with metadata such as the data set,
	 * group and series-level attributes, as well as the dimensions used in the
	 * series passed to the component.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo
	 * 		- Display attributes of XS artefacts
	 */
	public class MetadataPanel extends BaseSDMXView
	{
		/*===========================Constructor==============================*/
		
		public function MetadataPanel(direction:String="vertical")
		{
			super(direction);
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_referenceSeriesChanged) {
				_referenceSeriesChanged = false;
				displayMetadata();
			}
		}
		
		/*=========================Private methods============================*/
		
		private function displayMetadata():void 
		{
			removeAllChildren();
			displayDataSetMetadata();
			displaySeriesMetadata();
			displayGroupMetadata();
		}
		
		private function displayDataSetMetadata():void 
		{
			if (null != _dataSet.dataExtractionDate) {
				printBox("Last updated: ", 
					_dataSet.dataExtractionDate.toString());
			}
				
			if (_dataSet.attributeValues != null) {
				displayAttributes(_dataSet.attributeValues);	
			}	
		}
		
		private function displaySeriesMetadata():void
		{
			for each (var dimension:KeyValue in _referenceSeries.keyValues) {
				printBox(dimension.valueFor.conceptIdentity.
					name.localisedStrings.getDescriptionByLocale("en"), 
					dimension.value.description.localisedStrings.
					getDescriptionByLocale("en"));
			}
			
			if (_referenceSeries.attributeValues != null) {
				displayAttributes(_referenceSeries.attributeValues);	
			}
		} 
		
		private function displayGroupMetadata():void
		{
			if (_dataSet is DataSet) {
				for each (var group:GroupKey in (_dataSet as DataSet).groupKeys.
					getGroupsForTimeseries(_referenceSeries)) {
					if (group.attributeValues != null) {
						displayAttributes(group.attributeValues);	
					}
				}
			}
		}
		
		private function displayAttributes(
			attributes:AttributeValuesCollection):void 
		{
			for each (var attr:AttributeValue in attributes) {
				displayAttribute(attr);
			}
		}
		
		private function displayAttribute(attribute:AttributeValue):void
		{
			var key:String = (attribute is CodedAttributeValue) ? 
				(attribute as CodedAttributeValue).valueFor.conceptIdentity.
					name.localisedStrings.getDescriptionByLocale("en") :
				(attribute as UncodedAttributeValue).valueFor.conceptIdentity.
					name.localisedStrings.getDescriptionByLocale("en");			
			var value:String = (attribute is CodedAttributeValue) ? 
				(attribute as CodedAttributeValue).value.description.
					localisedStrings.getDescriptionByLocale("en") :
				(attribute as UncodedAttributeValue).value;
			printBox(key, value);	
		}
		
		private function printBox(key:String, value:String):void
		{
			var box:HBox = new HBox();
			box.percentWidth = 100;
			var keyField:Text = new Text();
			keyField.width = 150;
			keyField.text = key + ": ";
			keyField.styleName = "textBox";
			box.addChild(keyField);
			var valueField:Text = new Text();
			valueField.percentWidth = 100;
			valueField.text = value;
			valueField.styleName = "textBox";
			box.addChild(valueField);
			addChild(box);
		}
	}
}