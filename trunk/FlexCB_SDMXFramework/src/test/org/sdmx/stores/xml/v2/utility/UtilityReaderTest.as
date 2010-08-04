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
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.stores.xml.v2.DataReaderAdapter;
	import org.sdmx.stores.xml.v2.structure.StructureReader;
		
	public class UtilityReaderTest extends TestCase
	{
		private var _utilityReader:UtilityReader;
	
		public function UtilityReaderTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(UtilityReaderTest);
		}
		
		/**
		 * Based on the compact parser EXR data test. Tests that extraction 
		 * of data from the instance document into the DataSet object. 
		 */
		public function testGettingEXRData():void
		{
			var structureReader:StructureReader = new StructureReader();
			structureReader.dispatchKeyFamilies = true;
			structureReader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleKeyFamilies, 3000));
			structureReader.read(_structureXML);	
		}
		
		private function handleKeyFamilies(event:SDMXDataEvent):void 
		{
			_utilityReader = 
				new UtilityReader((event.data as KeyFamilies).getItemAt(0) 
					as KeyFamily);
			_utilityReader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleInitReady);
			_utilityReader.dataFile = _utilityXML;	
		}
		
		private function handleInitReady(event:Event):void
		{
			_utilityReader.addEventListener(DataReaderAdapter.DATASET_EVENT,
				handleDataSet);
			_utilityReader.query();	
		}		
		
			
		/**
		 * The testKeyFamilyFlow makes sure that, if key families are provided 
		 * to the parser, it will use the key families provided and ignore any 
		 * information about the location of the structure file provided by 
		 * the instance document. 
		 */
		public function testKeyFamilyFlow():void {
			var structureReader:StructureReader = new StructureReader();
			structureReader.dispatchKeyFamilies = true;
			structureReader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleKeyFamiliesForFlowTest, 3000));
			structureReader.read(_structureXML);
		}
		
		private function handleKeyFamiliesForFlowTest(event:SDMXDataEvent):void 
		{
			_utilityReader = 
				new UtilityReader((event.data as KeyFamilies).getItemAt(0) 
					as KeyFamily);
			_utilityReader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleInitReady);
			try {
				_utilityReader.dataFile = _utilityNoURI;
				assertTrue("Parsed the datafile fine with key families " + 
						"provided but not DataSet keyFamilyURI attribute.",
						 true);
			} catch (error:Error) {
				fail("Should not get an error because key families are " + 
						"provided, although no reference keyFamilyURI on the " + 
						"DataSet");
			}	
		}
		
		/**
		 * Tests that parsing fails when no structure file (or key family) 
		 * is provided through any mechanism. 
		 */ 
		public function testNoKeyFamilies():void {
			try {
				var reader:UtilityReader = new UtilityReader(null);
				fail("No valid structure file was provided, test should never" + 
						" get here.");
			} catch (error:ArgumentError) {}
		}		
		
		/**
	 	 * Tests that the parsing fails when an invalid URI is provided, making
	 	 * the lookup by URI into the key families fail.
		 */		
		public function testInvalidKeyFamilies():void {
			var structureReader:StructureReader = new StructureReader();
			structureReader.dispatchKeyFamilies = true;
			structureReader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleInvalidKeyFamilies, 3000));
			structureReader.read(_structureXML);
		}
		
		private function handleInvalidKeyFamilies(event:SDMXDataEvent):void 
		{
			_utilityReader = 
				new UtilityReader((event.data as KeyFamilies).getItemAt(0) 
					as KeyFamily);
			_utilityReader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleInitReady);
			try {
				_utilityReader.dataFile = _utilityInvalidURI;
				fail("Provided an invalid uri in the dataset to the key " + 
						"family, test should never get here.");
			} catch (error:Error) {
				assertTrue(error.message, true);
			}	
		}
									
		//helper method to test the dataset when parsing succeeds. 
		private function handleDataSet(event:SDMXDataEvent):void
		{
			var dataSet:DataSet = event.data as DataSet;
			
			assertNotNull("The dataset should not be null", dataSet);
			assertTrue("There should be only one or 0 attributes on the " + 
					"dataset level",
				dataSet.attributeValues.length < 2);
			assertNull("There is no dataflow associated to the dataset", 
				dataSet.describedBy);
			assertNull("There is no reporting begin date", 
				dataSet.reportingBeginDate);	
			assertNull("There is no reporting end date",
				dataSet.reportingEndDate);
			assertEquals("Groups should be 0", 0, 
				dataSet.groupKeys.length);
			assertEquals("There should be one series", 1, 
				dataSet.timeseriesKeys.length);
			assertEquals("The series should have 9 observations", 9, 
				(dataSet.timeseriesKeys.getItemAt(0) 
					as TimeseriesKey).timePeriods.length);
			var obs:TimePeriod = (dataSet.timeseriesKeys.getItemAt(0) 
				as TimeseriesKey).timePeriods.getItemAt(3) as TimePeriod;
			assertEquals("The values should be equal", 0.62, 
				obs.observationValue);
			assertEquals("The periods should be equal", "2008-11-24", 
				obs.periodComparator);	
			assertFalse("There should be some attributes", 
				null == obs.observation.attributeValues)	
			assertEquals("There should be 2 attributes", 2, 
				obs.observation.attributeValues.length);	
			assertEquals("The last attribute should be the obs_status", 
				"OBS_STATUS", (obs.observation.attributeValues.getItemAt(1) 
				as CodedAttributeValue).valueFor.id);
			assertEquals("The oservation status should be A", 
				"A", (obs.observation.attributeValues.getItemAt(1) 
				as CodedAttributeValue).value.id);	
		}
		
		public function testUtilityWithGroup():void
		{
			var structureReader:StructureReader = new StructureReader();
			structureReader.dispatchKeyFamilies = true;
			structureReader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleBISKeyFamilies, 3000));
			structureReader.read(_bisStructureXml);
		}
		
		public function testWrongData1():void
		{
			var structureReader:StructureReader = new StructureReader();
			structureReader.dispatchKeyFamilies = true;
			structureReader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleKeyFamiliesWD1, 3000));
			structureReader.read(_structureXML);
		}		
		
		public function testWrongData2():void
		{
			var structureReader:StructureReader = new StructureReader();
			structureReader.dispatchKeyFamilies = true;
			structureReader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleKeyFamiliesWD2, 3000));
			structureReader.read(_structureXML);
		}
		
		private function handleKeyFamiliesWD1(event:SDMXDataEvent):void 
		{
			_utilityReader = 
				new UtilityReader((event.data as KeyFamilies).getItemAt(0) 
					as KeyFamily);
			_utilityReader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleInitReadyWD1);
			_utilityReader.dataFile = _wrongData1;	
		}
		
		private function handleKeyFamiliesWD2(event:SDMXDataEvent):void 
		{
			_utilityReader = 
				new UtilityReader((event.data as KeyFamilies).getItemAt(0) 
					as KeyFamily);
			_utilityReader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleInitReadyWD2);
			_utilityReader.dataFile = _wrongData2;	
		}
		
		private function handleInitReadyWD1(event:Event):void
		{
			try {
				_utilityReader.query();
				fail("Should have caught an exception");
			} catch (e:Error) {	}	
		}
		
		private function handleInitReadyWD2(event:Event):void
		{
			try {
				_utilityReader.query();
				fail("Should have caught an exception");
			} catch (e:Error) {	}	
		}
				
		private function handleBISKeyFamilies(event:SDMXDataEvent):void 
		{
			_utilityReader = 
				new UtilityReader((event.data as KeyFamilies).getItemAt(0) 
					as KeyFamily);
			_utilityReader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleBISDataReady);
			_utilityReader.dataFile = _bisDataXml;
		}
		
		private function handleBISDataReady(event:Event):void
		{
			_utilityReader.addEventListener(DataReaderAdapter.DATASET_EVENT,
				handleBISDataWithGroup);
			_utilityReader.query();	
		}
		
		private function handleBISDataWithGroup(event:SDMXDataEvent):void
		{
			//Quick test just to make sure groups are correctly extracted.
			var dataSet:DataSet = event.data as DataSet;
			assertNotNull("The dataset should not be null", dataSet);
			assertEquals("There should be one group", 1, dataSet.groupKeys.length);
			var group:GroupKey = dataSet.groupKeys.getItemAt(0) as GroupKey;
			var groupKey:String = "";
			for each (var keyValue:KeyValue in group.keyValues) {
				groupKey = 
					groupKey + keyValue.value.id + ".";
			}			
			groupKey = groupKey.substr(0, groupKey.length - 1);
			assertEquals("The group key should match", "P.A.MX", groupKey);
			assertEquals("The group should have 4 attributes", 4, 
				group.attributeValues.length);
			var attribute1:CodedAttributeValue = 
				group.attributeValues.getItemAt(0) as CodedAttributeValue;
			assertEquals("The attribute id should match", "AVAILABILITY", 
				attribute1.valueFor.conceptIdentity.id);
			assertEquals("The attribute value should match", "A", 
				attribute1.value.id);					 	
			assertEquals("The group should contain one series", 1, 
				group.timeseriesKeys.length)
			var series:TimeseriesKey = 
				group.timeseriesKeys.getItemAt(0) as TimeseriesKey; 	
			assertEquals("The series key should match", "M.P.A.MX", 
				series.seriesKey);
			assertEquals("The series should have 2 attributes", 2, 
				series.attributeValues.length);
			var attribute2:CodedAttributeValue = 
				series.attributeValues.getItemAt(0) as CodedAttributeValue;
			if (attribute2.valueFor.conceptRole == ConceptRole.TIME_FORMAT) {
				assertEquals("The attribute id should match", "TIME_FORMAT", 
					attribute2.valueFor.conceptIdentity.id);
				assertEquals("The attribute value should match", "P1M", 
					attribute2.value.id);
			} else {	
				assertEquals("The attribute id should match", "COLLECTION", 
					attribute2.valueFor.conceptIdentity.id);
				assertEquals("The attribute value should match", "B", 
					attribute2.value.id);	
			}
			assertEquals("The series should contain 12 observations", 12, 
				series.timePeriods.length);
			var obs:TimePeriod = series.timePeriods.getItemAt(11) as TimePeriod;	
			assertEquals("The obs value should be 3.14", "3.14", 
				obs.observationValue);		
			assertEquals("The obs period should be 2000-12", "2000-12", 
				obs.periodComparator);
			assertEquals("The observation should have 2 attributes", 2, 
				obs.observation.attributeValues.length);
			var attribute3:CodedAttributeValue = 
				obs.observation.attributeValues.getItemAt(0) 
					as CodedAttributeValue;
			assertEquals("The attribute id should match", "OBS_CONF", 
				attribute3.valueFor.conceptIdentity.id);
			assertEquals("The attribute value should match", "F", 
				attribute3.value.id);		
		}

		/////////// Test data ///////////
		
		// Utility data with an invalid uri in the dataset
		private var _utilityInvalidURI:XML =
