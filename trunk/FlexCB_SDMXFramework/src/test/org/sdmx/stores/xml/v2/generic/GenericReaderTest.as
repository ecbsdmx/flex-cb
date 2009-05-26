// Copyright (c) 2009, European Central Bank
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
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.event.SDMXDataEvent;
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

	public class GenericReaderTest extends TestCase
	{
		
		private var _reader:GenericReader;
		
		public function GenericReaderTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(GenericReaderTest);
		}
		
		public function testBISData():void
		{
			var structureReader:StructureReader = new StructureReader();
			structureReader.dispatchKeyFamilies = true;
			structureReader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleBISKeyFamilies, 3000));
			structureReader.read(_bisStructureXml);
		}	
		
		private function handleBISKeyFamilies(event:SDMXDataEvent):void 
		{
			_reader = new GenericReader((event.data as KeyFamilies).getItemAt(0) 
				as KeyFamily);
			_reader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleBISDataReady);
			_reader.dataFile = _bisDataXml;
		}
		
		private function handleBISDataReady(event:Event):void
		{
			_reader.addEventListener(DataReaderAdapter.DATASET_EVENT,
				handleBISDataWithGroup);
			_reader.query();	
		}
		
		private function handleBISDataWithGroup(event:SDMXDataEvent):void
		{
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
			assertEquals("The group should contain two series", 2, 
				group.timeseriesKeys.length)
			var series:TimeseriesKey = 
				group.timeseriesKeys.getItemAt(0) as TimeseriesKey; 	
			assertEquals("The series key should match", "M.P.A.MX", 
				series.seriesKey);
			assertEquals("The series should have 2 attributes", 2, 
				series.attributeValues.length);
			var attribute2:CodedAttributeValue = 
				series.attributeValues.getItemAt(0) as CodedAttributeValue;
			assertEquals("The attribute id should match", "COLLECTION", 
				attribute2.valueFor.conceptIdentity.id);
			assertEquals("The attribute value should match", "B", 
				attribute2.value.id);	
			assertEquals("The series should contain 12 observations", 12, 
				series.timePeriods.length);
			var obs:TimePeriod = series.timePeriods.getItemAt(11) as TimePeriod;	
			assertEquals("The obs value should be 3.24", "3.24", 
				obs.observationValue);		
			assertEquals("The obs period should be 2000-12", "2000-12", 
				obs.periodComparator);
			assertEquals("The observation should have 1 attribute", 1, 
				obs.observation.attributeValues.length);
			var attribute3:CodedAttributeValue = 
				obs.observation.attributeValues.getItemAt(0) 
					as CodedAttributeValue;
			assertEquals("The attribute id should match", "OBS_STATUS", 
				attribute3.valueFor.conceptIdentity.id);
			assertEquals("The attribute value should match", "A", 
				attribute3.value.id);
		}
		
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
<GenericData xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd">
	<Header>
			<ID>JD014</ID>
			<Test>true</Test>
			<Truncated>false</Truncated>
			<Name xml:lang="en">Trans46302</Name>
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
			<DataSetAgency>BIS</DataSetAgency>
			<DataSetID>BIS_JD_237</DataSetID>
			<DataSetAction>Append</DataSetAction>
			<Extracted>2001-03-11T09:30:47-05:00</Extracted>
			<ReportingBegin>2000-01-01T00:00:00</ReportingBegin>
			<ReportingEnd>2000-12-01T00:00:00</ReportingEnd>
	</Header>
	<DataSet>
		<generic:KeyFamilyRef>BIS_JOINT_DEBT</generic:KeyFamilyRef>
		<generic:Group type="SiblingGroup">
			<generic:GroupKey>
				<generic:Value concept="JD_TYPE" value="P"/>
				<generic:Value concept="JD_CATEGORY" value="A"/>
				<generic:Value concept="VIS_CTY" value="MX"/>
			</generic:GroupKey>
			
			<generic:Attributes>
				<generic:Value concept="AVAILABILITY" value="A"/>
				<generic:Value concept="DECIMALS" value="2"/>
				<generic:Value concept="BIS_UNIT" value="USD"/>
				<generic:Value concept="UNIT_MULT" value="5"/>
			</generic:Attributes>
			<generic:Series>
				<generic:SeriesKey>
					<generic:Value concept="FREQ" value="M"/>
					<generic:Value concept="JD_TYPE" value="P"/>
					<generic:Value concept="JD_CATEGORY" value="A"/>
					<generic:Value concept="VIS_CTY" value="MX"/>
				</generic:SeriesKey>
				<generic:Attributes>
					<generic:Value concept="COLLECTION" value="B"/>
					<generic:Value concept="TIME_FORMAT" value="P1M"/>
				</generic:Attributes>
				<generic:Obs>
					<generic:Time>2000-01</generic:Time>
					<generic:ObsValue  value="3.14"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				
				<generic:Obs>
					<generic:Time>2000-02</generic:Time>
					<generic:ObsValue  value="3.14"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-03</generic:Time>
					<generic:ObsValue  value="4.29"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-04</generic:Time>
					<generic:ObsValue  value="6.04"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-05</generic:Time>
					<generic:ObsValue  value="5.18"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-06</generic:Time>
					<generic:ObsValue  value="5.07"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-07</generic:Time>
					<generic:ObsValue  value="3.13"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-08</generic:Time>
					<generic:ObsValue  value="1.17"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-09</generic:Time>
					<generic:ObsValue  value="1.14"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-10</generic:Time>
					<generic:ObsValue  value="3.04"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-11</generic:Time>
					<generic:ObsValue  value="1.14"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
				<generic:Obs>
					<generic:Time>2000-12</generic:Time>
					<generic:ObsValue  value="3.24"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>

			</generic:Series>
			<generic:Series>
				<generic:SeriesKey>
					<generic:Value concept="FREQ" value="A"/>
					<generic:Value concept="JD_TYPE" value="P"/>
					<generic:Value concept="JD_CATEGORY" value="A"/>
					<generic:Value concept="VIS_CTY" value="MX"/>
				</generic:SeriesKey>
				<generic:Attributes>
					<generic:Value concept="COLLECTION" value="B"/>
					<generic:Value concept="TIME_FORMAT" value="P1Y"/>
				</generic:Attributes>
				<generic:Obs>
					<generic:Time>2000-01</generic:Time>
					<generic:ObsValue  value="3.14"/>
					<generic:Attributes>
						<generic:Value concept="OBS_STATUS" value="A"/>
					</generic:Attributes>
				</generic:Obs>
			</generic:Series>			
			
			
		</generic:Group>
	</DataSet>
	
</GenericData>
	}
}