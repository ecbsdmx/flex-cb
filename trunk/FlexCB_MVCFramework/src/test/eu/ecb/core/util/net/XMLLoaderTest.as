// ECB/SIS Public License, version 1.0, document reference SIS/2001/116
//
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
package eu.ecb.core.util.net
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import eu.ecb.core.event.XMLDataEvent;
	import flash.events.ErrorEvent;
	import flash.net.URLRequest;

	/**
	 *	@private 
	 */
	public class XMLLoaderTest extends TestCase
	{
		private var _loader:XMLLoader;
		
		private var _testData:XML = XML(
			'<?xml version="1.0" encoding="UTF-8" ?>' +
			'<CompactData xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message https://stats.ecb.int/stats/vocabulary/sdmx/2.0/SDMXMessage.xsd">' +
			'<Header><ID>EXR-HIST_2007-04-26</ID><Test>false</Test><Name xml:lang="en">Euro foreign exchange reference rates</Name><Prepared>2007-04-26T14:25:11</Prepared><Sender id="4F0"><Name xml:lang="en">European Central Bank</Name></Sender><DataSetAgency>ECB</DataSetAgency><DataSetID>ECB_EXR_WEB</DataSetID><Extracted>2007-04-26T14:25:11</Extracted></Header>' +
			'<DataSet xmlns="http://www.ecb.int/vocabulary/stats/exr/1" xsi:schemaLocation="http://www.ecb.int/vocabulary/stats/exr/1 https://stats.ecb.int/stats/vocabulary/exr/1/2006-09-04/sdmx-compact.xsd">' +
			'<Group CURRENCY="USD" CURRENCY_DENOM="EUR" EXR_TYPE="SP00" EXR_SUFFIX="A" DECIMALS="4" UNIT="USD" UNIT_MULT="0" TITLE_COMPL="ECB reference exchange rate, US dollar/Euro, 2:15 pm (C.E.T.)" />' +
			'<Series FREQ="D" CURRENCY="USD" CURRENCY_DENOM="EUR" EXR_TYPE="SP00" EXR_SUFFIX="A" TIME_FORMAT="P1D" COLLECTION="A">' +
			'<Obs TIME_PERIOD="1999-01-04" OBS_VALUE="1.1789" OBS_STATUS="A" OBS_CONF="F" />' +
			'<Obs TIME_PERIOD="1999-01-05" OBS_VALUE="1.1790" OBS_STATUS="A" OBS_CONF="F" />' +
			'<Obs TIME_PERIOD="1999-01-06" OBS_VALUE="1.1743" OBS_STATUS="A" OBS_CONF="F" />' +
			'<Obs TIME_PERIOD="1999-01-07" OBS_VALUE="1.1632" OBS_STATUS="A" OBS_CONF="F" />' +
			'<Obs TIME_PERIOD="1999-01-08" OBS_VALUE="1.1659" OBS_STATUS="A" OBS_CONF="F" />' +
			'<Obs TIME_PERIOD="1999-01-11" OBS_VALUE="1.1569" OBS_STATUS="A" OBS_CONF="F" />' +
			'</Series></DataSet></CompactData>');
		
		public function XMLLoaderTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
			_loader = new XMLLoader();
		}
		
		public static function suite():TestSuite {
			return new TestSuite(XMLLoaderTest);
		}
		
		public function testLoadPlainXMLDataShouldWorkWhenCompressionTurnedOn():void {
			_loader.addEventListener(LoaderAdapter.DATA_LOADED, addAsync(getData, 3000));
			_loader.load(new URLRequest("testData/usd.xml"), true);			
		}
		
		private function getData(event:XMLDataEvent):void {
			assertEquals("The XML data should be equal", _testData, event.data);
		}
	}
}