<UtilityData xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message SDMXMessage.xsd  http://www.newyorkfed.org/xml/schemas/RateBase/utility RateBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFBase/utility FFBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFMethod/utility FFMethodUtility.xsd http://www.newyorkfed.org/xml/schemas/FF/utility FFUtility.xsd" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" xmlns:ffbase="http://www.newyorkfed.org/xml/schemas/FFBase/utility" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/utility" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/query" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:m="http://www.newyorkfed.org/xml/schemas/FFMethod/utility" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact" xmlns:ff="http://www.newyorkfed.org/xml/structures/ffStructure.xml" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/cross" xmlns:base="http://www.newyorkfed.org/xml/schemas/RateBase/utility">
   <Header>
      <ID>FFD</ID>
      <Test>false</Test>
      <Name xml:lang="en">Federal Funds daily averages</Name>
      <Prepared>2008-12-03</Prepared>
      <Sender id="FRBNY">
         <Name xml:lang="en">Federal Reserve Bank of New York</Name>
         <Contact>
            <Name xml:lang="en">George Matthes</Name>
            <Email>george.matthes@ny.frb.org</Email>
         </Contact>
      </Sender>
   </Header>
   <ff:DataSet keyFamilyURI="http://www.NOTnewyorkfed.org/xml/structures/ffStructure.xml">
      <ff:Series AVAILABILITY="A" DECIMALS="2" FF_METHOD="D" DISCLAIMER="G" TIME_FORMAT="P1D" >
         <ffbase:Key>
            <base:FREQ>D</base:FREQ>
            <base:RATE>FF</base:RATE>
            <base:MATURITY>O</base:MATURITY>
            <ffbase:FF_SCOPE>D</ffbase:FF_SCOPE>
         </ffbase:Key>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-12-02</base:TIME_PERIOD>
            <base:OBS_VALUE>0.47</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-12-01</base:TIME_PERIOD>
            <base:OBS_VALUE>0.52</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-28</base:TIME_PERIOD>
            <base:OBS_VALUE>0.52</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-26</base:TIME_PERIOD>
            <base:OBS_VALUE>0.53</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-25</base:TIME_PERIOD>
            <base:OBS_VALUE>0.59</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-24</base:TIME_PERIOD>
            <base:OBS_VALUE>0.62</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-21</base:TIME_PERIOD>
            <base:OBS_VALUE>0.57</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-20</base:TIME_PERIOD>
            <base:OBS_VALUE>0.49</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A" LAST_DAY_OF_MAINTENANCE_PERIOD="true">
            <base:TIME_PERIOD>2008-11-19</base:TIME_PERIOD>
            <base:OBS_VALUE>0.38</base:OBS_VALUE>
         </ff:Obs>         
      </ff:Series>
   </ff:DataSet>
</UtilityData>;		
		
		// Utility data with the uri removed from dataset.		
		private var _utilityNoURI:XML =
