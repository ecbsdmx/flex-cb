package org.sdmx.stores.xml.v2
{
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.stores.api.BaseSDMXDaoFactory;
	import org.sdmx.stores.xml.v2.structure.StructureReader;

	public class SDMXMLDataDaoTest extends TestCase
	{
		private var _dataDao:SDMXMLDataDao;
		
		public function SDMXMLDataDaoTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(SDMXMLDataDaoTest);
		}
		
		public function testDataDao():void
		{
			var structureReader:StructureReader = new StructureReader();
			structureReader.dispatchKeyFamilies = true;
			structureReader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleKeyFamilies, 3000));
			structureReader.read(_structureXML);	
		}
		
		private function handleKeyFamilies(event:SDMXDataEvent):void 
		{
			_dataDao = new SDMXMLDataDao();
			_dataDao.optimisationLevel = 0;
			_dataDao.disableObservationAttribute = true;
			_dataDao.keyFamilies = event.data as KeyFamilies;
			_dataDao.dataFile = _compactXML;
			_dataDao.getData();	
			_dataDao.addEventListener(BaseSDMXDaoFactory.DATA_EVENT,
				handleDataSet);	
		}
		
		private function handleDataSet(event:SDMXDataEvent):void
		{
			var dataSet:DataSet = event.data as DataSet;
			assertNotNull("The dataset should not be null", dataSet);
			assertEquals("There should be no attributes on the dataset level",
				0, dataSet.attributeValues.length);
			assertTrue("The extraction date should be 2007-04-26", 
				dataSet.dataExtractionDate.fullYearUTC == 2007 &&
				dataSet.dataExtractionDate.monthUTC == 3 &&
				dataSet.dataExtractionDate.date == 26);
			assertNull("There is no dataflow associated to the dataset", 
				dataSet.describedBy);
			assertNull("There is no reporting begin date", 
				dataSet.reportingBeginDate);	
			assertNull("There is no reporting end date",
				dataSet.reportingEndDate);
			assertEquals("There should be two groups", 2, 
				dataSet.groupKeys.length);
			assertEquals("First group does not contain series", 0, 
				(dataSet.groupKeys.getItemAt(0) as GroupKey).timeseriesKeys.length);	
			assertEquals("Second group contains the series", 1, 
				(dataSet.groupKeys.getItemAt(1) as GroupKey).timeseriesKeys.length);
			assertEquals("There should be one series", 1, 
				dataSet.timeseriesKeys.length);				
			assertEquals("The series key should be =", "D.USD.EUR.SP00.A", 
				(dataSet.timeseriesKeys.getItemAt(0) as TimeseriesKey).seriesKey);	
			assertEquals("The series should have 6 observations", 6, 
				(dataSet.timeseriesKeys.getItemAt(0) 
					as TimeseriesKey).timePeriods.length);
			var obs:TimePeriod = (dataSet.timeseriesKeys.getItemAt(0) 
				as TimeseriesKey).timePeriods.getItemAt(3) as TimePeriod;
			assertEquals("The values should be equal", 1.1632, 
				obs.observationValue);
			assertEquals("The periods should be equal", "1999-01-07", 
				obs.periodComparator);	
			assertEquals("There should be 2 attributes", 2, 
				obs.observation.attributeValues.length);	
			assertEquals("The last attribute should be the obs_conf", 
				"OBS_CONF", (obs.observation.attributeValues.getItemAt(1) 
				as CodedAttributeValue).valueFor.id);
			assertEquals("The oservation should be free", 
				"F", (obs.observation.attributeValues.getItemAt(1) 
				as CodedAttributeValue).value.id);	
		}
		
		private var _compactXML:XML =
<CompactData xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message https://stats.ecb.int/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd">
	<Header>
		<ID>EXR-HIST_2007-04-26</ID>
		<Test>false</Test>
		<Name xml:lang="en">Euro foreign exchange reference rates</Name>
		  <Prepared>2007-04-26T14:25:11</Prepared>
		<Sender id="4F0">
			<Name xml:lang="en">European Central Bank</Name>
		</Sender>
		<DataSetAgency>ECB</DataSetAgency>
		<DataSetID>ECB_EXR_WEB</DataSetID>
		<Extracted>2007-04-26T14:25:11</Extracted>
	</Header>
	<DataSet xmlns="http://www.ecb.int/vocabulary/stats/exr/1" xsi:schemaLocation="http://www.ecb.int/vocabulary/stats/exr/1 https://stats.ecb.int/stats/vocabulary/exr/1/2006-09-04/sdmx-compact.xsd">
		<Group CURRENCY="AUD" CURRENCY_DENOM="EUR" EXR_TYPE="SP00" EXR_SUFFIX="A" DECIMALS="4" UNIT="USD" UNIT_MULT="0" TITLE_COMPL="ECB reference exchange rate, Australian dollar/Euro, 2:15 pm (C.E.T.)" />
		<Group CURRENCY="USD" CURRENCY_DENOM="EUR" EXR_TYPE="SP00" EXR_SUFFIX="A" DECIMALS="4" UNIT="USD" UNIT_MULT="0" TITLE_COMPL="ECB reference exchange rate, US dollar/Euro, 2:15 pm (C.E.T.)" />
		<Series FREQ="D" CURRENCY="USD" CURRENCY_DENOM="EUR" EXR_TYPE="SP00" EXR_SUFFIX="A" TIME_FORMAT="P1D" COLLECTION="A">
			<Obs TIME_PERIOD="1999-01-04" OBS_VALUE="1.1789" OBS_STATUS="A" OBS_CONF="F" />
			<Obs TIME_PERIOD="1999-01-05" OBS_VALUE="1.1790" OBS_STATUS="A" OBS_CONF="F" />
			<Obs TIME_PERIOD="1999-01-06" OBS_VALUE="1.1743" OBS_STATUS="A" OBS_CONF="F" />
			<Obs TIME_PERIOD="1999-01-07" OBS_VALUE="1.1632" OBS_STATUS="A" OBS_CONF="F" />
			<Obs TIME_PERIOD="1999-01-08" OBS_VALUE="1.1659" OBS_STATUS="A" OBS_CONF="F" />
			<Obs TIME_PERIOD="1999-01-11" OBS_VALUE="1.1569" OBS_STATUS="A" OBS_CONF="F" />
		</Series>
	</DataSet>
