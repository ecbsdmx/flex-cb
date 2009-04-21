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
package org.sdmx.stores.xml.v2
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class GuessDataTypeTest extends TestCase
	{
		public function GuessDataTypeTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(GuessDataTypeTest);
		}
		
		public function testGetCompactFormat():void
		{
			assertEquals("Should be compact", SDMXDataFormats.SDMX_ML_COMPACT, 
				GuessDataType.guessFormat(_compactData));
		}
		
		public function testGetGenericFormat():void
		{
			assertEquals("Should be generic", SDMXDataFormats.SDMX_ML_GENERIC, 
				GuessDataType.guessFormat(_genericData));
		}
		
		public function testGetUtilityFormat():void
		{
			assertEquals("Should be utility", SDMXDataFormats.SDMX_ML_UTILITY, 
				GuessDataType.guessFormat(_utilityData));
		}
		
		public function testGetCrossSectionalFormat():void
		{
			assertNull("Cross-sectional is not supported", 
				GuessDataType.guessFormat(_crossSectionalData));
		}
		
		public function testGetMessageGroupFormatWithOneDataSetGeneric():void
		{
			assertEquals("Should be generic", 
				SDMXDataFormats.SDMX_ML_GENERIC, 
				GuessDataType.guessFormat(_genericDataMsgGroup));
		}
		
		public function testGetMessageGroupFormatWithOneDataSetCompact():void
		{
			assertEquals("Should be compact", 
				SDMXDataFormats.SDMX_ML_COMPACT, 
				GuessDataType.guessFormat(_compactDataMsgGroup));
		}
		
		public function testGetMessageGroupFormatWithOneDataSetUtility():void
		{
			assertEquals("Should be utility", 
				SDMXDataFormats.SDMX_ML_UTILITY, 
				GuessDataType.guessFormat(_utilityDataMsgGroup));
		}
		
		public function testGetMessageGroupFormatWithMultipleDataSets():void
		{
			assertNull("Multiple datasets is not supported", 
				GuessDataType.guessFormat(_messageGroupMultiple));
		}
		
		//Copyright SDMX 2005  -   www.sdmx.org
		private	var _compactData:XML =
<CompactData xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:bisc="urn:sdmx:org.sdmx.infomodel.keyfamily.KeyFamily=BIS:EXT_DEBT:compact"
xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd urn:sdmx:org.sdmx.infomodel.keyfamily.KeyFamily=BIS:EXT_DEBT:compact BIS_JOINT_DEBT_Compact.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact SDMXCompactData.xsd" >
	<Header>
		<ID>JD014</ID>
		<Test>true</Test>
		<Truncated>false</Truncated>
		<Name xml:lang="en">Trans46305</Name>
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
	<bisc:DataSet>
		<bisc:SiblingGroup  VIS_CTY="MX" JD_TYPE="P" JD_CATEGORY="A" AVAILABILITY="A" DECIMALS="2" BIS_UNIT="USD" UNIT_MULT="5"/>
		<bisc:SiblingGroup VIS_CTY="MX" JD_TYPE="P" JD_CATEGORY="B" AVAILABILITY="A" DECIMALS="2" BIS_UNIT="USD" UNIT_MULT="5"/>
		<bisc:Series FREQ="M" COLLECTION="B" TIME_FORMAT="P1M" VIS_CTY="MX" JD_TYPE="P" JD_CATEGORY="A" >
			<bisc:Obs TIME_PERIOD="2000-01" OBS_VALUE="3.14" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2001-02" OBS_VALUE="2.29" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-03" OBS_VALUE="3.14" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-04" OBS_VALUE="5.24" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-05" OBS_VALUE="3.14" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-06" OBS_VALUE="3.78" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-07" OBS_VALUE="3.65" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-08" OBS_VALUE="2.37" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-09" OBS_VALUE="3.14" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-10" OBS_VALUE="3.17" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-11" OBS_VALUE="3.34" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-12" OBS_VALUE="1.21" OBS_STATUS="A"/>
		</bisc:Series>
		<bisc:Series FREQ="A" COLLECTION="B" TIME_FORMAT="P1Y" VIS_CTY="MX" JD_TYPE="P" JD_CATEGORY="A">
			<bisc:Obs TIME_PERIOD="2000-01" OBS_VALUE="3.14" OBS_STATUS="A"/>
		</bisc:Series>
		<bisc:Series FREQ="M" COLLECTION="B" TIME_FORMAT="P1M" VIS_CTY="MX" JD_TYPE="P" JD_CATEGORY="B">
			<bisc:Obs TIME_PERIOD="2000-01" OBS_VALUE="5.14" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2001-02" OBS_VALUE="3.29" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-03" OBS_VALUE="6.14" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-04" OBS_VALUE="2.24" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-05" OBS_VALUE="3.14" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-06" OBS_VALUE="7.78" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-07" OBS_VALUE="3.65" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-08" OBS_VALUE="5.37" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-09" OBS_VALUE="3.14" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-10" OBS_VALUE="1.17" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-11" OBS_VALUE="4.34" OBS_STATUS="A"/>
			<bisc:Obs TIME_PERIOD="2000-12" OBS_VALUE="1.21" OBS_STATUS="A"/>
		</bisc:Series>
		<bisc:Series FREQ="A" COLLECTION="B" TIME_FORMAT="P1Y" VIS_CTY="MX" JD_TYPE="P" JD_CATEGORY="B" >
			<bisc:Obs TIME_PERIOD="2000-01" OBS_VALUE="4.14" OBS_STATUS="A"/>
		</bisc:Series>
	</bisc:DataSet>