<UtilityData xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message SDMXMessage.xsd  http://www.newyorkfed.org/xml/schemas/RateBase/utility RateBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFBase/utility FFBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFMethod/utility FFMethodUtility.xsd http://www.newyorkfed.org/xml/schemas/FF/utility FFUtility.xsd" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" xmlns:ffbase="http://www.newyorkfed.org/xml/schemas/FFBase/utility" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/utility" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/query" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:m="http://www.newyorkfed.org/xml/schemas/FFMethod/utility" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact" xmlns:ff="http://www.newyorkfed.org/xml/structures/ffStructure.xml" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/cross" xmlns:base="http://www.newyorkfed.org/xml/schemas/RateBase/utility">
   <Header>
      <ID>FFD</ID>
      <Test>false</Test>
      <Name xml:lang="en">Federal Funds daily averages</Name>
      <Prepared>2008-12-03</Prepared>
      <Sender id="FRBNY">
         <Name xml:lang="en">Federal Reserve Bank of New York</Name>
         <Contact>
            <Name xml:lang="en">George Matthes</Name>
            <Email>george.matthes@ny.frb.org</Email>
         </Contact>
      </Sender>
   </Header>
   <ff:DataSet keyFamilyURI="http://www.newyorkfed.org/xml/structures/ffStructure.xml">
      <ff:Series AVAILABILITY="A" DECIMALS="2" FF_METHOD="D" DISCLAIMER="G" TIME_FORMAT="P1D" >
         <ffbase:Key>
            <base:FREQ>D</base:FREQ>
            <base:RATE>FF</base:RATE>
            <base:MATURITY>O</base:MATURITY>
            <ffbase:FF_SCOPE>D</ffbase:FF_SCOPE>
         </ffbase:Key>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-12-02</base:TIME_PERIOD>
            <base:OBS_VALUE>0.47</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-12-01</base:TIME_PERIOD>
            <base:OBS_VALUE>0.52</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-28</base:TIME_PERIOD>
            <base:OBS_VALUE>0.52</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-26</base:TIME_PERIOD>
            <base:OBS_VALUE>0.53</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-25</base:TIME_PERIOD>
            <base:OBS_VALUE>0.59</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-24</base:TIME_PERIOD>
            <base:OBS_VALUE>0.62</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-21</base:TIME_PERIOD>
            <base:OBS_VALUE>0.57</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-20</base:TIME_PERIOD>
            <base:OBS_VALUE>0.49</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A" LAST_DAY_OF_MAINTENANCE_PERIOD="true">
            <base:TIME_PERIOD>2008-11-19</base:TIME_PERIOD>
            <base:OBS_VALUE>0.38</base:OBS_VALUE>
         </ff:Obs>         
      </ff:Series>
   </ff:DataSet>
</UtilityData>; 
		
	// utility xml file with a valid uri in the dataset
	private var _utilityXML:XML =  
<UtilityData xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message SDMXMessage.xsd  http://www.newyorkfed.org/xml/schemas/RateBase/utility RateBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFBase/utility FFBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFMethod/utility FFMethodUtility.xsd http://www.newyorkfed.org/xml/schemas/FF/utility FFUtility.xsd" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" xmlns:ffbase="http://www.newyorkfed.org/xml/schemas/FFBase/utility" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/utility" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/query" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:m="http://www.newyorkfed.org/xml/schemas/FFMethod/utility" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact" xmlns:ff="http://www.newyorkfed.org/xml/structures/ffStructure.xml" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/cross" xmlns:base="http://www.newyorkfed.org/xml/schemas/RateBase/utility">
   <Header>
      <ID>FFD</ID>
      <Test>false</Test>
      <Name xml:lang="en">Federal Funds daily averages</Name>
      <Prepared>2008-12-03</Prepared>
      <Sender id="FRBNY">
         <Name xml:lang="en">Federal Reserve Bank of New York</Name>
         <Contact>
            <Name xml:lang="en">George Matthes</Name>
            <Email>george.matthes@ny.frb.org</Email>
         </Contact>
      </Sender>
   </Header>
   <ff:DataSet keyFamilyURI="http://www.newyorkfed.org/xml/structures/ffStructure.xml">
      <ff:Series AVAILABILITY="A" DECIMALS="2" FF_METHOD="D" DISCLAIMER="G" TIME_FORMAT="P1D" >
         <ffbase:Key>
            <base:FREQ>D</base:FREQ>
            <base:RATE>FF</base:RATE>
            <base:MATURITY>O</base:MATURITY>
            <ffbase:FF_SCOPE>D</ffbase:FF_SCOPE>
         </ffbase:Key>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-12-02</base:TIME_PERIOD>
            <base:OBS_VALUE>0.47</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-12-01</base:TIME_PERIOD>
            <base:OBS_VALUE>0.52</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-28</base:TIME_PERIOD>
            <base:OBS_VALUE>0.52</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-26</base:TIME_PERIOD>
            <base:OBS_VALUE>0.53</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-25</base:TIME_PERIOD>
            <base:OBS_VALUE>0.59</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-24</base:TIME_PERIOD>
            <base:OBS_VALUE>0.62</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-21</base:TIME_PERIOD>
            <base:OBS_VALUE>0.57</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">
            <base:TIME_PERIOD>2008-11-20</base:TIME_PERIOD>
            <base:OBS_VALUE>0.49</base:OBS_VALUE>
         </ff:Obs>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A" LAST_DAY_OF_MAINTENANCE_PERIOD="true">
            <base:TIME_PERIOD>2008-11-19</base:TIME_PERIOD>
            <base:OBS_VALUE>0.38</base:OBS_VALUE>
         </ff:Obs>         
      </ff:Series>
   </ff:DataSet>
</UtilityData>;		
		
		// structure file
		private var _structureXML:XML = 
