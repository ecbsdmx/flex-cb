package org.sdmx.util.xs
{
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.UncodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.MeasureTypeDimension;
	import org.sdmx.stores.xml.v2.DataReaderAdapter;
	import org.sdmx.stores.xml.v2.compact.CompactReader;
	import org.sdmx.stores.xml.v2.structure.StructureReader;
	import org.sdmx.util.date.SDMXDate;

	public class ECBXSDataSetGeneratorTest extends TestCase
	{
		private var _exrKF:KeyFamily;
		private var _compactReader:CompactReader;
		
		public function ECBXSDataSetGeneratorTest(methodName:String=null)
		{
			super(methodName);
		}
				
		public static function suite():TestSuite {
			return new TestSuite(ECBXSDataSetGeneratorTest);
		}
		
		public function testConvertingToXSDataSet():void
		{
			var structureReader:StructureReader = new StructureReader();
			structureReader.dispatchKeyFamilies = true;
			structureReader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleKeyFamilies, 3000));
			structureReader.read(_kf);	
		}
		
		private function handleKeyFamilies(event:SDMXDataEvent):void 
		{
			_exrKF = (event.data as KeyFamilies).getItemAt(0) as KeyFamily;
			_compactReader = new CompactReader(_exrKF);
			_compactReader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleInitReady);
			_compactReader.optimisationLevel = CompactReader.NO_OPTIMISATION;	
			_compactReader.dataFile = _data;	
		}
		
		private function handleInitReady(event:Event):void
		{
			_compactReader.addEventListener(DataReaderAdapter.DATASET_EVENT,
				handleDataSet);
			_compactReader.query();	
		}
		
		private function handleDataSet(event:SDMXDataEvent):void
		{
			var dataSet:DataSet = event.data as DataSet;
			var generator:IXSDataSetGenerator = new ECBXSDataSetGenerator();
			var measureDimension:MeasureTypeDimension = 
				_exrKF.keyDescriptor.getDimension("CURRENCY") 
				as MeasureTypeDimension;
			var xsDataSet:XSDataSet = generator.convertToXSDataSet(dataSet,
				_exrKF, "1999-01-04", measureDimension);
			assertNotNull("The XS data set cannot be null", xsDataSet);
			
			assertNotNull("The groups cannot be null", xsDataSet.groups);
			assertEquals("There should be one group in the collection", 1,
				xsDataSet.groups.length);
			var xsGroup:XSGroup = xsDataSet.groups.getItemAt(0) as XSGroup; 	
			assertEquals("There should be two dimensions in the group key", 2,
				xsGroup.valueFor.length);
			for each (var groupDimValue:KeyValue in xsGroup.keyValues) {
				if (groupDimValue.valueFor.conceptRole == ConceptRole.TIME) {
					assertEquals("The time dimension should be set to " + 
						"'1999-01-04'", "1999-01-04", groupDimValue.value.id);	
				} else {
					assertEquals("The frequency should be daily", 
						"D", groupDimValue.value.id);
				}
			}
				
			assertNotNull("The sections cannot be null", xsGroup.sections);
			assertEquals("There should be one section in the collection", 1,
				xsGroup.sections.length);
			var section:Section = xsGroup.sections.getItemAt(0) as Section; 	
			assertEquals("There should be three dimensions in the section", 3,
				section.valueFor.length);
			for each (var sectionDimValue:KeyValue in section.keyValues) {
				if (sectionDimValue.valueFor.conceptIdentity.id == 
					"CURRENCY_DENOM") {
					assertEquals("The value should be EUR ", "EUR", 
						sectionDimValue.value.id);	
				} else if (sectionDimValue.valueFor.conceptIdentity.id == 
					"EXR_SUFFIX") {
					assertEquals("The value should be A ", "A", 
						sectionDimValue.value.id);
				} else if (sectionDimValue.valueFor.conceptIdentity.id == 
					"EXR_TYPE") {
					assertEquals("The value should be SP00 ", "SP00", 
						sectionDimValue.value.id);
				} else {
					fail("Should not reach this point");
				}
			}		
			
			assertNotNull("The observations cannot be null", 
				section.observations);
			assertEquals("There should be two obs in the collection", 2,
				section.observations.length);
			var obs1:UncodedXSObservation = 
				section.observations.getItemAt(0) as UncodedXSObservation;
			var obs2:UncodedXSObservation = 
				section.observations.getItemAt(1) as UncodedXSObservation; 	
			
			/*assertTrue("There should be no dimension on the obs level", null == 
				obs1.valueFor == obs1.keyValues == obs2.keyValues == 
				obs2.valueFor);*/
			assertEquals("Code for obs1 should be AUD", "AUD", 
				obs1.measure.code.id);
			assertEquals("Value for obs1 should be 1.9100", "1.9100", 
				obs1.value);	
			assertEquals("Code for obs2 should be NZD", "NZD", 
				obs2.measure.code.id);	
			assertEquals("Value for obs2 should be 2.2229", "2.2229", 
				obs2.value);	
		}
		
		private var _data:XML =
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
		<Series FREQ="D" CURRENCY="AUD" CURRENCY_DENOM="EUR" EXR_TYPE="SP00" EXR_SUFFIX="A" TIME_FORMAT="P1D" COLLECTION="A">
			<Obs TIME_PERIOD="1999-01-04" OBS_VALUE="1.9100" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-05" OBS_VALUE="1.8944" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-06" OBS_VALUE="1.8820" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-07" OBS_VALUE="1.8474" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-08" OBS_VALUE="1.8406" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-11" OBS_VALUE="1.8134" OBS_STATUS="A" OBS_CONF="F"/>
		</Series>			
		<Group CURRENCY="NZD" CURRENCY_DENOM="EUR" EXR_TYPE="SP00" EXR_SUFFIX="A" DECIMALS="4" UNIT="USD" UNIT_MULT="0" TITLE_COMPL="ECB reference exchange rate, US dollar/Euro, 2:15 pm (C.E.T.)" />
		<Series FREQ="D" CURRENCY="NZD" CURRENCY_DENOM="EUR" EXR_TYPE="SP00" EXR_SUFFIX="A" TIME_FORMAT="P1D" COLLECTION="A">
			<Obs TIME_PERIOD="1999-01-04" OBS_VALUE="2.2229" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-05" OBS_VALUE="2.2011" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-06" OBS_VALUE="2.1890" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-07" OBS_VALUE="2.1531" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-08" OBS_VALUE="2.1557" OBS_STATUS="A" OBS_CONF="F"/>
			<Obs TIME_PERIOD="1999-01-11" OBS_VALUE="2.1257" OBS_STATUS="A" OBS_CONF="F"/>
		</Series>
	</DataSet>
</CompactData>		
		
		private var _kf:XML = 
