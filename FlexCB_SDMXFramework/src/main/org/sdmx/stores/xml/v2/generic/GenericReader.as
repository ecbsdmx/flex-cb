// Copyright (c) 2009, Organisation for Economic Co-operation and Development
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
package org.sdmx.stores.xml.v2.generic
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.XMLListCollection;
	
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.stores.xml.v2.DataReaderAdapter;

	/**
	 * Reads an SDMX-ML Generic data file and returns a dataset containing the
	 * matching series.
	 * 
	 * @author Russell Penlington
	 * @author Xavier Sosnovsky
	 */
	public class GenericReader extends DataReaderAdapter
	{
		/*============================Namespaces==============================*/
		
		/**
		 * The SDMX 2.0 generic namespace 
		 */
		protected var genericNS:Namespace;
		
		protected var isSDMX21:Boolean;
		
		/*===========================Constructor==============================*/
		
		/**
		 * Instantiates a reader responsible for extracting data from a file 
		 * containing statistical data expressed in the SDMX-ML Generic Data 
		 * format. 
		 */
		public function GenericReader(kf:KeyFamily, 
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
			if (null == genericNS) {
				genericNS = new Namespace("generic", xml.namespace());
				isSDMX21 = genericNS.uri.indexOf("v2_1") > -1;
			}
			var dimensionValue:String = isSDMX21 ?
				String(xml.*[0].genericNS::Value.(@id==dimensionId).@value) :
				String(xml.*[0].genericNS::Value.(@concept==dimensionId).@value);
			return dimensionValue;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function getAttributeValue(xml:XML, 
			attributeId:String):String
		{
			var attrValue:String;
			if (isSDMX21) {
				attrValue = String(xml.genericNS::Attributes.genericNS::Value.
				(@id==attributeId).@value);
			} else {
				attrValue = String(xml.genericNS::Attributes.genericNS::Value.
				(@concept==attributeId).@value);
			}
			return attrValue;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function getObservations(xml:XML):XMLList 
		{
			return xml.genericNS::Obs;
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
			obs["value"]   = xml.genericNS::ObsValue.attribute("value");
			var period:String;
			if (isSDMX21) {
				period = xml.genericNS::ObsDimension..attribute("value");
			} else {
				period = xml.genericNS::Time.text();
			}
			obs["period"]  = period;
			return obs;		
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getGroupName(xml:XML):String
		{
			return xml.attribute("type");
		}
	}
}