<Structure xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd">
	<Header>
		<ID>FRBNY_FF</ID> 
		<Test>false</Test>
		<Prepared>2008-11-13</Prepared>
		<Sender id="FRBNY">
			<Name xml:lang="en">Federal Reserve Bank of New York</Name> 
			<Contact>
				<Name xml:lang="en">NY Fed Webteam</Name> 
				<Email>ny.piwebteam@ny.frb.org</Email> 
			</Contact>
		</Sender>	
	</Header>
	<CodeLists>
		<structure:CodeList id="CL_AVAILABILITY" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/structure:CodeLists/cl_availability.xml" isExternalReference="false">
			<structure:Name xml:lang="en">availability</structure:Name>
			<structure:Code value="A">
				<structure:Description xml:lang="en">free</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_DECIMALS" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/structure:CodeLists/cl_decimals.xml" isExternalReference="false">
			<structure:Name xml:lang="en">decimals</structure:Name>
			<structure:Code value="2">
				<structure:Description xml:lang="en">two</structure:Description>
			</structure:Code>
			<structure:Code value="5">
				<structure:Description xml:lang="en">five</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_DISCLAIMER" agencyID="FRBNY" version="1.0" uri="http://www.newyorkfed.org/xml/structure:CodeLists/Generalstructure:CodeLists.xml" isExternalReference="false">
			<structure:Name xml:lang="en">disclaimer</structure:Name>
			<structure:Code value="G">
				<structure:Description xml:lang="en">general disclaimer</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_TIME_FORMAT" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/structure:CodeLists/cl_time_format.xml" isExternalReference="false">
			<structure:Name xml:lang="en">time format</structure:Name>
			<structure:Code value="P1D">
				<structure:Description xml:lang="en">daily</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_FREQ" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/structure:CodeLists/cl_freq.htm" isExternalReference="false">
			<structure:Name xml:lang="en">frequency</structure:Name>
			<structure:Code value="D">
				<structure:Description xml:lang="en">daily</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_RATE" agencyID="FRBNY" version="1.0" uri="http://www.newyorkfed.org/xml/structure:CodeLists/Ratesstructure:CodeLists.xml" isExternalReference="false">
			<structure:Name xml:lang="en">interest rate type</structure:Name>
			<structure:Code value="FF">
				<structure:Description xml:lang="en">federal funds</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_MATURITY" agencyID="FRBNY" version="1.0" uri="http://www.newyorkfed.org/xml/structure:CodeLists/Ratesstructure:CodeLists.xml" isExternalReference="false">
			<structure:Name xml:lang="en">lending maturity</structure:Name>
			<structure:Code value="O">
				<structure:Description xml:lang="en">overnight - due next business day</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_FF_METHOD" agencyID="FRBNY" version="1.0" uri="http://www.newyorkfed.org/xml/structure:CodeLists/Ratestructure:CodeLists.xml" isExternalReference="false">
			<structure:Name xml:lang="en">method</structure:Name>
			<structure:Code value="D">
				<structure:Description xml:lang="en">daily effective rate</structure:Description>
			</structure:Code>
			<structure:Code value="P">
				<structure:Description xml:lang="en">period average to date</structure:Description>
			</structure:Code>
			<structure:Code value="M">
				<structure:Description xml:lang="en">monthly average to date</structure:Description>
			</structure:Code>
			<structure:Code value="T">
				<structure:Description xml:lang="en">target</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_FF_SCOPE" agencyID="FRBNY" version="1.0" uri="http://www.newyorkfed.org/xml/structure:CodeLists/Ratestructure:CodeLists.xml" isExternalReference="false">
			<structure:Name xml:lang="en">method</structure:Name>
			<structure:Code value="D">
				<structure:Description xml:lang="en">daily</structure:Description>
			</structure:Code>
			<structure:Code value="P">
				<structure:Description xml:lang="en">period to date</structure:Description>
			</structure:Code>
			<structure:Code value="M">
				<structure:Description xml:lang="en">monthly to date</structure:Description>
			</structure:Code>			
		</structure:CodeList>
		<structure:CodeList id="CL_OBS_CONF" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/structure:CodeLists/cl_bis_obs_conf.xml" isExternalReference="false">
			<structure:Name xml:lang="en">observation confidentiality</structure:Name>
			<structure:Code value="F">
				<structure:Description xml:lang="en">free</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_OBS_STATUS" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/structure:CodeLists/cl_obs_status.xml" isExternalReference="false">
			<structure:Name xml:lang="en">observation status</structure:Name>
			<structure:Code value="A">
				<structure:Description xml:lang="en">actual</structure:Description>
			</structure:Code>
			<structure:Code value="H">
				<structure:Description xml:lang="en">missing; holiday or weekend</structure:Description>
			</structure:Code>
			<structure:Code value="L">
				<structure:Description xml:lang="en">missing; data exist but were not collected</structure:Description>
			</structure:Code>
			<structure:Code value="M">
				<structure:Description xml:lang="en">missing; data cannot exist</structure:Description>
			</structure:Code>
			<structure:Code value="R">
				<structure:Description xml:lang="en">revised</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_BOOLEAN" agencyID="FRBNY" version="1.0" uri="http://www.newyorkfed.org/xml/structure:CodeLists/Generalstructure:CodeLists.xml" isExternalReference="false">
			<structure:Name>boolean</structure:Name>
			<structure:Code value="true">
				<structure:Description xml:lang="en">true</structure:Description>
			</structure:Code>
			<structure:Code value="false">
				<structure:Description xml:lang="en">false</structure:Description>
			</structure:Code>
		</structure:CodeList>
	</CodeLists>
	<Concepts>
		<structure:Concept id="AVAILABILITY" agencyID="BIS" version="1.0" isExternalReference="false" uri="http://www.bis.org/structure/concepts/AVAILABILITY.xml">
			<structure:Name>availability</structure:Name>
		</structure:Concept>
		<structure:Concept id="DECIMALS" agencyID="BIS" version="1.0" isExternalReference="false" uri="http://www.bis.org/structure/concepts/DECIMALS.xml">
			<structure:Name>decimals</structure:Name>
		</structure:Concept>
		<structure:Concept id="DISCLAIMER" agencyID="FRBNY" version="1.0">
			<structure:Name>disclaimer</structure:Name>
		</structure:Concept>
		<structure:Concept id="FF_METHOD" agencyID="FRBNY" version="1.0">
			<structure:Name>federal funds observation method </structure:Name>
		</structure:Concept>
		<structure:Concept id="FF_SCOPE" agencyID="FRBNY" version="1.0">
				<structure:Name>federal funds scope</structure:Name>
		</structure:Concept>
		<structure:Concept id="FREQ" agencyID="BIS" version="1.0" isExternalReference="false" uri="http://www.bis.org/structure/concepts/FREQ.xml">
			<structure:Name>frequency</structure:Name>
		</structure:Concept>
		<structure:Concept id="LAST_DAY_OF_MAINTENANCE_PERIOD" agencyID="FRBNY" version="1.0">
			<structure:Name>last day of maintenance period</structure:Name>
		</structure:Concept>
		<structure:Concept id="MATURITY" agencyID="FRBNY" version="1.0">
			<structure:Name>lending maturity</structure:Name>
		</structure:Concept>
		<structure:Concept id="OBS_CONF" agencyID="BIS" version="1.0" isExternalReference="false" uri="http://www.bis.org/structure/concepts/OBS_CONF.xml">
			<structure:Name>observation confidentiality</structure:Name>
		</structure:Concept>
		<structure:Concept id="OBS_STATUS" agencyID="FRBNY" version="1.0" isExternalReference="false" uri="http://www.bis.org/structure/concepts/OBS_STATUS.xml">
			<structure:Name>observation status</structure:Name>
		</structure:Concept>
		<structure:Concept id="OBS_VALUE" agencyID="FRBNY" version="1.0">
			<structure:Name>observation</structure:Name>
		</structure:Concept>
		<structure:Concept id="RATE" agencyID="FRBNY" version="1.0">
			<structure:Name>the reported rate</structure:Name>
		</structure:Concept>	
		<structure:Concept id="TIME_FORMAT" agencyID="BIS" version="1.0" isExternalReference="false" uri="http://www.bis.org/structure/concepts/TIME_FORMAT.xml">
			<structure:Name>time format</structure:Name>
		</structure:Concept>
		<structure:Concept id="TIME_PERIOD" agencyID="BIS" version="1.0" isExternalReference="false" uri="http://www.bis.org/structure/concepts/TIME.xml">
			<structure:Name>time</structure:Name>
		</structure:Concept>
	</Concepts>
	<KeyFamilies>
		<structure:KeyFamily id="FF" agencyID="FRBNY" version="1.0" uri="http://www.newyorkfed.org/xml/structures/ffStructure.xml">
			<structure:Name xml:lang="en">federal funds</structure:Name>
			<structure:Components>
				<structure:Dimension codelist="CL_FREQ" conceptRef="FREQ" isFrequencyDimension="true"/>
				<structure:Dimension codelist="CL_RATE" conceptRef="RATE"/>
				<structure:Dimension codelist="CL_MATURITY" conceptRef="MATURITY"/>
				<structure:Dimension codelist="CL_FF_SCOPE" conceptRef="FF_SCOPE"/>
				<structure:TimeDimension conceptRef="TIME_PERIOD"/>
				<structure:PrimaryMeasure conceptRef="OBS_VALUE"/>
				<structure:Attribute attachmentLevel="Series" conceptRef="AVAILABILITY" codelist="CL_AVAILABILITY" assignmentStatus="Mandatory"/>
				<structure:Attribute attachmentLevel="Series" conceptRef="DECIMALS" codelist="CL_DECIMALS" assignmentStatus="Mandatory"/>
				<structure:Attribute attachmentLevel="Series" conceptRef="FF_METHOD" codelist="CL_FF_METHOD" assignmentStatus="Mandatory"/>
				<structure:Attribute attachmentLevel="Series" conceptRef="DISCLAIMER" codelist="CL_DISCLAIMER" assignmentStatus="Mandatory"/>
				<structure:Attribute attachmentLevel="Series" conceptRef="TIME_FORMAT" codelist="CL_TIME_FORMAT" assignmentStatus="Mandatory" isTimeFormat="true"/>
				<structure:Attribute attachmentLevel="Observation" conceptRef="OBS_CONF" codelist="CL_OBS_CONF" assignmentStatus="Mandatory"/>
				<structure:Attribute attachmentLevel="Observation" conceptRef="OBS_STATUS" codelist="CL_OBS_STATUS" assignmentStatus="Mandatory"/>
				<structure:Attribute attachmentLevel="Observation" conceptRef="LAST_DAY_OF_MAINTENANCE_PERIOD" codelist="CL_BOOLEAN" assignmentStatus="Conditional"/>
			</structure:Components>
		</structure:KeyFamily>
	</KeyFamilies>
