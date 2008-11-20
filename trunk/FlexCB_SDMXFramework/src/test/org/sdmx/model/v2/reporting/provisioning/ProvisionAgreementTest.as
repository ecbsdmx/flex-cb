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
package org.sdmx.model.v2.reporting.provisioning
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.organisation.DataProvider;
	import org.sdmx.model.v2.base.VersionableArtefactAdapterTest;
	import org.sdmx.model.v2.base.VersionableArtefact;

	/**
	 * @private
	 */ 
	public class ProvisionAgreementTest extends VersionableArtefactAdapterTest {
		
		private var _agreement:ProvisionAgreement;
		
		public function ProvisionAgreementTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(ProvisionAgreementTest);
		}
		
		public override function setUp():void {
			super.setUp();
			_agreement = createVersionableArtefact() as ProvisionAgreement;
		}
		
		public override function createVersionableArtefact():VersionableArtefact {
			return new ProvisionAgreement(_id, new DataProvider("4F0"));
		}
		
		public function testSetAndGetDataProvider():void {
			assertEquals("The data provider should be equal", "4F0", _agreement.dataProvider.id);
			var provider:DataProvider = new DataProvider("RU2");
			_agreement.dataProvider = provider;
			assertEquals("The new data provider should be equal", "RU2", _agreement.dataProvider.id);
		}
		
		public function testSetAndGetContentConstraint():void {
			assertNull("The content constraint should be null", _agreement.contentConstraint);
			var constraints:ContentConstraint = new ContentConstraint("test");
			_agreement.contentConstraint = constraints;
			assertEquals("The content constraint should be equal", constraints, _agreement.contentConstraint);
		}
		
		public function testSetAndGetAttachmentConstraints():void {
			assertNull("The attachment constraint should be null", _agreement.attachmentConstraints);
			var constraints:AttachmentConstraintsCollection = new AttachmentConstraintsCollection();
			_agreement.attachmentConstraints = constraints;
			assertEquals("The attachment constraint should be equal", constraints, _agreement.attachmentConstraints);

		}
		
		public function testSetAndGetSource():void {
			assertNull("The source should be null", _agreement.source);
			var source:QueryDatasource = new RestDatasource("https://stats.ecb.europa.eu/test.sdmx.xml");
			_agreement.source = source;
			assertEquals("The source should be equal", source, _agreement.source);
		}
	}
}