</CompactData>	

		private var _structureXML:XML =
<Structure 
	xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure SDMXStructure.xsd">
	<Header>
		<ID>IREF000506</ID>
		<Test>false</Test>
		<Name xml:lang="en">ECB structural definitions</Name>
		<Prepared>2006-10-25T14:26:00</Prepared>
		<Sender id="4F0"/>
	</Header>
	<message:CodeLists xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
		<CodeList agencyID="ECB" id="CL_COLLECTION">
			<Name xml:lang="en">Collection indicator code list</Name>
			<Code value="A">
				<Description xml:lang="EN">Average of observations through period</Description>
			</Code>
			<Code value="B">
				<Description xml:lang="en">Beginning of period</Description>
			</Code>
			<Code value="E">
				<Description xml:lang="en">End of period</Description>
			</Code>
			<Code value="H">
				<Description xml:lang="en">Highest in period</Description>
			</Code>
			<Code value="L">
				<Description xml:lang="en">Lowest in period</Description>
			</Code>
			<Code value="M">
				<Description xml:lang="en">Middle of period</Description>
			</Code>
			<Code value="S">
				<Description xml:lang="en">Summed through period</Description>
			</Code>
			<Code value="U">
				<Description xml:lang="en">Unknown</Description>
			</Code>
			<Code value="V">
				<Description xml:lang="en">Other</Description>
			</Code>
			<Code value="Y">
				<Description xml:lang="en">Annualised summed</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_CURRENCY">
			<Name xml:lang="en">Currency code list</Name>
			<Code value="ALL">
				<Description xml:lang="en">Albanian lek</Description>
			</Code>
			<Code value="ARS">
				<Description xml:lang="en">Argentine peso</Description>
			</Code>
			<Code value="ATS">
				<Description xml:lang="en">Austrian schilling</Description>
			</Code>
			<Code value="AUD">
				<Description xml:lang="en">Australian dollar</Description>
			</Code>
			<Code value="BAM">
				<Description xml:lang="en">Bosnia-Hezergovinian convertible mark</Description>
			</Code>
			<Code value="BEF">
				<Description xml:lang="en">Belgian franc</Description>
			</Code>
			<Code value="BEL">
				<Description xml:lang="en">Belgian franc (financial)</Description>
			</Code>
			<Code value="BGN">
				<Description xml:lang="en">Bulgarian lev</Description>
			</Code>
			<Code value="BRL">
				<Description xml:lang="en">Brazilian real</Description>
			</Code>
			<Code value="CAD">
				<Description xml:lang="en">Canadian dollar</Description>
			</Code>
			<Code value="CHF">
				<Description xml:lang="en">Swiss franc</Description>
			</Code>
			<Code value="CLP">
				<Description xml:lang="en">Chilean peso</Description>
			</Code>
			<Code value="CNY">
				<Description xml:lang="en">Chinese yuan renminbi</Description>
			</Code>
			<Code value="COP">
				<Description xml:lang="en">Colombian peso</Description>
			</Code>
			<Code value="CSD">
				<Description xml:lang="en">Serbian dinar</Description>
			</Code>
			<Code value="CYP">
				<Description xml:lang="en">Cyprus pound</Description>
			</Code>
			<Code value="CZK">
				<Description xml:lang="en">Czech koruna</Description>
			</Code>
			<Code value="DEM">
				<Description xml:lang="en">German mark</Description>
			</Code>
			<Code value="DKK">
				<Description xml:lang="en">Danish krone</Description>
			</Code>
			<Code value="DZD">
				<Description xml:lang="en">Algerian dinar</Description>
			</Code>
			<Code value="EEK">
				<Description xml:lang="en">Estonian kroon</Description>
			</Code>
			<Code value="EGP">
				<Description xml:lang="en">Egyptian pound</Description>
			</Code>
			<Code value="ESP">
				<Description xml:lang="en">Spanish peseta</Description>
			</Code>
			<Code value="EUR">
				<Description xml:lang="en">Euro</Description>
			</Code>
			<Code value="FIM">
				<Description xml:lang="en">Finnish markka</Description>
			</Code>
			<Code value="FRF">
				<Description xml:lang="en">French franc</Description>
			</Code>
			<Code value="GBP">
				<Description xml:lang="en">UK pound sterling</Description>
			</Code>
			<Code value="GRD">
				<Description xml:lang="en">Greek drachma</Description>
			</Code>
			<Code value="HKD">
				<Description xml:lang="en">Hong Kong dollar</Description>
			</Code>
			<Code value="HRK">
				<Description xml:lang="en">Croatian kuna</Description>
			</Code>
			<Code value="HUF">
				<Description xml:lang="en">Hungarian forint</Description>
			</Code>
			<Code value="IDR">
				<Description xml:lang="en">Indonesian rupiah</Description>
			</Code>
			<Code value="IEP">
				<Description xml:lang="en">Irish pound</Description>
			</Code>
			<Code value="ILS">
				<Description xml:lang="en">Israeli shekel</Description>
			</Code>
			<Code value="INR">
				<Description xml:lang="en">Indian rupee</Description>
			</Code>
			<Code value="IQD">
				<Description xml:lang="en">Iraqi dinar</Description>
			</Code>
			<Code value="IRR">
				<Description xml:lang="en">Iranian rial</Description>
			</Code>
			<Code value="ISK">
				<Description xml:lang="en">Iceland krona</Description>
			</Code>
			<Code value="ITL">
				<Description xml:lang="en">Italian lira</Description>
			</Code>
			<Code value="JOD">
				<Description xml:lang="en">Jordanian dinar</Description>
			</Code>
			<Code value="JPY">
				<Description xml:lang="en">Japanese yen</Description>
			</Code>
			<Code value="KPW">
				<Description xml:lang="en">Korean won (North)</Description>
			</Code>
			<Code value="KRW">
				<Description xml:lang="en">Korean won (Republic)</Description>
			</Code>
			<Code value="KWD">
				<Description xml:lang="en">Kuwait dinar</Description>
			</Code>
			<Code value="LBP">
				<Description xml:lang="en">Lebanese pound</Description>
			</Code>
			<Code value="LKR">
				<Description xml:lang="en">Sri Lanka rupee</Description>
			</Code>
			<Code value="LTL">
				<Description xml:lang="en">Lithuanian litas</Description>
			</Code>
			<Code value="LUF">
				<Description xml:lang="en">Luxembourg franc</Description>
			</Code>
			<Code value="LVL">
				<Description xml:lang="en">Latvian lats</Description>
			</Code>
			<Code value="LYD">
				<Description xml:lang="en">Libyan dinar</Description>
			</Code>
			<Code value="MAD">
				<Description xml:lang="en">Moroccan dirham</Description>
			</Code>
			<Code value="MKD">
				<Description xml:lang="en">Macedonian denar</Description>
			</Code>
			<Code value="MTL">
				<Description xml:lang="en">Maltese lira</Description>
			</Code>
			<Code value="MXN">
				<Description xml:lang="en">Mexican peso</Description>
			</Code>
			<Code value="MYR">
				<Description xml:lang="en">Malaysian ringgit</Description>
			</Code>
			<Code value="NLG">
				<Description xml:lang="en">Netherlands guilder</Description>
			</Code>
			<Code value="NOK">
				<Description xml:lang="en">Norwegian krone</Description>
			</Code>
			<Code value="NZD">
				<Description xml:lang="en">New Zealand dollar</Description>
			</Code>
			<Code value="PEN">
				<Description xml:lang="en">Peru nuevo sol</Description>
			</Code>
			<Code value="PHP">
				<Description xml:lang="en">Philippine peso</Description>
			</Code>
			<Code value="PKR">
				<Description xml:lang="en">Pakistan rupee</Description>
			</Code>
			<Code value="PLN">
				<Description xml:lang="en">Polish zloty (new)</Description>
			</Code>
			<Code value="PTE">
				<Description xml:lang="en">Portugese escudo</Description>
			</Code>
			<Code value="ROL">
				<Description xml:lang="en">Romanian leu</Description>
			</Code>
			<Code value="RON">
				<Description xml:lang="en">Romanian leu (new)</Description>
			</Code>
			<Code value="RUB">
				<Description xml:lang="en">rouble (new)</Description>
			</Code>
			<Code value="SAR">
				<Description xml:lang="en">Saudi riyal</Description>
			</Code>
			<Code value="SEK">
				<Description xml:lang="en">Swedish krona</Description>
			</Code>
			<Code value="SGD">
				<Description xml:lang="en">Singapore dollar</Description>
			</Code>
			<Code value="SIT">
				<Description xml:lang="en">Slovenian tolar</Description>
			</Code>
			<Code value="SKK">
				<Description xml:lang="en">Slovak koruna</Description>
			</Code>
			<Code value="SYP">
				<Description xml:lang="en">Syrian pound</Description>
			</Code>
			<Code value="THB">
				<Description xml:lang="en">Thai bhat</Description>
			</Code>
			<Code value="TND">
				<Description xml:lang="en">Tunisian dinar</Description>
			</Code>
			<Code value="TRL">
				<Description xml:lang="en">Turkish lira</Description>
			</Code>
			<Code value="TRY">
				<Description xml:lang="en">Turkish lira (new)</Description>
			</Code>
			<Code value="TWD">
				<Description xml:lang="en">New Taiwan dollar</Description>
			</Code>
			<Code value="UAH">
				<Description xml:lang="en">Ukraine hryvnia</Description>
			</Code>
			<Code value="USD">
				<Description xml:lang="en">US dollar</Description>
			</Code>
			<Code value="VEB">
				<Description xml:lang="en">Venezuela bolivar</Description>
			</Code>
			<Code value="XAG">
				<Description xml:lang="en">Silver</Description>
			</Code>
			<Code value="XDR">
				<Description xml:lang="en">Special Drawing Rights (SDR)</Description>
			</Code>
			<Code value="XEU">
				<Description xml:lang="en">European Currency Unit (E.C.U.)</Description>
			</Code>
			<Code value="Z01">
				<Description xml:lang="en">All currencies combined</Description>
			</Code>
			<Code value="Z02">
				<Description xml:lang="en">Euro and MU national currencies</Description>
			</Code>
			<Code value="Z03">
				<Description xml:lang="en">Other EU currencies combined</Description>
			</Code>
			<Code value="Z04">
				<Description xml:lang="en">Other currencies than EU combined</Description>
			</Code>
			<Code value="Z05">
				<Description xml:lang="en">All currencies other than EU, EUR, USD, CHF, JPY</Description>
			</Code>
			<Code value="Z06">
				<Description xml:lang="en">Non-MU currencies combined</Description>
			</Code>
			<Code value="Z07">
				<Description xml:lang="en">All currencies other than domestic, Euro and MU currencies</Description>
			</Code>
			<Code value="Z08">
				<Description xml:lang="en">EER narrow group of currencies including also Greece until 01 january 2001</Description>
			</Code>
			<Code value="Z09">
				<Description xml:lang="en">EER broad group of currencies including also Greece until 01 january 2001</Description>
			</Code>
			<Code value="Z0Z">
				<Description xml:lang="en">Not applicable</Description>
			</Code>
			<Code value="Z10">
				<Description xml:lang="en">EER-12 group of currencies</Description>
			</Code>
			<Code value="Z11">
				<Description xml:lang="en">EER broad group of currencies (excluding Greece)</Description>
			</Code>
			<Code value="Z12">
				<Description xml:lang="en">Euro and Euro Area countries currencies (including Greece)</Description>
			</Code>
			<Code value="Z13">
				<Description xml:lang="en">Other EU currencies combined (MU12; excluding GRD)</Description>
			</Code>
			<Code value="Z14">
				<Description xml:lang="en">Other currencies than EU15 combined</Description>
			</Code>
			<Code value="Z15">
				<Description xml:lang="en">All currencies other than EU15, EUR, USD, CHF, JPY</Description>
			</Code>
			<Code value="Z16">
				<Description xml:lang="en">Non-MU12 currencies combined</Description>
			</Code>
			<Code value="Z17">
				<Description xml:lang="en">ECB EER-12 group of currencies and Euro Area countries currencies</Description>
			</Code>
			<Code value="Z18">
				<Description xml:lang="en">ECB EER broad group of currencies and Euro Area countries currencies</Description>
			</Code>
			<Code value="Z21">
				<Description xml:lang="en">ECB EER broad group, regional breakdown, industrialised countries</Description>
			</Code>
			<Code value="Z22">
				<Description xml:lang="en">ECB EER broad group, regional breakdown, non-Japan Asia</Description>
			</Code>
			<Code value="Z23">
				<Description xml:lang="en">ECB EER broad group, regional breakdown, Latin America</Description>
			</Code>
			<Code value="Z24">
				<Description xml:lang="en">ECB EER broad group, regional breakdown, Central and Eastern Europe (CEEC)</Description>
			</Code>
			<Code value="Z25">
				<Description xml:lang="en">ECB EER broad group, regional breakdown, other countries</Description>
			</Code>
			<Code value="Z30">
				<Description xml:lang="en">EER-23 group of currencies</Description>
			</Code>
			<Code value="Z31">
				<Description xml:lang="en">EER-42 group of currencies</Description>
			</Code>
			<Code value="Z37">
				<Description xml:lang="en">ECB EER-23 group of currencies and Euro Area countries currencies</Description>
			</Code>
			<Code value="Z38">
				<Description xml:lang="en">ECB EER-42 group of currencies and Euro Area countries currencies</Description>
			</Code>
			<Code value="Z41">
				<Description xml:lang="en">All currencies other than domestic</Description>
			</Code>
			<Code value="Z44">
				<Description xml:lang="en">Other currencies than EU15 and domestic</Description>
			</Code>
			<Code value="Z45">
				<Description xml:lang="en">All currencies other than EU15, EUR, USD, CHF, JPY and domestic</Description>
			</Code>
			<Code value="Z50">
                                <Description>ECB EER-24 group of currencies (AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, CY, CZ, EE, HU, LV, LT, MT,
PL, SK, BG, RO)</Description>
                        </Code>
                        <Code value="Z51">
                                <Description>ECB EER-44 group of currencies (AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, CY, CZ, EE, HU, LV, LT, MT,
PL, SK, BG, RO, NZ, DZ, AR, BR, HR, IN, ID, IL, MY, MX, MA, PH, RU, ZA, TW, TH, TR, IS, CL, VE)</Description>
                        </Code>
                        <Code value="Z52">
                                <Description>Euro and Euro area country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI)</Description>
                        </Code>
                        <Code value="Z53">
                                <Description>Non-euro area 13 currencies combined (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI)</Description>
                        </Code>
                        <Code value="Z56">
                                <Description>ECB EER-12 group of currencies and Euro area country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR,
 SI, AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US)</Description>
                        </Code>
                        <Code value="Z57">
                                <Description>ECB EER-24 group of currencies and Euro area country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR,
 SI, AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, CY, CZ, EE, HU, LV, LT, MT, PL, SK, BG, RO)</Description>
                        </Code>
                        <Code value="Z58">
                                <Description>ECB EER-44 group of currencies and Euro area country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR,
 SI, AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, CY, CZ, EE, HU, LV, LT, MT, PL, SK, BG, RO, NZ, DZ, AR, BR, HR, IN, ID, IL, MY, MX, MA, PH, RU, ZA,