</Structure>;
		private var _bisStructureXml:XML = 
<Structure xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd">
	<Header>
		<ID>BIS_01</ID>
		<Test>true</Test>
		<Truncated>false</Truncated>
		<Name xml:lang="en">Trans46301</Name>
		<Prepared>2002-03-11T09:30:47-05:00</Prepared>
		<Sender id="BIS">
			<Name xml:lang="en">Bank for International Settlements</Name>
			<Contact>
				<Name xml:lang="en">G.B. Smith</Name>
				<Telephone>+000.000.0000</Telephone>
			</Contact>
		</Sender>
		<Receiver id="ECB">
			<Name xml:lang="en">European Central Bank</Name>
			<Contact>
				<Name xml:lang="en">B.S. Featherstone</Name>
				<Department xml:lang="en">Statistics Division</Department>
				<Telephone>+000.000.0001</Telephone>
			</Contact>
		</Receiver>
		<Extracted>2002-03-11T09:30:47-05:00</Extracted>
	</Header>
	<CodeLists>
		<structure:CodeList id="CL_OBS_STATUS" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_obs_status.xml">
					<structure:Name xml:lang="en">Observation Status</structure:Name>
					<structure:Code value="A">
						<structure:Description xml:lang="en">Present</structure:Description>
					</structure:Code>
					<structure:Code value="M">
						<structure:Description xml:lang="en">Missing</structure:Description>
					</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_FREQ" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_freq.htm">
			<structure:Name xml:lang="en">Frequency code list (BIS, ECB)</structure:Name>
			<structure:Code value="A">
				<structure:Description xml:lang="en">Annual</structure:Description>
			</structure:Code>
			<structure:Code value="D">
				<structure:Description xml:lang="en">Daily</structure:Description>
			</structure:Code>
			<structure:Code value="H">
				<structure:Description xml:lang="en">Semi-annual</structure:Description>
			</structure:Code>
			<structure:Code value="M">
				<structure:Description xml:lang="en">Monthly</structure:Description>
			</structure:Code>
			<structure:Code value="Q">
				<structure:Description xml:lang="en">Quarterly</structure:Description>
			</structure:Code>
			<structure:Code value="W">
				<structure:Description xml:lang="en">Weekly</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_JD_TYPE" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_jd_type.xml">
			<structure:Name xml:lang="en">Data Type (amounts outstanding, net disbursement or changes)</structure:Name>
			<structure:Code value="P">
				<structure:Description xml:lang="en">Amounts outstanding at end of period</structure:Description>
			</structure:Code>
			<structure:Code value="Q">
				<structure:Description xml:lang="en">Net Disbursm.(Cat B,C,E,F) or Val.Adj.Change in stocks(Cat A,D,J,L,M)</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_JD_CATEGORY" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_jd_category.xml">
			<structure:Name xml:lang="en">Debt category</structure:Name>
			<structure:Code value="A">
				<structure:Description xml:lang="en">External Debt, All Maturities, Bank Loans</structure:Description>
			</structure:Code>
			<structure:Code value="B">
				<structure:Description xml:lang="en">External Debt, All Maturities, Debt Securities Issued Abroad</structure:Description>
			</structure:Code>
			<structure:Code value="C">
				<structure:Description xml:lang="en">External Debt, All Maturities, Brady Bonds</structure:Description>
			</structure:Code>
			<structure:Code value="D">
				<structure:Description xml:lang="en">External Debt, All Maturities, Non-Bank Trade Credits</structure:Description>
			</structure:Code>
			<structure:Code value="E">
				<structure:Description xml:lang="en">External Debt, All Maturities, Multilateral Claims</structure:Description>
			</structure:Code>
			<structure:Code value="F">
				<structure:Description xml:lang="en">External Debt, All Maturities, Off. Bilateral Loans (DAC Creditors)</structure:Description>
			</structure:Code>
			<structure:Code value="G">
				<structure:Description xml:lang="en">Debt due within 1 year, Liabilities To Banks</structure:Description>
			</structure:Code>
			<structure:Code value="H">
				<structure:Description xml:lang="en">Debt due within 1 year, Debt Securities Issued Abroad</structure:Description>
			</structure:Code>
			<structure:Code value="I">
				<structure:Description xml:lang="en">Debt due within 1 year, Non-Bank Trade Credits</structure:Description>
			</structure:Code>
			<structure:Code value="J">
				<structure:Description xml:lang="en">Memorandum Item, Liabilities to Banks (Locational)</structure:Description>
			</structure:Code>
			<structure:Code value="K">
				<structure:Description xml:lang="en">Memorandum Item, Liabilities to Banks (Consolidated)</structure:Description>
			</structure:Code>
			<structure:Code value="L">
				<structure:Description xml:lang="en">Memorandum Item, Total Trade Credits</structure:Description>
			</structure:Code>
			<structure:Code value="M">
				<structure:Description xml:lang="en">Memorandum Item, Total Claims on Banks</structure:Description>
			</structure:Code>
			<structure:Code value="N">
				<structure:Description xml:lang="en">Memorandum Item, International Reserve Assets (excl. Gold)</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_TIME_FORMAT" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_time_format.xml">
			<structure:Name xml:lang="en">Time formats based on ISO 8601.</structure:Name>
			<structure:Code value="P1Y">
				<structure:Description xml:lang="en">Annual</structure:Description>
			</structure:Code>
			<structure:Code value="P6M">
				<structure:Description xml:lang="en">Semi-annual</structure:Description>
			</structure:Code>
			<structure:Code value="P3M">
				<structure:Description xml:lang="en">Quarterly</structure:Description>
			</structure:Code>
			<structure:Code value="P1M">
				<structure:Description xml:lang="en">Monthly</structure:Description>
			</structure:Code>
			<structure:Code value="P7D">
				<structure:Description xml:lang="en">Weekly</structure:Description>
			</structure:Code>
			<structure:Code value="P1D">
				<structure:Description xml:lang="en">Daily</structure:Description>
			</structure:Code>
			<structure:Code value="PT1M">
				<structure:Description xml:lang="en">Minutely</structure:Description>
			</structure:Code>			
		</structure:CodeList>		
		<structure:CodeList id="CL_BIS_IF_REF_AREA" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_bis_if-ref_area.xml">
			<structure:Name xml:lang="en">Reference Area Code for BIS-IFS</structure:Name>
			<structure:Code value="CH">
				<structure:Description xml:lang="en">Switzerland (includes the Bank for International Settlements)</structure:Description>
			</structure:Code>
			<structure:Code value="DE">
				<structure:Description xml:lang="en">Germany (includes the European Central Bank)</structure:Description>
			</structure:Code>
			<structure:Code value="US">
				<structure:Description xml:lang="en">United States (includes American Samoa, Guam, Midway Islands)</structure:Description>
			</structure:Code>
			<structure:Code value="MX">
				<structure:Description xml:lang="en">Mexico</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_AVAILABILITY" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_availability.xml">
			<structure:Name xml:lang="en">Availability</structure:Name>
			<structure:Code value="A">
				<structure:Description xml:lang="en">Free</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_COLLECTION" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_collection.xml">
			<structure:Name xml:lang="en">Collection</structure:Name>
			<structure:Code value="A">
				<structure:Description xml:lang="en">Average of observations through period</structure:Description>
			</structure:Code>
			<structure:Code value="B">
				<structure:Description xml:lang="en">Beginning of period</structure:Description>
			</structure:Code>
			<structure:Code value="E">
				<structure:Description xml:lang="en">End of period</structure:Description>
			</structure:Code>
			<structure:Code value="H">
				<structure:Description xml:lang="en">Highest in period</structure:Description>
			</structure:Code>
			<structure:Code value="L">
				<structure:Description xml:lang="en">Lowest in period</structure:Description>
			</structure:Code>
			<structure:Code value="M">
				<structure:Description xml:lang="en">Middle of period</structure:Description>
			</structure:Code>
			<structure:Code value="S">
				<structure:Description xml:lang="en">Summed through period</structure:Description>
			</structure:Code>
			<structure:Code value="U">
				<structure:Description xml:lang="en">Unknown</structure:Description>
			</structure:Code>
			<structure:Code value="V">
				<structure:Description xml:lang="en">Other</structure:Description>
			</structure:Code>
			<structure:Code value="Y">
				<structure:Description xml:lang="en">Annualised summed</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_DECIMALS" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_decimals.xml">
			<structure:Name xml:lang="en">Decimals codelist (BIS, ECB)</structure:Name>
			<structure:Code value="1">
				<structure:Description xml:lang="en">one</structure:Description>
			</structure:Code>
			<structure:Code value="2">
				<structure:Description xml:lang="en">two</structure:Description>
			</structure:Code>
			<structure:Code value="3">
				<structure:Description xml:lang="en">three</structure:Description>
			</structure:Code>
			<structure:Code value="4">
				<structure:Description xml:lang="en">four</structure:Description>
			</structure:Code>
			<structure:Code value="5">
				<structure:Description xml:lang="en">five</structure:Description>
			</structure:Code>
			<structure:Code value="6">
				<structure:Description xml:lang="en">six</structure:Description>
			</structure:Code>
			<structure:Code value="7">
				<structure:Description xml:lang="en">seven</structure:Description>
			</structure:Code>
			<structure:Code value="8">
				<structure:Description xml:lang="en">eight</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_BIS_OBS_CONF" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_bis_obs_conf.xml">
			<structure:Name xml:lang="en">Observation confidentiality code list</structure:Name>
			<structure:Code value="C">
				<structure:Description xml:lang="en">Non-publishable and confidential</structure:Description>
			</structure:Code>
			<structure:Code value="F">
				<structure:Description xml:lang="en">Free</structure:Description>
			</structure:Code>
			<structure:Code value="N">
				<structure:Description xml:lang="en">Non-publishable, but non-confidential</structure:Description>
			</structure:Code>
			<structure:Code value="R">
				<structure:Description xml:lang="en">Confidential statistical information due to identifiable respondents</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_BIS_UNIT" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_bis_unit.xml">
			<structure:Name xml:lang="en">BIS Unit</structure:Name>
			<structure:Code value="CHF">
				<structure:Description xml:lang="en">Swiss Francs</structure:Description>
			</structure:Code>
			<structure:Code value="USD">
				<structure:Description xml:lang="en">United States Dollars</structure:Description>
			</structure:Code>
			<structure:Code value="NZD">
				<structure:Description xml:lang="en">New Zealand Dollars</structure:Description>
			</structure:Code>
			<structure:Code value="EUR">
				<structure:Description xml:lang="en">Euros</structure:Description>
			</structure:Code>
		</structure:CodeList>
		<structure:CodeList id="CL_UNIT_MULT" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/codelists/cl_unit_mult.xml">
			<structure:Name xml:lang="en">Unit multiplier</structure:Name>
			<structure:Code value="0">
				<structure:Description xml:lang="en">Units</structure:Description>
			</structure:Code>
			<structure:Code value="1">
				<structure:Description xml:lang="en">Tens</structure:Description>
			</structure:Code>
			<structure:Code value="2">
				<structure:Description xml:lang="en">Hundreds</structure:Description>
			</structure:Code>
			<structure:Code value="3">
				<structure:Description xml:lang="en">Thousands</structure:Description>
			</structure:Code>
			<structure:Code value="4">
				<structure:Description xml:lang="en">Ten Thousands</structure:Description>
			</structure:Code>
			<structure:Code value="5">
				<structure:Description xml:lang="en">Millions</structure:Description>
			</structure:Code>
			<structure:Code value="6">
				<structure:Description xml:lang="en">Billions</structure:Description>
			</structure:Code>
		</structure:CodeList>
	</CodeLists>
	<Concepts>
		<structure:Concept id="TIME_PERIOD" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/VIS_CTY.xml">
			<structure:Name xml:lang="en">Time</structure:Name>
		</structure:Concept>
		<structure:Concept id="FREQ" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/FREQ.xml">
			<structure:Name xml:lang="en">Frequency</structure:Name>
		</structure:Concept>
		<structure:Concept id="JD_TYPE" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/JD_TYPE.xml">
			<structure:Name xml:lang="en">Data Type (amounts outstanding, net disbursement or changes)</structure:Name>
		</structure:Concept>
		<structure:Concept id="JD_CATEGORY" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/JD_CATEGORY.xml">
			<structure:Name xml:lang="en">Debt category</structure:Name>
		</structure:Concept>
		<structure:Concept id="VIS_CTY" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/VIS_CTY.xml">
			<structure:Name xml:lang="en">Vis-a-vis country</structure:Name>
		</structure:Concept>
		<structure:Concept id="AVAILABILITY" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/AVAILABILITY.xml">
			<structure:Name xml:lang="en">Availability</structure:Name>
		</structure:Concept>
		<structure:Concept id="COLLECTION" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/COLLECTION.xml">
			<structure:Name xml:lang="en">Collection indicator</structure:Name>
		</structure:Concept>
		<structure:Concept id="DECIMALS" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/DECIMALS.xml">
			<structure:Name xml:lang="en">Decimals</structure:Name>
		</structure:Concept>
		<structure:Concept id="OBS_CONF" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/OBS_CONF.xml">
			<structure:Name xml:lang="en">Observation confidentiality</structure:Name>
		</structure:Concept>
		<structure:Concept id="TIME_FORMAT" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/TIME_FORMAT.xml">
			<structure:Name xml:lang="en">Time Format</structure:Name>
		</structure:Concept>		
		<structure:Concept id="OBS_STATUS" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/OBS_STATUS.xml">
			<structure:Name xml:lang="en">Observation status</structure:Name>
		</structure:Concept>
		<structure:Concept id="OBS_PRE_BREAK" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/OBS_PRE_BREAK.xml">
			<structure:Name xml:lang="en">Pre-break observation</structure:Name>
		</structure:Concept>
		<structure:Concept id="BIS_UNIT" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/UNIT.xml">
			<structure:Name xml:lang="en">Unit</structure:Name>
		</structure:Concept>
		<structure:Concept id="UNIT_MULT" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/UNIT_MULT.xml">
			<structure:Name xml:lang="en">Unit multiplier</structure:Name>
		</structure:Concept>
		<structure:Concept id="OBS_VALUE" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/OBS_VALUE.xml">
					<structure:Name xml:lang="en">Observation value</structure:Name>
		</structure:Concept>
		<structure:Concept id="STOCKS" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/STOCKS.xml">
					<structure:Name xml:lang="en">Stocks as measure</structure:Name>
		</structure:Concept>
		<structure:Concept id="FLOWS" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/concepts/FLOWS.xml">
					<structure:Name xml:lang="en">Flows as measure</structure:Name>
		</structure:Concept>
	</Concepts>
	<KeyFamilies>
		<structure:KeyFamily id="BIS_JOINT_DEBT" agencyID="BIS" version="1.0" uri="http://www.bis.org/structure/key_families/JOINT_DEBT.xml">
			<structure:Name xml:lang="en">Joint BIS-IMF-OECD-World Bank stats - external debt</structure:Name>
			<structure:Components>	
				<structure:Dimension conceptRef="FREQ" codelist="CL_FREQ" isFrequencyDimension="true"/>
				<structure:Dimension conceptRef="JD_TYPE" codelist="CL_JD_TYPE" isMeasureDimension="true"/>
				<structure:Dimension conceptRef="JD_CATEGORY" codelist="CL_JD_CATEGORY" crossSectionalAttachDataSet="false" crossSectionalAttachGroup="false" crossSectionalAttachSection="false" crossSectionalAttachObservation="true"/>
				<structure:Dimension conceptRef="VIS_CTY" codelist="CL_BIS_IF_REF_AREA" crossSectionalAttachGroup="false" crossSectionalAttachSection="false" crossSectionalAttachObservation="true"/>
				<structure:TimeDimension conceptRef="TIME_PERIOD" crossSectionalAttachGroup="true"/>
				<structure:Group id="Group">
					<structure:DimensionRef>JD_TYPE</structure:DimensionRef>
					<structure:DimensionRef>JD_CATEGORY</structure:DimensionRef>
					<structure:DimensionRef>VIS_CTY</structure:DimensionRef>					
				</structure:Group>
					<structure:PrimaryMeasure conceptRef="OBS_VALUE">
						<structure:TextFormat textType="Double"/>
					</structure:PrimaryMeasure>
					<structure:CrossSectionalMeasure conceptRef="STOCKS" measureDimension="JD_TYPE" code="P"/>
					<structure:CrossSectionalMeasure conceptRef="FLOWS" measureDimension="JD_TYPE" code="Q"/>				
				<structure:Attribute conceptRef="AVAILABILITY" codelist="CL_AVAILABILITY" attachmentLevel="Group" assignmentStatus="Mandatory" crossSectionalAttachDataSet="false" crossSectionalAttachGroup="true" crossSectionalAttachSection="false" crossSectionalAttachObservation="false">
					<structure:AttachmentGroup>Group</structure:AttachmentGroup>
				</structure:Attribute>
				<structure:Attribute conceptRef="TIME_FORMAT" codelist="CL_TIME_FORMAT" attachmentLevel="Series" assignmentStatus="Mandatory" isTimeFormat="true" crossSectionalAttachDataSet="false" crossSectionalAttachGroup="false" crossSectionalAttachSection="true" crossSectionalAttachObservation="false"/>
				<structure:Attribute conceptRef="COLLECTION" codelist="CL_COLLECTION" attachmentLevel="Series" assignmentStatus="Mandatory" crossSectionalAttachDataSet="false" crossSectionalAttachGroup="false" crossSectionalAttachSection="true" crossSectionalAttachObservation="false"/>
				<structure:Attribute conceptRef="DECIMALS" codelist="CL_DECIMALS" attachmentLevel="Group" assignmentStatus="Mandatory" crossSectionalAttachDataSet="false" crossSectionalAttachGroup="true" crossSectionalAttachSection="false" crossSectionalAttachObservation="false">
					<structure:AttachmentGroup>Group</structure:AttachmentGroup>
				</structure:Attribute>
				<structure:Attribute conceptRef="OBS_CONF" codelist="CL_BIS_OBS_CONF" attachmentLevel="Observation" assignmentStatus="Conditional" crossSectionalAttachDataSet="false" crossSectionalAttachGroup="false" crossSectionalAttachSection="false" crossSectionalAttachObservation="true">
					<structure:AttachmentMeasure>P</structure:AttachmentMeasure>
					<structure:AttachmentMeasure>Q</structure:AttachmentMeasure>					
				</structure:Attribute>
				<structure:Attribute conceptRef="OBS_STATUS" codelist="CL_OBS_STATUS" attachmentLevel="Observation" assignmentStatus="Mandatory" crossSectionalAttachDataSet="false" crossSectionalAttachGroup="false" crossSectionalAttachSection="false" crossSectionalAttachObservation="true">
					<structure:AttachmentMeasure>P</structure:AttachmentMeasure>
					<structure:AttachmentMeasure>Q</structure:AttachmentMeasure>					
				</structure:Attribute>				
				<structure:Attribute conceptRef="BIS_UNIT" codelist="CL_BIS_UNIT" attachmentLevel="Group" assignmentStatus="Mandatory" crossSectionalAttachDataSet="false" crossSectionalAttachGroup="true" crossSectionalAttachSection="false" crossSectionalAttachObservation="false">
					<structure:AttachmentGroup>Group</structure:AttachmentGroup>
				</structure:Attribute>				
				<structure:Attribute conceptRef="UNIT_MULT" codelist="CL_UNIT_MULT" attachmentLevel="Group" assignmentStatus="Mandatory" crossSectionalAttachDataSet="false" crossSectionalAttachGroup="true" crossSectionalAttachSection="false" crossSectionalAttachObservation="false">
					<structure:AttachmentGroup>Group</structure:AttachmentGroup>
				</structure:Attribute>
			</structure:Components>
		</structure:KeyFamily>
	</KeyFamilies>
