// Copyright (c) 2008, Federal Reserve Bank of New York
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this 
// list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation 
// and/or other materials provided with the distribution.
// Neither the name of the Federal Reserve Bank of New York nor the names of 
// its contributors may be used to endorse or promote products derived from this 
// software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
// POSSIBILITY OF SUCH DAMAGE.

package org.sdmx.stores.xml.v2.utility
{
	import flash.events.IEventDispatcher;
	
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.stores.xml.v2.DataReaderAdapter;

	/**
	 * UtilityReader reads SDMX-ML utility data file and returns a dataset 
	 * containing the matching series. Based on CompactReader by 
	 * Xavier Sosnovsky. 
	 * 
	 * @author Allen Harvey
	 * 
	 * The reader ignores namespaces within the utility file. Thus 
	 * conflicting elements (e.g. <ns1:DataSet> ... </ns1:DataSet> 
	 * <ns2:DataSet> ... </ns2:DataSet>) will cause the parser to fail.
	 */
	public class UtilityReader extends DataReaderAdapter
	{
		/*===========================Constructor==============================*/
		
		/**
		 * Creates a UtilityReader. 
		 * 
		 * @param kf The key family that will be used to extract and interpret 
		 * the statistical data available in the data file.
		 */
		public function UtilityReader(kf:KeyFamily, 
			target:IEventDispatcher=null)
		{
			super(kf, target);
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function getDimensionValue(xml:XML, 
			dimensionId:String):String
		{
			var value:String;
			var dimensions:XMLList;
			if (xml.localName() == "Series") {
				dimensions = xml.children()[0].children();
			} else {
				dimensions = xml.children()[0].children()[0].children();
			}	
			for each (var child:XML in dimensions) {
				if(child.localName() == dimensionId) {
					value = child.text();
					break;
				}
			}
			return value;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function getAttributeValue(xml:XML, 
			attributeId:String):String
		{
			return String(xml.attribute(attributeId));
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function getObservations(xml:XML):XMLList 
		{
			return xml..*::Obs;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function getMatchingSeries(group:GroupKey, 
			position:uint):void
		{
			for each (var series:TimeseriesKey in _dataSet.timeseriesKeys) {
            	if (series.belongsToGroup(group.keyValues)) {
                	group.timeseriesKeys.addItem(series);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function getObservation(xml:XML):Object
		{
			var obs:Object = new Object();
		
			// For instance documents in which the namespace of the obs and the 
			// PrimaryMeasure and TimeDimension elements are different, it is
			// impossible to know the namespace of the latter elements 
			// beforehand, so match only on the name of the element, stripping 
			// the namespace(s). 
			for each (var child:XML in xml.children()) {
				var noNsName:String = child.localName();
				if(noNsName == _primaryMeasureCode) {
					obs["value"] = child.text();
				} else if (noNsName == _timeDimensionCode) {
					obs["period"] = child.text();
				}
			}
						
			if(obs["period"] == null || obs["period"].length == 0) {
			 	throw new Error("TimeDimensionCode ("+_timeDimensionCode+") " + 
			 			"not found in the obs. Malformed instance document?");
			} 			
			return obs;		
		}
	}
}