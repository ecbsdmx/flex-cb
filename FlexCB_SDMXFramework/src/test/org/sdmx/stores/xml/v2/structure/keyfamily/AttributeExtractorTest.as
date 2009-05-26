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
package org.sdmx.stores.xml.v2.structure.keyfamily
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.DataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.UncodedDataAttribute;
	import org.sdmx.model.v2.base.type.AttachmentLevel;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.base.type.UsageStatus;
	import org.sdmx.model.v2.base.structure.LengthRange;
	import org.sdmx.model.v2.base.type.DataType;
	import org.sdmx.model.v2.structure.concept.Concepts;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.CodedDataAttribute;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	/**
	 * @private
	 */
	public class AttributeExtractorTest extends TestCase {

		public function AttributeExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(AttributeExtractorTest);
		}
		
		public function testAttributeWithTextFormatExtraction():void {
			var group:GroupKeyDescriptor = new GroupKeyDescriptor("SiblingGroup");
			var concepts:Concepts = new Concepts("Concepts");
			var concept1:Concept = new Concept("FREQ");
			var concept2:Concept = new Concept("REF_AREA");
			var concept3:Concept = new Concept("TITLE_COMPL");
			concepts.addItem(concept1);
			concepts.addItem(concept2);
			concepts.addItem(concept3);
			var xml:XML =
				<Attribute conceptRef="TITLE_COMPL" attachmentLevel="Group" assignmentStatus="Mandatory" isEntityAttribute="true">
					<TextFormat textType="String" maxLength="1050"/>
					<AttachmentGroup>SiblingGroup</AttachmentGroup>
				</Attribute>
			var extractor:AttributeExtractor = 
				new AttributeExtractor(null, concepts, group);	
			var attribute:DataAttribute = extractor.extract(xml) as DataAttribute;
			assertNotNull("The attribute cannot be null", attribute);
			assertTrue("The attribute should be an uncoded one", attribute is UncodedDataAttribute);
			assertEquals("The 3rd concept is the selected one", concept3, attribute.conceptIdentity);
			assertEquals("The group should be there", group, attribute.attachmentGroup);
			assertEquals("The level of attachement should be group", AttachmentLevel.GROUP, attribute.attachmentLevel);
			assertEquals("Entity should be the concept role", ConceptRole.ENTITY, attribute.conceptRole);
			assertEquals("The assignment status should be mandatory", UsageStatus.MANDATORY, attribute.usageStatus);
			assertTrue("The local representation should be a LengthRange", attribute.localRepresentation is LengthRange);
			assertEquals("The local representation should be of type 'String'", DataType.STRING, (attribute.localRepresentation as LengthRange).dataType);
			assertEquals("The minLength should be 0", 0, (attribute.localRepresentation as LengthRange).minLength);
			assertEquals("The minLength should be 1050", 1050, (attribute.localRepresentation as LengthRange).maxLength);
		}
		
		public function testAttributeWithCodeListExtraction():void {
			var group:GroupKeyDescriptor = new GroupKeyDescriptor("SiblingGroup");
			var concepts:Concepts = new Concepts("Concepts");
			var concept1:Concept = new Concept("OBS_CONF");
			var concept2:Concept = new Concept("OBS_STATUS");
			var concept3:Concept = new Concept("OBS_PRE_BREAK");
			concepts.addItem(concept1);
			concepts.addItem(concept2);
			concepts.addItem(concept3);
			var codeLists:CodeLists = new CodeLists("Code lists");
			codeLists.addItem(new CodeList("CL_OBS_CONF", new InternationalString(), new MaintenanceAgency("ECB")));
			codeLists.addItem(new CodeList("CL_OBS_STATUS", new InternationalString(), new MaintenanceAgency("ECB")));
			codeLists.addItem(new CodeList("CL_CURRENCY", new InternationalString(), new MaintenanceAgency("ECB")));
			var xml:XML =
				<Attribute conceptRef="OBS_STATUS" attachmentLevel="Observation" codelist="CL_OBS_STATUS" assignmentStatus="Mandatory"/>
			var extractor:AttributeExtractor = 
				new AttributeExtractor(codeLists, concepts, group);	
			var attribute:DataAttribute = extractor.extract(xml) as DataAttribute;
			assertNotNull("The attribute cannot be null", attribute);
			assertTrue("The attribute should be an coded one", attribute is CodedDataAttribute);
			assertEquals("The 2nd concept is the selected one", concept2, attribute.conceptIdentity);
			assertNull("The group should be null", attribute.attachmentGroup);
			assertEquals("The level of attachement should be observation", AttachmentLevel.OBSERVATION, attribute.attachmentLevel);
			assertEquals("The assignment status should be mandatory", UsageStatus.MANDATORY, attribute.usageStatus);
			assertEquals("The local representation should be the 2nd code list", codeLists.getItemAt(1), attribute.localRepresentation);
		}
		
		public function testAttributeNoConcept():void {
			var group:GroupKeyDescriptor = new GroupKeyDescriptor("SiblingGroup");
			var concepts:Concepts = new Concepts("Concepts");
			var concept1:Concept = new Concept("OBS_CONF");
			var concept2:Concept = new Concept("OBS_COM");
			var concept3:Concept = new Concept("OBS_PRE_BREAK");
			concepts.addItem(concept1);
			concepts.addItem(concept2);
			concepts.addItem(concept3);
			var xml:XML =
				<Attribute conceptRef="OBS_STATUS" attachmentLevel="Observation" codelist="CL_OBS_STATUS" assignmentStatus="Mandatory"/>
			var extractor:AttributeExtractor = 
				new AttributeExtractor(null, concepts, group);	
			try {	
				extractor.extract(xml);		
				fail("The concept could not be found!");		
			} catch (error:SyntaxError) {}	
		}
		
		public function testUnknownGroup():void {
			var group:GroupKeyDescriptor = new GroupKeyDescriptor("SiblingGroup");
			var concepts:Concepts = new Concepts("Concepts");
			var concept1:Concept = new Concept("FREQ");
			var concept2:Concept = new Concept("REF_AREA");
			var concept3:Concept = new Concept("TITLE_COMPL");
			concepts.addItem(concept1);
			concepts.addItem(concept2);
			concepts.addItem(concept3);
			var xml:XML =
				<Attribute conceptRef="TITLE_COMPL" attachmentLevel="Group" assignmentStatus="Mandatory" isEntityAttribute="true">
					<TextFormat textType="String" maxLength="1050"/>
					<AttachmentGroup>Group</AttachmentGroup>
				</Attribute>
			var extractor:AttributeExtractor = 
				new AttributeExtractor(null, concepts, group);	
			try {	
				extractor.extract(xml) as DataAttribute;
				fail("The group could not be found!");		
			} catch (error:SyntaxError) {}	
		}
	}
}