</Structure>
		private var _bisDataXml:XML =
<UtilityData xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/draft/common" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/draft/compact" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/draft/cross" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/draft/generic" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/draft/query" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/draft/structure" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/draft/utility" 
xmlns:bisjd="urn:sdmx:org.sdmx.infomodel.keyfamily.KeyFamily=BIS:EXT_DEBT:utility"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd urn:sdmx:org.sdmx.infomodel.keyfamily.KeyFamily=BIS:EXT_DEBT:utility BIS_JOINT_DEBT_Utility.xsd">
	<Header>
		<ID>JD01678594</ID>
		<Test>true</Test>
		<Truncated>false</Truncated>
		<Name xml:lang="en">Trans46304</Name>
		<Prepared>2001-03-11T09:30:47-05:00</Prepared>
		<Sender id="BIS">
			<Name xml:lang="en">Bank for International Settlements</Name>
			<Contact>
				<Name xml:lang="en">G.B. Smith</Name>
				<Telephone>+000.000.0000</Telephone>
			</Contact>
		</Sender>
		<Receiver id="ECB">
			<Name xml:lang="en">European Central Bank</Name>
			<Contact>
				<Name xml:lang="en">B.S. Featherstone</Name>
				<Department xml:lang="en">Statistics Division</Department>
				<Telephone>+000.000.0001</Telephone>
			</Contact>
		</Receiver>
		<DataSetAction>Append</DataSetAction>
		<Extracted>2001-03-11T09:30:47-05:00</Extracted>
		<ReportingBegin>2000-01-01T00:00:00</ReportingBegin>
		<ReportingEnd>2000-12-01T00:00:00</ReportingEnd>
	</Header>
	<bisjd:DataSet>
		<bisjd:Group AVAILABILITY="A" DECIMALS="2" BIS_UNIT="USD" UNIT_MULT="5">
			<bisjd:Series COLLECTION="B" TIME_FORMAT="P1M">
				<bisjd:Key>
					<bisjd:FREQ>M</bisjd:FREQ>
					<bisjd:JD_TYPE>P</bisjd:JD_TYPE>
					<bisjd:JD_CATEGORY>A</bisjd:JD_CATEGORY>
					<bisjd:VIS_CTY>MX</bisjd:VIS_CTY>					
				</bisjd:Key>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-01</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>3.14</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-02</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>3.19</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-03</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>5.26</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-04</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>5.12</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-05</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>4.13</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-06</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>3.12</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-07</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>3.14</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-08</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>3.79</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-09</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>9.79</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-10</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>3.14</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-11</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>3.19</bisjd:OBS_VALUE>
				</bisjd:Obs>
				<bisjd:Obs OBS_STATUS="A" OBS_CONF="F">
					<bisjd:TIME_PERIOD>2000-12</bisjd:TIME_PERIOD>
					<bisjd:OBS_VALUE>3.14</bisjd:OBS_VALUE>
				</bisjd:Obs>
			</bisjd:Series>
		</bisjd:Group>
	</bisjd:DataSet>
