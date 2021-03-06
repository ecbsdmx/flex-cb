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
package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	
	/**
	 * @private
	 */
	public class DataSetPackageTests
	{
		public static function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(AttachableArtefactAdapterTest.suite());
			suite.addTest(AttributeValuesCollectionTest.suite());
			suite.addTest(AttributeValueTest.suite());
			suite.addTest(BaseDataSetTest.suite());
			suite.addTest(BaseXSComponentTest.suite());
			suite.addTest(CodedAttributeValueTest.suite());
			suite.addTest(CodedObservationTest.suite());
			suite.addTest(CodedXSObservationTest.suite());
			suite.addTest(DataSetTest.suite());
			suite.addTest(GroupKeysCollectionTest.suite());
			suite.addTest(GroupKeyTest.suite());
			suite.addTest(KeyTest.suite());
			suite.addTest(KeyValuesCollectionTest.suite());
			suite.addTest(KeyValueTest.suite());
			suite.addTest(SectionTest.suite());
			suite.addTest(SectionsCollectionTest.suite());
			suite.addTest(TimePeriodsCollectionTest.suite());
			suite.addTest(TimePeriodTest.suite());
			suite.addTest(TimeseriesKeysCollectionTest.suite());
			suite.addTest(TimeseriesKeyTest.suite());
			suite.addTest(UncodedAttributeValueTest.suite());
 			suite.addTest(UncodedObservationTest.suite());	
 			suite.addTest(UncodedXSObservationTest.suite());
 			suite.addTest(XSDataSetTest.suite());
 			suite.addTest(XSGroupsCollectionTest.suite());
 			suite.addTest(XSGroupTest.suite());
 			suite.addTest(XSObservationsCollectionTest.suite());
 			suite.addTest(XSObsTest.suite());
 			return suite;
		}
	}
}