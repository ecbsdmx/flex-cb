package org.sdmx.stores.xml.v2.structure.hierarchy
{
	import flexunit.framework.TestSuite;
	
	public class HierarchyPackageTests
	{
		public static function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(HierarchicalCodeSchemeExtractorTest.suite());
			suite.addTest(HierarchyExtractorTest.suite());
			suite.addTest(CodeAssociationExtractorTest.suite());
 			return suite;
		}
	}
}