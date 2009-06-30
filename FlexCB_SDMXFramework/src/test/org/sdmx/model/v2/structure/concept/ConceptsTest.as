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
package org.sdmx.model.v2.structure.concept
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	/**
	 * @private 
	 */
	public class ConceptsTest extends TestCase {
		
		public function ConceptsTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(ConceptsTest);
		}
		
		public function testGetAndSetID():void
		{
			var collection:Concepts = new Concepts("c");
			assertEquals("id=c", "c", collection.id);
			collection.id = "d";
			assertEquals("id=d", "d", collection.id);
		}
		
		public function testAddItem():void {
			var collection:Concepts = new Concepts();
			try {
				collection.addItem("Wrong object");
				fail("Concepts collections can only contain concepts");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:Concepts = new Concepts();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Concepts collections can only contain concepts");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:Concepts = new Concepts();
			var concept1:Concept = new Concept("A");
			var concept2:ConceptScheme = new ConceptScheme("cs", 
				new InternationalString(), new MaintenanceAgency("ECB"));
			collection.addItem(concept1);
			collection.setItemAt(concept2, 0);
			assertEquals("length=1", 1, collection.length);
			assertEquals("Concept2", concept2, collection.getItemAt(0));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Concepts collections can only contain concepts");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetConcept():void {
			var collection:Concepts = new Concepts();
			var concept1:Concept = new Concept("A");
			concept1.version = "1.0";
			var concept2:Concept = new Concept("AB");
			var concept3:Concept = new Concept("A");
			concept3.version = "2.0";			
			var conceptScheme1:ConceptScheme = new ConceptScheme("test1", 
				new InternationalString(), new MaintenanceAgency("ECB"));
			var concept4:Concept = new Concept("C1");	
			var concept5:Concept = new Concept("C2");				
			var concept8:Concept = new Concept("C2");
			concept8.version = "8.0";
			conceptScheme1.concepts.addItem(concept4);
			conceptScheme1.concepts.addItem(concept5);
			conceptScheme1.concepts.addItem(concept8);
			var conceptScheme2:ConceptScheme = new ConceptScheme("test1", 
				new InternationalString(), new MaintenanceAgency("OECD"));				
			var concept6:Concept = new Concept("C1");	
			var concept7:Concept = new Concept("C2");
			concept7.version = "8.0";					
			conceptScheme2.concepts.addItem(concept6);
			conceptScheme2.concepts.addItem(concept7);
			collection.addItem(concept1);
			collection.addItem(concept2);
			collection.addItem(concept3);
			collection.addItem(conceptScheme1);
			collection.addItem(conceptScheme2);
			assertEquals("The 1st concept should be returned", concept1, collection.getConcept("A"));
			//assertEquals("The 3rd concept should be returned", concept3, collection.getConcept("A", "2.0"));
			assertEquals("The 8th concept should be returned", concept8, collection.getConcept("C2", null, "ECB", "test1"));
			/*assertEquals("The 8th concept should be returned", concept8, collection.getConcept("C2", "8.0", "ECB", "test1"));			
			assertEquals("The 7th concept should be returned", concept7, collection.getConcept("C2", "8.0", "OECD", "test1"));*/			
			try {
				collection.getConcept(null);
				fail("The conceptId should not be null");
			} catch (error:ArgumentError) {}
			try {
				collection.getConcept("");
				fail("The conceptId should not be empty");
			} catch (error:ArgumentError) {}
		}
	}
}