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
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import mx.resources.Locale;
	
	/**
	 *	@private 
	 */
	public class MaintainableArtefactAdapterTest extends VersionableArtefactAdapterTest
	{
		private var _artefact:MaintainableArtefact;
		
		protected var _maintainer:MaintenanceAgency;
		
		protected var _name:InternationalString;
		
		public function MaintainableArtefactAdapterTest(methodName:String = null) {
			super(methodName);
			_name = new InternationalString();
			_name.localisedStrings.addItem(new LocalisedString(new Locale("en"), "test"));
			_maintainer = new MaintenanceAgency("OECB");
		}
		
		public override function setUp():void {
			super.setUp();
			_artefact = createMaintainableArtefact();
			assertNotNull("Problem creating maintainable artefact", _artefact);
		}
		
		public override function createVersionableArtefact():VersionableArtefact {
			return createMaintainableArtefact();
		}
		
		public function createMaintainableArtefact():MaintainableArtefact {
			return new MaintainableArtefactAdapter(_id, _name, _maintainer);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(MaintainableArtefactAdapterTest);
		}
		
		public override function testConstructor():void {
			assertEquals("Maintenance agencies should be equal", _maintainer, _artefact.maintainer);
			assertFalse("isFinal flag should be false by default", _artefact.isFinal);
			try {
				var name:InternationalString = new InternationalString();
				name.localisedStrings.addItem(new LocalisedString(new Locale("en"), "test"));
				new MaintainableArtefactAdapter("identifier", name, null);
				fail("It should not be possible construct a MaintainableArtefact without Maintenance agency");
			} catch (error:ArgumentError){}
		}
		
		public function testSetAndGetFinal():void {
			assertFalse("isFinal flag should be false by default", _artefact.isFinal);
			_artefact.isFinal = true;
			assertTrue("isFinal flag should be now be true", _artefact.isFinal);
		}
		
		public function testSetAndGetMaintainer():void {
			assertEquals("Maintenance agencies should be equal", _maintainer, _artefact.maintainer);
			var newMaintainer:MaintenanceAgency = new MaintenanceAgency("OECB");
			_artefact.maintainer = newMaintainer;
			assertEquals("Maintenance agencies should be equal", newMaintainer, _artefact.maintainer);
			try {
				_artefact.maintainer = null;
				fail("It should not be possible pass a null Maintenance agency");
			} catch (error:ArgumentError){}
		}
	}
}