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
package org.sdmx.stores.xml.v2.compact
{
	import flash.events.IEventDispatcher;
	
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.stores.xml.v2.DataReaderAdapter;
	import org.sdmx.stores.xml.v2.GuessSDMXVersion;
	
	/**
	 * Reads an SDMX-ML Compact data file and returns a dataset containing the
	 * matching series.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class CompactReader extends DataReaderAdapter {
		
		/*=============================Constants==============================*/
		
		/**
		 * In this mode, no optimisation trick is applied and things are done
		 * in the cleanest possible way, as far as the SDMX information model is
		 * concerned. 
		 */
		public static const NO_OPTIMISATION:uint = 0;
		
		/**
		 * In this mode, optimisation is applied by treating the group as a
		 * sibling group.  
		 */
		public static const SIBLING_GROUP_OPTIMISATION:uint = 1;
		
		/**
		 * In this mode, optimisation is applied by treating the group as a
		 * sibling group. At the difference with the SIBLING_GROUP_OPTIMISATION
		 * mode, this mode makes the assumption that the frequency dimension is
		 * in the 1st position in the key, and that the frequency code has a 
		 * one character length.
		 */
		public static const SIBLING_GROUP_DEFINED_KEY_ORDER:uint = 2;
		
		/**
		 * In this mode, optimisation is applied by making the assumption that
		 * each group is a sibling group, that it contains only one series and
		 * that the series is positioned just after the group in the data file. 
		 */
		public static const SERIES_POSITION_OPTIMISATION:uint = 3;
		
		/*===========================Constructor==============================*/
		
		public function CompactReader(kf:KeyFamily, 
			target:IEventDispatcher = null) 
		{		
			super(kf, target);
		}
				
		/*=========================Protected methods==========================*/
				
		/**
		 * @inheritDoc
		 */ 
		override protected function getObservations(xml:XML):XMLList 
		{
			return xml.*::Obs;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function getObservation(xml:XML):Object
		{
			return {period: xml.attribute(_timeDimensionCode), 
				value: xml.attribute(_primaryMeasureCode)}		
		}
		
		/**
		 *  @inheritDoc
		 */
		override protected function getDimensionValue(xml:XML, 
			dimensionId:String):String
		{
			return String(xml.attribute(dimensionId));
		}
		
		/**
		 *  @inheritDoc
		 */
		override protected function getAttributeValue(xml:XML, 
			attributeId:String):String
		{
			return String(xml.attribute(attributeId));
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function getMatchingSeries(group:GroupKey, 
			position:uint):void
		{
			if (_optimisationLevel == SERIES_POSITION_OPTIMISATION) {
				if (position < _dataSet.timeseriesKeys.length) {
					group.timeseriesKeys.addItem(
						_dataSet.timeseriesKeys.getItemAt(position));
				}
			} else if (_optimisationLevel==NO_OPTIMISATION) {
				for each (var s3:TimeseriesKey in _dataSet.timeseriesKeys) {
                	if (s3.belongsToGroup(group.keyValues)) {
                    	group.timeseriesKeys.addItem(s3);
					}
				}
			} else {
				var groupKeyVal:String = "";
				for each (var keyValue:KeyValue in group.keyValues) {
					groupKeyVal = groupKeyVal + keyValue.value.id + ".";
				}			
				groupKeyVal = groupKeyVal.substr(0, groupKeyVal.length - 1);
				
				if (_optimisationLevel == SIBLING_GROUP_OPTIMISATION) {
					for each (var s1:TimeseriesKey in _dataSet.timeseriesKeys) {
						if (s1.belongsToSiblingGroup(groupKeyVal)) {
							group.timeseriesKeys.addItem(s1);
							break;
						}
					}
				} else if (_optimisationLevel == 
					SIBLING_GROUP_DEFINED_KEY_ORDER) {
					var s2:TimeseriesKey = _dataSet.timeseriesKeys.
						getTimeseriesKeyBySiblingGroup(groupKeyVal);
					if (s2 != null) {
						group.timeseriesKeys.addItem(s2);
					}
				}
			}
		}	
		
		/**
		 * @inheritDoc
		 */
		override protected function getGroupName(xml:XML):String
		{
			if (GuessSDMXVersion.SDMX_v2_1 == GuessSDMXVersion.getSdmxVersion()) {
				var typeAttr:QName = 
				new QName("http://www.w3.org/2001/XMLSchema-instance", "type");
				if (xml.attribute(typeAttr).length() > 0) {
					var grpName:String = xml.attribute(typeAttr).toString();
					return grpName.substr(grpName.indexOf(":") + 1, 
						grpName.length);
				} else {
					throw new Error("Could not find group xsi:type attribute" + 
							" in: " + xml);
				}
			} else {
				return xml.localName() 
			}
		}
	}
}