</CompactData>;
		
		//Copyright SDMX 2005  -   www.sdmx.org
		private var _genericData:XML =
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
</GenericData>;

		//Copyright SDMX 2005  -   www.sdmx.org
		private var _utilityData:XML =
<UtilityData xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/draft/common" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/draft/compact" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/draft/cross" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/draft/generic" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/draft/query" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/draft/structure" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/draft/utility" 
xmlns:bisjd="urn:sdmx:org.sdmx.infomodel.keyfamily.KeyFamily=BIS:EXT_DEBT:utility"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd urn:sdmx:org.sdmx.infomodel.keyfamily.KeyFamily=BIS:EXT_DEBT:utility BIS_JOINT_DEBT_Utility.xsd" >
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
		<bisjd:SiblingGroup AVAILABILITY="A" DECIMALS="2" BIS_UNIT="USD" UNIT_MULT="5">
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
			</bisjd:Series>
		</bisjd:SiblingGroup>
	</bisjd:DataSet>
</UtilityData>;

		private var _messageGroupMultiple:XML =
<MessageGroup 
	xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message https://stats.ecb.europa.eu/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd">
	<Header>
		<ID>IREF000001</ID>
		<Test>false</Test>
		<Name xml:lang="en">ECB structural definitions</Name>
		<Prepared>2009-03-16T11:18:27Z</Prepared>
		<Sender id="4F0"><Name xml:lang="en">European Central Bank</Name><Contact><Department xml:lang="en">DG Statistics</Department><URI>mailto:statistics@ecb.europa.eu</URI></Contact></Sender>
		<Extracted>2009-03-16T11:18:27Z</Extracted>
	</Header>
	<DataSet>
		<Group REF_AREA="I4" ADJUSTMENT="N" GOVNT_REF_SECTOR="B1300" GOVNT_ITEM_ESA="TOE" GOVNT_COUNT_SECTOR="B0000" GOVNT_VALUATION="CU" GOVNT_ST_SUFFIX="G" TITLE_COMPL="Euro area 15 (fixed composition) - Total expenditure - All sectors/ unspecified/ not applicable (ESA95)-NCBs - General government (ESA95)-NCBs - Non-financial flows current prices - Percentage points, series(t)/GDP(t) - Neither seasonally nor working day adjusted" UNIT="PC" UNIT_MULT="0" DECIMALS="6"/>
		<Series FREQ="A" REF_AREA="I4" ADJUSTMENT="N" GOVNT_REF_SECTOR="B1300" GOVNT_ITEM_ESA="TOE" GOVNT_COUNT_SECTOR="B0000" GOVNT_VALUATION="CU" GOVNT_ST_SUFFIX="G" TIME_FORMAT="P1Y" COLLECTION="S" PUBL_PUBLIC="SPB.T0101; SPB.T0701; SPB.T1110">
			<Obs TIME_PERIOD="1995" OBS_VALUE="52.797882" OBS_STATUS="A"/>
		</Series>
	</DataSet>
	<DataSet>
		<Group AME_REF_AREA="AUT" AME_TRANSFORMATION="1" AME_AGG_METHOD="0" AME_UNIT="0" AME_REFERENCE="0" AME_ITEM="UUTGE" EXT_TITLE="Austria - Total expenditure: general government :- Excessive deficit procedure (Including one-off proceeds (treated as negative expenditure) relative to the allocation of mobile phone licences (UMTS))" EXT_UNIT="National currency" TITLE_COMPL="Austria - Total expenditure: general government :- Excessive deficit procedure (Including one-off proceeds (treated as negative expenditure) relative to the allocation of mobile phone licences (UMTS)) - National currency - AMECO data class: Data at current prices"/>
		<Series FREQ="A" AME_REF_AREA="AUT" AME_TRANSFORMATION="1" AME_AGG_METHOD="0" AME_UNIT="0" AME_REFERENCE="0" AME_ITEM="UUTGE" TIME_FORMAT="P1Y" PUBL_PUBLIC="SPB.T1110">
			<Obs TIME_PERIOD="1976" OBS_VALUE="26.6546" OBS_STATUS="A"/>
		</Series>
	</DataSet>
