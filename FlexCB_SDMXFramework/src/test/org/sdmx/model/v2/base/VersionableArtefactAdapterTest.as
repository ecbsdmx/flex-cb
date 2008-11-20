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
package org.sdmx.model.v2.base
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import mx.resources.Locale;
	
	/**
	 *	@private 
	 */
	public class VersionableArtefactAdapterTest extends IdentifiableArtefactAdapterTest
	{
		private var _artefact:VersionableArtefact;
		
		public function VersionableArtefactAdapterTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
			_artefact = createVersionableArtefact();
			assertNotNull("Problem creating versionable artefact", _artefact);
		}
				
		public override function createIdentifiableArtefact():IdentifiableArtefact {
			return createVersionableArtefact();
		}
		
		public function createVersionableArtefact():VersionableArtefact {
			return new VersionableArtefactAdapter(_id);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(VersionableArtefactAdapterTest);
		}
		
		public function testSetAndGetVersion():void {
			assertNull("Version should be null", _artefact.version);
			var version:String = "1.0";
			_artefact.version = version;
			assertEquals("Versions should be equal", version, _artefact.version);
		}
		
		public function testSetAndGetValidFrom():void {
			assertNull("validFrom should be null", _artefact.validFrom);
			var validFrom:Date = new Date();
			_artefact.validFrom = validFrom;
			assertEquals("validFrom should be equal", validFrom, _artefact.validFrom);
		}
		
		public function testSetAndGetValidTo():void {
			assertNull("validTo should be null", _artefact.validTo);
			var validTo:Date = new Date();
			_artefact.validTo = validTo;
			assertEquals("validTo should be equal", validTo, _artefact.validTo);
		}
		
		public function testValidFromAfterValidTo():void {
			assertNull("validFrom should be null", _artefact.validFrom);
			assertNull("validTo should be null", _artefact.validTo);
			var validFrom:Date = new Date("2006", 11, 31, 0, 0, 0);
			var validTo:Date = new Date("2006", 1, 31, 0, 0, 0);
			_artefact.validTo = validTo;
			try {
				_artefact.validFrom = validFrom;
				fail("validFrom cannot be after validTo");
			} catch (error:ArgumentError) {}
		}
		
		public function testValidToBeforeValidFrom():void {
			assertNull("validFrom should be null", _artefact.validFrom);
			assertNull("validTo should be null", _artefact.validTo);
			var validFrom:Date = new Date("2006", 11, 31, 0, 0, 0);
			var validTo:Date = new Date("2006", 1, 31, 0, 0, 0);
			_artefact.validFrom = validFrom;
			try {
				_artefact.validTo = validTo;
				fail("validTo cannot be before validFrom");
			} catch (error:ArgumentError) {}
		}
	}
}