</UtilityData>		

private var _wrongData1:XML =
<UtilityData xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message SDMXMessage.xsd  http://www.newyorkfed.org/xml/schemas/RateBase/utility RateBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFBase/utility FFBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFMethod/utility FFMethodUtility.xsd http://www.newyorkfed.org/xml/schemas/FF/utility FFUtility.xsd" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" xmlns:ffbase="http://www.newyorkfed.org/xml/schemas/FFBase/utility" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/utility" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/query" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:m="http://www.newyorkfed.org/xml/schemas/FFMethod/utility" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact" xmlns:ff="http://www.newyorkfed.org/xml/structures/ffStructure.xml" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/cross" xmlns:base="http://www.newyorkfed.org/xml/schemas/RateBase/utility">
   <Header>
      <ID>FFD</ID>
      <Test>false</Test>
      <Name xml:lang="en">Wrong data</Name>
      <Prepared>2008-12-03</Prepared>
      <Sender id="ECB"/>
   </Header>
   <ff:DataSet keyFamilyURI="http://www.newyorkfed.org/xml/structures/ffStructure.xml">
      <ff:Series AVAILABILITY="A" DECIMALS="2" FF_METHOD="D" DISCLAIMER="G" TIME_FORMAT="P1D" >
         <ffbase:Key>
            <base:FREQ>D</base:FREQ>
            <base:RATE>FF</base:RATE>
            <base:MATURITY>O</base:MATURITY>
            <ffbase:FF_SCOPE>D</ffbase:FF_SCOPE>
         </ffbase:Key>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">            
            <base:OBS_VALUE>0.59</base:OBS_VALUE>
         </ff:Obs>
      </ff:Series>
   </ff:DataSet>