</MessageGroup>;		

		private var _crossSectionalData:XML =
//Copyright SDMX 2005  -   www.sdmx.org
<CrossSectionalData xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:biscs="urn:sdmx:org.sdmx.infomodel.keyfamily.KeyFamily=BIS:EXT_DEBT:cross"
xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd urn:sdmx:org.sdmx.infomodel.keyfamily.KeyFamily=BIS:EXT_DEBT:cross BIS_JOINT_DEBT_CrossSectional.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross SDMXCrossSectionalData.xsd">
	<Header>
		<ID>BIS947586</ID>
		<Test>true</Test>
		<Truncated>false</Truncated>
		<Name xml:lang="en">Trans46305</Name>
		<Prepared>2001-03-11T09:30:47-05:00</Prepared>
		<Sender id="BIS">
			<Name xml:lang="en">Bank for International Settlements</Name>
			<Contact>
				<Name xml:lang="en">G.B. Smith</Name>
				<Telephone>+000.000.0000</Telephone>
			</Contact>
		</Sender>
	</Header>
	<biscs:DataSet>
		<biscs:Group  TIME="2000" BIS_UNIT="USD" UNIT_MULT="5" DECIMALS="2" AVAILABILITY="A" FREQ="A" >
			<biscs:Section COLLECTION="B" TIME_FORMAT="P1Y">
				<biscs:STOCKS  JD_CATEGORY="A" value="3.14" OBS_STATUS="A" VIS_CTY="MX"/>
				<biscs:FLOWS  JD_CATEGORY="A" value="1.00" OBS_STATUS="A" VIS_CTY="MX"/>
				<biscs:STOCKS  JD_CATEGORY="B" value="6.39" OBS_STATUS="A" VIS_CTY="MX"/>
				<biscs:FLOWS  JD_CATEGORY="B" value="2.27" OBS_STATUS="A" VIS_CTY="MX"/>
				<biscs:STOCKS  JD_CATEGORY="C" value="2.34" OBS_STATUS="A" VIS_CTY="MX"/>
				<biscs:FLOWS  JD_CATEGORY="C" value="-1.00" OBS_STATUS="A" VIS_CTY="MX"/>
				<biscs:STOCKS  JD_CATEGORY="D" value="3.19" OBS_STATUS="A" VIS_CTY="MX"/>
				<biscs:FLOWS  JD_CATEGORY="D" value="-1.06" OBS_STATUS="A" VIS_CTY="MX"/>
			</biscs:Section>
		</biscs:Group>
	</biscs:DataSet>
</CrossSectionalData>;	

		private var _compactDataMsgGroup:XML =
<MessageGroup 
	xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message https://stats.ecb.europa.eu/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd">
	<Header>
		<ID>IREF000001</ID>
		<Test>false</Test>
		<Name xml:lang="en">ECB structural definitions</Name>
		<Prepared>2009-03-16T11:18:27Z</Prepared>
		<Sender id="4F0"><Name xml:lang="en">European Central Bank</Name><Contact><Department xml:lang="en">DG Statistics</Department><URI>mailto:statistics@ecb.europa.eu</URI></Contact></Sender>
		<Extracted>2009-03-16T11:18:27Z</Extracted>
	</Header>
	<DataSet>
		<Group REF_AREA="I4" ADJUSTMENT="N" GOVNT_REF_SECTOR="B1300" GOVNT_ITEM_ESA="TOE" GOVNT_COUNT_SECTOR="B0000" GOVNT_VALUATION="CU" GOVNT_ST_SUFFIX="G" TITLE_COMPL="Euro area 15 (fixed composition) - Total expenditure - All sectors/ unspecified/ not applicable (ESA95)-NCBs - General government (ESA95)-NCBs - Non-financial flows current prices - Percentage points, series(t)/GDP(t) - Neither seasonally nor working day adjusted" UNIT="PC" UNIT_MULT="0" DECIMALS="6"/>
		<Series FREQ="A" REF_AREA="I4" ADJUSTMENT="N" GOVNT_REF_SECTOR="B1300" GOVNT_ITEM_ESA="TOE" GOVNT_COUNT_SECTOR="B0000" GOVNT_VALUATION="CU" GOVNT_ST_SUFFIX="G" TIME_FORMAT="P1Y" COLLECTION="S" PUBL_PUBLIC="SPB.T0101; SPB.T0701; SPB.T1110">
			<Obs TIME_PERIOD="1995" OBS_VALUE="52.797882" OBS_STATUS="A"/>
		</Series>
	</DataSet>
