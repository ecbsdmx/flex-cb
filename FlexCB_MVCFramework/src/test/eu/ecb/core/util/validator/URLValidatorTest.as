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
package eu.ecb.core.util.validator
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import mx.events.ValidationResultEvent;
	import mx.collections.ArrayCollection;

	/**
	 *	@private 
	 */
	public class URLValidatorTest extends TestCase {
		
		public function URLValidatorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(URLValidatorTest);
		}
		
		public function testSetAndGetAllowNoPath():void {
			var validator:URLValidator = new URLValidator();
			assertFalse("By default, allowNoPath should be false", validator.allowNoPath);
			validator.allowNoPath = true;
			assertTrue("allowNoPath should now be true", validator.allowNoPath);
		}
		
		public function testSetAndGetAllowNoScheme():void {
			var validator:URLValidator = new URLValidator();
			assertFalse("By default, allowNoScheme should be false", validator.allowNoScheme);
			validator.allowNoScheme = true;
			assertTrue("allowNoScheme should now be true", validator.allowNoScheme);
		}
		
		public function testGoodURI():void {
			var validator:URLValidator = new URLValidator();
			assertEquals("http://192.168.2.1/data/index.xml should be ok", ValidationResultEvent.VALID, validator.validate("http://192.168.2.1/data/index.xml").type);
			assertEquals("http://user:pwd@www.ecb.europa.eu:8080/data/index.xml should be ok", ValidationResultEvent.VALID, validator.validate("http://user:pwd@www.ecb.europa.eu:8080/data/index.xml").type);
			assertEquals("http://www.ecb.europa.eu/data/index.php?test=0 should be ok", ValidationResultEvent.VALID, validator.validate("http://www.ecb.europa.eu/data/index.php?test=0").type);
			assertEquals("http://www.ecb.europa.eu/data/index.html#intro should be ok", ValidationResultEvent.VALID, validator.validate("http://www.ecb.europa.eu/data/index.html#intro").type);	
		}
		
		public function testBadURI():void {
			var validator:URLValidator = new URLValidator();
			assertEquals("http://192.168.2.1/data/ index.xml should not be ok", ValidationResultEvent.INVALID, validator.validate("http://192.168.2.1/data/ index.xml").type);
			assertEquals("http://192.357.2.1/data/index.xml should not be ok", ValidationResultEvent.INVALID, validator.validate("http://192.357.2.1/data/index.xml").type);
			assertEquals("http:///user:pwd@www.ecb.europa.eu:8080/data/index.xml should not be ok", ValidationResultEvent.INVALID, validator.validate("http:///user:pwd@www.ecb.europa.eu:8080/data/index.xml").type);
			assertEquals("http://www.ecb.europa.eu\data\index.php?test=0 should not be ok", ValidationResultEvent.INVALID, validator.validate("http://www.ecb.europa.eu\data\index.php?test=0").type);
		}
		
		public function testAllowNoPath():void {
			var validator:URLValidator = new URLValidator();
			assertEquals("http://www.ecb.int should not be ok", ValidationResultEvent.INVALID, validator.validate("http://www.ecb.int").type);
			assertEquals("http://www.ecb.int/ should not be ok", ValidationResultEvent.INVALID, validator.validate("http://www.ecb.int/").type);
			assertEquals("http://www.ecb.int:8080 not should be ok", ValidationResultEvent.INVALID, validator.validate("http://www.ecb.int:8080").type);
			assertEquals("http://192.168.2.1 should not be ok", ValidationResultEvent.INVALID, validator.validate("http://192.168.2.1").type);
			assertEquals("http://192.168.2.1:8080/ should not be ok", ValidationResultEvent.INVALID, validator.validate("http://192.168.2.1:8080/").type);
			validator.allowNoPath = true;
			assertEquals("http://www.ecb.int should be ok", ValidationResultEvent.VALID, validator.validate("http://www.ecb.int").type);
			assertEquals("http://www.ecb.int/ should be ok", ValidationResultEvent.VALID, validator.validate("http://www.ecb.int/").type);
			assertEquals("http://www.ecb.int:8080 should be ok", ValidationResultEvent.VALID, validator.validate("http://www.ecb.int:8080").type);
			assertEquals("http://192.168.2.1 should be ok", ValidationResultEvent.VALID, validator.validate("http://192.168.2.1").type);
			assertEquals("http://192.168.2.1:8080/ should be ok", ValidationResultEvent.VALID, validator.validate("http://192.168.2.1:8080/").type);
		}
		
		public function testAllowNoScheme():void {
			var validator:URLValidator = new URLValidator();
			assertEquals("www.ecb.europa.eu/data/index.html#intro should not be ok", ValidationResultEvent.INVALID, validator.validate("www.ecb.europa.eu/data/index.html#intro").type);
			validator.allowNoScheme = true;
			assertEquals("www.ecb.europa.eu/data/index.html#intro should now be ok", ValidationResultEvent.VALID, validator.validate("www.ecb.europa.eu/data/index.html#intro").type);
		}
		
		public function testSetAndGetSchemes():void {
			var validator:URLValidator = new URLValidator();
			assertEquals("There should be 2 schemes available by default", 2, validator.schemes.length);
			assertTrue("http should be an allowed scheme", validator.schemes.contains("http"));
			assertTrue("https should be an allowed scheme", validator.schemes.contains("https"));
			assertEquals("ftp://www.ecb.europa.eu/data/index.html#intro should not be ok", ValidationResultEvent.INVALID, validator.validate("ftp://www.ecb.europa.eu/data/index.html#intro").type);
			validator.schemes = new ArrayCollection(["http", "https", "ftp"]);
			assertEquals("ftp://www.ecb.europa.eu/data/index.html#intro should now be ok", ValidationResultEvent.VALID, validator.validate("ftp://www.ecb.europa.eu/data/index.html#intro").type);
		}
	}
}