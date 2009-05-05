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
	public class IdentifiableArtefactAdapterTest extends AnnotableArtefactAdapterTest
	{	
		protected var _id:String = "identifier";
		
		private var _name:InternationalString;
		
		private var _error:String = "An exception should have been caught";
		
		private var _artefact:IdentifiableArtefact;
		
		public function IdentifiableArtefactAdapterTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
			_artefact = createIdentifiableArtefact();
			assertNotNull("Problem creating identifiable artefact", _artefact);
		}
				
		public override function createAnnotableArtefact():AnnotableArtefact {
			return createIdentifiableArtefact();
		}
		
		public function createIdentifiableArtefact():IdentifiableArtefact {
			return new IdentifiableArtefactAdapter(_id);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(IdentifiableArtefactAdapterTest);
		}
				
		public function testConstructor():void {
			assertEquals("The identifiers should be equal", _id, _artefact.id);
			assertNull("The name should be null", _artefact.name)
			assertNull("The uri should be null", _artefact.uri);
			assertNull("The urn should be null", _artefact.urn);
			assertNull("The description should be null", _artefact.description);
			try {
				new IdentifiableArtefactAdapter(null);
				fail(_error + "_1");
			} catch (error:ArgumentError) {}
			try {
				new IdentifiableArtefactAdapter("   ");
				fail(_error + "_2");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetId():void {
			assertEquals("The identifiers should be equal", _id, _artefact.id);
			var newId:String = _id + "_new";
			_artefact.id = newId;
			assertEquals("The new identifiers should be equal", newId, _artefact.id);
			try {
				_artefact.id = null;
				fail(_error + "_1");
			} catch (error:ArgumentError) {}
			try {
				_artefact.id = "   	";
				fail(_error + "_2");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetName():void {
			var newName:InternationalString = new InternationalString();
			newName.localisedStrings.addItem(new LocalisedString(new Locale("de"), "Hallo"));
			_artefact.name = newName;
			assertEquals("The new names should be equal", newName, _artefact.name);
		}
		
		public function testSetAndGetUri():void {
			assertNull("The uri should be null", _artefact.uri);
			var uri:String = "http://www.sdmx.org";
			_artefact.uri = uri;
			assertEquals("The URIs should be equal", uri, _artefact.uri);
		}
		
		public function testSetAndGetUrn():void {
			assertNull("The urn should be null", _artefact.urn);
			var urn:String = "http://www.sdmx.org";
			_artefact.urn = urn;
			assertEquals("The URNs should be equal", urn, _artefact.urn);
		}
		
		public function testSetAndGetDescription():void {
			assertNull("The description should be null", _artefact.description);
			var descriptions:InternationalString = new InternationalString();
			_artefact.description = descriptions;
			assertNull("The description should still be null", _artefact.description);
			descriptions.localisedStrings.addItem(new LocalisedString(new Locale("en"), "test"));
			_artefact.description = descriptions;
			assertEquals("The descriptions should be equal", descriptions, _artefact.description);
		}
	}
}