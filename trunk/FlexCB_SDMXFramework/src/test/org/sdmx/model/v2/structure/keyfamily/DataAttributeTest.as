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
package org.sdmx.model.v2.structure.keyfamily
{
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.structure.AttributeTest;
	import org.sdmx.model.v2.base.structure.Attribute;
	import org.sdmx.model.v2.base.type.AttachmentLevel;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */
	public class DataAttributeTest extends AttributeTest
	{
		public function DataAttributeTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(DataAttributeTest);
		}
		
		public override function createAttribute():Attribute {
			return new DataAttribute(_id, _item);
		}
		
		public function testSetAndGetAttachmentLevel():void {
			var attribute:DataAttribute = createAttribute() as DataAttribute;
			assertNull("No default attachment level should be set", attribute.attachmentLevel);
			attribute.attachmentLevel = AttachmentLevel.DATASET;
			assertEquals("AttachmentLevels should be equals", 
				AttachmentLevel.DATASET, attribute.attachmentLevel);
			try {
				attribute.attachmentLevel = "Weird level";
				fail("Attachment level is not valid!");
			} catch (error:TypeError) {}
		}
		
		public function testSetAndGetAttachmentGroup():void {
			var attribute:DataAttribute = createAttribute() as DataAttribute;
			assertNull("No default attachment group should be set", 
				attribute.attachmentGroup);
			var group:GroupKeyDescriptor = new GroupKeyDescriptor("SiblingGroup");	
			attribute.attachmentLevel = AttachmentLevel.GROUP;
			attribute.attachmentGroup = group;
			assertEquals("AttachmentGroups should be equals", 
				group, attribute.attachmentGroup);
			attribute.attachmentLevel = AttachmentLevel.SERIES;
			try {
				attribute.attachmentGroup = group;
				fail("Attachment level is not valid for attaching a group!");
			} catch (error:ArgumentError) {}
		}
	}
}