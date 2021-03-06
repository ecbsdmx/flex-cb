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
package org.sdmx.model.v2.reporting.provisioning
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	/**
	 * @private
	 */ 
	public class QueryDatasourceTest extends TestCase {
		
		protected var _url:String = "http://www.sdmx.org/compact.xml";
		
		protected var _datasource:QueryDatasource;

		public function QueryDatasourceTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(QueryDatasourceTest);
		}
		
		public override function setUp():void {
			_datasource	= createQueryDatasource();	
		}
		
		public function createQueryDatasource():QueryDatasource {
			return new QueryDatasource(_url);
		}
		
		public function testConstructorAndSetter():void {
			assertNotNull("The datasource cannot be null", _datasource);
			assertEquals("The url should be equal", _url, _datasource.dataUrl);
			var newUrl:String = _url + ".zlib";
			_datasource.dataUrl = newUrl;
			assertEquals("The url should be equal", newUrl, _datasource.dataUrl);
		}
	}
}