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
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	public class FindKeyFamilyTest extends TestCase
	{
		
		private var _kf:KeyFamily;
		
		public function FindKeyFamilyTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(FindKeyFamilyTest);
		}
		
		public function testGetOneKeyFamily():void
		{
			_kf = new KeyFamily("TEST", new InternationalString(), 
				new MaintenanceAgency("ECB"), new KeyDescriptor(), 
				new MeasureDescriptor(), true);
			var keyFamilies:KeyFamilies = new KeyFamilies();
			keyFamilies.addItem(_kf);	
			assertEquals("In testGetOneKeyFamily", _kf, FindKeyFamily.find(
				_compactData, keyFamilies));	
		}
		
		public function testGetKeyFamilyByURN():void
		{
			var kf0:KeyFamily = new KeyFamily("KF0", new InternationalString(), 
				new MaintenanceAgency("ECB"), new KeyDescriptor(), 
				new MeasureDescriptor(), true);
			_kf = new KeyFamily("TEST", new InternationalString(), 
				new MaintenanceAgency("ECB"), new KeyDescriptor(), 
				new MeasureDescriptor(), true);
			_kf.urn = "http://test.test/";	
			var keyFamilies:KeyFamilies = new KeyFamilies();
			keyFamilies.addItem(kf0);
			keyFamilies.addItem(_kf);	
			assertEquals("In testGetTwoKeyFamily", _kf, FindKeyFamily.find(
				_compactData, keyFamilies));	
		}
		
		public function testGetKeyFamilyByID():void
		{
			var kf0:KeyFamily = new KeyFamily("KF0", new InternationalString(), 
				new MaintenanceAgency("ECB"), new KeyDescriptor(), 
				new MeasureDescriptor(), true);
			_kf = new KeyFamily("BIS_JOINT_DEBT", new InternationalString(), 
				new MaintenanceAgency("BIS"), new KeyDescriptor(), 
				new MeasureDescriptor(), true);
			var keyFamilies:KeyFamilies = new KeyFamilies();
			keyFamilies.addItem(kf0);
			keyFamilies.addItem(_kf);	
			assertEquals("In testGetThreeKeyFamily", _kf, FindKeyFamily.find(
				_genericData, keyFamilies));	
		}
		
		private var _compactData:XML =
<MessageGroup 
	xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:testkf="http://test.test/"
	xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message https://stats.ecb.europa.eu/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd">
	<Header>
		<ID>IREF000001</ID>
		<Test>false</Test>
		<Name xml:lang="en">ECB structural definitions</Name>
		<Prepared>2009-03-16T11:18:27Z</Prepared>
		<Sender id="4F0"><Name xml:lang="en">European Central Bank</Name><Contact><Department xml:lang="en">DG Statistics</Department><URI>mailto:statistics@ecb.europa.eu</URI></Contact></Sender>
		<Extracted>2009-03-16T11:18:27Z</Extracted>
	</Header>
	<testkf:DataSet>
		<Group REF_AREA="I4" ADJUSTMENT="N" GOVNT_REF_SECTOR="B1300" GOVNT_ITEM_ESA="TOE" GOVNT_COUNT_SECTOR="B0000" GOVNT_VALUATION="CU" GOVNT_ST_SUFFIX="G" TITLE_COMPL="Euro area 15 (fixed composition) - Total expenditure - All sectors/ unspecified/ not applicable (ESA95)-NCBs - General government (ESA95)-NCBs - Non-financial flows current prices - Percentage points, series(t)/GDP(t) - Neither seasonally nor working day adjusted" UNIT="PC" UNIT_MULT="0" DECIMALS="6"/>
		<Series FREQ="A" REF_AREA="I4" ADJUSTMENT="N" GOVNT_REF_SECTOR="B1300" GOVNT_ITEM_ESA="TOE" GOVNT_COUNT_SECTOR="B0000" GOVNT_VALUATION="CU" GOVNT_ST_SUFFIX="G" TIME_FORMAT="P1Y" COLLECTION="S" PUBL_PUBLIC="SPB.T0101; SPB.T0701; SPB.T1110">
			<Obs TIME_PERIOD="1995" OBS_VALUE="52.797882" OBS_STATUS="A"/>
		</Series>
	</testkf:DataSet>
</MessageGroup>;	

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
	}
}