<message:Structure 
	xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure SDMXStructure.xsd" 
	xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <message:Header>
        <message:ID>fe7a30ac-53b4-42b3-8eac-7f22c535c7eb</message:ID>
        <message:Test>false</message:Test>
        <message:Prepared>2009-11-02T11:08:50+01:00</message:Prepared>
        <message:Sender id="ECB"/>
    </message:Header>
    <message:CodeLists>
        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_COLLECTION">
            <structure:Name>Collection indicator code list</structure:Name>
            <structure:Code value="A">
                <structure:Description>Average of observations through period</structure:Description>
            </structure:Code>
            <structure:Code value="B">
                <structure:Description>Beginning of period</structure:Description>
            </structure:Code>
            <structure:Code value="E">
                <structure:Description>End of period</structure:Description>
            </structure:Code>
            <structure:Code value="H">
                <structure:Description>Highest in period</structure:Description>
            </structure:Code>
            <structure:Code value="L">
                <structure:Description>Lowest in period</structure:Description>
            </structure:Code>
            <structure:Code value="M">
                <structure:Description>Middle of period</structure:Description>
            </structure:Code>
            <structure:Code value="S">
                <structure:Description>Summed through period</structure:Description>
            </structure:Code>
            <structure:Code value="U">
                <structure:Description>Unknown</structure:Description>
            </structure:Code>
            <structure:Code value="V">
                <structure:Description>Other</structure:Description>
            </structure:Code>
            <structure:Code value="Y">
                <structure:Description>Annualised summed</structure:Description>
            </structure:Code>
        </structure:CodeList>
        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_CURRENCY">
            <structure:Name>Currency code list</structure:Name>
            <structure:Code value="ADF">
                <structure:Description>Andorran Franc (1-1 peg to the French franc)</structure:Description>
            </structure:Code>
            <structure:Code value="ADP">
                <structure:Description>Andorran Peseta (1-1 peg to the Spanish peseta)</structure:Description>

            </structure:Code>
            <structure:Code value="AED">
                <structure:Description>United Arab Emirates dirham</structure:Description>
            </structure:Code>
            <structure:Code value="AFA">
                <structure:Description>Afghanistan afghani (old)</structure:Description>
            </structure:Code>
            <structure:Code value="AFN">

                <structure:Description>Afghanistan, Afghanis</structure:Description>
            </structure:Code>
            <structure:Code value="ALL">
                <structure:Description>Albanian lek</structure:Description>
            </structure:Code>
            <structure:Code value="AMD">
                <structure:Description>Armenian dram</structure:Description>

            </structure:Code>
            <structure:Code value="ANG">
                <structure:Description>Netherlands Antillean guilder</structure:Description>
            </structure:Code>
            <structure:Code value="AOA">
                <structure:Description>Angola, Kwanza</structure:Description>
            </structure:Code>
            <structure:Code value="AON">

                <structure:Description>Angolan kwanza (old)</structure:Description>
            </structure:Code>
            <structure:Code value="AOR">
                <structure:Description>Angolan kwanza readjustado</structure:Description>
            </structure:Code>
            <structure:Code value="ARS">
                <structure:Description>Argentine peso</structure:Description>

            </structure:Code>
            <structure:Code value="ATS">
                <structure:Description>Austrian schilling</structure:Description>
            </structure:Code>
            <structure:Code value="AUD">
                <structure:Description>Australian dollar</structure:Description>
            </structure:Code>
            <structure:Code value="AWG">

                <structure:Description>Aruban florin/guilder</structure:Description>
            </structure:Code>
            <structure:Code value="AZM">
                <structure:Description>Azerbaijanian manat (old)</structure:Description>
            </structure:Code>
            <structure:Code value="AZN">
                <structure:Description>Azerbaijan, manats</structure:Description>

            </structure:Code>
            <structure:Code value="BAM">
                <structure:Description>Bosnia-Hezergovinian convertible mark</structure:Description>
            </structure:Code>
            <structure:Code value="BBD">
                <structure:Description>Barbados dollar</structure:Description>
            </structure:Code>
            <structure:Code value="BDT">

                <structure:Description>Bangladesh taka</structure:Description>
            </structure:Code>
            <structure:Code value="BEF">
                <structure:Description>Belgian franc</structure:Description>
            </structure:Code>
            <structure:Code value="BEL">
                <structure:Description>Belgian franc (financial)</structure:Description>

            </structure:Code>
            <structure:Code value="BGL">
                <structure:Description>Bulgarian lev (old)</structure:Description>
            </structure:Code>
            <structure:Code value="BGN">
                <structure:Description>Bulgarian lev</structure:Description>
            </structure:Code>
            <structure:Code value="BHD">

                <structure:Description>Bahraini dinar</structure:Description>
            </structure:Code>
            <structure:Code value="BIF">
                <structure:Description>Burundi franc</structure:Description>
            </structure:Code>
            <structure:Code value="BMD">
                <structure:Description>Bermudian dollar</structure:Description>

            </structure:Code>
            <structure:Code value="BND">
                <structure:Description>Brunei dollar</structure:Description>
            </structure:Code>
            <structure:Code value="BOB">
                <structure:Description>Bolivian boliviano</structure:Description>
            </structure:Code>
            <structure:Code value="BRL">

                <structure:Description>Brazilian real</structure:Description>
            </structure:Code>
            <structure:Code value="BSD">
                <structure:Description>Bahamas dollar</structure:Description>
            </structure:Code>
            <structure:Code value="BTN">
                <structure:Description>Bhutan ngultrum</structure:Description>

            </structure:Code>
            <structure:Code value="BWP">
                <structure:Description>Botswana pula</structure:Description>
            </structure:Code>
            <structure:Code value="BYB">
                <structure:Description>Belarussian rouble (old)</structure:Description>
            </structure:Code>
            <structure:Code value="BYR">

                <structure:Description>Belarus, Rubles</structure:Description>
            </structure:Code>
            <structure:Code value="BZD">
                <structure:Description>Belize dollar</structure:Description>
            </structure:Code>
            <structure:Code value="CAD">
                <structure:Description>Canadian dollar</structure:Description>

            </structure:Code>
            <structure:Code value="CDF">
                <structure:Description>Congo franc (ex Zaire)</structure:Description>
            </structure:Code>
            <structure:Code value="CHF">
                <structure:Description>Swiss franc</structure:Description>
            </structure:Code>
            <structure:Code value="CLP">

                <structure:Description>Chilean peso</structure:Description>
            </structure:Code>
            <structure:Code value="CNY">
                <structure:Description>Chinese yuan renminbi</structure:Description>
            </structure:Code>
            <structure:Code value="COP">
                <structure:Description>Colombian peso</structure:Description>

            </structure:Code>
            <structure:Code value="CRC">
                <structure:Description>Costa Rican colon</structure:Description>
            </structure:Code>
            <structure:Code value="CSD">
                <structure:Description>Serbian dinar</structure:Description>
            </structure:Code>
            <structure:Code value="CUP">

                <structure:Description>Cuban peso</structure:Description>
            </structure:Code>
            <structure:Code value="CVE">
                <structure:Description>Cape Verde escudo</structure:Description>
            </structure:Code>
            <structure:Code value="CYP">
                <structure:Description>Cyprus pound</structure:Description>

            </structure:Code>
            <structure:Code value="CZK">
                <structure:Description>Czech koruna</structure:Description>
            </structure:Code>
            <structure:Code value="DEM">
                <structure:Description>German mark</structure:Description>
            </structure:Code>
            <structure:Code value="DJF">

                <structure:Description>Djibouti franc</structure:Description>
            </structure:Code>
            <structure:Code value="DKK">
                <structure:Description>Danish krone</structure:Description>
            </structure:Code>
            <structure:Code value="DOP">
                <structure:Description>Dominican peso</structure:Description>

            </structure:Code>
            <structure:Code value="DZD">
                <structure:Description>Algerian dinar</structure:Description>
            </structure:Code>
            <structure:Code value="ECS">
                <structure:Description>Ecuador sucre</structure:Description>
            </structure:Code>
            <structure:Code value="EEK">

                <structure:Description>Estonian kroon</structure:Description>
            </structure:Code>
            <structure:Code value="EGP">
                <structure:Description>Egyptian pound</structure:Description>
            </structure:Code>
            <structure:Code value="ERN">
                <structure:Description>Erytrean nafka</structure:Description>

            </structure:Code>
            <structure:Code value="ESP">
                <structure:Description>Spanish peseta</structure:Description>
            </structure:Code>
            <structure:Code value="ETB">
                <structure:Description>Ethiopian birr</structure:Description>
            </structure:Code>
            <structure:Code value="EUR">

                <structure:Description>Euro</structure:Description>
            </structure:Code>
            <structure:Code value="FIM">
                <structure:Description>Finnish markka</structure:Description>
            </structure:Code>
            <structure:Code value="FJD">
                <structure:Description>Fiji dollar</structure:Description>

            </structure:Code>
            <structure:Code value="FKP">
                <structure:Description>Falkland Islands pound</structure:Description>
            </structure:Code>
            <structure:Code value="FRF">
                <structure:Description>French franc</structure:Description>
            </structure:Code>
            <structure:Code value="GBP">

                <structure:Description>UK pound sterling</structure:Description>
            </structure:Code>
            <structure:Code value="GEL">
                <structure:Description>Georgian lari</structure:Description>
            </structure:Code>
            <structure:Code value="GGP">
                <structure:Description>Guernsey, Pounds</structure:Description>

            </structure:Code>
            <structure:Code value="GHC">
                <structure:Description>Ghana Cedi (old)</structure:Description>
            </structure:Code>
            <structure:Code value="GHS">
                <structure:Description>Ghana Cedi</structure:Description>
            </structure:Code>
            <structure:Code value="GIP">

                <structure:Description>Gibraltar pound</structure:Description>
            </structure:Code>
            <structure:Code value="GMD">
                <structure:Description>Gambian dalasi</structure:Description>
            </structure:Code>
            <structure:Code value="GNF">
                <structure:Description>Guinea franc</structure:Description>

            </structure:Code>
            <structure:Code value="GRD">
                <structure:Description>Greek drachma</structure:Description>
            </structure:Code>
            <structure:Code value="GTQ">
                <structure:Description>Guatemalan quetzal</structure:Description>
            </structure:Code>
            <structure:Code value="GYD">

                <structure:Description>Guyanan dollar</structure:Description>
            </structure:Code>
            <structure:Code value="HKD">
                <structure:Description>Hong Kong dollar</structure:Description>
            </structure:Code>
            <structure:Code value="HKQ">
                <structure:Description>Hong Kong dollar (old)</structure:Description>

            </structure:Code>
            <structure:Code value="HNL">
                <structure:Description>Honduran lempira</structure:Description>
            </structure:Code>
            <structure:Code value="HRK">
                <structure:Description>Croatian kuna</structure:Description>
            </structure:Code>
            <structure:Code value="HTG">

                <structure:Description>Haitian gourde</structure:Description>
            </structure:Code>
            <structure:Code value="HUF">
                <structure:Description>Hungarian forint</structure:Description>
            </structure:Code>
            <structure:Code value="IDR">
                <structure:Description>Indonesian rupiah</structure:Description>

            </structure:Code>
            <structure:Code value="IEP">
                <structure:Description>Irish pound</structure:Description>
            </structure:Code>
            <structure:Code value="ILS">
                <structure:Description>Israeli shekel</structure:Description>
            </structure:Code>
            <structure:Code value="IMP">

                <structure:Description>Isle of Man, Pounds</structure:Description>
            </structure:Code>
            <structure:Code value="INR">
                <structure:Description>Indian rupee</structure:Description>
            </structure:Code>
            <structure:Code value="IQD">
                <structure:Description>Iraqi dinar</structure:Description>

            </structure:Code>
            <structure:Code value="IRR">
                <structure:Description>Iranian rial</structure:Description>
            </structure:Code>
            <structure:Code value="ISK">
                <structure:Description>Iceland krona</structure:Description>
            </structure:Code>
            <structure:Code value="ITL">

                <structure:Description>Italian lira</structure:Description>
            </structure:Code>
            <structure:Code value="JEP">
                <structure:Description>Jersey, Pounds</structure:Description>
            </structure:Code>
            <structure:Code value="JMD">
                <structure:Description>Jamaican dollar</structure:Description>

            </structure:Code>
            <structure:Code value="JOD">
                <structure:Description>Jordanian dinar</structure:Description>
            </structure:Code>
            <structure:Code value="JPY">
                <structure:Description>Japanese yen</structure:Description>
            </structure:Code>
            <structure:Code value="KES">

                <structure:Description>Kenyan shilling</structure:Description>
            </structure:Code>
            <structure:Code value="KGS">
                <structure:Description>Kyrgyzstan som</structure:Description>
            </structure:Code>
            <structure:Code value="KHR">
                <structure:Description>Kampuchean real (Cambodian)</structure:Description>

            </structure:Code>
            <structure:Code value="KMF">
                <structure:Description>Comoros franc</structure:Description>
            </structure:Code>
            <structure:Code value="KPW">
                <structure:Description>Korean won (North)</structure:Description>
            </structure:Code>
            <structure:Code value="KRW">

                <structure:Description>Korean won (Republic)</structure:Description>
            </structure:Code>
            <structure:Code value="KWD">
                <structure:Description>Kuwait dinar</structure:Description>
            </structure:Code>
            <structure:Code value="KYD">
                <structure:Description>Cayman Islands dollar</structure:Description>

            </structure:Code>
            <structure:Code value="KZT">
                <structure:Description>Kazakstan tenge</structure:Description>
            </structure:Code>
            <structure:Code value="LAK">
                <structure:Description>Lao kip</structure:Description>
            </structure:Code>
            <structure:Code value="LBP">

                <structure:Description>Lebanese pound</structure:Description>
            </structure:Code>
            <structure:Code value="LKR">
                <structure:Description>Sri Lanka rupee</structure:Description>
            </structure:Code>
            <structure:Code value="LRD">
                <structure:Description>Liberian dollar</structure:Description>

            </structure:Code>
            <structure:Code value="LSL">
                <structure:Description>Lesotho loti</structure:Description>
            </structure:Code>
            <structure:Code value="LTL">
                <structure:Description>Lithuanian litas</structure:Description>
            </structure:Code>
            <structure:Code value="LUF">

                <structure:Description>Luxembourg franc</structure:Description>
            </structure:Code>
            <structure:Code value="LVL">
                <structure:Description>Latvian lats</structure:Description>
            </structure:Code>
            <structure:Code value="LYD">
                <structure:Description>Libyan dinar</structure:Description>

            </structure:Code>
            <structure:Code value="MAD">
                <structure:Description>Moroccan dirham</structure:Description>
            </structure:Code>
            <structure:Code value="MDL">
                <structure:Description>Moldovian leu</structure:Description>
            </structure:Code>
            <structure:Code value="MGA">

                <structure:Description>Madagascar, Ariary</structure:Description>
            </structure:Code>
            <structure:Code value="MGF">
                <structure:Description>Malagasy franc</structure:Description>
            </structure:Code>
            <structure:Code value="MKD">
                <structure:Description>Macedonian denar</structure:Description>

            </structure:Code>
            <structure:Code value="MMK">
                <structure:Description>Myanmar kyat</structure:Description>
            </structure:Code>
            <structure:Code value="MNT">
                <structure:Description>Mongolian tugrik</structure:Description>
            </structure:Code>
            <structure:Code value="MOP">

                <structure:Description>Macau pataca</structure:Description>
            </structure:Code>
            <structure:Code value="MRO">
                <structure:Description>Mauritanian ouguiya</structure:Description>
            </structure:Code>
            <structure:Code value="MTL">
                <structure:Description>Maltese lira</structure:Description>

            </structure:Code>
            <structure:Code value="MUR">
                <structure:Description>Mauritius rupee</structure:Description>
            </structure:Code>
            <structure:Code value="MVR">
                <structure:Description>Maldive rufiyaa</structure:Description>
            </structure:Code>
            <structure:Code value="MWK">

                <structure:Description>Malawi kwacha</structure:Description>
            </structure:Code>
            <structure:Code value="MXN">
                <structure:Description>Mexican peso</structure:Description>
            </structure:Code>
            <structure:Code value="MXP">
                <structure:Description>Mexican peso (old)</structure:Description>

            </structure:Code>
            <structure:Code value="MYR">
                <structure:Description>Malaysian ringgit</structure:Description>
            </structure:Code>
            <structure:Code value="MZM">
                <structure:Description>Mozambique metical (old)</structure:Description>
            </structure:Code>
            <structure:Code value="MZN">

                <structure:Description>Mozambique, Meticais</structure:Description>
            </structure:Code>
            <structure:Code value="NAD">
                <structure:Description>Namibian dollar</structure:Description>
            </structure:Code>
            <structure:Code value="NGN">
                <structure:Description>Nigerian naira</structure:Description>

            </structure:Code>
            <structure:Code value="NIO">
                <structure:Description>Nicaraguan cordoba</structure:Description>
            </structure:Code>
            <structure:Code value="NLG">
                <structure:Description>Netherlands guilder</structure:Description>
            </structure:Code>
            <structure:Code value="NOK">

                <structure:Description>Norwegian krone</structure:Description>
            </structure:Code>
            <structure:Code value="NPR">
                <structure:Description>Nepaleese rupee</structure:Description>
            </structure:Code>
            <structure:Code value="NZD">
                <structure:Description>New Zealand dollar</structure:Description>

            </structure:Code>
            <structure:Code value="OMR">
                <structure:Description>Oman Sul rial</structure:Description>
            </structure:Code>
            <structure:Code value="PAB">
                <structure:Description>Panama balboa</structure:Description>
            </structure:Code>
            <structure:Code value="PEN">

                <structure:Description>Peru nuevo sol</structure:Description>
            </structure:Code>
            <structure:Code value="PGK">
                <structure:Description>Papua New Guinea kina</structure:Description>
            </structure:Code>
            <structure:Code value="PHP">
                <structure:Description>Philippine peso</structure:Description>

            </structure:Code>
            <structure:Code value="PKR">
                <structure:Description>Pakistan rupee</structure:Description>
            </structure:Code>
            <structure:Code value="PLN">
                <structure:Description>Polish zloty</structure:Description>
            </structure:Code>
            <structure:Code value="PLZ">

                <structure:Description>Polish zloty (old)</structure:Description>
            </structure:Code>
            <structure:Code value="PTE">
                <structure:Description>Portugese escudo</structure:Description>
            </structure:Code>
            <structure:Code value="PYG">
                <structure:Description>Paraguay guarani</structure:Description>

            </structure:Code>
            <structure:Code value="QAR">
                <structure:Description>Qatari rial</structure:Description>
            </structure:Code>
            <structure:Code value="ROL">
                <structure:Description>Romanian leu (old)</structure:Description>
            </structure:Code>
            <structure:Code value="RON">

                <structure:Description>Romanian leu</structure:Description>
            </structure:Code>
            <structure:Code value="RSD">
                <structure:Description>Serbian dinar</structure:Description>
            </structure:Code>
            <structure:Code value="RUB">
                <structure:Description>Rouble</structure:Description>

            </structure:Code>
            <structure:Code value="RUR">
                <structure:Description>Russian ruble (old)</structure:Description>
            </structure:Code>
            <structure:Code value="RWF">
                <structure:Description>Rwanda franc</structure:Description>
            </structure:Code>
            <structure:Code value="SAR">

                <structure:Description>Saudi riyal</structure:Description>
            </structure:Code>
            <structure:Code value="SBD">
                <structure:Description>Solomon Islands dollar</structure:Description>
            </structure:Code>
            <structure:Code value="SCR">
                <structure:Description>Seychelles rupee</structure:Description>

            </structure:Code>
            <structure:Code value="SDD">
                <structure:Description>Sudanese dinar</structure:Description>
            </structure:Code>
            <structure:Code value="SDG">
                <structure:Description>Sudan, Dinars</structure:Description>
            </structure:Code>
            <structure:Code value="SDP">

                <structure:Description>Sudanese pound (old)</structure:Description>
            </structure:Code>
            <structure:Code value="SEK">
                <structure:Description>Swedish krona</structure:Description>
            </structure:Code>
            <structure:Code value="SGD">
                <structure:Description>Singapore dollar</structure:Description>

            </structure:Code>
            <structure:Code value="SHP">
                <structure:Description>St. Helena pound</structure:Description>
            </structure:Code>
            <structure:Code value="SIT">
                <structure:Description>Slovenian tolar</structure:Description>
            </structure:Code>
            <structure:Code value="SKK">

                <structure:Description>Slovak koruna</structure:Description>
            </structure:Code>
            <structure:Code value="SLL">
                <structure:Description>Sierra Leone leone</structure:Description>
            </structure:Code>
            <structure:Code value="SOS">
                <structure:Description>Somali shilling</structure:Description>

            </structure:Code>
            <structure:Code value="SPL">
                <structure:Description>Seborga, Luigini</structure:Description>
            </structure:Code>
            <structure:Code value="SRD">
                <structure:Description>Suriname, Dollars</structure:Description>
            </structure:Code>
            <structure:Code value="SRG">

                <structure:Description>Suriname guilder</structure:Description>
            </structure:Code>
            <structure:Code value="STD">
                <structure:Description>Sao Tome and Principe dobra</structure:Description>
            </structure:Code>
            <structure:Code value="SVC">
                <structure:Description>El Salvador colon</structure:Description>

            </structure:Code>
            <structure:Code value="SYP">
                <structure:Description>Syrian pound</structure:Description>
            </structure:Code>
            <structure:Code value="SZL">
                <structure:Description>Swaziland lilangeni</structure:Description>
            </structure:Code>
            <structure:Code value="THB">

                <structure:Description>Thai bhat</structure:Description>
            </structure:Code>
            <structure:Code value="TJR">
                <structure:Description>Tajikistan rouble</structure:Description>
            </structure:Code>
            <structure:Code value="TJS">
                <structure:Description>Tajikistan, Somoni</structure:Description>

            </structure:Code>
            <structure:Code value="TMM">
                <structure:Description>Turkmenistan manat (old)</structure:Description>
            </structure:Code>
            <structure:Code value="TMT">
                <structure:Description>Turkmenistan manat</structure:Description>
            </structure:Code>
            <structure:Code value="TND">

                <structure:Description>Tunisian dinar</structure:Description>
            </structure:Code>
            <structure:Code value="TOP">
                <structure:Description>Tongan paanga</structure:Description>
            </structure:Code>
            <structure:Code value="TPE">
                <structure:Description>East Timor escudo</structure:Description>

            </structure:Code>
            <structure:Code value="TRL">
                <structure:Description>Turkish lira (old)</structure:Description>
            </structure:Code>
            <structure:Code value="TRY">
                <structure:Description>Turkish lira</structure:Description>
            </structure:Code>
            <structure:Code value="TTD">

                <structure:Description>Trinidad and Tobago dollar</structure:Description>
            </structure:Code>
            <structure:Code value="TVD">
                <structure:Description>Tuvalu, Tuvalu Dollars</structure:Description>
            </structure:Code>
            <structure:Code value="TWD">
                <structure:Description>New Taiwan dollar</structure:Description>

            </structure:Code>
            <structure:Code value="TZS">
                <structure:Description>Tanzania shilling</structure:Description>
            </structure:Code>
            <structure:Code value="UAH">
                <structure:Description>Ukraine hryvnia</structure:Description>
            </structure:Code>
            <structure:Code value="UGX">

                <structure:Description>Uganda Shilling</structure:Description>
            </structure:Code>
            <structure:Code value="USD">
                <structure:Description>US dollar</structure:Description>
            </structure:Code>
            <structure:Code value="UYU">
                <structure:Description>Uruguayan peso</structure:Description>

            </structure:Code>
            <structure:Code value="UZS">
                <structure:Description>Uzbekistan sum</structure:Description>
            </structure:Code>
            <structure:Code value="VEB">
                <structure:Description>Venezuela bolivar (old)</structure:Description>
            </structure:Code>
            <structure:Code value="VEF">

                <structure:Description>Venezuela bolivar</structure:Description>
            </structure:Code>
            <structure:Code value="VND">
                <structure:Description>Vietnamese dong</structure:Description>
            </structure:Code>
            <structure:Code value="VUV">
                <structure:Description>Vanuatu vatu</structure:Description>

            </structure:Code>
            <structure:Code value="WST">
                <structure:Description>Samoan tala</structure:Description>
            </structure:Code>
            <structure:Code value="XAF">
                <structure:Description>CFA franc / BEAC</structure:Description>
            </structure:Code>
            <structure:Code value="XAG">

                <structure:Description>Silver</structure:Description>
            </structure:Code>
            <structure:Code value="XAU">
                <structure:Description>Gold in units of grams</structure:Description>
            </structure:Code>
            <structure:Code value="XBA">
                <structure:Description>European composite unit</structure:Description>

            </structure:Code>
            <structure:Code value="XBB">
                <structure:Description>European Monetary unit EC-6</structure:Description>
            </structure:Code>
            <structure:Code value="XCD">
                <structure:Description>Eastern Caribbean dollar</structure:Description>
            </structure:Code>
            <structure:Code value="XDR">

                <structure:Description>Special Drawing Rights (SDR)</structure:Description>
            </structure:Code>
            <structure:Code value="XEU">
                <structure:Description>European Currency Unit (E.C.U.)</structure:Description>
            </structure:Code>
            <structure:Code value="XOF">
                <structure:Description>CFA franc / BCEAO</structure:Description>

            </structure:Code>
            <structure:Code value="XPD">
                <structure:Description>Palladium Ounces</structure:Description>
            </structure:Code>
            <structure:Code value="XPF">
                <structure:Description>Pacific franc</structure:Description>
            </structure:Code>
            <structure:Code value="XPT">

                <structure:Description>Platinum, Ounces</structure:Description>
            </structure:Code>
            <structure:Code value="YER">
                <structure:Description>Yemeni rial</structure:Description>
            </structure:Code>
            <structure:Code value="YUM">
                <structure:Description>Yugoslav dinar</structure:Description>

            </structure:Code>
            <structure:Code value="Z01">
                <structure:Description>All currencies combined</structure:Description>
            </structure:Code>
            <structure:Code value="Z02">
                <structure:Description>Euro and euro area national currencies</structure:Description>
            </structure:Code>
            <structure:Code value="Z03">

                <structure:Description>Other EU currencies combined</structure:Description>
            </structure:Code>
            <structure:Code value="Z04">
                <structure:Description>Other currencies than EU combined</structure:Description>
            </structure:Code>
            <structure:Code value="Z05">
                <structure:Description>All currencies other than EU, EUR, USD, CHF, JPY</structure:Description>

            </structure:Code>
            <structure:Code value="Z06">
                <structure:Description>Non-Euro and non-euro area currencies combined</structure:Description>
            </structure:Code>
            <structure:Code value="Z07">
                <structure:Description>All currencies other than domestic, Euro and euro area currencies</structure:Description>
            </structure:Code>
            <structure:Code value="Z08">

                <structure:Description>ECB EER-12 group of currencies (AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US), changing composition of the euro area</structure:Description>
            </structure:Code>
            <structure:Code value="Z09">
                <structure:Description>EER broad group of currencies including also Greece until 01 january 2001</structure:Description>
            </structure:Code>
            <structure:Code value="Z0Z">
                <structure:Description>Not applicable</structure:Description>

            </structure:Code>
            <structure:Code value="Z10">
                <structure:Description>EER-12 group of currencies (AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US)</structure:Description>
            </structure:Code>
            <structure:Code value="Z11">
                <structure:Description>EER broad group of currencies (excluding Greece)</structure:Description>
            </structure:Code>
            <structure:Code value="Z12">

                <structure:Description>Euro and Euro Area countries currencies (including Greece)</structure:Description>
            </structure:Code>
            <structure:Code value="Z13">
                <structure:Description>Other EU currencies combined (MU12; excluding GRD)</structure:Description>
            </structure:Code>
            <structure:Code value="Z14">
                <structure:Description>Other currencies than EU15 and EUR combined</structure:Description>

            </structure:Code>
            <structure:Code value="Z15">
                <structure:Description>All currencies other than EU15, EUR, USD, CHF, JPY</structure:Description>
            </structure:Code>
            <structure:Code value="Z16">
                <structure:Description>Non-MU12 currencies combined</structure:Description>
            </structure:Code>
            <structure:Code value="Z17">

                <structure:Description>ECB EER-12 group of currencies and Euro Area countries currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US)</structure:Description>
            </structure:Code>
            <structure:Code value="Z18">
                <structure:Description>ECB EER broad group of currencies and Euro Area countries currencies</structure:Description>
            </structure:Code>
            <structure:Code value="Z19">
                <structure:Description>ECB EER-12 group of currencies and Euro area 11 countries currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US)</structure:Description>

            </structure:Code>
            <structure:Code value="Z20">
                <structure:Description>ECB EER-12 group of currencies (AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US) - Euro area 15</structure:Description>
            </structure:Code>
            <structure:Code value="Z21">
                <structure:Description>ECB EER broad group, regional breakdown, industrialised countries</structure:Description>
            </structure:Code>
            <structure:Code value="Z22">

                <structure:Description>ECB EER broad group, regional breakdown, non-Japan Asia</structure:Description>
            </structure:Code>
            <structure:Code value="Z23">
                <structure:Description>ECB EER broad group, regional breakdown, Latin America</structure:Description>
            </structure:Code>
            <structure:Code value="Z24">
                <structure:Description>ECB EER broad group, regional breakdown, Central and Eastern Europe (CEEC)</structure:Description>

            </structure:Code>
            <structure:Code value="Z25">
                <structure:Description>ECB EER broad group, regional breakdown, other countries</structure:Description>
            </structure:Code>
            <structure:Code value="Z26">
                <structure:Description>Euro area 15 countries currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI, MT and CY)</structure:Description>
            </structure:Code>
            <structure:Code value="Z27">

                <structure:Description>ECB EER-12 group of currencies and Euro area 15 country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI, CY, MT, AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US)</structure:Description>
            </structure:Code>
            <structure:Code value="Z28">
                <structure:Description>Euro area-16 countries (BE, DE, IE, GR, ES, FR, IT, CY, LU, MT, NL, AT, PT, SI, SK and FI)</structure:Description>
            </structure:Code>
            <structure:Code value="Z29">
                <structure:Description>Euro area-16 countries vis-à-vis the EER-12 group of trading partners and other euro area countries (AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, BE, DE, IE, GR, ES, FR, IT, CY, LU, MT, NL, AT, PT, SI, SK and FI)</structure:Description>

            </structure:Code>
            <structure:Code value="Z30">
                <structure:Description>EER-23 group of currencies (CZ, CY, DK, EE, LV, LT, HU, MT, PL, SI, SK, SE, GB, AU, CA, CN, HK, JP, NO, SG, KR, CH, US)</structure:Description>
            </structure:Code>
            <structure:Code value="Z31">
                <structure:Description>EER-42 group of currencies (CZ, CY, DK, EE, LV, LT, HU, MT, PL, SI, SK, SE, GB, AU, CA, CN, HK, JP, NO, SG, KR, CH, US, DZ, AR, BR, BG, HR, IN, ID, IL, MY, MX, MA, NZ, PH, RO, RU, ZA, TW, TH, TR)</structure:Description>
            </structure:Code>
            <structure:Code value="Z37">

                <structure:Description>ECB EER-23 group of currencies and Euro Area countries currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, CZ, CY, DK, EE, LV, LT, HU, MT, PL, SI, SK, SE, GB, AU, CA, CN, HK, JP, NO, SG, KR, CH, US)</structure:Description>
            </structure:Code>
            <structure:Code value="Z38">
                <structure:Description>ECB EER-42 group of currencies and Euro Area countries currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, CZ, CY, DK, EE, LV, LT, HU, MT, PL, SI, SK, SE, GB, AU, CA, CN, HK, JP, NO, SG, KR, CH, US, DZ, AR, BR, BG, HR, IN, ID, IL, MY, MX, MA, NZ, PH, RO, RU, ZA, TW, TH, TR)</structure:Description>
            </structure:Code>
            <structure:Code value="Z40">
                <structure:Description>ECB EER-12 group of currencies (AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US)</structure:Description>

            </structure:Code>
            <structure:Code value="Z41">
                <structure:Description>All currencies other than domestic</structure:Description>
            </structure:Code>
            <structure:Code value="Z44">
                <structure:Description>Other currencies than EU15, EUR and domestic</structure:Description>
            </structure:Code>
            <structure:Code value="Z45">

                <structure:Description>All currencies other than EU15, EUR, USD, CHF, JPY and domestic</structure:Description>
            </structure:Code>
            <structure:Code value="Z46">
                <structure:Description>All currencies other than EUR, USD, GBP and JPY</structure:Description>
            </structure:Code>
            <structure:Code value="Z50">
                <structure:Description>ECB EER-24 group of currencies (AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, CY, CZ, EE, HU, LV, LT, MT, PL, SK, BG, RO)</structure:Description>

            </structure:Code>
            <structure:Code value="Z51">
                <structure:Description>ECB EER-44 group of currencies (AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, CY, CZ, EE, HU, LV, LT, MT, PL, SK, BG, RO, NZ, DZ, AR, BR, HR, IN, ID, IL, MY, MX, MA, PH, RU, ZA, TW, TH, TR, IS, CL, VE)</structure:Description>
            </structure:Code>
            <structure:Code value="Z52">
                <structure:Description>Euro and Euro area country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI)</structure:Description>
            </structure:Code>
            <structure:Code value="Z53">

                <structure:Description>Non-euro area 13 currencies combined (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI)</structure:Description>
            </structure:Code>
            <structure:Code value="Z54">
                <structure:Description>ECB EER-22 group of currencies (AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US,CZ, EE, HU, LV, LT, PL, SK, BG, RO) - Euro area 15</structure:Description>
            </structure:Code>
            <structure:Code value="Z55">
                <structure:Description>ECB EER-42 group of currencies (AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, CZ, EE, HU, LV, LT, PL, SK, BG, RO, NZ, DZ, AR, BR, HR, IN, ID, IL, MY, MX, MA, PH, RU, ZA, TW, TH, TR, IS, CL, VE) - Euro area 15</structure:Description>

            </structure:Code>
            <structure:Code value="Z56">
                <structure:Description>ECB EER-12 group of currencies and Euro area country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI, AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US)</structure:Description>
            </structure:Code>
            <structure:Code value="Z57">
                <structure:Description>ECB EER-21 group of currencies and Euro area 16 country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI, AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, CY, CZ, EE, HU, LV, LT, MT, PL, SK, BG, RO)</structure:Description>
            </structure:Code>
            <structure:Code value="Z58">

                <structure:Description>ECB EER-41 group of currencies and Euro area 16 country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI, AU, CA, CN, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, CY, CZ, EE, HU, LV, LT, MT, PL, SK, BG, RO, NZ, DZ, AR, BR, HR, IN, ID, IL, MY, MX, MA, PH, RU, ZA, TW, TH, TR, IS, CL, VE)</structure:Description>
            </structure:Code>
            <structure:Code value="Z59">
                <structure:Description>Euro area-16 countries vis-à-vis the EER-21 group of trading partners (AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, BG, CZ, EE, LV, LT, HU, PL, RO and CN)</structure:Description>
            </structure:Code>
            <structure:Code value="Z60">
                <structure:Description>Euro area-16 countries vis-à-vis the EER-41 group of trading partners (AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB, US, BG, CZ, EE, LV, LT, HU, PL, RO, CN, DZ, AR, BR, CL, HR, IS, IN, ID, IL, MY, MX, MA, NZ, PH, RU, ZA, TW, TH, TR and VE)</structure:Description>

            </structure:Code>
            <structure:Code value="Z62">
                <structure:Description>Euro and Euro area country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI, CY, MT)</structure:Description>
            </structure:Code>
            <structure:Code value="Z63">
                <structure:Description>Non-euro area 15 currencies combined (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI, CY, MT)</structure:Description>
            </structure:Code>
            <structure:Code value="Z67">

                <structure:Description>Euro area-16 countries vis-à-vis the EER-12 group of trading partners (AU, CA, DK, HK, JP, NO, SG, KR, SE, CH, GB and US)</structure:Description>
            </structure:Code>
            <structure:Code value="Z72">
                <structure:Description>Euro and Euro area 16 country currencies (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI, CY, MT, SK)</structure:Description>
            </structure:Code>
            <structure:Code value="Z73">
                <structure:Description>Non-euro area 16 currencies combined (FR, BE, LU, NL, DE, IT, IE, PT, ES, FI, AT, GR, SI, CY, MT, SK)</structure:Description>

            </structure:Code>
            <structure:Code value="ZAR">
                <structure:Description>South African Rand</structure:Description>
            </structure:Code>
            <structure:Code value="ZMK">
                <structure:Description>Zambian kwacha</structure:Description>
            </structure:Code>
            <structure:Code value="ZWD">

                <structure:Description>Zimbabwe dollar</structure:Description>
            </structure:Code>
            <structure:Code value="ZWN">
                <structure:Description>Zimbabwe, Zimbabwe Dollars</structure:Description>
            </structure:Code>
        </structure:CodeList>
        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_DECIMALS">
            <structure:Name>Decimals code list</structure:Name>

            <structure:Code value="0">
                <structure:Description>Zero</structure:Description>
            </structure:Code>
            <structure:Code value="1">
                <structure:Description>One</structure:Description>
            </structure:Code>
            <structure:Code value="2">
                <structure:Description>Two</structure:Description>

            </structure:Code>
            <structure:Code value="3">
                <structure:Description>Three</structure:Description>
            </structure:Code>
            <structure:Code value="4">
                <structure:Description>Four</structure:Description>
            </structure:Code>
            <structure:Code value="5">

                <structure:Description>Five</structure:Description>
            </structure:Code>
            <structure:Code value="6">
                <structure:Description>Six</structure:Description>
            </structure:Code>
            <structure:Code value="7">
                <structure:Description>Seven</structure:Description>

            </structure:Code>
            <structure:Code value="8">
                <structure:Description>Eight</structure:Description>
            </structure:Code>
            <structure:Code value="9">
                <structure:Description>Nine</structure:Description>
            </structure:Code>
        </structure:CodeList>

        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_EXR_SUFFIX">
            <structure:Name>Exch. rate series variation code list</structure:Name>
            <structure:Code value="A">
                <structure:Description>Average or standardised measure for given frequency</structure:Description>
            </structure:Code>
            <structure:Code value="E">
                <structure:Description>End-of-period</structure:Description>

            </structure:Code>
            <structure:Code value="P">
                <structure:Description>Growth rate to previous period</structure:Description>
            </structure:Code>
            <structure:Code value="R">
                <structure:Description>Annual rate of change</structure:Description>
            </structure:Code>
            <structure:Code value="S">

                <structure:Description>Accumulated perc change compared to 1998 (Dec 1998 for monthly series and 1998Q4 for quart. series)</structure:Description>
            </structure:Code>
        </structure:CodeList>
        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_EXR_TYPE">
            <structure:Name>Exchange rate type code list</structure:Name>
            <structure:Code value="BRC0">
                <structure:Description>Real bilateral exchange rate, CPI deflated</structure:Description>

            </structure:Code>
            <structure:Code value="CR00">
                <structure:Description>Central rate</structure:Description>
            </structure:Code>
            <structure:Code value="EN00">
                <structure:Description>Nominal effective exch. rate</structure:Description>
            </structure:Code>
            <structure:Code value="ERC0">

                <structure:Description>Real effective exch. rate CPI deflated</structure:Description>
            </structure:Code>
            <structure:Code value="ERC1">
                <structure:Description>Real effective exch. rate retail prices deflated</structure:Description>
            </structure:Code>
            <structure:Code value="ERD0">
                <structure:Description>Real effective exch. rate GDP deflators deflated</structure:Description>

            </structure:Code>
            <structure:Code value="ERM0">
                <structure:Description>Real effective exch. rate import unit values deflated</structure:Description>
            </structure:Code>
            <structure:Code value="ERP0">
                <structure:Description>Real effective exch. rate producer prices deflated</structure:Description>
            </structure:Code>
            <structure:Code value="ERU0">

                <structure:Description>Real effective exch. rate ULC manufacturing deflated</structure:Description>
            </structure:Code>
            <structure:Code value="ERU1">
                <structure:Description>Real effective exch. rate ULC total economy deflated</structure:Description>
            </structure:Code>
            <structure:Code value="ERW0">
                <structure:Description>Real effective exch. rate wholesale prices deflated</structure:Description>

            </structure:Code>
            <structure:Code value="ERX0">
                <structure:Description>Real effective exch. rate export unit values deflated</structure:Description>
            </structure:Code>
            <structure:Code value="F01M">
                <structure:Description>1m-forward</structure:Description>
            </structure:Code>
            <structure:Code value="F03M">

                <structure:Description>3m-forward</structure:Description>
            </structure:Code>
            <structure:Code value="F06M">
                <structure:Description>6m-forward</structure:Description>
            </structure:Code>
            <structure:Code value="F12M">
                <structure:Description>12m-forward</structure:Description>

            </structure:Code>
            <structure:Code value="IR00">
                <structure:Description>Indicative rate</structure:Description>
            </structure:Code>
            <structure:Code value="NN00">
                <structure:Description>Nominal harmonised competitiveness indicator</structure:Description>
            </structure:Code>
            <structure:Code value="NRC0">

                <structure:Description>Real harmonised competitiveness indicator CPI deflated</structure:Description>
            </structure:Code>
            <structure:Code value="NRD0">
                <structure:Description>Real harmonised competitiveness indicator GDP deflators deflated</structure:Description>
            </structure:Code>
            <structure:Code value="NRP0">
                <structure:Description>Real harmonised competitiveness indicator Producer Prices deflated</structure:Description>

            </structure:Code>
            <structure:Code value="NRU0">
                <structure:Description>Real harmonised competitiveness indicator ULC manufacturing deflated</structure:Description>
            </structure:Code>
            <structure:Code value="NRU1">
                <structure:Description>Real harmonised competitiveness indicator ULC in total economy deflated</structure:Description>
            </structure:Code>
            <structure:Code value="OF00">

                <structure:Description>Official fixing</structure:Description>
            </structure:Code>
            <structure:Code value="RR00">
                <structure:Description>Reference rate</structure:Description>
            </structure:Code>
            <structure:Code value="SP00">
                <structure:Description>Spot</structure:Description>

            </structure:Code>
        </structure:CodeList>
        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_FREQ">
            <structure:Name>Frequency code list</structure:Name>
            <structure:Code value="A">
                <structure:Description>Annual</structure:Description>
            </structure:Code>
            <structure:Code value="B">

                <structure:Description>Business</structure:Description>
            </structure:Code>
            <structure:Code value="D">
                <structure:Description>Daily</structure:Description>
            </structure:Code>
            <structure:Code value="E">
                <structure:Description>Event (not supported)</structure:Description>

            </structure:Code>
            <structure:Code value="H">
                <structure:Description>Half-yearly</structure:Description>
            </structure:Code>
            <structure:Code value="M">
                <structure:Description>Monthly</structure:Description>
            </structure:Code>
            <structure:Code value="N">

                <structure:Description>Minutely</structure:Description>
            </structure:Code>
            <structure:Code value="Q">
                <structure:Description>Quarterly</structure:Description>
            </structure:Code>
            <structure:Code value="W">
                <structure:Description>Weekly</structure:Description>

            </structure:Code>
        </structure:CodeList>
        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_OBS_CONF">
            <structure:Name>Observation confidentiality code list</structure:Name>
            <structure:Code value="C">
                <structure:Description>Confidential statistical information</structure:Description>
            </structure:Code>
            <structure:Code value="D">

                <structure:Description>Secondary confidentiality set by the sender, not for publication</structure:Description>
            </structure:Code>
            <structure:Code value="F">
                <structure:Description>Free</structure:Description>
            </structure:Code>
            <structure:Code value="N">
                <structure:Description>Not for publication, restricted for internal use only</structure:Description>

            </structure:Code>
            <structure:Code value="S">
                <structure:Description>Secondary confidentiality set and managed by the receiver, not for publication</structure:Description>
            </structure:Code>
        </structure:CodeList>
        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_OBS_STATUS">
            <structure:Name>Observation status code list</structure:Name>
            <structure:Code value="A">

                <structure:Description>Normal value</structure:Description>
            </structure:Code>
            <structure:Code value="B">
                <structure:Description>Break</structure:Description>
            </structure:Code>
            <structure:Code value="E">
                <structure:Description>Estimated value</structure:Description>

            </structure:Code>
            <structure:Code value="F">
                <structure:Description>Forecast value</structure:Description>
            </structure:Code>
            <structure:Code value="H">
                <structure:Description>Missing value; holiday or weekend</structure:Description>
            </structure:Code>
            <structure:Code value="L">

                <structure:Description>Missing value; data exist but were not collected</structure:Description>
            </structure:Code>
            <structure:Code value="M">
                <structure:Description>Missing value; data cannot exist</structure:Description>
            </structure:Code>
            <structure:Code value="P">
                <structure:Description>Provisional value</structure:Description>

            </structure:Code>
            <structure:Code value="Q">
                <structure:Description>Missing value; suppressed</structure:Description>
            </structure:Code>
            <structure:Code value="S">
                <structure:Description>Strike</structure:Description>
            </structure:Code>
        </structure:CodeList>

        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_ORGANISATION">
            <structure:Name>Organisation code list</structure:Name>
            <structure:Code value="1A0">
                <structure:Description>International organisations</structure:Description>
            </structure:Code>
            <structure:Code value="1B0">
                <structure:Description>UN organisations</structure:Description>

            </structure:Code>
            <structure:Code value="1C0">
                <structure:Description>International Monetary Fund</structure:Description>
            </structure:Code>
            <structure:Code value="1D0">
                <structure:Description>World Trade Organisation</structure:Description>
            </structure:Code>
            <structure:Code value="1E0">

                <structure:Description>International Bank for Reconstruction and Development</structure:Description>
            </structure:Code>
            <structure:Code value="1F0">
                <structure:Description>International Development Association</structure:Description>
            </structure:Code>
            <structure:Code value="1G0">
                <structure:Description>Other UN Organisations (includes 1H, 1J-1T)</structure:Description>

            </structure:Code>
            <structure:Code value="1H0">
                <structure:Description>UNESCO (United Nations Educational, Scientific and Cultural Organisation)</structure:Description>
            </structure:Code>
            <structure:Code value="1J0">
                <structure:Description>FAO (Food and Agriculture Organisation)</structure:Description>
            </structure:Code>
            <structure:Code value="1K0">

                <structure:Description>WHO (World Health Organisation)</structure:Description>
            </structure:Code>
            <structure:Code value="1L0">
                <structure:Description>IFAD (International Fund for Agricultural Development)</structure:Description>
            </structure:Code>
            <structure:Code value="1M0">
                <structure:Description>IFC (International Finance Corporation)</structure:Description>

            </structure:Code>
            <structure:Code value="1N0">
                <structure:Description>MIGA (Multilateral Investment Guarantee Agency)</structure:Description>
            </structure:Code>
            <structure:Code value="1O0">
                <structure:Description>UNICEF (United Nations Children Fund)</structure:Description>
            </structure:Code>
            <structure:Code value="1P0">

                <structure:Description>UNHCR (United Nations High Commissioner for Refugees)</structure:Description>
            </structure:Code>
            <structure:Code value="1Q0">
                <structure:Description>UNRWA (United Nations Relief and Works Agency for Palestine)</structure:Description>
            </structure:Code>
            <structure:Code value="1R0">
                <structure:Description>IAEA (International Atomic Energy Agency)</structure:Description>

            </structure:Code>
            <structure:Code value="1S0">
                <structure:Description>ILO (International Labour Organisation)</structure:Description>
            </structure:Code>
            <structure:Code value="1T0">
                <structure:Description>ITU (International Telecommunication Union)</structure:Description>
            </structure:Code>
            <structure:Code value="1Z0">

                <structure:Description>Rest of UN Organisations n.i.e.</structure:Description>
            </structure:Code>
            <structure:Code value="4A0">
                <structure:Description>European Community Institutions, Organs and Organisms</structure:Description>
            </structure:Code>
            <structure:Code value="4C0">
                <structure:Description>European Investment Bank</structure:Description>

            </structure:Code>
            <structure:Code value="4D0">
                <structure:Description>Statistical Office of the European Commission (Eurostat)</structure:Description>
            </structure:Code>
            <structure:Code value="4D1">
                <structure:Description>European Commission (including Eurostat)</structure:Description>
            </structure:Code>
            <structure:Code value="4E0">

                <structure:Description>European Development Fund</structure:Description>
            </structure:Code>
            <structure:Code value="4F0">
                <structure:Description>European Central Bank (ECB)</structure:Description>
            </structure:Code>
            <structure:Code value="4F1">
                <structure:Description>ECB_LM</structure:Description>

            </structure:Code>
            <structure:Code value="4F2">
                <structure:Description>ECB_AC</structure:Description>
            </structure:Code>
            <structure:Code value="4F3">
                <structure:Description>ECB_FO</structure:Description>
            </structure:Code>
            <structure:Code value="4F4">

                <structure:Description>ECB_MB</structure:Description>
            </structure:Code>
            <structure:Code value="4F5">
                <structure:Description>D-Internal Finance</structure:Description>
            </structure:Code>
            <structure:Code value="4F6">
                <structure:Description>ECB, D-BN</structure:Description>

            </structure:Code>
            <structure:Code value="4F7">
                <structure:Description>ECB, DG-P</structure:Description>
            </structure:Code>
            <structure:Code value="4G0">
                <structure:Description>EIF (European Investment Fund)</structure:Description>
            </structure:Code>
            <structure:Code value="4H0">

                <structure:Description>European Community of Steel and Coal</structure:Description>
            </structure:Code>
            <structure:Code value="4J0">
                <structure:Description>Other EC Institutions, Organs and Organisms covered by General budget</structure:Description>
            </structure:Code>
            <structure:Code value="4K0">
                <structure:Description>European Parliament</structure:Description>

            </structure:Code>
            <structure:Code value="4L0">
                <structure:Description>European Council</structure:Description>
            </structure:Code>
            <structure:Code value="4M0">
                <structure:Description>Court of Justice</structure:Description>
            </structure:Code>
            <structure:Code value="4N0">

                <structure:Description>Court of Auditors</structure:Description>
            </structure:Code>
            <structure:Code value="4P0">
                <structure:Description>Economic and Social Committee</structure:Description>
            </structure:Code>
            <structure:Code value="4Q0">
                <structure:Description>Committee of Regions</structure:Description>

            </structure:Code>
            <structure:Code value="4Z0">
                <structure:Description>Other European Community Institutions, Organs and Organisms</structure:Description>
            </structure:Code>
            <structure:Code value="5A0">
                <structure:Description>Organisation for Economic Cooperation and Development OECD)</structure:Description>
            </structure:Code>
            <structure:Code value="5B0">

                <structure:Description>Bank for International Settlements</structure:Description>
            </structure:Code>
            <structure:Code value="5C0">
                <structure:Description>Inter-American Development Bank</structure:Description>
            </structure:Code>
            <structure:Code value="5D0">
                <structure:Description>African Development Bank</structure:Description>

            </structure:Code>
            <structure:Code value="5E0">
                <structure:Description>Asian Development Bank</structure:Description>
            </structure:Code>
            <structure:Code value="5F0">
                <structure:Description>European Bank for Reconstruction and Development</structure:Description>
            </structure:Code>
            <structure:Code value="5G0">

                <structure:Description>IIC (Inter-American Investment Corporation)</structure:Description>
            </structure:Code>
            <structure:Code value="5H0">
                <structure:Description>NIB (Nordic Investment Bank)</structure:Description>
            </structure:Code>
            <structure:Code value="5I0">
                <structure:Description>Eastern Caribbean Central Bank (ECCB)</structure:Description>

            </structure:Code>
            <structure:Code value="5J0">
                <structure:Description>IBEC (International Bank for Economic Co-operation)</structure:Description>
            </structure:Code>
            <structure:Code value="5K0">
                <structure:Description>IIB (International Investment Bank)</structure:Description>
            </structure:Code>
            <structure:Code value="5L0">

                <structure:Description>CDB (Caribbean Development Bank)</structure:Description>
            </structure:Code>
            <structure:Code value="5M0">
                <structure:Description>AMF (Arab Monetary Fund)</structure:Description>
            </structure:Code>
            <structure:Code value="5N0">
                <structure:Description>BADEA (Banque arabe pour le developpement economique en Afrique)</structure:Description>

            </structure:Code>
            <structure:Code value="5O0">
                <structure:Description>Banque Centrale des Etats de l`Afrique de l`Ouest (BCEAO)</structure:Description>
            </structure:Code>
            <structure:Code value="5P0">
                <structure:Description>CASDB (Central African States Development Bank)</structure:Description>
            </structure:Code>
            <structure:Code value="5Q0">

                <structure:Description>African Development Fund</structure:Description>
            </structure:Code>
            <structure:Code value="5R0">
                <structure:Description>Asian Development Fund</structure:Description>
            </structure:Code>
            <structure:Code value="5S0">
                <structure:Description>Fonds special unifie de developpement</structure:Description>

            </structure:Code>
            <structure:Code value="5T0">
                <structure:Description>CABEI (Central American Bank for Economic Integration)</structure:Description>
            </structure:Code>
            <structure:Code value="5U0">
                <structure:Description>ADC (Andean Development Corporation)</structure:Description>
            </structure:Code>
            <structure:Code value="5V0">

                <structure:Description>Other International Organisations (financial institutions)</structure:Description>
            </structure:Code>
            <structure:Code value="5W0">
                <structure:Description>Banque des Etats de l`Afrique Centrale (BEAC)</structure:Description>
            </structure:Code>
            <structure:Code value="5X0">
                <structure:Description>Communaute economique et Monetaire de l`Afrique Centrale (CEMAC)</structure:Description>

            </structure:Code>
            <structure:Code value="5Y0">
                <structure:Description>Eastern Caribbean Currency Union (ECCU)</structure:Description>
            </structure:Code>
            <structure:Code value="5Z0">
                <structure:Description>Other International Financial Organisations n.i.e.</structure:Description>
            </structure:Code>
            <structure:Code value="6A0">

                <structure:Description>Other International Organisations (non-financial institutions)</structure:Description>
            </structure:Code>
            <structure:Code value="6B0">
                <structure:Description>NATO (North Atlantic Treaty Organisation)</structure:Description>
            </structure:Code>
            <structure:Code value="6C0">
                <structure:Description>Council of Europe</structure:Description>

            </structure:Code>
            <structure:Code value="6D0">
                <structure:Description>ICRC (International Committee of the Red Cross)</structure:Description>
            </structure:Code>
            <structure:Code value="6E0">
                <structure:Description>ESA (European Space Agency)</structure:Description>
            </structure:Code>
            <structure:Code value="6F0">

                <structure:Description>EPO (European Patent Office)</structure:Description>
            </structure:Code>
            <structure:Code value="6G0">
                <structure:Description>EUROCONTROL (European Organisation for the Safety of Air Navigation)</structure:Description>
            </structure:Code>
            <structure:Code value="6H0">
                <structure:Description>EUTELSAT (European Telecommunications Satellite Organisation)</structure:Description>

            </structure:Code>
            <structure:Code value="6I0">
                <structure:Description>West African Economic and Monetary Union (WAEMU)</structure:Description>
            </structure:Code>
            <structure:Code value="6J0">
                <structure:Description>INTELSAT (International Telecommunications Satellite Organisation)</structure:Description>
            </structure:Code>
            <structure:Code value="6K0">

                <structure:Description>EBU/UER (European Broadcasting Union/Union europeenne de radio-television)</structure:Description>
            </structure:Code>
            <structure:Code value="6L0">
                <structure:Description>EUMETSAT (European Organisation for the Exploitation of Meteorological Satellites)</structure:Description>
            </structure:Code>
            <structure:Code value="6M0">
                <structure:Description>ESO (European Southern Observatory)</structure:Description>

            </structure:Code>
            <structure:Code value="6N0">
                <structure:Description>ECMWF (European Centre for Medium-Range Weather Forecasts)</structure:Description>
            </structure:Code>
            <structure:Code value="6O0">
                <structure:Description>EMBL (European Molecular Biology Laboratory)</structure:Description>
            </structure:Code>
            <structure:Code value="6P0">

                <structure:Description>CERN (European Organisation for Nuclear Research)</structure:Description>
            </structure:Code>
            <structure:Code value="6Q0">
                <structure:Description>IOM (International Organisation for Migration)</structure:Description>
            </structure:Code>
            <structure:Code value="6R0">
                <structure:Description>Islamic Development Bank (IDB)</structure:Description>

            </structure:Code>
            <structure:Code value="6Z0">
                <structure:Description>Other International Non-Financial Organisations n.i.e.</structure:Description>
            </structure:Code>
            <structure:Code value="7Z0">
                <structure:Description>International Organisations excl. European Community Institutions (4A)</structure:Description>
            </structure:Code>
            <structure:Code value="8A0">

                <structure:Description>International Union of Credit and Investment Insurers</structure:Description>
            </structure:Code>
            <structure:Code value="AE2">
                <structure:Description>Central Bank of the United Arab Emirates</structure:Description>
            </structure:Code>
            <structure:Code value="AE4">
                <structure:Description>Ministry of Finance and Industry (United Arab Emirates)</structure:Description>

            </structure:Code>
            <structure:Code value="AF2">
                <structure:Description>Da Afghanistan Bank</structure:Description>
            </structure:Code>
            <structure:Code value="AF4">
                <structure:Description>Ministry of Finance (Afghanistan, Islamic State of)</structure:Description>
            </structure:Code>
            <structure:Code value="AG2">

                <structure:Description>Eastern Caribbean Central Bank (ECCB) (Antigua and Barbuda)</structure:Description>
            </structure:Code>
            <structure:Code value="AG4">
                <structure:Description>Ministry of Finance (Antigua and Barbuda)</structure:Description>
            </structure:Code>
            <structure:Code value="AI4">
                <structure:Description>Ministry of Finance (Anguilla)</structure:Description>

            </structure:Code>
            <structure:Code value="AL1">
                <structure:Description>Institution of Statistics (Albania)</structure:Description>
            </structure:Code>
            <structure:Code value="AL2">
                <structure:Description>Bank of Albania</structure:Description>
            </structure:Code>
            <structure:Code value="AL4">

                <structure:Description>Ministere des Finances (Albania)</structure:Description>
            </structure:Code>
            <structure:Code value="AM1">
                <structure:Description>State National Statistics Service (Armenia)</structure:Description>
            </structure:Code>
            <structure:Code value="AM2">
                <structure:Description>Central Bank of Armenia</structure:Description>

            </structure:Code>
            <structure:Code value="AM4">
                <structure:Description>Ministry of Finance and Economy (Armenia)</structure:Description>
            </structure:Code>
            <structure:Code value="AN1">
                <structure:Description>Central Bureau of Statistics (Netherlands Antilles)</structure:Description>
            </structure:Code>
            <structure:Code value="AN2">

                <structure:Description>Bank of the Netherlands Antilles</structure:Description>
            </structure:Code>
            <structure:Code value="AO2">
                <structure:Description>Banco Nacional de Angola</structure:Description>
            </structure:Code>
            <structure:Code value="AO4">
                <structure:Description>Ministerio das Finanças (Angola)</structure:Description>

            </structure:Code>
            <structure:Code value="AR1">
                <structure:Description>Instituto Nacional de Estadistica y Censos (Argentina)</structure:Description>
            </structure:Code>
            <structure:Code value="AR2">
                <structure:Description>Banco Central de la Republica Argentina</structure:Description>
            </structure:Code>
            <structure:Code value="AR4">

                <structure:Description>Ministerio de Economia (Argentina)</structure:Description>
            </structure:Code>
            <structure:Code value="AT1">
                <structure:Description>Statistik Österreich (Austria)</structure:Description>
            </structure:Code>
            <structure:Code value="AT2">
                <structure:Description>Oesterreichische Nationalbank (Austria)</structure:Description>

            </structure:Code>
            <structure:Code value="AU1">
                <structure:Description>Australian Bureau of Statistics</structure:Description>
            </structure:Code>
            <structure:Code value="AU2">
                <structure:Description>Reserve Bank of Australia</structure:Description>
            </structure:Code>
            <structure:Code value="AU3">

                <structure:Description>Australian Prudential Regulation Authority</structure:Description>
            </structure:Code>
            <structure:Code value="AW1">
                <structure:Description>Central Bureau of Statistics (Aruba)</structure:Description>
            </structure:Code>
            <structure:Code value="AW2">
                <structure:Description>Centrale Bank van Aruba</structure:Description>

            </structure:Code>
            <structure:Code value="AZ1">
                <structure:Description>State Statistics Committee of the Azerbaijan Republic</structure:Description>
            </structure:Code>
            <structure:Code value="AZ2">
                <structure:Description>National Bank of Azerbaijan</structure:Description>
            </structure:Code>
            <structure:Code value="AZ4">

                <structure:Description>Ministry of Finance (Azerbaijan)</structure:Description>
            </structure:Code>
            <structure:Code value="BA1">
                <structure:Description>Institute of Statistics (Bosnia and Herzegovina)</structure:Description>
            </structure:Code>
            <structure:Code value="BA2">
                <structure:Description>Central Bank of Bosnia and Herzegovina</structure:Description>

            </structure:Code>
            <structure:Code value="BA4">
                <structure:Description>Ministry of Finance for the Federation of Bosnia and Herzegovina</structure:Description>
            </structure:Code>
            <structure:Code value="BB1">
                <structure:Description>Barbados Statistical Service</structure:Description>
            </structure:Code>
            <structure:Code value="BB2">

                <structure:Description>Central Bank of Barbados</structure:Description>
            </structure:Code>
            <structure:Code value="BB4">
                <structure:Description>Ministry of Finance and Economic Affairs (Barbados)</structure:Description>
            </structure:Code>
            <structure:Code value="BD2">
                <structure:Description>Bangladesh Bank</structure:Description>

            </structure:Code>
            <structure:Code value="BD4">
                <structure:Description>Ministry of Finance (Bangladesh)</structure:Description>
            </structure:Code>
            <structure:Code value="BE1">
                <structure:Description>Institut National de Statistiques de Belgique (Belgium)</structure:Description>
            </structure:Code>
            <structure:Code value="BE2">

                <structure:Description>Banque Nationale de Belgique (Belgium)</structure:Description>
            </structure:Code>
            <structure:Code value="BE3">
                <structure:Description>Federal Public Service Budget (Belgium)</structure:Description>
            </structure:Code>
            <structure:Code value="BE9">
                <structure:Description>Bureau van Dijk</structure:Description>

            </structure:Code>
            <structure:Code value="BF2">
                <structure:Description>Banque Centrale des Etats de l`Afrique de l`Ouest (BCEAO) (Burkina Faso)</structure:Description>
            </structure:Code>
            <structure:Code value="BF4">
                <structure:Description>Ministere de l`Economie et des Finances (Burkina Faso)</structure:Description>
            </structure:Code>
            <structure:Code value="BG1">

                <structure:Description>National Statistical Institute of Bulgaria</structure:Description>
            </structure:Code>
            <structure:Code value="BG2">
                <structure:Description>Bulgarian National Bank</structure:Description>
            </structure:Code>
            <structure:Code value="BG3">
                <structure:Description>Prime Ministers Office (Bulgaria)</structure:Description>

            </structure:Code>
            <structure:Code value="BG4">
                <structure:Description>Ministry of Finance (Bulgaria)</structure:Description>
            </structure:Code>
            <structure:Code value="BH1">
                <structure:Description>Directorate of Statistics (Bahrain)</structure:Description>
            </structure:Code>
            <structure:Code value="BH2">

                <structure:Description>Bahrain Monetary Authority</structure:Description>
            </structure:Code>
            <structure:Code value="BH4">
                <structure:Description>Ministry of Finance and National Economy (Bahrain)</structure:Description>
            </structure:Code>
            <structure:Code value="BI2">
                <structure:Description>Banque de la Republique du Burundi</structure:Description>

            </structure:Code>
            <structure:Code value="BI3">
                <structure:Description>Ministere du Plan (Burundi)</structure:Description>
            </structure:Code>
            <structure:Code value="BI4">
                <structure:Description>Ministere des finances (Burundi)</structure:Description>
            </structure:Code>
            <structure:Code value="BJ1">

                <structure:Description>Institut National de la Statistique et de l`Analyse Economique (Benin)</structure:Description>
            </structure:Code>
            <structure:Code value="BJ2">
                <structure:Description>Banque Centrale des Etats de l`Afrique de l`Ouest (BCEAO) (Benin)</structure:Description>
            </structure:Code>
            <structure:Code value="BJ4">
                <structure:Description>Ministere des Finances (Benin)</structure:Description>

            </structure:Code>
            <structure:Code value="BM1">
                <structure:Description>Bermuda Government - Department of Statistics</structure:Description>
            </structure:Code>
            <structure:Code value="BM2">
                <structure:Description>Bermuda Monetary Authority</structure:Description>
            </structure:Code>
            <structure:Code value="BN1">

                <structure:Description>Department of Statistics (Brunei Darussalam)</structure:Description>
            </structure:Code>
            <structure:Code value="BN4">
                <structure:Description>Ministry of Finance (Brunei Darussalam)</structure:Description>
            </structure:Code>
            <structure:Code value="BO1">
                <structure:Description>Instituto Nacional de Estadistica (Bolivia)</structure:Description>

            </structure:Code>
            <structure:Code value="BO2">
                <structure:Description>Banco Central de Bolivia</structure:Description>
            </structure:Code>
            <structure:Code value="BO3">
                <structure:Description>Secretaria Nacional de Hacienda (Bolivia)</structure:Description>
            </structure:Code>
            <structure:Code value="BO4">

                <structure:Description>Ministerio de Hacienda (Bolivia)</structure:Description>
            </structure:Code>
            <structure:Code value="BR2">
                <structure:Description>Banco Central do Brasil</structure:Description>
            </structure:Code>
            <structure:Code value="BR4">
                <structure:Description>Ministerio da Fazenda (Brazil)</structure:Description>

            </structure:Code>
            <structure:Code value="BS1">
                <structure:Description>Department of Statistics (Bahamas)</structure:Description>
            </structure:Code>
            <structure:Code value="BS2">
                <structure:Description>The Central Bank of the Bahamas</structure:Description>
            </structure:Code>
            <structure:Code value="BS4">

                <structure:Description>Ministry of Finance (Bahamas)</structure:Description>
            </structure:Code>
            <structure:Code value="BT2">
                <structure:Description>Royal Monetary Authority of Bhutan</structure:Description>
            </structure:Code>
            <structure:Code value="BT4">
                <structure:Description>Ministry of Finance (Bhutan)</structure:Description>

            </structure:Code>
            <structure:Code value="BW2">
                <structure:Description>Bank of Botswana</structure:Description>
            </structure:Code>
            <structure:Code value="BW4">
                <structure:Description>Ministry of Finance and Development Planning (Botswana)</structure:Description>
            </structure:Code>
            <structure:Code value="BY1">

                <structure:Description>Ministry of Statistics and Analysis of the Republic of Belarus</structure:Description>
            </structure:Code>
            <structure:Code value="BY2">
                <structure:Description>National Bank of Belarus</structure:Description>
            </structure:Code>
            <structure:Code value="BY4">
                <structure:Description>Ministry of Finance of the Republic of Belarus</structure:Description>

            </structure:Code>
            <structure:Code value="BZ1">
                <structure:Description>Central Statistical Office (Belize)</structure:Description>
            </structure:Code>
            <structure:Code value="BZ2">
                <structure:Description>Central Bank of Belize</structure:Description>
            </structure:Code>
            <structure:Code value="BZ3">

                <structure:Description>Ministry of Foreign Affairs (Belize)</structure:Description>
            </structure:Code>
            <structure:Code value="BZ4">
                <structure:Description>Ministry of Finance (Belize)</structure:Description>
            </structure:Code>
            <structure:Code value="CA1">
                <structure:Description>Statistics Canada</structure:Description>

            </structure:Code>
            <structure:Code value="CA2">
                <structure:Description>Bank of Canada</structure:Description>
            </structure:Code>
            <structure:Code value="CD1">
                <structure:Description>Institute National de la Statistique (Congo, Dem. Rep. of)</structure:Description>
            </structure:Code>
            <structure:Code value="CD2">

                <structure:Description>Banque Centrale du Congo (Congo, Dem. Rep. of)</structure:Description>
            </structure:Code>
            <structure:Code value="CD4">
                <structure:Description>Ministry of Finance and Budget (Congo, Dem. Rep. of)</structure:Description>
            </structure:Code>
            <structure:Code value="CF2">
                <structure:Description>Banque des Etats de l`Afrique Centrale (BEAC) (Central African Republic)</structure:Description>

            </structure:Code>
            <structure:Code value="CF3">
                <structure:Description>Presidence de la Republique (Central African Republic)</structure:Description>
            </structure:Code>
            <structure:Code value="CF4">
                <structure:Description>Ministere des Finances, du Plan et de la Cooperation International (Central African Republic)</structure:Description>
            </structure:Code>
            <structure:Code value="CG1">

                <structure:Description>Centre National de la Statistique et des Etudes Economiques (CNSEE) (Congo, Rep of)</structure:Description>
            </structure:Code>
            <structure:Code value="CG2">
                <structure:Description>Banque des Etats de l`Afrique Centrale (BEAC) (Congo, Rep. of)</structure:Description>
            </structure:Code>
            <structure:Code value="CG4">
                <structure:Description>Ministere de l`economie, des finances et du budget (Congo, Rep of)</structure:Description>

            </structure:Code>
            <structure:Code value="CH1">
                <structure:Description>Swiss Federal Statistical Office</structure:Description>
            </structure:Code>
            <structure:Code value="CH2">
                <structure:Description>Schweizerische Nationalbank (Switzerland)</structure:Description>
            </structure:Code>
            <structure:Code value="CH3">

                <structure:Description>Direction generale des douanes (Switzerland)</structure:Description>
            </structure:Code>
            <structure:Code value="CH4">
                <structure:Description>Swiss Federal Finance Administration (Switzerland)</structure:Description>
            </structure:Code>
            <structure:Code value="CI2">
                <structure:Description>Banque Centrale des Etats de l`Afrique de l`Ouest (BCEAO) (Cote d`Ivoire)</structure:Description>

            </structure:Code>
            <structure:Code value="CI4">
                <structure:Description>Ministere de l`Economie et des Finances (Cote d`Ivoire)</structure:Description>
            </structure:Code>
            <structure:Code value="CL2">
                <structure:Description>Banco Central de Chile</structure:Description>
            </structure:Code>
            <structure:Code value="CL4">

                <structure:Description>Ministerio de Hacienda (Chile)</structure:Description>
            </structure:Code>
            <structure:Code value="CM2">
                <structure:Description>Banque des Etats de l`Afrique Centrale (BEAC) (Cameroon)</structure:Description>
            </structure:Code>
            <structure:Code value="CM3">
                <structure:Description>Ministere du Plan et de l`Amenagement du Territoire (Cameroon)</structure:Description>

            </structure:Code>
            <structure:Code value="CM4">
                <structure:Description>Ministere de l`economie et des finances (Cameroon)</structure:Description>
            </structure:Code>
            <structure:Code value="CN1">
                <structure:Description>State National Bureau of Statistics (China, P.R. Mainland)</structure:Description>
            </structure:Code>
            <structure:Code value="CN2">

                <structure:Description>The Peoples Bank of China</structure:Description>
            </structure:Code>
            <structure:Code value="CN3">
                <structure:Description>State Administration of Foreign Exchange (China, P.R. Mainland)</structure:Description>
            </structure:Code>
            <structure:Code value="CN4">
                <structure:Description>Ministry of Finance (China, P.R. Mainland)</structure:Description>

            </structure:Code>
            <structure:Code value="CO1">
                <structure:Description>Centro Administrativo Nacional (Colombia)</structure:Description>
            </structure:Code>
            <structure:Code value="CO2">
                <structure:Description>Banco de la Republica (Colombia)</structure:Description>
            </structure:Code>
            <structure:Code value="CO4">

                <structure:Description>Ministerio de Hacienda y Credito Publico (Colombia)</structure:Description>
            </structure:Code>
            <structure:Code value="CR2">
                <structure:Description>Banco Central de Costa Rica</structure:Description>
            </structure:Code>
            <structure:Code value="CR4">
                <structure:Description>Ministerio de Hacienda (Costa Rica)</structure:Description>

            </structure:Code>
            <structure:Code value="CS1">
                <structure:Description>Federal Statistical Office (Serbia and Montenegro)</structure:Description>
            </structure:Code>
            <structure:Code value="CS2">
                <structure:Description>National Bank of Serbia</structure:Description>
            </structure:Code>
            <structure:Code value="CS4">

                <structure:Description>Federal Ministry of Finance (Serbia and Montenegro)</structure:Description>
            </structure:Code>
            <structure:Code value="CV1">
                <structure:Description>Instituto Nacional de Estatistica (Cape Verde)</structure:Description>
            </structure:Code>
            <structure:Code value="CV2">
                <structure:Description>Banco de Cabo Verde (Cape Verde)</structure:Description>

            </structure:Code>
            <structure:Code value="CV3">
                <structure:Description>Ministere de la coordination economique (Cape Verde)</structure:Description>
            </structure:Code>
            <structure:Code value="CV4">
                <structure:Description>Ministerio das Financas (Cape Verde)</structure:Description>
            </structure:Code>
            <structure:Code value="CY1">

                <structure:Description>Cyprus, Department of Statistics and Research (Ministry of Finance)</structure:Description>
            </structure:Code>
            <structure:Code value="CY2">
                <structure:Description>Central Bank of Cyprus</structure:Description>
            </structure:Code>
            <structure:Code value="CY4">
                <structure:Description>Ministry of Finance (Cyprus)</structure:Description>

            </structure:Code>
            <structure:Code value="CZ1">
                <structure:Description>Czech Statistical Office</structure:Description>
            </structure:Code>
            <structure:Code value="CZ2">
                <structure:Description>Czech National Bank</structure:Description>
            </structure:Code>
            <structure:Code value="CZ3">

                <structure:Description>Ministry of Transport and Communications/Transport Policy (Czech Republic)</structure:Description>
            </structure:Code>
            <structure:Code value="CZ4">
                <structure:Description>Ministry of Finance of the Czech Republic</structure:Description>
            </structure:Code>
            <structure:Code value="D22">
                <structure:Description>EU 15 central banks</structure:Description>

            </structure:Code>
            <structure:Code value="D32">
                <structure:Description>EU 25 central banks</structure:Description>
            </structure:Code>
            <structure:Code value="D82">
                <structure:Description>Central banks of the new EU Member States 2004 (CY,CZ,EE,HU,LV,LT,MT,PL,SK,SI)</structure:Description>
            </structure:Code>
            <structure:Code value="DE1">

                <structure:Description>Statistisches Bundesamt (Germany)</structure:Description>
            </structure:Code>
            <structure:Code value="DE2">
                <structure:Description>Deutsche Bundesbank (Germany)</structure:Description>
            </structure:Code>
            <structure:Code value="DE3">
                <structure:Description>Kraftfahrt-Bundesamt (Germany)</structure:Description>

            </structure:Code>
            <structure:Code value="DE4">
                <structure:Description>Bundesministerium der Finanzen (Germany)</structure:Description>
            </structure:Code>
            <structure:Code value="DE8">
                <structure:Description>IFO Institut für Wirtschaftsforschung (Germany)</structure:Description>
            </structure:Code>
            <structure:Code value="DE9">

                <structure:Description>Zentrum fur Europaische Wirtschaftsforschnung (ZEW, Germany)</structure:Description>
            </structure:Code>
            <structure:Code value="DJ2">
                <structure:Description>Banque Nationale de Djibouti</structure:Description>
            </structure:Code>
            <structure:Code value="DJ3">
                <structure:Description>Tresor National (Djibouti)</structure:Description>

            </structure:Code>
            <structure:Code value="DJ4">
                <structure:Description>Ministere de l`Economie et des Finances (Djibouti)</structure:Description>
            </structure:Code>
            <structure:Code value="DK1">
                <structure:Description>Danmarks Statistik (Denmark)</structure:Description>
            </structure:Code>
            <structure:Code value="DK2">

                <structure:Description>Danmarks Nationalbank (Denmark)</structure:Description>
            </structure:Code>
            <structure:Code value="DM1">
                <structure:Description>Central Statistical Office (Dominica)</structure:Description>
            </structure:Code>
            <structure:Code value="DM2">
                <structure:Description>Eastern Caribbean Central Bank (ECCB) (Dominica)</structure:Description>

            </structure:Code>
            <structure:Code value="DM4">
                <structure:Description>Ministry of Finance (Dominica)</structure:Description>
            </structure:Code>
            <structure:Code value="DO2">
                <structure:Description>Banco Central de la Republica Dominicana</structure:Description>
            </structure:Code>
            <structure:Code value="DZ1">

                <structure:Description>Office National des Statistiques (Algeria)</structure:Description>
            </structure:Code>
            <structure:Code value="DZ2">
                <structure:Description>Banque d`Algerie</structure:Description>
            </structure:Code>
            <structure:Code value="DZ4">
                <structure:Description>Ministere des Finances (Algeria)</structure:Description>

            </structure:Code>
            <structure:Code value="EC1">
                <structure:Description>Instituto Nacional de Estadistica y Censos (Ecuador)</structure:Description>
            </structure:Code>
            <structure:Code value="EC2">
                <structure:Description>Banco Central del Ecuador</structure:Description>
            </structure:Code>
            <structure:Code value="EC4">

                <structure:Description>Ministerio de Finanzas y Credito Publico (Ecuador)</structure:Description>
            </structure:Code>
            <structure:Code value="EE1">
                <structure:Description>Estonia, State Statistical Office</structure:Description>
            </structure:Code>
            <structure:Code value="EE2">
                <structure:Description>Bank of Estonia</structure:Description>

            </structure:Code>
            <structure:Code value="EE4">
                <structure:Description>Ministry of Finance (Estonia)</structure:Description>
            </structure:Code>
            <structure:Code value="EG1">
                <structure:Description>Central Agency for Public Mobilization and Stats. (Egypt)</structure:Description>
            </structure:Code>
            <structure:Code value="EG2">

                <structure:Description>Central Bank of Egypt</structure:Description>
            </structure:Code>
            <structure:Code value="EG4">
                <structure:Description>Ministry of Finance (Egypt)</structure:Description>
            </structure:Code>
            <structure:Code value="ER2">
                <structure:Description>Bank of Eritrea</structure:Description>

            </structure:Code>
            <structure:Code value="ER4">
                <structure:Description>Ministry of Finance (Eritrea)</structure:Description>
            </structure:Code>
            <structure:Code value="ES1">
                <structure:Description>Instituto Nacional de Statistica (Spain)</structure:Description>
            </structure:Code>
            <structure:Code value="ES2">

                <structure:Description>Banco de Espana (Spain)</structure:Description>
            </structure:Code>
            <structure:Code value="ES3">
                <structure:Description>Departamento de Aduanas (Spain)</structure:Description>
            </structure:Code>
            <structure:Code value="ES4">
                <structure:Description>Ministerio de Economia y Hacienda (Spain)</structure:Description>

            </structure:Code>
            <structure:Code value="ES5">
                <structure:Description>Ministerio de Industria, Tourismo y Comerco (Spain)</structure:Description>
            </structure:Code>
            <structure:Code value="ET2">
                <structure:Description>National Bank of Ethiopia</structure:Description>
            </structure:Code>
            <structure:Code value="ET3">

                <structure:Description>Customs and Excise Administration (Ethiopia)</structure:Description>
            </structure:Code>
            <structure:Code value="ET4">
                <structure:Description>Ministry of Finance (Ethiopia)</structure:Description>
            </structure:Code>
            <structure:Code value="FI1">
                <structure:Description>Statistics Finland (Finland)</structure:Description>

            </structure:Code>
            <structure:Code value="FI2">
                <structure:Description>Bank of Finland (Finland)</structure:Description>
            </structure:Code>
            <structure:Code value="FI3">
                <structure:Description>National Board of Customs (Finland)</structure:Description>
            </structure:Code>
            <structure:Code value="FJ1">

                <structure:Description>Bureau of Statistics (Fiji)</structure:Description>
            </structure:Code>
            <structure:Code value="FJ2">
                <structure:Description>Reserve Bank of Fiji</structure:Description>
            </structure:Code>
            <structure:Code value="FJ4">
                <structure:Description>Ministry of Finance and National Planning (Fiji)</structure:Description>

            </structure:Code>
            <structure:Code value="FM1">
                <structure:Description>Office of Planning and Statistics (Micronesia, Federated States of)</structure:Description>
            </structure:Code>
            <structure:Code value="FR1">
                <structure:Description>Institut National de la Statistique et des Etudes Economiques - INSEE (France)</structure:Description>
            </structure:Code>
            <structure:Code value="FR2">

                <structure:Description>Banque de France (France)</structure:Description>
            </structure:Code>
            <structure:Code value="FR3">
                <structure:Description>Ministere de l Equipement, des Transports et du Logement (France)</structure:Description>
            </structure:Code>
            <structure:Code value="FR4">
                <structure:Description>Ministere de l`Economie et des Finances (France)</structure:Description>

            </structure:Code>
            <structure:Code value="FR5">
                <structure:Description>Direction generale des douanes (France)</structure:Description>
            </structure:Code>
            <structure:Code value="GA2">
                <structure:Description>Banque des Etats de l`Afrique Centrale (BEAC) (Gabon)</structure:Description>
            </structure:Code>
            <structure:Code value="GA3">

                <structure:Description>Ministere du Plan (Gabon)</structure:Description>
            </structure:Code>
            <structure:Code value="GA4">
                <structure:Description>Ministry of Economy, Finance and Privatization (Gabon)</structure:Description>
            </structure:Code>
            <structure:Code value="GA5">
                <structure:Description>Tresorier-Payeur General du Gabon</structure:Description>

            </structure:Code>
            <structure:Code value="GB1">
                <structure:Description>Office for National Statistics (United Kingdom)</structure:Description>
            </structure:Code>
            <structure:Code value="GB2">
                <structure:Description>Bank of England (United Kingdom)</structure:Description>
            </structure:Code>
            <structure:Code value="GB3">

                <structure:Description>Department of Environment, Transport and the Regions (United Kingdom)</structure:Description>
            </structure:Code>
            <structure:Code value="GB4">
                <structure:Description>Department of Trade and Industry (United Kingdom)</structure:Description>
            </structure:Code>
            <structure:Code value="GB9">
                <structure:Description>NTC Economics (United Kingdom)</structure:Description>

            </structure:Code>
            <structure:Code value="GD2">
                <structure:Description>Eastern Caribbean Central Bank (ECCB) (Grenada)</structure:Description>
            </structure:Code>
            <structure:Code value="GD4">
                <structure:Description>Ministry of Finance (Grenada)</structure:Description>
            </structure:Code>
            <structure:Code value="GE1">

                <structure:Description>State Department for Statistics of Georgia</structure:Description>
            </structure:Code>
            <structure:Code value="GE2">
                <structure:Description>National Bank of Georgia</structure:Description>
            </structure:Code>
            <structure:Code value="GE4">
                <structure:Description>Ministry of Finance (Georgia)</structure:Description>

            </structure:Code>
            <structure:Code value="GF1">
                <structure:Description>Institut National de la Statistique et des Etudes Economiques - INSEE - Service regional (Guiana, French)</structure:Description>
            </structure:Code>
            <structure:Code value="GG6">
                <structure:Description>Financial Services Commission, Guernsey (GG)</structure:Description>
            </structure:Code>
            <structure:Code value="GH1">

                <structure:Description>Ghana Statistical Service</structure:Description>
            </structure:Code>
            <structure:Code value="GH2">
                <structure:Description>Bank of Ghana</structure:Description>
            </structure:Code>
            <structure:Code value="GH4">
                <structure:Description>Ministry of Finance (Ghana)</structure:Description>

            </structure:Code>
            <structure:Code value="GM2">
                <structure:Description>Central Bank of The Gambia</structure:Description>
            </structure:Code>
            <structure:Code value="GM4">
                <structure:Description>Ministry of Finance and Economic Affairs (Gambia)</structure:Description>
            </structure:Code>
            <structure:Code value="GN1">

                <structure:Description>Service de la Statistique generale et de la Mecanographie (Guinea)</structure:Description>
            </structure:Code>
            <structure:Code value="GN2">
                <structure:Description>Banque Centrale de la Republique de Guinee</structure:Description>
            </structure:Code>
            <structure:Code value="GN4">
                <structure:Description>Ministere de l`Economie et des Finances (Guinea)</structure:Description>

            </structure:Code>
            <structure:Code value="GP1">
                <structure:Description>Institut National de la Statistique et des Etudes Economiques - INSEE -Service regional (Guadeloupe)</structure:Description>
            </structure:Code>
            <structure:Code value="GQ2">
                <structure:Description>Banque des Etats de l`Afrique Centrale (BEAC) (Equatorial Guinea)</structure:Description>
            </structure:Code>
            <structure:Code value="GQ4">

                <structure:Description>Ministerio de Economia y Hacienda (Equatorial Guinea)</structure:Description>
            </structure:Code>
            <structure:Code value="GR1">
                <structure:Description>National Statistical Service of Greece (Greece)</structure:Description>
            </structure:Code>
            <structure:Code value="GR2">
                <structure:Description>Bank of Greece (Greece)</structure:Description>

            </structure:Code>
            <structure:Code value="GR4">
                <structure:Description>Ministry of Economy and Finance (Greece)</structure:Description>
            </structure:Code>
            <structure:Code value="GT1">
                <structure:Description>Instituto Nacional de Estadistica (Guatemala)</structure:Description>
            </structure:Code>
            <structure:Code value="GT2">

                <structure:Description>Banco de Guatemala</structure:Description>
            </structure:Code>
            <structure:Code value="GT4">
                <structure:Description>Ministerio de Finanzas Publicas (Guatemala)</structure:Description>
            </structure:Code>
            <structure:Code value="GW2">
                <structure:Description>Banque Centrale des Etats de l`Afrique de l`Ouest (BCEAO) (Guinea-Bissau)</structure:Description>

            </structure:Code>
            <structure:Code value="GW4">
                <structure:Description>Ministere de l`Economie et des Finances (Guinea-Bissau)</structure:Description>
            </structure:Code>
            <structure:Code value="GY1">
                <structure:Description>Statistical Bureau / Ministry of Planning (Guyana)</structure:Description>
            </structure:Code>
            <structure:Code value="GY2">

                <structure:Description>Bank of Guyana</structure:Description>
            </structure:Code>
            <structure:Code value="GY4">
                <structure:Description>Ministry of Finance (Guyana)</structure:Description>
            </structure:Code>
            <structure:Code value="HK1">
                <structure:Description>Census and Statistics Department (China, P.R. Hong Kong)</structure:Description>

            </structure:Code>
            <structure:Code value="HK2">
                <structure:Description>Hong Kong Monetary Authority</structure:Description>
            </structure:Code>
            <structure:Code value="HK4">
                <structure:Description>Financial Services and the Treasury Bureau (Treasury) (China, P.R. Hong Kong)</structure:Description>
            </structure:Code>
            <structure:Code value="HN1">

                <structure:Description>Direccion General de Censos y Estadisticas (Honduras)</structure:Description>
            </structure:Code>
            <structure:Code value="HN2">
                <structure:Description>Banco Central de Honduras</structure:Description>
            </structure:Code>
            <structure:Code value="HN4">
                <structure:Description>Ministerio de Hacienda y Credito Publico (Honduras)</structure:Description>

            </structure:Code>
            <structure:Code value="HR1">
                <structure:Description>Central Bureau of Statistics (Croatia)</structure:Description>
            </structure:Code>
            <structure:Code value="HR2">
                <structure:Description>Croatian National Bank</structure:Description>
            </structure:Code>
            <structure:Code value="HR4">

                <structure:Description>Ministry of Finance (Croatia)</structure:Description>
            </structure:Code>
            <structure:Code value="HT1">
                <structure:Description>Institut Haitien de Statistique et d`Informatique (Haiti)</structure:Description>
            </structure:Code>
            <structure:Code value="HT2">
                <structure:Description>Banque de la Republique dHaiti</structure:Description>

            </structure:Code>
            <structure:Code value="HT4">
                <structure:Description>Ministere de l`Economie et des Finances (Haiti)</structure:Description>
            </structure:Code>
            <structure:Code value="HU1">
                <structure:Description>Hungarian Central Statistical Office</structure:Description>
            </structure:Code>
            <structure:Code value="HU2">

                <structure:Description>National Bank of Hungary</structure:Description>
            </structure:Code>
            <structure:Code value="HU4">
                <structure:Description>Ministry of Finance (Hungary)</structure:Description>
            </structure:Code>
            <structure:Code value="I22">
                <structure:Description>Euro area 12 central banks</structure:Description>

            </structure:Code>
            <structure:Code value="I32">
                <structure:Description>Euro area 13 central banks</structure:Description>
            </structure:Code>
            <structure:Code value="I42">
                <structure:Description>Euro area 15 central banks</structure:Description>
            </structure:Code>
            <structure:Code value="I52">

                <structure:Description>Euro area 16 central banks</structure:Description>
            </structure:Code>
            <structure:Code value="ID1">
                <structure:Description>BPS-Statistics Indonesia</structure:Description>
            </structure:Code>
            <structure:Code value="ID2">
                <structure:Description>Bank Indonesia</structure:Description>

            </structure:Code>
            <structure:Code value="ID4">
                <structure:Description>Ministry of Finance (Indonesia)</structure:Description>
            </structure:Code>
            <structure:Code value="IE1">
                <structure:Description>Central Statistical Office (Ireland)</structure:Description>
            </structure:Code>
            <structure:Code value="IE2">

                <structure:Description>Central Bank of Ireland (Ireland)</structure:Description>
            </structure:Code>
            <structure:Code value="IE3">
                <structure:Description>The Office of the Revenue Commissioners (Ireland)</structure:Description>
            </structure:Code>
            <structure:Code value="IE4">
                <structure:Description>Department of Finance (Ireland)</structure:Description>

            </structure:Code>
            <structure:Code value="IL1">
                <structure:Description>Central Bureau of Statistics (Israel)</structure:Description>
            </structure:Code>
            <structure:Code value="IL2">
                <structure:Description>Bank of Israel</structure:Description>
            </structure:Code>
            <structure:Code value="IM6">

                <structure:Description>Financial Supervision Commission, Isle of Man (IM)</structure:Description>
            </structure:Code>
            <structure:Code value="IN2">
                <structure:Description>Reserve Bank of India</structure:Description>
            </structure:Code>
            <structure:Code value="IN4">
                <structure:Description>Ministry of Finance (India)</structure:Description>

            </structure:Code>
            <structure:Code value="IQ2">
                <structure:Description>Central Bank of Iraq</structure:Description>
            </structure:Code>
            <structure:Code value="IQ4">
                <structure:Description>Ministry of Finance (Iraq)</structure:Description>
            </structure:Code>
            <structure:Code value="IR2">

                <structure:Description>The Central Bank of the Islamic Republic of Iran</structure:Description>
            </structure:Code>
            <structure:Code value="IS1">
                <structure:Description>Statistics Iceland</structure:Description>
            </structure:Code>
            <structure:Code value="IS2">
                <structure:Description>Central Bank of Iceland</structure:Description>

            </structure:Code>
            <structure:Code value="IT1">
                <structure:Description>Instituto Nazionale di Statistica - ISTAT (Italy)</structure:Description>
            </structure:Code>
            <structure:Code value="IT2">
                <structure:Description>Banca d` Italia (Italy)</structure:Description>
            </structure:Code>
            <structure:Code value="IT3">

                <structure:Description>Ufficio Italiano dei Cambi (Italy)</structure:Description>
            </structure:Code>
            <structure:Code value="IT4">
                <structure:Description>Ministerio de Tesore (Italy)</structure:Description>
            </structure:Code>
            <structure:Code value="IT9">
                <structure:Description>Instituto di Studi e Analisi Economica (Italy)</structure:Description>

            </structure:Code>
            <structure:Code value="JE6">
                <structure:Description>Financial Services Commission, Jersey (JE)</structure:Description>
            </structure:Code>
            <structure:Code value="JM1">
                <structure:Description>Statistical Institute of Jamaica</structure:Description>
            </structure:Code>
            <structure:Code value="JM2">

                <structure:Description>Bank of Jamaica</structure:Description>
            </structure:Code>
            <structure:Code value="JM4">
                <structure:Description>Ministry of Finance and Planning (Jamaica)</structure:Description>
            </structure:Code>
            <structure:Code value="JO1">
                <structure:Description>Department of Statistics (Jordon)</structure:Description>

            </structure:Code>
            <structure:Code value="JO2">
                <structure:Description>Central Bank of Jordan</structure:Description>
            </structure:Code>
            <structure:Code value="JO4">
                <structure:Description>Ministry of Finance (Jordon)</structure:Description>
            </structure:Code>
            <structure:Code value="JP2">

                <structure:Description>Bank of Japan</structure:Description>
            </structure:Code>
            <structure:Code value="JP4">
                <structure:Description>Ministry of Finance (Japan)</structure:Description>
            </structure:Code>
            <structure:Code value="KE1">
                <structure:Description>Central Bureau of Statistics (Kenya)</structure:Description>

            </structure:Code>
            <structure:Code value="KE2">
                <structure:Description>Central Bank of Kenya</structure:Description>
            </structure:Code>
            <structure:Code value="KE3">
                <structure:Description>Ministry of Planning and National Development (Kenya)</structure:Description>
            </structure:Code>
            <structure:Code value="KE4">

                <structure:Description>Office of the Vice President and Ministry of Finance (Kenya)</structure:Description>
            </structure:Code>
            <structure:Code value="KG1">
                <structure:Description>National Statistical Committee of Kyrgyz Republic</structure:Description>
            </structure:Code>
            <structure:Code value="KG2">
                <structure:Description>National Bank of the Kyrgyz Republic</structure:Description>

            </structure:Code>
            <structure:Code value="KG4">
                <structure:Description>Ministry of Finance (Kyrgyz Republic)</structure:Description>
            </structure:Code>
            <structure:Code value="KH2">
                <structure:Description>National Bank of Cambodia</structure:Description>
            </structure:Code>
            <structure:Code value="KH4">

                <structure:Description>Ministere de l`economie et des finances (Cambodia)</structure:Description>
            </structure:Code>
            <structure:Code value="KI2">
                <structure:Description>Bank of Kiribati, Ltd</structure:Description>
            </structure:Code>
            <structure:Code value="KI4">
                <structure:Description>Ministry of Finance and Economic Planning (Kiribati)</structure:Description>

            </structure:Code>
            <structure:Code value="KM2">
                <structure:Description>Banque Centrale des Comoros</structure:Description>
            </structure:Code>
            <structure:Code value="KM4">
                <structure:Description>Ministere des Finances, du budget et du plan (Comoros)</structure:Description>
            </structure:Code>
            <structure:Code value="KN2">

                <structure:Description>Eastern Caribbean Central Bank (ECCB) (St. Kitts and Nevis)</structure:Description>
            </structure:Code>
            <structure:Code value="KN4">
                <structure:Description>Ministry of Finance (St. Kitts and Nevis)</structure:Description>
            </structure:Code>
            <structure:Code value="KR2">
                <structure:Description>The Bank of Korea</structure:Description>

            </structure:Code>
            <structure:Code value="KR4">
                <structure:Description>Ministry of Finance and Economy (Korea, Republic of)</structure:Description>
            </structure:Code>
            <structure:Code value="KW1">
                <structure:Description>Statistics and Information Technology Sector (Kuwait)</structure:Description>
            </structure:Code>
            <structure:Code value="KW2">

                <structure:Description>Central Bank of Kuwait</structure:Description>
            </structure:Code>
            <structure:Code value="KW4">
                <structure:Description>Ministry of Finance (Kuwait)</structure:Description>
            </structure:Code>
            <structure:Code value="KY1">
                <structure:Description>Department of Finance &amp; Development / Statistical Office (Cayman Islands)</structure:Description>

            </structure:Code>
            <structure:Code value="KY2">
                <structure:Description>Cayman Islands Monetary Authority</structure:Description>
            </structure:Code>
            <structure:Code value="KZ1">
                <structure:Description>National Statistical Agency / Ministry of Economy and Trade of the Republic of Kazakhstan</structure:Description>
            </structure:Code>
            <structure:Code value="KZ2">

                <structure:Description>National Bank of the Republic of Kazakhstan</structure:Description>
            </structure:Code>
            <structure:Code value="KZ4">
                <structure:Description>Ministry of Finance (Kazakhstan)</structure:Description>
            </structure:Code>
            <structure:Code value="LA2">
                <structure:Description>Bank of the Lao P.D.R.</structure:Description>

            </structure:Code>
            <structure:Code value="LA4">
                <structure:Description>Ministry of Finance (Lao Peoples Democratic Republic)</structure:Description>
            </structure:Code>
            <structure:Code value="LB1">
                <structure:Description>Central Administration of Statistics (Lebanon)</structure:Description>
            </structure:Code>
            <structure:Code value="LB2">

                <structure:Description>Banque du Liban (Lebanon)</structure:Description>
            </structure:Code>
            <structure:Code value="LB4">
                <structure:Description>Ministere des finances (Lebanon)</structure:Description>
            </structure:Code>
            <structure:Code value="LC2">
                <structure:Description>Eastern Caribbean Central Bank (ECCB) (St. Lucia)</structure:Description>

            </structure:Code>
            <structure:Code value="LC4">
                <structure:Description>Ministry of Finance, International Financial Services and Economic Affairs (St. Lucia)</structure:Description>
            </structure:Code>
            <structure:Code value="LI1">
                <structure:Description>Amt fur Volkswirtschaft</structure:Description>
            </structure:Code>
            <structure:Code value="LK2">

                <structure:Description>Central Bank of Sri Lanka</structure:Description>
            </structure:Code>
            <structure:Code value="LR1">
                <structure:Description>Ministry of Planning and Economic Affairs (Liberia)</structure:Description>
            </structure:Code>
            <structure:Code value="LR2">
                <structure:Description>Central Bank of Liberia</structure:Description>

            </structure:Code>
            <structure:Code value="LR4">
                <structure:Description>Ministry of Finance (Liberia)</structure:Description>
            </structure:Code>
            <structure:Code value="LS2">
                <structure:Description>Central Bank of Lesotho</structure:Description>
            </structure:Code>
            <structure:Code value="LS4">

                <structure:Description>Ministry of Finance (Lesotho)</structure:Description>
            </structure:Code>
            <structure:Code value="LT1">
                <structure:Description>Lithuania, Department of Statistics</structure:Description>
            </structure:Code>
            <structure:Code value="LT2">
                <structure:Description>Bank of Lithuania</structure:Description>

            </structure:Code>
            <structure:Code value="LT4">
                <structure:Description>Ministry of Finance (Lithuania)</structure:Description>
            </structure:Code>
            <structure:Code value="LU1">
                <structure:Description>STATEC - Service central de la statistique et des études économiques du Luxembourg</structure:Description>
            </structure:Code>
            <structure:Code value="LU2">

                <structure:Description>Banque centrale du Luxembourg</structure:Description>
            </structure:Code>
            <structure:Code value="LV1">
                <structure:Description>Central Statistical Bureau of Latvia</structure:Description>
            </structure:Code>
            <structure:Code value="LV2">
                <structure:Description>Bank of Latvia</structure:Description>

            </structure:Code>
            <structure:Code value="LV3">
                <structure:Description>The Treasury of the Republic of Latvia</structure:Description>
            </structure:Code>
            <structure:Code value="LY1">
                <structure:Description>The National Corporation for Information and Documentation (Libya)</structure:Description>
            </structure:Code>
            <structure:Code value="LY2">

                <structure:Description>Central Bank of Libya</structure:Description>
            </structure:Code>
            <structure:Code value="LY3">
                <structure:Description>General Peoples Secretariat of the Treasury (Libya)</structure:Description>
            </structure:Code>
            <structure:Code value="MA1">
                <structure:Description>Ministere de la Prevision Economique et du Plan (Morocco)</structure:Description>

            </structure:Code>
            <structure:Code value="MA2">
                <structure:Description>Bank Al-Maghrib (Morocco)</structure:Description>
            </structure:Code>
            <structure:Code value="MA4">
                <structure:Description>Ministere de l`Economie, des Finances, de la Privatisation et du Tourisme (Morocco)</structure:Description>
            </structure:Code>
            <structure:Code value="MA5">

                <structure:Description>Office des Changes (Morocco)</structure:Description>
            </structure:Code>
            <structure:Code value="MD1">
                <structure:Description>State Depart. of Statist. of the Rep. of Moldova</structure:Description>
            </structure:Code>
            <structure:Code value="MD2">
                <structure:Description>National Bank of Moldova</structure:Description>

            </structure:Code>
            <structure:Code value="MD4">
                <structure:Description>Ministry of Finance (Moldova)</structure:Description>
            </structure:Code>
            <structure:Code value="MG1">
                <structure:Description>INSTAT/Exchanges Commerciaux et des Services (Madagascar)</structure:Description>
            </structure:Code>
            <structure:Code value="MG2">

                <structure:Description>Banque Centrale de Madagascar</structure:Description>
            </structure:Code>
            <structure:Code value="MG4">
                <structure:Description>Ministere des finances de l`Economie (Madagascar)</structure:Description>
            </structure:Code>
            <structure:Code value="MH4">
                <structure:Description>Ministry of Finance (Marshall Islands, Rep)</structure:Description>

            </structure:Code>
            <structure:Code value="MK1">
                <structure:Description>State Statistical Office (Macedonia)</structure:Description>
            </structure:Code>
            <structure:Code value="MK2">
                <structure:Description>National Bank of the Republic of Macedonia</structure:Description>
            </structure:Code>
            <structure:Code value="MK4">

                <structure:Description>Ministry of Finance (Macedonia)</structure:Description>
            </structure:Code>
            <structure:Code value="ML1">
                <structure:Description>Direction Nationale de la Statistique et de l`Informatique (DNSI) (Mali)</structure:Description>
            </structure:Code>
            <structure:Code value="ML2">
                <structure:Description>Banque Centrale des Etats de l`Afrique de l`Ouest (BCEAO) (Mali)</structure:Description>

            </structure:Code>
            <structure:Code value="ML4">
                <structure:Description>Ministere des Finances et du Commerce (Mali)</structure:Description>
            </structure:Code>
            <structure:Code value="MM1">
                <structure:Description>Central Statistical Organization (Myanmar)</structure:Description>
            </structure:Code>
            <structure:Code value="MM2">

                <structure:Description>Central Bank of Myanmar</structure:Description>
            </structure:Code>
            <structure:Code value="MM4">
                <structure:Description>Ministry of Finance and Revenue (Myanmar)</structure:Description>
            </structure:Code>
            <structure:Code value="MN1">
                <structure:Description>National Statistical Office (Mongolia)</structure:Description>

            </structure:Code>
            <structure:Code value="MN2">
                <structure:Description>Bank of Mongolia</structure:Description>
            </structure:Code>
            <structure:Code value="MN4">
                <structure:Description>Ministry of Finance and Economy (Mongolia)</structure:Description>
            </structure:Code>
            <structure:Code value="MO1">

                <structure:Description>Statistics and Census Department (China, P.R. Macao)</structure:Description>
            </structure:Code>
            <structure:Code value="MO2">
                <structure:Description>Monetary Authority of Macau (China, P.R. Macao)</structure:Description>
            </structure:Code>
            <structure:Code value="MO4">
                <structure:Description>Departamento de Estudos e Planeamento Financeiro (China, P.R. Macao)</structure:Description>

            </structure:Code>
            <structure:Code value="MQ1">
                <structure:Description>Department of Statistics (Martinique)</structure:Description>
            </structure:Code>
            <structure:Code value="MR2">
                <structure:Description>Banque Centrale de Mauritanie</structure:Description>
            </structure:Code>
            <structure:Code value="MR3">

                <structure:Description>Ministere du Plan (Mauritania)</structure:Description>
            </structure:Code>
            <structure:Code value="MR4">
                <structure:Description>Ministere des Finances (Mauritania)</structure:Description>
            </structure:Code>
            <structure:Code value="MT1">
                <structure:Description>Malta - Central Office of Statistics</structure:Description>

            </structure:Code>
            <structure:Code value="MT2">
                <structure:Description>Central Bank of Malta</structure:Description>
            </structure:Code>
            <structure:Code value="MT4">
                <structure:Description>Ministry of Finance (Malta)</structure:Description>
            </structure:Code>
            <structure:Code value="MU1">

                <structure:Description>Central Statistical Office (Mauritius)</structure:Description>
            </structure:Code>
            <structure:Code value="MU2">
                <structure:Description>Bank of Mauritius</structure:Description>
            </structure:Code>
            <structure:Code value="MV2">
                <structure:Description>Maldives Monetary Authority (Maldives)</structure:Description>

            </structure:Code>
            <structure:Code value="MV4">
                <structure:Description>Ministry of Finance and Treasury (Maldives)</structure:Description>
            </structure:Code>
            <structure:Code value="MW1">
                <structure:Description>National Statistical Office (Malawi)</structure:Description>
            </structure:Code>
            <structure:Code value="MW2">

                <structure:Description>Reserve Bank of Malawi</structure:Description>
            </structure:Code>
            <structure:Code value="MW4">
                <structure:Description>Ministry of Finance (Malawi)</structure:Description>
            </structure:Code>
            <structure:Code value="MX1">
                <structure:Description>Instituto Nacional de Estadisticas (INEGI) (Mexico)</structure:Description>

            </structure:Code>
            <structure:Code value="MX2">
                <structure:Description>Banco de Mexico</structure:Description>
            </structure:Code>
            <structure:Code value="MX4">
                <structure:Description>Secretaria de Hacienda y Credito Publico (Mexico)</structure:Description>
            </structure:Code>
            <structure:Code value="MY1">

                <structure:Description>Department of Statistics Malaysia</structure:Description>
            </structure:Code>
            <structure:Code value="MY2">
                <structure:Description>Bank Negara Malaysia</structure:Description>
            </structure:Code>
            <structure:Code value="MZ1">
                <structure:Description>Direcçao Nacional de Estatistica (Mozambique)</structure:Description>

            </structure:Code>
            <structure:Code value="MZ2">
                <structure:Description>Banco de Moçambique</structure:Description>
            </structure:Code>
            <structure:Code value="MZ4">
                <structure:Description>Ministry of Planning and Finance (Mozambique)</structure:Description>
            </structure:Code>
            <structure:Code value="NA2">

                <structure:Description>Bank of Namibia</structure:Description>
            </structure:Code>
            <structure:Code value="NA4">
                <structure:Description>Ministry of Finance (Namibia)</structure:Description>
            </structure:Code>
            <structure:Code value="NC1">
                <structure:Description>Institut Territorial de la Statistique et des Etudes Economiques (New Caledonia)</structure:Description>

            </structure:Code>
            <structure:Code value="NE2">
                <structure:Description>Banque Centrale des Etats de l`Afrique de l`Ouest (BCEAO) (Niger)</structure:Description>
            </structure:Code>
            <structure:Code value="NE3">
                <structure:Description>Ministere du Plan (Niger)</structure:Description>
            </structure:Code>
            <structure:Code value="NE4">

                <structure:Description>Ministere des Finances (Niger)</structure:Description>
            </structure:Code>
            <structure:Code value="NG1">
                <structure:Description>Federal Office of Statistics (Nigeria)</structure:Description>
            </structure:Code>
            <structure:Code value="NG2">
                <structure:Description>Central Bank of Nigeria</structure:Description>

            </structure:Code>
            <structure:Code value="NG4">
                <structure:Description>Federal Ministry of Finance (Nigeria)</structure:Description>
            </structure:Code>
            <structure:Code value="NI2">
                <structure:Description>Banco Central de Nicaragua</structure:Description>
            </structure:Code>
            <structure:Code value="NI4">

                <structure:Description>Ministerio de Hacienda y Credito Publico (Nicaragua)</structure:Description>
            </structure:Code>
            <structure:Code value="NL1">
                <structure:Description>Central Bureau voor de Statistiek (Netherlands)</structure:Description>
            </structure:Code>
            <structure:Code value="NL2">
                <structure:Description>Nederlandse Bank (Netherlands)</structure:Description>

            </structure:Code>
            <structure:Code value="NL4">
                <structure:Description>Ministry of Finance (Netherlands)</structure:Description>
            </structure:Code>
            <structure:Code value="NO1">
                <structure:Description>Statistics Norway</structure:Description>
            </structure:Code>
            <structure:Code value="NO2">

                <structure:Description>Norges Bank (Norway)</structure:Description>
            </structure:Code>
            <structure:Code value="NP2">
                <structure:Description>Nepal Rastra Bank</structure:Description>
            </structure:Code>
            <structure:Code value="NP4">
                <structure:Description>Ministry of Finance (Nepal)</structure:Description>

            </structure:Code>
            <structure:Code value="NZ1">
                <structure:Description>Statistics New Zealand</structure:Description>
            </structure:Code>
            <structure:Code value="NZ2">
                <structure:Description>Reserve Bank of New Zealand</structure:Description>
            </structure:Code>
            <structure:Code value="OM2">

                <structure:Description>Central Bank of Oman</structure:Description>
            </structure:Code>
            <structure:Code value="OM4">
                <structure:Description>Ministry of Finance (Oman)</structure:Description>
            </structure:Code>
            <structure:Code value="PA2">
                <structure:Description>Banco Nacional de Panama</structure:Description>

            </structure:Code>
            <structure:Code value="PA3">
                <structure:Description>Office of the Controller General (Panama)</structure:Description>
            </structure:Code>
            <structure:Code value="PA6">
                <structure:Description>Superintendencia de Bancos (Panama)</structure:Description>
            </structure:Code>
            <structure:Code value="PE2">

                <structure:Description>Banco Central de Reserva del Peru</structure:Description>
            </structure:Code>
            <structure:Code value="PE4">
                <structure:Description>Ministerio de Economia y Finanzas (Peru)</structure:Description>
            </structure:Code>
            <structure:Code value="PG1">
                <structure:Description>National Statistical Office (Papua New Guinea)</structure:Description>

            </structure:Code>
            <structure:Code value="PG2">
                <structure:Description>Bank of Papua New Guinea</structure:Description>
            </structure:Code>
            <structure:Code value="PH2">
                <structure:Description>Central Bank of the Philippines</structure:Description>
            </structure:Code>
            <structure:Code value="PH3">

                <structure:Description>Bureau of the Treasury (Philippines)</structure:Description>
            </structure:Code>
            <structure:Code value="PK1">
                <structure:Description>Federal Bureau of Statistics (Pakistan)</structure:Description>
            </structure:Code>
            <structure:Code value="PK2">
                <structure:Description>State Bank of Pakistan</structure:Description>

            </structure:Code>
            <structure:Code value="PK4">
                <structure:Description>Ministry of Finance and Revenue (Pakistan)</structure:Description>
            </structure:Code>
            <structure:Code value="PL1">
                <structure:Description>Central Statistical Office of Poland</structure:Description>
            </structure:Code>
            <structure:Code value="PL2">

                <structure:Description>Bank of Poland</structure:Description>
            </structure:Code>
            <structure:Code value="PL4">
                <structure:Description>Ministry of Finance (Poland)</structure:Description>
            </structure:Code>
            <structure:Code value="PS1">
                <structure:Description>Palestinian Central Bureau of Statistics</structure:Description>

            </structure:Code>
            <structure:Code value="PS2">
                <structure:Description>Palestine Monetary Authority</structure:Description>
            </structure:Code>
            <structure:Code value="PT1">
                <structure:Description>Instituto Nacional de Estatística (Portugal)</structure:Description>
            </structure:Code>
            <structure:Code value="PT2">

                <structure:Description>Banco de Portugal (Portugal)</structure:Description>
            </structure:Code>
            <structure:Code value="PT3">
                <structure:Description>Direccao Geral do Orçamento (DGO) (Portugal)</structure:Description>
            </structure:Code>
            <structure:Code value="PY2">
                <structure:Description>Banco Central del Paraguay</structure:Description>

            </structure:Code>
            <structure:Code value="PY4">
                <structure:Description>Ministerio de Hacienda (Paraguay)</structure:Description>
            </structure:Code>
            <structure:Code value="QA2">
                <structure:Description>Qatar Central Bank</structure:Description>
            </structure:Code>
            <structure:Code value="QA4">

                <structure:Description>Ministry of Finance, Economy and Commerce (Qatar)</structure:Description>
            </structure:Code>
            <structure:Code value="RO1">
                <structure:Description>Romania, National Commission for Statistics</structure:Description>
            </structure:Code>
            <structure:Code value="RO2">
                <structure:Description>National Bank of Romania</structure:Description>

            </structure:Code>
            <structure:Code value="RO4">
                <structure:Description>Ministere des Finances Public (Romania)</structure:Description>
            </structure:Code>
            <structure:Code value="RU1">
                <structure:Description>State Committee of the Russian Federation on Statistics</structure:Description>
            </structure:Code>
            <structure:Code value="RU2">

                <structure:Description>Central Bank of Russian Federation</structure:Description>
            </structure:Code>
            <structure:Code value="RU3">
                <structure:Description>State Customs Committee of the Russian Federation</structure:Description>
            </structure:Code>
            <structure:Code value="RU4">
                <structure:Description>Ministry of Finance (Russian Federation)</structure:Description>

            </structure:Code>
            <structure:Code value="RW2">
                <structure:Description>Banque Nationale Du Rwanda</structure:Description>
            </structure:Code>
            <structure:Code value="RW4">
                <structure:Description>Ministere des Finances et Planification Economie (Rwanda)</structure:Description>
            </structure:Code>
            <structure:Code value="SA1">

                <structure:Description>Central Department of Statistics (Saudi Arabia)</structure:Description>
            </structure:Code>
            <structure:Code value="SA2">
                <structure:Description>Saudi Arabian Monetary Agency</structure:Description>
            </structure:Code>
            <structure:Code value="SA4">
                <structure:Description>Ministry of Finance (Saudi Arabia)</structure:Description>

            </structure:Code>
            <structure:Code value="SB2">
                <structure:Description>Central Bank of Solomon Islands</structure:Description>
            </structure:Code>
            <structure:Code value="SB4">
                <structure:Description>Ministry of Finance and Treasury (Solomon Islands)</structure:Description>
            </structure:Code>
            <structure:Code value="SC2">

                <structure:Description>Central Bank of Seychelles</structure:Description>
            </structure:Code>
            <structure:Code value="SC4">
                <structure:Description>Ministry of Finance (Seychelles)</structure:Description>
            </structure:Code>
            <structure:Code value="SD1">
                <structure:Description>Central Bureau of Statistics (Sudan)</structure:Description>

            </structure:Code>
            <structure:Code value="SD2">
                <structure:Description>Bank of Sudan</structure:Description>
            </structure:Code>
            <structure:Code value="SD4">
                <structure:Description>Ministry of Finance and National Economy (Sudan)</structure:Description>
            </structure:Code>
            <structure:Code value="SE1">

                <structure:Description>Statistics Sweden (Sweden)</structure:Description>
            </structure:Code>
            <structure:Code value="SE2">
                <structure:Description>Sveriges Riksbank (Sweden)</structure:Description>
            </structure:Code>
            <structure:Code value="SE3">
                <structure:Description>Sika Swedish Institute for Transport and Communications Analysis</structure:Description>

            </structure:Code>
            <structure:Code value="SE4">
                <structure:Description>Banverket (National Rail Administration) Sweden</structure:Description>
            </structure:Code>
            <structure:Code value="SG1">
                <structure:Description>Ministry of Trade and Industry / Department of Statistics (Singapore)</structure:Description>
            </structure:Code>
            <structure:Code value="SG2">

                <structure:Description>Monetary Authority of Singapore</structure:Description>
            </structure:Code>
            <structure:Code value="SG3">
                <structure:Description>International Enterprise Singapore</structure:Description>
            </structure:Code>
            <structure:Code value="SG4">
                <structure:Description>Ministry of Finance (Singapore)</structure:Description>

            </structure:Code>
            <structure:Code value="SI1">
                <structure:Description>Statistical Office of the Republic of Slovenia</structure:Description>
            </structure:Code>
            <structure:Code value="SI2">
                <structure:Description>Bank of Slovenia</structure:Description>
            </structure:Code>
            <structure:Code value="SI4">

                <structure:Description>Ministry of Finance (Slovenia)</structure:Description>
            </structure:Code>
            <structure:Code value="SK1">
                <structure:Description>Statistical Office of the Slovak Republic</structure:Description>
            </structure:Code>
            <structure:Code value="SK2">
                <structure:Description>National Bank of Slovakia</structure:Description>

            </structure:Code>
            <structure:Code value="SK4">
                <structure:Description>Ministry of Finance of the Slovak Republic</structure:Description>
            </structure:Code>
            <structure:Code value="SL2">
                <structure:Description>Bank of Sierra Leone</structure:Description>
            </structure:Code>
            <structure:Code value="SM2">

                <structure:Description>Instituto di Credito Sammarinese / Central Bank (San Marino)</structure:Description>
            </structure:Code>
            <structure:Code value="SM4">
                <structure:Description>Ministry of Finance and Budget (San Marino)</structure:Description>
            </structure:Code>
            <structure:Code value="SN1">
                <structure:Description>Direction de la Prevision et de la Statistique (Senegal)</structure:Description>

            </structure:Code>
            <structure:Code value="SN2">
                <structure:Description>Banque Centrale des Etats de l`Afrique de l`Ouest (BCEAO) (Senegal)</structure:Description>
            </structure:Code>
            <structure:Code value="SN4">
                <structure:Description>Ministere de l`Economie et des Finances (Senegal)</structure:Description>
            </structure:Code>
            <structure:Code value="SO2">

                <structure:Description>Central Bank of Somalia</structure:Description>
            </structure:Code>
            <structure:Code value="SR1">
                <structure:Description>General Bureau of Statistics (Suriname)</structure:Description>
            </structure:Code>
            <structure:Code value="SR2">
                <structure:Description>Centrale Bank van Suriname</structure:Description>

            </structure:Code>
            <structure:Code value="SR4">
                <structure:Description>Ministry of Finance (Suriname)</structure:Description>
            </structure:Code>
            <structure:Code value="ST2">
                <structure:Description>Banco Central de Sao Tome e Principe</structure:Description>
            </structure:Code>
            <structure:Code value="ST4">

                <structure:Description>Ministry of Planning and Financing (Sao Tome and Principe)</structure:Description>
            </structure:Code>
            <structure:Code value="SV2">
                <structure:Description>Banco Central de Reserva de El Salvador</structure:Description>
            </structure:Code>
            <structure:Code value="SV4">
                <structure:Description>Ministerio de Hacienda (El Salvador)</structure:Description>

            </structure:Code>
            <structure:Code value="SY1">
                <structure:Description>Central Bureau of Statistics (Syria Arab Rep.)</structure:Description>
            </structure:Code>
            <structure:Code value="SY2">
                <structure:Description>Central Bank of Syria</structure:Description>
            </structure:Code>
            <structure:Code value="SY4">

                <structure:Description>Ministry of Finance (Syrian Arab Rep.)</structure:Description>
            </structure:Code>
            <structure:Code value="SZ2">
                <structure:Description>Central Bank of Swaziland</structure:Description>
            </structure:Code>
            <structure:Code value="SZ4">
                <structure:Description>Ministry of Finance (Swaziland)</structure:Description>

            </structure:Code>
            <structure:Code value="TD1">
                <structure:Description>Institut de la Statistique (INSDEE) (Chad)</structure:Description>
            </structure:Code>
            <structure:Code value="TD2">
                <structure:Description>Banque des Etats de l`Afrique Centrale (BEAC) (Chad)</structure:Description>
            </structure:Code>
            <structure:Code value="TD4">

                <structure:Description>Ministere des finances (Chad)</structure:Description>
            </structure:Code>
            <structure:Code value="TG2">
                <structure:Description>Banque Centrale des Etats de l`Afrique de l`Ouest (BCEAO) (Togo)</structure:Description>
            </structure:Code>
            <structure:Code value="TG3">
                <structure:Description>Ministere du Plan (Togo)</structure:Description>

            </structure:Code>
            <structure:Code value="TG4">
                <structure:Description>Ministere de l`Economie des Finances (Togo)</structure:Description>
            </structure:Code>
            <structure:Code value="TH2">
                <structure:Description>Bank of Thailand</structure:Description>
            </structure:Code>
            <structure:Code value="TH4">

                <structure:Description>Ministry of Finance (Thailand)</structure:Description>
            </structure:Code>
            <structure:Code value="TJ1">
                <structure:Description>State Statistical Agency of Tajikistan</structure:Description>
            </structure:Code>
            <structure:Code value="TJ2">
                <structure:Description>National Bank of Tajikistan</structure:Description>

            </structure:Code>
            <structure:Code value="TJ4">
                <structure:Description>Ministry of Finance (Tajikistan)</structure:Description>
            </structure:Code>
            <structure:Code value="TM1">
                <structure:Description>National Institute of State Statistics and Information (Turkmenistan)</structure:Description>
            </structure:Code>
            <structure:Code value="TM2">

                <structure:Description>Central Bank of Turkmenistan</structure:Description>
            </structure:Code>
            <structure:Code value="TM4">
                <structure:Description>Ministry of Economy and Finance (Turkmenistan)</structure:Description>
            </structure:Code>
            <structure:Code value="TN2">
                <structure:Description>Banque centrale de Tunisie</structure:Description>

            </structure:Code>
            <structure:Code value="TN4">
                <structure:Description>Ministere des Finances (Tunisia)</structure:Description>
            </structure:Code>
            <structure:Code value="TO1">
                <structure:Description>Statistics Department (Tongo)</structure:Description>
            </structure:Code>
            <structure:Code value="TO2">

                <structure:Description>National Reserve Bank of Tonga</structure:Description>
            </structure:Code>
            <structure:Code value="TO4">
                <structure:Description>Ministry of Finance (Tongo)</structure:Description>
            </structure:Code>
            <structure:Code value="TR1">
                <structure:Description>State Institute of Statistics (Turkey)</structure:Description>

            </structure:Code>
            <structure:Code value="TR2">
                <structure:Description>Central Bank of the Republic of Turkey</structure:Description>
            </structure:Code>
            <structure:Code value="TR3">
                <structure:Description>Hazine Müstesarligi (Turkish Treasury)</structure:Description>
            </structure:Code>
            <structure:Code value="TST">

                <structure:Description>Internal ECB recipient for automatic and filtered mapping ECB to BIS series keys of data files sent to ESCB</structure:Description>
            </structure:Code>
            <structure:Code value="TT2">
                <structure:Description>Central Bank of Trinidad and Tobago</structure:Description>
            </structure:Code>
            <structure:Code value="TT4">
                <structure:Description>Ministry of Finance (Trinidad and Tobago)</structure:Description>

            </structure:Code>
            <structure:Code value="TW2">
                <structure:Description>Central Bank of China, Taipei</structure:Description>
            </structure:Code>
            <structure:Code value="TZ1">
                <structure:Description>Central Statistical Bureau (Tanzania)</structure:Description>
            </structure:Code>
            <structure:Code value="TZ2">

                <structure:Description>Bank of Tanzania</structure:Description>
            </structure:Code>
            <structure:Code value="TZ4">
                <structure:Description>Ministry of Finance (Tanzania)</structure:Description>
            </structure:Code>
            <structure:Code value="U22">
                <structure:Description>Central banks belonging to the Euro area</structure:Description>

            </structure:Code>
            <structure:Code value="U32">
                <structure:Description>EU central banks not belonging to the Euro area</structure:Description>
            </structure:Code>
            <structure:Code value="UA1">
                <structure:Description>State Statistics Committee of Ukraine</structure:Description>
            </structure:Code>
            <structure:Code value="UA2">

                <structure:Description>National Bank of Ukraine</structure:Description>
            </structure:Code>
            <structure:Code value="UA4">
                <structure:Description>Ministry of Finance (Ukraine)</structure:Description>
            </structure:Code>
            <structure:Code value="UG1">
                <structure:Description>Uganda Bureau of Statistics</structure:Description>

            </structure:Code>
            <structure:Code value="UG2">
                <structure:Description>Bank of Uganda</structure:Description>
            </structure:Code>
            <structure:Code value="UG4">
                <structure:Description>Ministry of Finance, Planning and Economic Development (Uganda)</structure:Description>
            </structure:Code>
            <structure:Code value="US2">

                <structure:Description>Federal Reserve Bank of New York (USA)</structure:Description>
            </structure:Code>
            <structure:Code value="US3">
                <structure:Description>Board of Governors of the Federal Reserve System (USA)</structure:Description>
            </structure:Code>
            <structure:Code value="US4">
                <structure:Description>U.S. Department of Treasury (USA)</structure:Description>

            </structure:Code>
            <structure:Code value="US5">
                <structure:Description>U.S. Department of Commerce (USA)</structure:Description>
            </structure:Code>
            <structure:Code value="UY2">
                <structure:Description>Banco Central del Uruguay</structure:Description>
            </structure:Code>
            <structure:Code value="UY4">

                <structure:Description>Ministerio de Economia y Finanzas (Uruguay)</structure:Description>
            </structure:Code>
            <structure:Code value="UZ1">
                <structure:Description>Goskomprognozstat (Uzbekistan)</structure:Description>
            </structure:Code>
            <structure:Code value="UZ3">
                <structure:Description>Ministry of Economy (Uzbekistan)</structure:Description>

            </structure:Code>
            <structure:Code value="UZ4">
                <structure:Description>Ministry of Finance (Uzbekistan)</structure:Description>
            </structure:Code>
            <structure:Code value="V12">
                <structure:Description>EU 27 central banks</structure:Description>
            </structure:Code>
            <structure:Code value="VC2">

                <structure:Description>Eastern Caribbean Central Bank (ECCB) (St. Vincent and Grenadines)</structure:Description>
            </structure:Code>
            <structure:Code value="VC4">
                <structure:Description>Ministry of Finance and Planning (St. Vincent and the Grenadines)</structure:Description>
            </structure:Code>
            <structure:Code value="VE2">
                <structure:Description>Banco Central de Venezuela</structure:Description>

            </structure:Code>
            <structure:Code value="VE4">
                <structure:Description>Ministerio de Finanzas (Venezuela)</structure:Description>
            </structure:Code>
            <structure:Code value="VN1">
                <structure:Description>General Statistics Office (Vietnam)</structure:Description>
            </structure:Code>
            <structure:Code value="VN2">

                <structure:Description>State Bank of Vietnam</structure:Description>
            </structure:Code>
            <structure:Code value="VU1">
                <structure:Description>Statistical Office (Vanuatu)</structure:Description>
            </structure:Code>
            <structure:Code value="VU2">
                <structure:Description>Reserve Bank of Vanuatu</structure:Description>

            </structure:Code>
            <structure:Code value="VU4">
                <structure:Description>Ministry of Finance and Economic Management (Vanuatu)</structure:Description>
            </structure:Code>
            <structure:Code value="WS1">
                <structure:Description>Department of Statistics (Samoa)</structure:Description>
            </structure:Code>
            <structure:Code value="WS2">

                <structure:Description>Central Bank of Samoa</structure:Description>
            </structure:Code>
            <structure:Code value="WS4">
                <structure:Description>Samoa Treasury Department</structure:Description>
            </structure:Code>
            <structure:Code value="YE1">
                <structure:Description>Central Statistical Organization (Yemen)</structure:Description>

            </structure:Code>
            <structure:Code value="YE2">
                <structure:Description>Central Bank of Yemen</structure:Description>
            </structure:Code>
            <structure:Code value="YE4">
                <structure:Description>Ministry of Finance (Yemen)</structure:Description>
            </structure:Code>
            <structure:Code value="ZA1">

                <structure:Description>South African Reserve Service</structure:Description>
            </structure:Code>
            <structure:Code value="ZA2">
                <structure:Description>South African Reserve Bank</structure:Description>
            </structure:Code>
            <structure:Code value="ZM1">
                <structure:Description>Central Statistical Office (Zambia)</structure:Description>

            </structure:Code>
            <structure:Code value="ZM2">
                <structure:Description>Bank of Zambia</structure:Description>
            </structure:Code>
            <structure:Code value="ZW1">
                <structure:Description>Central Statistical Office (Zimbabwe)</structure:Description>
            </structure:Code>
            <structure:Code value="ZW2">

                <structure:Description>Reserve Bank of Zimbabwe</structure:Description>
            </structure:Code>
            <structure:Code value="ZW4">
                <structure:Description>Ministry of Finance, Economic Planning and Development (Zimbabwe)</structure:Description>
            </structure:Code>
            <structure:Code value="ZZZ">
                <structure:Description>Unspecified (e.g. any, dissemination, internal exchange etc)</structure:Description>

            </structure:Code>
        </structure:CodeList>
        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_UNIT">
            <structure:Name>Unit code list</structure:Name>
            <structure:Code value="ADF">
                <structure:Description>Andorran franc (1-1 peg to the French franc)</structure:Description>
            </structure:Code>
            <structure:Code value="ADP">

                <structure:Description>Andorran peseta (1-1 peg to the Spanish peseta)</structure:Description>
            </structure:Code>
            <structure:Code value="AED">
                <structure:Description>United Arab Emirates dirham</structure:Description>
            </structure:Code>
            <structure:Code value="AFA">
                <structure:Description>Afghanistan afghani (old)</structure:Description>

            </structure:Code>
            <structure:Code value="AFN">
                <structure:Description>Afghanistan, Afghanis</structure:Description>
            </structure:Code>
            <structure:Code value="ALL">
                <structure:Description>Albanian lek</structure:Description>
            </structure:Code>
            <structure:Code value="AMD">

                <structure:Description>Armenian dram</structure:Description>
            </structure:Code>
            <structure:Code value="ANG">
                <structure:Description>Netherlands Antillean guilder</structure:Description>
            </structure:Code>
            <structure:Code value="AOA">
                <structure:Description>Angolan kwanza</structure:Description>

            </structure:Code>
            <structure:Code value="AON">
                <structure:Description>Angolan kwanza (old)</structure:Description>
            </structure:Code>
            <structure:Code value="AOR">
                <structure:Description>Angolan kwanza readjustado</structure:Description>
            </structure:Code>
            <structure:Code value="ARS">

                <structure:Description>Argentine peso</structure:Description>
            </structure:Code>
            <structure:Code value="ATS">
                <structure:Description>Austrian schilling</structure:Description>
            </structure:Code>
            <structure:Code value="AUD">
                <structure:Description>Australian dollar</structure:Description>

            </structure:Code>
            <structure:Code value="AWG">
                <structure:Description>Aruban florin/guilder</structure:Description>
            </structure:Code>
            <structure:Code value="AZM">
                <structure:Description>Azerbaijanian manat (old)</structure:Description>
            </structure:Code>
            <structure:Code value="AZN">

                <structure:Description>Azerbaijan, manats</structure:Description>
            </structure:Code>
            <structure:Code value="BAM">
                <structure:Description>Bosnia-Hezergovinian convertible mark</structure:Description>
            </structure:Code>
            <structure:Code value="BBD">
                <structure:Description>Barbados dollar</structure:Description>

            </structure:Code>
            <structure:Code value="BDT">
                <structure:Description>Bangladesh taka</structure:Description>
            </structure:Code>
            <structure:Code value="BEF">
                <structure:Description>Belgian franc</structure:Description>
            </structure:Code>
            <structure:Code value="BEL">

                <structure:Description>Belgian franc (financial)</structure:Description>
            </structure:Code>
            <structure:Code value="BGL">
                <structure:Description>Bulgarian lev (old)</structure:Description>
            </structure:Code>
            <structure:Code value="BGN">
                <structure:Description>Bulgarian lev</structure:Description>

            </structure:Code>
            <structure:Code value="BHD">
                <structure:Description>Bahraini dinar</structure:Description>
            </structure:Code>
            <structure:Code value="BIF">
                <structure:Description>Burundi franc</structure:Description>
            </structure:Code>
            <structure:Code value="BMD">

                <structure:Description>Bermudian dollar</structure:Description>
            </structure:Code>
            <structure:Code value="BND">
                <structure:Description>Brunei dollar</structure:Description>
            </structure:Code>
            <structure:Code value="BOB">
                <structure:Description>Bolivian boliviano</structure:Description>

            </structure:Code>
            <structure:Code value="BRL">
                <structure:Description>Brazilian real</structure:Description>
            </structure:Code>
            <structure:Code value="BSD">
                <structure:Description>Bahamas dollar</structure:Description>
            </structure:Code>
            <structure:Code value="BTN">

                <structure:Description>Bhutan ngultrum</structure:Description>
            </structure:Code>
            <structure:Code value="BWP">
                <structure:Description>Botswana pula</structure:Description>
            </structure:Code>
            <structure:Code value="BYB">
                <structure:Description>Belarussian rouble (old)</structure:Description>

            </structure:Code>
            <structure:Code value="BYR">
                <structure:Description>Belarus, Rubles</structure:Description>
            </structure:Code>
            <structure:Code value="BZD">
                <structure:Description>Belize dollar</structure:Description>
            </structure:Code>
            <structure:Code value="CAD">

                <structure:Description>Canadian dollar</structure:Description>
            </structure:Code>
            <structure:Code value="CDF">
                <structure:Description>Congo franc (ex Zaire)</structure:Description>
            </structure:Code>
            <structure:Code value="CHF">
                <structure:Description>Swiss franc</structure:Description>

            </structure:Code>
            <structure:Code value="CLP">
                <structure:Description>Chilean peso</structure:Description>
            </structure:Code>
            <structure:Code value="CNY">
                <structure:Description>Chinese yuan renminbi</structure:Description>
            </structure:Code>
            <structure:Code value="COP">

                <structure:Description>Colombian peso</structure:Description>
            </structure:Code>
            <structure:Code value="CRC">
                <structure:Description>Costa Rican colon</structure:Description>
            </structure:Code>
            <structure:Code value="CSD">
                <structure:Description>Serbian dinar</structure:Description>

            </structure:Code>
            <structure:Code value="CUP">
                <structure:Description>Cuban peso</structure:Description>
            </structure:Code>
            <structure:Code value="CVE">
                <structure:Description>Cape Verde escudo</structure:Description>
            </structure:Code>
            <structure:Code value="CYP">

                <structure:Description>Cypriot pound</structure:Description>
            </structure:Code>
            <structure:Code value="CZK">
                <structure:Description>Czech koruna</structure:Description>
            </structure:Code>
            <structure:Code value="DAYS">
                <structure:Description>Days</structure:Description>

            </structure:Code>
            <structure:Code value="DEM">
                <structure:Description>German mark</structure:Description>
            </structure:Code>
            <structure:Code value="DJF">
                <structure:Description>Djibouti franc</structure:Description>
            </structure:Code>
            <structure:Code value="DKK">

                <structure:Description>Danish krone</structure:Description>
            </structure:Code>
            <structure:Code value="DOP">
                <structure:Description>Dominican peso</structure:Description>
            </structure:Code>
            <structure:Code value="DZD">
                <structure:Description>Algerian dinar</structure:Description>

            </structure:Code>
            <structure:Code value="ECS">
                <structure:Description>Ecuador sucre</structure:Description>
            </structure:Code>
            <structure:Code value="EEK">
                <structure:Description>Estonian kroon</structure:Description>
            </structure:Code>
            <structure:Code value="EGP">

                <structure:Description>Egyptian pound</structure:Description>
            </structure:Code>
            <structure:Code value="ERN">
                <structure:Description>Erytrean nafka</structure:Description>
            </structure:Code>
            <structure:Code value="ESP">
                <structure:Description>Spanish peseta</structure:Description>

            </structure:Code>
            <structure:Code value="ETB">
                <structure:Description>Ethiopian birr</structure:Description>
            </structure:Code>
            <structure:Code value="EUR">
                <structure:Description>Euro</structure:Description>
            </structure:Code>
            <structure:Code value="FIM">

                <structure:Description>Finnish markka</structure:Description>
            </structure:Code>
            <structure:Code value="FJD">
                <structure:Description>Fiji dollar</structure:Description>
            </structure:Code>
            <structure:Code value="FKP">
                <structure:Description>Falkland Islands pound</structure:Description>

            </structure:Code>
            <structure:Code value="FRF">
                <structure:Description>French franc</structure:Description>
            </structure:Code>
            <structure:Code value="GBP">
                <structure:Description>UK pound sterling</structure:Description>
            </structure:Code>
            <structure:Code value="GEL">

                <structure:Description>Georgian lari</structure:Description>
            </structure:Code>
            <structure:Code value="GGP">
                <structure:Description>Guernsey, Pounds</structure:Description>
            </structure:Code>
            <structure:Code value="GHC">
                <structure:Description>Ghana Cedi (old)</structure:Description>

            </structure:Code>
            <structure:Code value="GHS">
                <structure:Description>Ghana Cedi</structure:Description>
            </structure:Code>
            <structure:Code value="GIP">
                <structure:Description>Gibraltar pound</structure:Description>
            </structure:Code>
            <structure:Code value="GMD">

                <structure:Description>Gambian dalasi</structure:Description>
            </structure:Code>
            <structure:Code value="GNF">
                <structure:Description>Guinea franc</structure:Description>
            </structure:Code>
            <structure:Code value="GRD">
                <structure:Description>Greek drachma</structure:Description>

            </structure:Code>
            <structure:Code value="GTQ">
                <structure:Description>Guatemalan quetzal</structure:Description>
            </structure:Code>
            <structure:Code value="GYD">
                <structure:Description>Guyanan dollar</structure:Description>
            </structure:Code>
            <structure:Code value="HKD">

                <structure:Description>Hong Kong dollar</structure:Description>
            </structure:Code>
            <structure:Code value="HKQ">
                <structure:Description>Hong Kong dollar (old)</structure:Description>
            </structure:Code>
            <structure:Code value="HNL">
                <structure:Description>Honduran lempira</structure:Description>

            </structure:Code>
            <structure:Code value="HOURS">
                <structure:Description>Hours</structure:Description>
            </structure:Code>
            <structure:Code value="HRK">
                <structure:Description>Croatian kuna</structure:Description>
            </structure:Code>
            <structure:Code value="HTG">

                <structure:Description>Haitian gourde</structure:Description>
            </structure:Code>
            <structure:Code value="HUF">
                <structure:Description>Hungarian forint</structure:Description>
            </structure:Code>
            <structure:Code value="IDR">
                <structure:Description>Indonesian rupiah</structure:Description>

            </structure:Code>
            <structure:Code value="IEP">
                <structure:Description>Irish pound</structure:Description>
            </structure:Code>
            <structure:Code value="ILS">
                <structure:Description>Israeli shekel</structure:Description>
            </structure:Code>
            <structure:Code value="IMP">

                <structure:Description>Isle of Man, Pounds</structure:Description>
            </structure:Code>
            <structure:Code value="INR">
                <structure:Description>Indian rupee</structure:Description>
            </structure:Code>
            <structure:Code value="IQD">
                <structure:Description>Iraqi dinar</structure:Description>

            </structure:Code>
            <structure:Code value="IRR">
                <structure:Description>Iranian rial</structure:Description>
            </structure:Code>
            <structure:Code value="ISK">
                <structure:Description>Iceland krona</structure:Description>
            </structure:Code>
            <structure:Code value="ITL">

                <structure:Description>Italian lira</structure:Description>
            </structure:Code>
            <structure:Code value="JEP">
                <structure:Description>Jersey, Pounds</structure:Description>
            </structure:Code>
            <structure:Code value="JMD">
                <structure:Description>Jamaican dollar</structure:Description>

            </structure:Code>
            <structure:Code value="JOD">
                <structure:Description>Jordanian dinar</structure:Description>
            </structure:Code>
            <structure:Code value="JPY">
                <structure:Description>Japanese yen</structure:Description>
            </structure:Code>
            <structure:Code value="KES">

                <structure:Description>Kenyan shilling</structure:Description>
            </structure:Code>
            <structure:Code value="KGS">
                <structure:Description>Kyrgyzstan som</structure:Description>
            </structure:Code>
            <structure:Code value="KHR">
                <structure:Description>Kampuchean real (Cambodian)</structure:Description>

            </structure:Code>
            <structure:Code value="KILO">
                <structure:Description>Kilograms</structure:Description>
            </structure:Code>
            <structure:Code value="KLITRE">
                <structure:Description>Kilolitres</structure:Description>
            </structure:Code>
            <structure:Code value="KMF">

                <structure:Description>Comoros franc</structure:Description>
            </structure:Code>
            <structure:Code value="KPW">
                <structure:Description>Korean won (North)</structure:Description>
            </structure:Code>
            <structure:Code value="KRW">
                <structure:Description>Korean won (Republic)</structure:Description>

            </structure:Code>
            <structure:Code value="KWD">
                <structure:Description>Kuwait dinar</structure:Description>
            </structure:Code>
            <structure:Code value="KYD">
                <structure:Description>Cayman Islands dollar</structure:Description>
            </structure:Code>
            <structure:Code value="KZT">

                <structure:Description>Kazakstan tenge</structure:Description>
            </structure:Code>
            <structure:Code value="LAK">
                <structure:Description>Lao kip</structure:Description>
            </structure:Code>
            <structure:Code value="LBP">
                <structure:Description>Lebanese pound</structure:Description>

            </structure:Code>
            <structure:Code value="LITRES">
                <structure:Description>Litres</structure:Description>
            </structure:Code>
            <structure:Code value="LKR">
                <structure:Description>Sri Lanka rupee</structure:Description>
            </structure:Code>
            <structure:Code value="LRD">

                <structure:Description>Liberian dollar</structure:Description>
            </structure:Code>
            <structure:Code value="LSL">
                <structure:Description>Lesotho loti</structure:Description>
            </structure:Code>
            <structure:Code value="LTL">
                <structure:Description>Lithuanian litas</structure:Description>

            </structure:Code>
            <structure:Code value="LUF">
                <structure:Description>Luxembourg franc</structure:Description>
            </structure:Code>
            <structure:Code value="LVL">
                <structure:Description>Latvian lats</structure:Description>
            </structure:Code>
            <structure:Code value="LYD">

                <structure:Description>Libyan dinar</structure:Description>
            </structure:Code>
            <structure:Code value="MAD">
                <structure:Description>Moroccan dirham</structure:Description>
            </structure:Code>
            <structure:Code value="MAN-DY">
                <structure:Description>Man Days</structure:Description>

            </structure:Code>
            <structure:Code value="MAN-YR">
                <structure:Description>Man Years</structure:Description>
            </structure:Code>
            <structure:Code value="MDL">
                <structure:Description>Moldovian leu</structure:Description>
            </structure:Code>
            <structure:Code value="MGA">

                <structure:Description>Madagascar, Ariary</structure:Description>
            </structure:Code>
            <structure:Code value="MGF">
                <structure:Description>Malagasy franc</structure:Description>
            </structure:Code>
            <structure:Code value="MKD">
                <structure:Description>Macedonian denar</structure:Description>

            </structure:Code>
            <structure:Code value="MMK">
                <structure:Description>Myanmar kyat</structure:Description>
            </structure:Code>
            <structure:Code value="MNT">
                <structure:Description>Mongolian tugrik</structure:Description>
            </structure:Code>
            <structure:Code value="MONTHS">

                <structure:Description>Months</structure:Description>
            </structure:Code>
            <structure:Code value="MOP">
                <structure:Description>Macau pataca</structure:Description>
            </structure:Code>
            <structure:Code value="MRO">
                <structure:Description>Mauritanian ouguiya</structure:Description>

            </structure:Code>
            <structure:Code value="MTL">
                <structure:Description>Maltese lira</structure:Description>
            </structure:Code>
            <structure:Code value="MUR">
                <structure:Description>Mauritius rupee</structure:Description>
            </structure:Code>
            <structure:Code value="MVR">

                <structure:Description>Maldive rufiyaa</structure:Description>
            </structure:Code>
            <structure:Code value="MWK">
                <structure:Description>Malawi kwacha</structure:Description>
            </structure:Code>
            <structure:Code value="MXN">
                <structure:Description>Mexican peso</structure:Description>

            </structure:Code>
            <structure:Code value="MXP">
                <structure:Description>Mexican peso (old)</structure:Description>
            </structure:Code>
            <structure:Code value="MYR">
                <structure:Description>Malaysian ringgit</structure:Description>
            </structure:Code>
            <structure:Code value="MZM">

                <structure:Description>Mozambique metical (old)</structure:Description>
            </structure:Code>
            <structure:Code value="MZN">
                <structure:Description>Mozambique, Meticais</structure:Description>
            </structure:Code>
            <structure:Code value="NAD">
                <structure:Description>Namibian dollar</structure:Description>

            </structure:Code>
            <structure:Code value="NATCUR">
                <structure:Description>National currency</structure:Description>
            </structure:Code>
            <structure:Code value="NGN">
                <structure:Description>Nigerian naira</structure:Description>
            </structure:Code>
            <structure:Code value="NIO">

                <structure:Description>Nicaraguan cordoba</structure:Description>
            </structure:Code>
            <structure:Code value="NLG">
                <structure:Description>Netherlands guilder</structure:Description>
            </structure:Code>
            <structure:Code value="NOK">
                <structure:Description>Norwegian krone</structure:Description>

            </structure:Code>
            <structure:Code value="NPR">
                <structure:Description>Nepaleese rupee</structure:Description>
            </structure:Code>
            <structure:Code value="NZD">
                <structure:Description>New Zealand dollar</structure:Description>
            </structure:Code>
            <structure:Code value="OMR">

                <structure:Description>Oman Sul rial</structure:Description>
            </structure:Code>
            <structure:Code value="OUNCES">
                <structure:Description>Ounces</structure:Description>
            </structure:Code>
            <structure:Code value="PAB">
                <structure:Description>Panama balboa</structure:Description>

            </structure:Code>
            <structure:Code value="PC">
                <structure:Description>Percent</structure:Description>
            </structure:Code>
            <structure:Code value="PCCH">
                <structure:Description>Percentage change</structure:Description>
            </structure:Code>
            <structure:Code value="PCPA">

                <structure:Description>Percent per annum</structure:Description>
            </structure:Code>
            <structure:Code value="PCT">
                <structure:Description>Percentage change (code value to be discontinued)</structure:Description>
            </structure:Code>
            <structure:Code value="PEN">
                <structure:Description>Peru nuevo sol</structure:Description>

            </structure:Code>
            <structure:Code value="PERS">
                <structure:Description>Persons</structure:Description>
            </structure:Code>
            <structure:Code value="PGK">
                <structure:Description>Papua New Guinea kina</structure:Description>
            </structure:Code>
            <structure:Code value="PHP">

                <structure:Description>Philippine peso</structure:Description>
            </structure:Code>
            <structure:Code value="PKR">
                <structure:Description>Pakistan rupee</structure:Description>
            </structure:Code>
            <structure:Code value="PLN">
                <structure:Description>Polish zloty</structure:Description>

            </structure:Code>
            <structure:Code value="PLZ">
                <structure:Description>Polish zloty (old)</structure:Description>
            </structure:Code>
            <structure:Code value="PM">
                <structure:Description>Per thousand</structure:Description>
            </structure:Code>
            <structure:Code value="POINTS">

                <structure:Description>Points</structure:Description>
            </structure:Code>
            <structure:Code value="PTE">
                <structure:Description>Portugese escudo</structure:Description>
            </structure:Code>
            <structure:Code value="PURE_NUMB">
                <structure:Description>Pure number</structure:Description>

            </structure:Code>
            <structure:Code value="PYG">
                <structure:Description>Paraguay guarani</structure:Description>
            </structure:Code>
            <structure:Code value="QAR">
                <structure:Description>Qatari rial</structure:Description>
            </structure:Code>
            <structure:Code value="ROL">

                <structure:Description>Romanian leu (old)</structure:Description>
            </structure:Code>
            <structure:Code value="RON">
                <structure:Description>Romanian leu</structure:Description>
            </structure:Code>
            <structure:Code value="RSD">
                <structure:Description>Serbian dinar</structure:Description>

            </structure:Code>
            <structure:Code value="RUB">
                <structure:Description>Rouble</structure:Description>
            </structure:Code>
            <structure:Code value="RUR">
                <structure:Description>Russian ruble (old)</structure:Description>
            </structure:Code>
            <structure:Code value="RWF">

                <structure:Description>Rwanda franc</structure:Description>
            </structure:Code>
            <structure:Code value="SAR">
                <structure:Description>Saudi riyal</structure:Description>
            </structure:Code>
            <structure:Code value="SBD">
                <structure:Description>Solomon Islands dollar</structure:Description>

            </structure:Code>
            <structure:Code value="SCR">
                <structure:Description>Seychelles rupee</structure:Description>
            </structure:Code>
            <structure:Code value="SDD">
                <structure:Description>Sudanese dinar</structure:Description>
            </structure:Code>
            <structure:Code value="SDG">

                <structure:Description>Sudan, Dinars</structure:Description>
            </structure:Code>
            <structure:Code value="SDP">
                <structure:Description>Sudanese pound (old)</structure:Description>
            </structure:Code>
            <structure:Code value="SEK">
                <structure:Description>Swedish krona</structure:Description>

            </structure:Code>
            <structure:Code value="SGD">
                <structure:Description>Singapore dollar</structure:Description>
            </structure:Code>
            <structure:Code value="SHP">
                <structure:Description>St. Helena pound</structure:Description>
            </structure:Code>
            <structure:Code value="SIT">

                <structure:Description>Slovenian tolar</structure:Description>
            </structure:Code>
            <structure:Code value="SKK">
                <structure:Description>Slovak koruna</structure:Description>
            </structure:Code>
            <structure:Code value="SLL">
                <structure:Description>Sierra Leone leone</structure:Description>

            </structure:Code>
            <structure:Code value="SOS">
                <structure:Description>Somali shilling</structure:Description>
            </structure:Code>
            <structure:Code value="SPL">
                <structure:Description>Seborga, Luigini</structure:Description>
            </structure:Code>
            <structure:Code value="SQ_M">

                <structure:Description>Square Metres</structure:Description>
            </structure:Code>
            <structure:Code value="SRD">
                <structure:Description>Suriname, Dollars</structure:Description>
            </structure:Code>
            <structure:Code value="SRG">
                <structure:Description>Suriname guilder</structure:Description>

            </structure:Code>
            <structure:Code value="STD">
                <structure:Description>Sao Tome and Principe dobra</structure:Description>
            </structure:Code>
            <structure:Code value="SVC">
                <structure:Description>El Salvador colon</structure:Description>
            </structure:Code>
            <structure:Code value="SYP">

                <structure:Description>Syrian pound</structure:Description>
            </structure:Code>
            <structure:Code value="SZL">
                <structure:Description>Swaziland lilangeni</structure:Description>
            </structure:Code>
            <structure:Code value="THB">
                <structure:Description>Thai bhat</structure:Description>

            </structure:Code>
            <structure:Code value="TJR">
                <structure:Description>Tajikistan rouble</structure:Description>
            </structure:Code>
            <structure:Code value="TJS">
                <structure:Description>Tajikistan, Somoni</structure:Description>
            </structure:Code>
            <structure:Code value="TMM">

                <structure:Description>Turkmenistan manat (old)</structure:Description>
            </structure:Code>
            <structure:Code value="TMT">
                <structure:Description>Turkmenistan manat</structure:Description>
            </structure:Code>
            <structure:Code value="TND">
                <structure:Description>Tunisian dinar</structure:Description>

            </structure:Code>
            <structure:Code value="TONNES">
                <structure:Description>Tonnes</structure:Description>
            </structure:Code>
            <structure:Code value="TOP">
                <structure:Description>Tongan paanga</structure:Description>
            </structure:Code>
            <structure:Code value="TPE">

                <structure:Description>East Timor escudo</structure:Description>
            </structure:Code>
            <structure:Code value="TRL">
                <structure:Description>Turkish lira (old)</structure:Description>
            </structure:Code>
            <structure:Code value="TRY">
                <structure:Description>Turkish lira</structure:Description>

            </structure:Code>
            <structure:Code value="TTD">
                <structure:Description>Trinidad and Tobago dollar</structure:Description>
            </structure:Code>
            <structure:Code value="TVD">
                <structure:Description>Tuvalu, Tuvalu Dollars</structure:Description>
            </structure:Code>
            <structure:Code value="TWD">

                <structure:Description>New Taiwan dollar</structure:Description>
            </structure:Code>
            <structure:Code value="TZS">
                <structure:Description>Tanzania shilling</structure:Description>
            </structure:Code>
            <structure:Code value="UAH">
                <structure:Description>Ukraine hryvnia</structure:Description>

            </structure:Code>
            <structure:Code value="UGX">
                <structure:Description>Uganda Shilling</structure:Description>
            </structure:Code>
            <structure:Code value="UNITS">
                <structure:Description>Unit described in title</structure:Description>
            </structure:Code>
            <structure:Code value="USD">

                <structure:Description>US dollar</structure:Description>
            </structure:Code>
            <structure:Code value="UYU">
                <structure:Description>Uruguayan peso</structure:Description>
            </structure:Code>
            <structure:Code value="UZS">
                <structure:Description>Uzbekistan sum</structure:Description>

            </structure:Code>
            <structure:Code value="VEB">
                <structure:Description>Venezuela bolivar (old)</structure:Description>
            </structure:Code>
            <structure:Code value="VEF">
                <structure:Description>Venezuela bolivar</structure:Description>
            </structure:Code>
            <structure:Code value="VND">

                <structure:Description>Vietnamese dong</structure:Description>
            </structure:Code>
            <structure:Code value="VUV">
                <structure:Description>Vanuatu vatu</structure:Description>
            </structure:Code>
            <structure:Code value="WST">
                <structure:Description>Samoan tala</structure:Description>

            </structure:Code>
            <structure:Code value="XAF">
                <structure:Description>CFA franc / BEAC</structure:Description>
            </structure:Code>
            <structure:Code value="XAG">
                <structure:Description>Silver</structure:Description>
            </structure:Code>
            <structure:Code value="XAU">

                <structure:Description>Gold in units of grams</structure:Description>
            </structure:Code>
            <structure:Code value="XBA">
                <structure:Description>European composite unit</structure:Description>
            </structure:Code>
            <structure:Code value="XBB">
                <structure:Description>European Monetary unit EC-6</structure:Description>

            </structure:Code>
            <structure:Code value="XCD">
                <structure:Description>Eastern Caribbean dollar</structure:Description>
            </structure:Code>
            <structure:Code value="XDR">
                <structure:Description>Special Drawing Rights (S.D.R.)</structure:Description>
            </structure:Code>
            <structure:Code value="XEU">

                <structure:Description>European Currency Unit (E.C.U.)</structure:Description>
            </structure:Code>
            <structure:Code value="XOF">
                <structure:Description>CFA franc / BCEAO</structure:Description>
            </structure:Code>
            <structure:Code value="XPD">
                <structure:Description>Palladium Ounces</structure:Description>

            </structure:Code>
            <structure:Code value="XPF">
                <structure:Description>Pacific franc</structure:Description>
            </structure:Code>
            <structure:Code value="XPT">
                <structure:Description>Platinum, Ounces</structure:Description>
            </structure:Code>
            <structure:Code value="YEARS">

                <structure:Description>Years</structure:Description>
            </structure:Code>
            <structure:Code value="YER">
                <structure:Description>Yemeni rial</structure:Description>
            </structure:Code>
            <structure:Code value="YUM">
                <structure:Description>Yugoslav dinar</structure:Description>

            </structure:Code>
            <structure:Code value="ZAR">
                <structure:Description>South African rand</structure:Description>
            </structure:Code>
            <structure:Code value="ZMK">
                <structure:Description>Zambian kwacha</structure:Description>
            </structure:Code>
            <structure:Code value="ZWD">

                <structure:Description>Zimbabwe dollar</structure:Description>
            </structure:Code>
            <structure:Code value="ZWN">
                <structure:Description>Zimbabwe, Zimbabwe Dollars</structure:Description>
            </structure:Code>
        </structure:CodeList>
        <structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_UNIT_MULT">
            <structure:Name>Unit multiplier code list</structure:Name>

            <structure:Code value="-2">
                <structure:Description>Hundredth</structure:Description>
            </structure:Code>
            <structure:Code value="0">
                <structure:Description>Units</structure:Description>
            </structure:Code>
            <structure:Code value="1">
                <structure:Description>Tens</structure:Description>

            </structure:Code>
            <structure:Code value="2">
                <structure:Description>Hundreds</structure:Description>
            </structure:Code>
            <structure:Code value="3">
                <structure:Description>Thousands</structure:Description>
            </structure:Code>
            <structure:Code value="4">

                <structure:Description>Tens of thousands</structure:Description>
            </structure:Code>
            <structure:Code value="6">
                <structure:Description>Millions</structure:Description>
            </structure:Code>
            <structure:Code value="9">
                <structure:Description>Billions</structure:Description>

            </structure:Code>
        </structure:CodeList>
    </message:CodeLists>
    <message:Concepts>
        <structure:Concept version="1.0" agencyID="ECB" id="BREAKS">
            <structure:Name>Breaks</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="COLLECTION">
            <structure:Name>Collection indicator</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="COMPILATION">
            <structure:Name>Compilation</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="COVERAGE">
            <structure:Name>Coverage</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="CURRENCY">
            <structure:Name>Currency</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="CURRENCY_DENOM">
            <structure:Name>Currency denominator</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="DECIMALS">
            <structure:Name>Decimals</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="EXR_SUFFIX">
            <structure:Name>Series variation - EXR context</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="EXR_TYPE">
            <structure:Name>Exchange rate type</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="FREQ">
            <structure:Name>Frequency</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="OBS_CONF">
            <structure:Name>Observation confidentiality</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="OBS_PRE_BREAK">
            <structure:Name>Pre-break observation value</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="OBS_STATUS">
            <structure:Name>Observation status</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="OBS_VALUE">
            <structure:Name>Observation value</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="TIME_FORMAT">
            <structure:Name>Time format code</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="TIME_PERIOD">
            <structure:Name>Time period or range</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="TITLE_COMPL">
            <structure:Name>Title complement</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="UNIT">
            <structure:Name>Unit</structure:Name>
        </structure:Concept>
        <structure:Concept version="1.0" agencyID="ECB" id="UNIT_MULT">
            <structure:Name>Unit multiplier</structure:Name>
        </structure:Concept>
    </message:Concepts>
    <message:KeyFamilies>
        <structure:KeyFamily isFinal="true" urn="urn:sdmx:org.sdmx.infomodel.keyfamily.KeyFamily=ECB:ECB_EXR1" version="1.0" agencyID="ECB" id="ECB_EXR1">
            <structure:Name>Exchange Rates</structure:Name>
            <structure:Components>
                <structure:Dimension isFrequencyDimension="true" codelistAgency="ECB" codelist="CL_FREQ" conceptAgency="ECB" conceptVersion="1.0" conceptRef="FREQ" crossSectionalAttachGroup="true"/>
                <structure:Dimension codelistAgency="ECB" codelist="CL_CURRENCY" conceptAgency="ECB" conceptVersion="1.0" conceptRef="CURRENCY" isMeasureDimension="true"/>
                <structure:Dimension codelistAgency="ECB" codelist="CL_CURRENCY" conceptAgency="ECB" conceptVersion="1.0" conceptRef="CURRENCY_DENOM" crossSectionalAttachSection="true"/>
                <structure:Dimension codelistAgency="ECB" codelist="CL_EXR_TYPE" conceptAgency="ECB" conceptVersion="1.0" conceptRef="EXR_TYPE" crossSectionalAttachSection="true"/>
                <structure:Dimension codelistAgency="ECB" codelist="CL_EXR_SUFFIX" conceptAgency="ECB" conceptVersion="1.0" conceptRef="EXR_SUFFIX" crossSectionalAttachSection="true"/>
                <structure:TimeDimension conceptAgency="ECB" conceptVersion="1.0" conceptRef="TIME_PERIOD" crossSectionalAttachGroup="true"/>
                <structure:Group id="Group">
                    <structure:DimensionRef>CURRENCY</structure:DimensionRef>
                    <structure:DimensionRef>CURRENCY_DENOM</structure:DimensionRef>
                    <structure:DimensionRef>EXR_TYPE</structure:DimensionRef>
                    <structure:DimensionRef>EXR_SUFFIX</structure:DimensionRef>
                </structure:Group>
                <structure:PrimaryMeasure conceptAgency="ECB" conceptVersion="1.0" conceptRef="OBS_VALUE"/>
                <structure:Attribute assignmentStatus="Conditional" attachmentLevel="Group" conceptAgency="ECB" conceptVersion="1.0" conceptRef="COMPILATION" crossSectionalAttachSection="true">
                    <structure:TextFormat maxLength="1050" minLength="0" textType="String"/>
                    <structure:AttachmentGroup>Group</structure:AttachmentGroup>
                </structure:Attribute>
                <structure:Attribute assignmentStatus="Conditional" attachmentLevel="Group" conceptAgency="ECB" conceptVersion="1.0" conceptRef="COVERAGE" crossSectionalAttachSection="true">
                    <structure:TextFormat maxLength="350" minLength="0" textType="String"/>
                    <structure:AttachmentGroup>Group</structure:AttachmentGroup>
                </structure:Attribute>
                <structure:Attribute assignmentStatus="Mandatory" attachmentLevel="Group" codelistAgency="ECB" codelistVersion="1.0" codelist="CL_DECIMALS" conceptAgency="ECB" conceptVersion="1.0" conceptRef="DECIMALS" crossSectionalAttachObservation="true">
                    <structure:AttachmentGroup>Group</structure:AttachmentGroup>
                </structure:Attribute>
                <structure:Attribute assignmentStatus="Mandatory" attachmentLevel="Group" conceptAgency="ECB" conceptVersion="1.0" conceptRef="TITLE_COMPL" crossSectionalAttachObservation="true">
                    <structure:TextFormat maxLength="1050" minLength="1" textType="String"/>
                    <structure:AttachmentGroup>Group</structure:AttachmentGroup>
                </structure:Attribute>
                <structure:Attribute assignmentStatus="Mandatory" attachmentLevel="Group" codelistAgency="ECB" codelistVersion="1.0" codelist="CL_UNIT" conceptAgency="ECB" conceptVersion="1.0" conceptRef="UNIT" crossSectionalAttachObservation="true">
                    <structure:AttachmentGroup>Group</structure:AttachmentGroup>
                </structure:Attribute>
                <structure:Attribute assignmentStatus="Mandatory" attachmentLevel="Group" codelistAgency="ECB" codelistVersion="1.0" codelist="CL_UNIT_MULT" conceptAgency="ECB" conceptVersion="1.0" conceptRef="UNIT_MULT" crossSectionalAttachObservation="true">
                    <structure:AttachmentGroup>Group</structure:AttachmentGroup>
                </structure:Attribute>
                <structure:Attribute assignmentStatus="Conditional" attachmentLevel="Series" conceptAgency="ECB" conceptVersion="1.0" conceptRef="BREAKS" crossSectionalAttachObservation="true">
                    <structure:TextFormat maxLength="350" minLength="0" textType="String"/>
                </structure:Attribute>
                <structure:Attribute assignmentStatus="Mandatory" attachmentLevel="Series" codelistAgency="ECB" codelistVersion="1.0" codelist="CL_COLLECTION" conceptAgency="ECB" conceptVersion="1.0" conceptRef="COLLECTION" crossSectionalAttachSection="true"/>
                <structure:Attribute isTimeFormat="true" assignmentStatus="Mandatory" attachmentLevel="Series" conceptAgency="ECB" conceptVersion="1.0" conceptRef="TIME_FORMAT" crossSectionalAttachGroup="true">
                    <structure:TextFormat maxLength="3" minLength="3" textType="String"/>
                </structure:Attribute>
                <structure:Attribute assignmentStatus="Conditional" attachmentLevel="Observation" codelistAgency="ECB" codelistVersion="1.0" codelist="CL_OBS_CONF" conceptAgency="ECB" conceptVersion="1.0" conceptRef="OBS_CONF" crossSectionalAttachObservation="true"/>
                <structure:Attribute assignmentStatus="Conditional" attachmentLevel="Observation" conceptAgency="ECB" conceptVersion="1.0" conceptRef="OBS_PRE_BREAK" crossSectionalAttachObservation="true">
                    <structure:TextFormat maxLength="15" minLength="0" textType="String"/>
                </structure:Attribute>
                <structure:Attribute assignmentStatus="Mandatory" attachmentLevel="Observation" codelistAgency="ECB" codelistVersion="1.0" codelist="CL_OBS_STATUS" conceptAgency="ECB" conceptVersion="1.0" conceptRef="OBS_STATUS" crossSectionalAttachObservation="true"/>
            </structure:Components>
        </structure:KeyFamily>
    </message:KeyFamilies>
</message:Structure>	
	}
}