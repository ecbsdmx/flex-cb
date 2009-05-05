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
package org.sdmx.model.v2.base.structure
{
	import org.sdmx.model.v2.base.IdentifiableArtefactAdapterTest;
	import org.sdmx.model.v2.base.IdentifiableArtefact;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.item.Item;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.base.type.DataType;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.LocalisedString;
	import mx.resources.Locale;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 *	@private 
	 */
	public class ComponentTest extends IdentifiableArtefactAdapterTest
	{
		private var _component:Component;
		
		protected var _item:Concept = new Concept("1");
		
		public function ComponentTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
			_component = createComponent();
			assertNotNull("Problem creating component", _component);	
		}
		
		public override function createIdentifiableArtefact():IdentifiableArtefact {
			return createComponent();
		}
		
		public function createComponent():Component {
			return new Component(_id, _item);
		}
				
		public static function suite():TestSuite {
			return new TestSuite(ComponentTest);
		}
		
		public function testSetAndGetConceptIdentity():void {
			assertEquals("Item 1 should be the concept identity", _item, _component.conceptIdentity);
			var item2:Concept = new Concept("2");
			_component.conceptIdentity = item2;
			assertEquals("Item 2 should be the concept identity", item2, _component.conceptIdentity);
			try {
				_component.conceptIdentity = null;
				fail("The concept identity cannot be null");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetConceptRole():void {
			assertNull("There should be no default role assigned to the component", _component.conceptRole);
			_component.conceptRole = ConceptRole.FREQUENCY;
			assertEquals("The role should be frequency", ConceptRole.FREQUENCY, _component.conceptRole);
			try {
				_component.conceptRole = "My own role";
				fail("Not a proper concept role");
			} catch (error:TypeError) {}
		}
				
		public function testSetAndGetLocalType():void {
			assertNull("There should be no default type assigned to the component", _component.localType);
			_component.localType = DataType.BOOLEAN;
			assertEquals("The type should now be boolean", DataType.BOOLEAN, _component.localType);
			try {
				_component.localType = "My own type";
				fail("Not a proper data type");
			} catch (error:TypeError) {}
		}
						
		public function testSetAndGetLocalRepresentation():void {
			assertNull("There should be no default representation assigned to " + 
					"the component", _component.localRepresentation);
			var clName:InternationalString = new InternationalString();
			clName.localisedStrings.addItem(new LocalisedString(new Locale("en"), "Exch. rate series variation code list"));
			var codeList:CodeList = new CodeList("CL_EXR_SUFFIX", clName, new MaintenanceAgency("OECB"));
			_component.localRepresentation = codeList;
			assertEquals("Local representations should be equal", codeList, _component.localRepresentation);
		}
	}
}