</MessageGroup>;	

		private var _genericDataMsgGroup:XML =
<MessageGroup 
	xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message https://stats.ecb.europa.eu/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd">
	<Header>
		<ID>IREF000001</ID>
		<Test>false</Test>
		<Name xml:lang="en">ECB structural definitions</Name>
		<Prepared>2009-03-16T11:18:27Z</Prepared>
		<Sender id="4F0"><Name xml:lang="en">European Central Bank</Name><Contact><Department xml:lang="en">DG Statistics</Department><URI>mailto:statistics@ecb.europa.eu</URI></Contact></Sender>
		<Extracted>2009-03-16T11:18:27Z</Extracted>
	</Header>
	<DataSet>
		<KeyFamilyRef>BIS_JOINT_DEBT</KeyFamilyRef>
		<Group type="SiblingGroup">
			<GroupKey>
				<Value concept="JD_TYPE" value="P"/>
				<Value concept="JD_CATEGORY" value="A"/>
				<Value concept="VIS_CTY" value="MX"/>
			</GroupKey>
			<Attributes>
				<Value concept="AVAILABILITY" value="A"/>
				<Value concept="DECIMALS" value="2"/>
				<Value concept="BIS_UNIT" value="USD"/>
				<Value concept="UNIT_MULT" value="5"/>
			</Attributes>
			<Series>
				<SeriesKey>
					<Value concept="FREQ" value="A"/>
					<Value concept="JD_TYPE" value="P"/>
					<Value concept="JD_CATEGORY" value="A"/>
					<Value concept="VIS_CTY" value="MX"/>
				</SeriesKey>
				<Attributes>
					<Value concept="COLLECTION" value="B"/>
					<Value concept="TIME_FORMAT" value="P1Y"/>
				</Attributes>
				<Obs>
					<Time>2000-01</Time>
					<ObsValue  value="3.14"/>
					<Attributes>
						<Value concept="OBS_STATUS" value="A"/>
					</Attributes>
				</Obs>
			</Series>			
		</Group>
	</DataSet>
</MessageGroup>;

		private var _utilityDataMsgGroup:XML =
<MessageGroup 
	xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message https://stats.ecb.europa.eu/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd">
	<Header>
		<ID>IREF000001</ID>
		<Test>false</Test>
		<Name xml:lang="en">ECB structural definitions</Name>
		<Prepared>2009-03-16T11:18:27Z</Prepared>
		<Sender id="4F0"><Name xml:lang="en">European Central Bank</Name><Contact><Department xml:lang="en">DG Statistics</Department><URI>mailto:statistics@ecb.europa.eu</URI></Contact></Sender>
		<Extracted>2009-03-16T11:18:27Z</Extracted>
	</Header>
	<DataSet>
		<SiblingGroup AVAILABILITY="A" DECIMALS="2" BIS_UNIT="USD" UNIT_MULT="5">
			<Series COLLECTION="B" TIME_FORMAT="P1M">
				<Key>
					<FREQ>M</FREQ>
					<JD_TYPE>P</JD_TYPE>
					<JD_CATEGORY>A</JD_CATEGORY>
					<VIS_CTY>MX</VIS_CTY>					
				</Key>
				<Obs OBS_STATUS="A" OBS_CONF="F">
					<TIME_PERIOD>2000-01</TIME_PERIOD>
					<OBS_VALUE>3.14</OBS_VALUE>
				</Obs>
			</Series>
		</SiblingGroup>
	</DataSet>
</MessageGroup>;
	}
}