TW, TH, TR, IS, CL, VE)</Description>
			</Code>
			<Code value="ZAR">
				<Description xml:lang="en">South African Rand</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_DECIMALS">
			<Name xml:lang="en">Decimals codelist</Name>
			<Code value="0">
				<Description xml:lang="en">Zero</Description>
			</Code>
			<Code value="1">
				<Description xml:lang="en">One</Description>
			</Code>
			<Code value="2">
				<Description xml:lang="en">Two</Description>
			</Code>
			<Code value="3">
				<Description xml:lang="en">Three</Description>
			</Code>
			<Code value="4">
				<Description xml:lang="en">Four</Description>
			</Code>
			<Code value="5">
				<Description xml:lang="en">Five</Description>
			</Code>
			<Code value="6">
				<Description xml:lang="en">Six</Description>
			</Code>
			<Code value="7">
				<Description xml:lang="en">Seven</Description>
			</Code>
			<Code value="8">
				<Description xml:lang="en">Eight</Description>
			</Code>
			<Code value="9">
				<Description xml:lang="en">Nine</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_EXR_SUFFIX">
			<Name xml:lang="en">Exch. rate series variation code list</Name>
			<Code value="A">
				<Description xml:lang="en">Average or standardised measure for given frequency</Description>
			</Code>
			<Code value="E">
				<Description xml:lang="en">End-of-period</Description>
			</Code>
			<Code value="P">
                                <Description>Growth rate to previous period</Description>
                        </Code>
                        <Code value="R">
                                <Description>Annual rate of change</Description>
                        </Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_EXR_TYPE">
			<Name xml:lang="en">Exchange rate type code list</Name>
			<Code value="BRC0">
				<Description xml:lang="en">Real bilateral exchange rate, CPI deflated</Description>
			</Code>
			<Code value="CR00">
				<Description xml:lang="en">Central rate</Description>
			</Code>
			<Code value="EN00">
				<Description xml:lang="en">Nominal effective exch. rate</Description>
			</Code>
			<Code value="ERC0">
				<Description xml:lang="en">Real effective exch. rate CPI deflated</Description>
			</Code>
			<Code value="ERC1">
				<Description xml:lang="en">Real effective exch. rate retail prices deflated</Description>
			</Code>
			<Code value="ERD0">
				<Description xml:lang="en">Real effective exch. rate GDP deflators deflated</Description>
			</Code>
			<Code value="ERM0">
				<Description xml:lang="en">Real effective exch. rate import unit values deflated</Description>
			</Code>
			<Code value="ERP0">
				<Description xml:lang="en">Real effective exch. rate producer prices deflated</Description>
			</Code>
			<Code value="ERU0">
				<Description xml:lang="en">Real effective exch. rate ULC manufacturing deflated</Description>
			</Code>
			<Code value="ERU1">
				<Description xml:lang="en">Real effective exch. rate ULC total economy deflated</Description>
			</Code>
			<Code value="ERW0">
				<Description xml:lang="en">Real effective exch. rate wholesale prices deflated</Description>
			</Code>
			<Code value="ERX0">
				<Description xml:lang="en">Real effective exch. rate export unit values deflated</Description>
			</Code>
			<Code value="F01M">
				<Description xml:lang="en">1m-forward</Description>
			</Code>
			<Code value="F03M">
				<Description xml:lang="en">3m-forward</Description>
			</Code>
			<Code value="F06M">
				<Description xml:lang="en">6m-forward</Description>
			</Code>
			<Code value="F12M">
				<Description xml:lang="en">12m-forward</Description>
			</Code>
			<Code value="IR00">
				<Description xml:lang="en">Indicative rate</Description>
			</Code>
			<Code value="NRC0">
				<Description xml:lang="en">Real national competitiveness indicator CPI deflated</Description>
			</Code>
			<Code value="NRD0">
				<Description xml:lang="en">Real national competitiveness indicator GDP deflators deflated</Description>
			</Code>
			<Code value="NRP0">
				<Description xml:lang="en">Real national competitiveness indicator Producer Prices deflated</Description>
			</Code>
			<Code value="NRU0">
				<Description xml:lang="en">Real national competitiveness indicator ULC manufacturing deflated</Description>
			</Code>
			<Code value="NRU1">
				<Description xml:lang="en">Real national competitiveness indicator ULC in total economy deflated</Description>
			</Code>
			<Code value="OF00">
				<Description xml:lang="en">Official fixing</Description>
			</Code>
			<Code value="RR00">
				<Description xml:lang="en">Reference rate</Description>
			</Code>
			<Code value="SP00">
				<Description xml:lang="en">Spot</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_FREQ">
			<Name xml:lang="en">Frequency code list</Name>
			<Code value="A">
				<Description xml:lang="en">Annual</Description>
			</Code>
			<Code value="B">
				<Description xml:lang="en">Business</Description>
			</Code>
			<Code value="D">
				<Description xml:lang="en">Daily</Description>
			</Code>
			<Code value="E">
				<Description xml:lang="en">Event (not supported)</Description>
			</Code>
			<Code value="H">
				<Description xml:lang="en">Half-yearly</Description>
			</Code>
			<Code value="M">
				<Description xml:lang="en">Monthly</Description>
			</Code>
			<Code value="Q">
				<Description xml:lang="en">Quarterly</Description>
			</Code>
			<Code value="W">
				<Description xml:lang="en">Weekly</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_OBS_CONF">
			<Name xml:lang="en">Observation confidentiality code list</Name>
			<Code value="C">
				<Description xml:lang="en">Confidential statistical information</Description>
			</Code>
			<Code value="D">
				<Description xml:lang="en">Secondary confidentiality set by the sender, not for publication</Description>
			</Code>
			<Code value="F">
				<Description xml:lang="en">Free (free for publication)</Description>
			</Code>
			<Code value="N">
				<Description xml:lang="en">Not for publication, restricted for internal use only</Description>
			</Code>
			<Code value="R">
				<Description xml:lang="en">Discontinued from 13 October 2006</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_OBS_STATUS">
			<Name xml:lang="en">Observation status code list</Name>
			<Code value="A">
				<Description xml:lang="en">Normal value</Description>
			</Code>
			<Code value="B">
				<Description xml:lang="en">Break</Description>
			</Code>
			<Code value="E">
				<Description xml:lang="en">Estimated value</Description>
			</Code>
			<Code value="F">
				<Description xml:lang="en">Forecast value</Description>
			</Code>
			<Code value="H">
				<Description xml:lang="en">Missing value; holiday or weekend</Description>
			</Code>
			<Code value="L">
				<Description xml:lang="en">Missing value; data exist but were not collected</Description>
			</Code>
			<Code value="M">
				<Description xml:lang="en">Missing value; data cannot exist</Description>
			</Code>
			<Code value="P">
				<Description xml:lang="en">Provisional value</Description>
			</Code>
			<Code value="Q">
				<Description xml:lang="en">Missing value; suppressed</Description>
			</Code>
			<Code value="S">
				<Description xml:lang="en">Strike</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_UNIT">
			<Name xml:lang="en">Unit code list</Name>
			<Code value="ARS">
				<Description xml:lang="en">Argentine peso</Description>
			</Code>
			<Code value="ATS">
				<Description xml:lang="en">Austrian schilling</Description>
			</Code>
			<Code value="AUD">
				<Description xml:lang="en">Australian dollar</Description>
			</Code>
			<Code value="BEF">
				<Description xml:lang="en">Belgian franc</Description>
			</Code>
			<Code value="BEL">
				<Description xml:lang="en">Belgian franc (financial)</Description>
			</Code>
			<Code value="BGN">
				<Description xml:lang="en">Bulgarian lev</Description>
			</Code>
			<Code value="BRL">
				<Description xml:lang="en">Brazilian real</Description>
			</Code>
			<Code value="CAD">
				<Description xml:lang="en">Canadian dollar</Description>
			</Code>
			<Code value="CHF">
				<Description xml:lang="en">Swiss franc</Description>
			</Code>
			<Code value="CLP">
				<Description xml:lang="en">Chilean peso</Description>
			</Code>
			<Code value="CNY">
				<Description xml:lang="en">Chinese yuan renminbi</Description>
			</Code>
			<Code value="COP">
				<Description xml:lang="en">Colombian peso</Description>
			</Code>
			<Code value="CYP">
				<Description xml:lang="en">Cypriot pound</Description>
			</Code>
			<Code value="CZK">
				<Description xml:lang="en">Czech koruna</Description>
			</Code>
			<Code value="DAYS">
				<Description xml:lang="en">Days</Description>
			</Code>
			<Code value="DEM">
				<Description xml:lang="en">German mark</Description>
			</Code>
			<Code value="DKK">
				<Description xml:lang="en">Danish krone</Description>
			</Code>
			<Code value="DZD">
				<Description xml:lang="en">Algerian dinar</Description>
			</Code>
			<Code value="EEK">
				<Description xml:lang="en">Estonian kroon</Description>
			</Code>
			<Code value="EGP">
				<Description xml:lang="en">Egyptian pound</Description>
			</Code>
			<Code value="ESP">
				<Description xml:lang="en">Spanish peseta</Description>
			</Code>
			<Code value="EUR">
				<Description xml:lang="en">Euro</Description>
			</Code>
			<Code value="FIM">
				<Description xml:lang="en">Finnish markka</Description>
			</Code>
			<Code value="FRF">
				<Description xml:lang="en">French franc</Description>
			</Code>
			<Code value="GBP">
				<Description xml:lang="en">UK pound sterling</Description>
			</Code>
			<Code value="GRD">
				<Description xml:lang="en">Greek drachma</Description>
			</Code>
			<Code value="HKD">
				<Description xml:lang="en">Hong Kong dollar</Description>
			</Code>
			<Code value="HOURS">
				<Description xml:lang="en">Hours</Description>
			</Code>
			<Code value="HRK">
				<Description xml:lang="en">Croatian kuna</Description>
			</Code>
			<Code value="HUF">
				<Description xml:lang="en">Hungarian forint</Description>
			</Code>
			<Code value="IDR">
				<Description xml:lang="en">Indonesian rupiah</Description>
			</Code>
			<Code value="IEP">
				<Description xml:lang="en">Irish pound</Description>
			</Code>
			<Code value="ILS">
				<Description xml:lang="en">Israeli shekel</Description>
			</Code>
			<Code value="INR">
				<Description xml:lang="en">Indian rupee</Description>
			</Code>
			<Code value="IQD">
				<Description xml:lang="en">Iraqi dinar</Description>
			</Code>
			<Code value="IRR">
				<Description xml:lang="en">Iranian rial</Description>
			</Code>
			<Code value="ISK">
				<Description xml:lang="en">Iceland krona</Description>
			</Code>
			<Code value="ITL">
				<Description xml:lang="en">Italian lira</Description>
			</Code>
			<Code value="JOD">
				<Description xml:lang="en">Jordanian dinar</Description>
			</Code>
			<Code value="JPY">
				<Description xml:lang="en">Japanese yen</Description>
			</Code>
			<Code value="KILO">
				<Description xml:lang="en">Kilograms</Description>
			</Code>
			<Code value="KLITRE">
				<Description xml:lang="en">Kilolitres</Description>
			</Code>
			<Code value="KPW">
				<Description xml:lang="en">Korean won (North)</Description>
			</Code>
			<Code value="KRW">
				<Description xml:lang="en">Korean won (Republic)</Description>
			</Code>
			<Code value="KWD">
				<Description xml:lang="en">Kuwait dinar</Description>
			</Code>
			<Code value="LBP">
				<Description xml:lang="en">Lebanese pound</Description>
			</Code>
			<Code value="LITRES">
				<Description xml:lang="en">Litres</Description>
			</Code>
			<Code value="LKR">
				<Description xml:lang="en">Sri Lanka rupee</Description>
			</Code>
			<Code value="LTL">
				<Description xml:lang="en">Lithuanian litas</Description>
			</Code>
			<Code value="LUF">
				<Description xml:lang="en">Luxembourg franc</Description>
			</Code>
			<Code value="LVL">
				<Description xml:lang="en">Latvian lats</Description>
			</Code>
			<Code value="LYD">
				<Description xml:lang="en">Libyan dinar</Description>
			</Code>
			<Code value="MAD">
				<Description xml:lang="en">Moroccan dirham</Description>
			</Code>
			<Code value="MAN-DY">
				<Description xml:lang="en">Man Days</Description>
			</Code>
			<Code value="MAN-YR">
				<Description xml:lang="en">Man Years</Description>
			</Code>
			<Code value="MONTHS">
				<Description xml:lang="en">Months</Description>
			</Code>
			<Code value="MTL">
				<Description xml:lang="en">Maltese lira</Description>
			</Code>
			<Code value="MXN">
				<Description xml:lang="en">Mexican peso</Description>
			</Code>
			<Code value="MXP">
				<Description xml:lang="en">Mexican peso (old)</Description>
			</Code>
			<Code value="MYR">
				<Description xml:lang="en">Malaysian ringgit</Description>
			</Code>
			<Code value="NATCUR">
				<Description xml:lang="en">National currency</Description>
			</Code>
			<Code value="NLG">
				<Description xml:lang="en">Netherlands guilder</Description>
			</Code>
			<Code value="NOK">
				<Description xml:lang="en">Nowegian krone</Description>
			</Code>
			<Code value="NZD">
				<Description xml:lang="en">New Zealand dollar</Description>
			</Code>
			<Code value="OUNCES">
				<Description xml:lang="en">Ounces</Description>
			</Code>
			<Code value="PC">
				<Description xml:lang="en">Percent</Description>
			</Code>
			<Code value="PCPA">
				<Description xml:lang="en">Percent per annum</Description>
			</Code>
			<Code value="PCT">
				<Description xml:lang="en">Percentage of change</Description>
			</Code>
			<Code value="PEN">
				<Description xml:lang="en">Peru nuevo sol</Description>
			</Code>
			<Code value="PERS">
				<Description xml:lang="en">Persons</Description>
			</Code>
			<Code value="PHP">
				<Description xml:lang="en">Philippine peso</Description>
			</Code>
			<Code value="PKR">
				<Description xml:lang="en">Pakistan rupee</Description>
			</Code>
			<Code value="PLN">
				<Description xml:lang="en">Polish zloty (new)</Description>
			</Code>
			<Code value="PM">
				<Description xml:lang="en">Per thousand</Description>
			</Code>
			<Code value="POINTS">
				<Description xml:lang="en">Points</Description>
			</Code>
			<Code value="PTE">
				<Description xml:lang="en">Portugese escudo</Description>
			</Code>
			<Code value="PURE_NUMB">
				<Description xml:lang="en">Pure number</Description>
			</Code>
			<Code value="ROL">
				<Description xml:lang="en">Romanian leu</Description>
			</Code>
			<Code value="RON">
				<Description xml:lang="en">Romanian leu (new)</Description>
			</Code>
			<Code value="RUB">
				<Description xml:lang="en">Rouble (new)</Description>
			</Code>
			<Code value="SAR">
				<Description xml:lang="en">Saudi riyal</Description>
			</Code>
			<Code value="SEK">
				<Description xml:lang="en">Swedish krona</Description>
			</Code>
			<Code value="SGD">
				<Description xml:lang="en">Singapore dollar</Description>
			</Code>
			<Code value="SIT">
				<Description xml:lang="en">Slovenian tolar</Description>
			</Code>
			<Code value="SKK">
				<Description xml:lang="en">Slovak koruna</Description>
			</Code>
			<Code value="SQ_M">
				<Description xml:lang="en">Square Metres</Description>
			</Code>
			<Code value="SYP">
				<Description xml:lang="en">Syrian pound</Description>
			</Code>
			<Code value="THB">
				<Description xml:lang="en">Thai bhat</Description>
			</Code>
			<Code value="TND">
				<Description xml:lang="en">Tunisian dinar</Description>
			</Code>
			<Code value="TONNES">
				<Description xml:lang="en">Tonnes</Description>
			</Code>
			<Code value="TRL">
				<Description xml:lang="en">Turkish lira</Description>
			</Code>
			<Code value="TRY">
				<Description xml:lang="en">Turkish lira (new)</Description>
			</Code>
			<Code value="TWD">
				<Description xml:lang="en">New Taiwan dollar</Description>
			</Code>
			<Code value="UAH">
				<Description xml:lang="en">Ukraine hryvnia</Description>
			</Code>
			<Code value="UNITS">
				<Description xml:lang="en">Unit described in title</Description>
			</Code>
			<Code value="USD">
				<Description xml:lang="en">US dollar</Description>
			</Code>
			<Code value="VEB">
				<Description xml:lang="en">Venezuela bolivar</Description>
			</Code>
			<Code value="XAG">
				<Description xml:lang="en">Silver</Description>
			</Code>
			<Code value="XDR">
				<Description xml:lang="en">Special Drawing Rights (S.D.R.)</Description>
			</Code>
			<Code value="XEU">
				<Description xml:lang="en">European Currency Unit (E.C.U.)</Description>
			</Code>
			<Code value="YEARS">
				<Description xml:lang="en">Years</Description>
			</Code>
			<Code value="ZAR">
				<Description xml:lang="en">South African rand</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_UNIT_MULT">
			<Name xml:lang="en">Unit multiplier code list</Name>
			<Code value="0">
				<Description xml:lang="en">Units</Description>
			</Code>
			<Code value="1">
				<Description xml:lang="en">Tens</Description>
			</Code>
			<Code value="2">
				<Description xml:lang="en">Hundreds</Description>
			</Code>
			<Code value="3">
				<Description xml:lang="en">Thousands</Description>
			</Code>
			<Code value="4">
				<Description xml:lang="en">Tens of thousands</Description>
			</Code>
			<Code value="6">
				<Description xml:lang="en">Millions</Description>
			</Code>
			<Code value="9">
				<Description xml:lang="en">Billions</Description>
			</Code>
		</CodeList>
	</message:CodeLists>
	<message:Concepts xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
		<Concept agencyID="ECB" id="COLLECTION">
			<Name xml:lang="en">Collection indicator</Name>
		</Concept>
		<Concept agencyID="ECB" id="CURRENCY">
			<Name xml:lang="en">Currency</Name>
		</Concept>
		<Concept agencyID="ECB" id="CURRENCY_DENOM">
			<Name xml:lang="en">Currency denominator</Name>
		</Concept>
		<Concept agencyID="ECB" id="DECIMALS">
			<Name xml:lang="en">Decimals</Name>
		</Concept>
		<Concept agencyID="ECB" id="EXR_SUFFIX">
			<Name xml:lang="en">Series variation - EXR context</Name>
		</Concept>
		<Concept agencyID="ECB" id="EXR_TYPE">
			<Name xml:lang="en">Exchange rate type</Name>
		</Concept>
		<Concept agencyID="ECB" id="FREQ">
			<Name xml:lang="en">Frequency</Name>
		</Concept>
		<Concept agencyID="ECB" id="OBS_CONF">
			<Name xml:lang="en">Observation confidentiality</Name>
		</Concept>
		<Concept agencyID="ECB" id="OBS_STATUS">
			<Name xml:lang="en">Observation status</Name>
		</Concept>
		<Concept agencyID="ECB" id="OBS_VALUE">
			<Name xml:lang="en">Observation value</Name>
		</Concept>
		<Concept agencyID="ECB" id="TIME_FORMAT">
			<Name xml:lang="en">Time format code</Name>
		</Concept>
		<Concept agencyID="ECB" id="TIME_PERIOD">
			<Name xml:lang="en">Time period or range</Name>
		</Concept>
		<Concept agencyID="ECB" id="TITLE_COMPL">
			<Name xml:lang="en">Title complement</Name>
		</Concept>
		<Concept agencyID="ECB" id="UNIT">
			<Name xml:lang="en">Unit</Name>
		</Concept>
		<Concept agencyID="ECB" id="UNIT_MULT">
			<Name xml:lang="en">Unit multiplier</Name>
		</Concept>
	</message:Concepts>
	<message:KeyFamilies xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
		<KeyFamily agencyID="ECB" id="ECB_EXR1" uri="http://stats.ecb.europa.eu/stats/dtf_test/ecb_exr1.xml">
			<Name xml:lang="en">Exchange Rates</Name>
			<Components>
				<Dimension conceptRef="FREQ" codelist="CL_FREQ" isFrequencyDimension="true"/>
				<Dimension conceptRef="CURRENCY" codelist="CL_CURRENCY"/>
				<Dimension conceptRef="CURRENCY_DENOM" codelist="CL_CURRENCY"/>
				<Dimension conceptRef="EXR_TYPE" codelist="CL_EXR_TYPE"/>
				<Dimension conceptRef="EXR_SUFFIX" codelist="CL_EXR_SUFFIX"/>
				<TimeDimension conceptRef="TIME_PERIOD"/>
				<Group id="Group">
					<DimensionRef>CURRENCY</DimensionRef>
					<DimensionRef>CURRENCY_DENOM</DimensionRef>
					<DimensionRef>EXR_TYPE</DimensionRef>
					<DimensionRef>EXR_SUFFIX</DimensionRef>
				</Group>
				<PrimaryMeasure conceptRef="OBS_VALUE"/>
				<Attribute conceptRef="TIME_FORMAT" attachmentLevel="Series" assignmentStatus="Mandatory" isTimeFormat="true">
					<TextFormat textType="String" maxLength="3"/>
				</Attribute>
				<Attribute conceptRef="OBS_STATUS" attachmentLevel="Observation" codelist="CL_OBS_STATUS" assignmentStatus="Mandatory"/>
				<Attribute conceptRef="OBS_CONF" attachmentLevel="Observation" codelist="CL_OBS_CONF" assignmentStatus="Conditional"/>
				<Attribute conceptRef="COLLECTION" attachmentLevel="Series" codelist="CL_COLLECTION" assignmentStatus="Mandatory"/>
				<Attribute conceptRef="DECIMALS" attachmentLevel="Group" codelist="CL_DECIMALS" assignmentStatus="Mandatory">
					<AttachmentGroup>Group</AttachmentGroup>
				</Attribute>
				<Attribute conceptRef="TITLE_COMPL" attachmentLevel="Group" assignmentStatus="Mandatory">
					<TextFormat textType="String" maxLength="1050"/>
					<AttachmentGroup>Group</AttachmentGroup>
				</Attribute>
				<Attribute conceptRef="UNIT" attachmentLevel="Group" codelist="CL_UNIT" assignmentStatus="Mandatory">
					<AttachmentGroup>Group</AttachmentGroup>
				</Attribute>
				<Attribute conceptRef="UNIT_MULT" attachmentLevel="Group" codelist="CL_UNIT_MULT" assignmentStatus="Mandatory">
					<AttachmentGroup>Group</AttachmentGroup>
				</Attribute>
			</Components>
		</KeyFamily>
	</message:KeyFamilies>
</Structure>
		
	}
}