</UtilityData>;	
private var _wrongData2:XML =
<UtilityData xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message SDMXMessage.xsd  http://www.newyorkfed.org/xml/schemas/RateBase/utility RateBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFBase/utility FFBaseUtility.xsd http://www.newyorkfed.org/xml/schemas/FFMethod/utility FFMethodUtility.xsd http://www.newyorkfed.org/xml/schemas/FF/utility FFUtility.xsd" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" xmlns:ffbase="http://www.newyorkfed.org/xml/schemas/FFBase/utility" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/utility" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/query" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:m="http://www.newyorkfed.org/xml/schemas/FFMethod/utility" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact" xmlns:ff="http://www.newyorkfed.org/xml/structures/ffStructure.xml" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/cross" xmlns:base="http://www.newyorkfed.org/xml/schemas/RateBase/utility">
   <Header>
      <ID>FFD</ID>
      <Test>false</Test>
      <Name xml:lang="en">Wrong data</Name>
      <Prepared>2008-12-03</Prepared>
      <Sender id="ECB"/>
   </Header>
   <ff:DataSet keyFamilyURI="http://www.newyorkfed.org/xml/structures/ffStructure.xml">
      <ff:Series AVAILABILITY="A" DECIMALS="2" FF_METHOD="D" DISCLAIMER="G" TIME_FORMAT="P1D" >
         <ffbase:Key>
            <base:FREQ>D</base:FREQ>
            <base:RATE>FF</base:RATE>
            <base:MATURITY>O</base:MATURITY>
            <ffbase:FF_SCOPE>D</ffbase:FF_SCOPE>
         </ffbase:Key>
         <ff:Obs OBS_CONF="F" OBS_STATUS="A">            
            <base:TIME_PERIOD></base:TIME_PERIOD>
            <base:OBS_VALUE>0.59</base:OBS_VALUE>
         </ff:Obs>
      </ff:Series>
   </ff:DataSet>
</UtilityData>;	 
	}	
}