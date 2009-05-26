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
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;

	/**
	 * @private
	 */
	public class GroupExtractorTest extends TestCase {
		
		public function GroupExtractorTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(GroupExtractorTest);
		}
		
		public function testGroupExtraction():void {
			var keyDescriptor:KeyDescriptor = new KeyDescriptor();
			keyDescriptor.addItem(new Dimension("FREQUENCY", new Concept("FREQUENCY")));
			keyDescriptor.addItem(new Dimension("CURRENCY", new Concept("CURRENCY")));
			keyDescriptor.addItem(new Dimension("CURRENCY_DENOM", new Concept("CURRENCY_DENOM")));
			keyDescriptor.addItem(new Dimension("EXR_TYPE", new Concept("EXR_TYPE")));
			keyDescriptor.addItem(new Dimension("EXR_SUFFIX", new Concept("EXR_SUFFIX")));
			var xml:XML = 
				<Group id="Group">
					<DimensionRef>CURRENCY</DimensionRef>
					<DimensionRef>CURRENCY_DENOM</DimensionRef>
					<DimensionRef>EXR_TYPE</DimensionRef>
					<DimensionRef>EXR_SUFFIX</DimensionRef>
				</Group>
			var extractor:GroupExtractor = new GroupExtractor(keyDescriptor);
			var group:GroupKeyDescriptor = extractor.extract(xml) as GroupKeyDescriptor;	
			assertEquals("There should be 4 items in the group key", 4, group.length);
			assertEquals("The 1st item should be 'CURRENCY'", "CURRENCY", (group.getItemAt(0) as Dimension).conceptIdentity.id);
			assertEquals("The 2nd item should be 'CURRENCY_DENOM'", "CURRENCY_DENOM", (group.getItemAt(1) as Dimension).conceptIdentity.id);
			assertEquals("The 3rd item should be 'EXR_TYPE'", "EXR_TYPE", (group.getItemAt(2) as Dimension).conceptIdentity.id);
			assertEquals("The 4th item should be 'EXR_SUFFIX'", "EXR_SUFFIX", (group.getItemAt(3) as Dimension).conceptIdentity.id);									
		}
	}
}