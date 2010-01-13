package org.sdmx.model.v2.structure.hierarchy
{
	import flexunit.framework.TestSuite;
	
	public class HierarchyPackageTests
	{
		public static function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
 			suite.addTest(CodeAssociationsCollectionTest.suite());	 			
 			suite.addTest(CodeAssociationTest.suite());
 			suite.addTest(HierarchicalCodeSchemesCollectionTest.suite());
 			suite.addTest(HierarchicalCodeSchemeTest.suite());
 			suite.addTest(HierarchiesCollectionTest.suite());
 			suite.addTest(HierarchyTest.suite());
 			return suite;
		}
	}
}