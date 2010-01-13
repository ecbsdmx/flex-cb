package org.sdmx.model.v2.structure.hierarchy
{
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.VersionableArtefact;
	import org.sdmx.model.v2.base.VersionableArtefactAdapterTest;

	public class HierarchyTest extends VersionableArtefactAdapterTest
	{
		public function HierarchyTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(HierarchyTest);
		}
		
		override public function createVersionableArtefact():VersionableArtefact 
		{
			_id = "h1";
			return new Hierarchy(_id);
		}
		
		public function testSetAndGetChildren():void
		{
			var hierarchy:Hierarchy = createVersionableArtefact() as Hierarchy;
			assertNull("By default, there should be no children in the" + 
				" hierarchy", hierarchy.children);
			var children:CodeAssociationsCollection = 
				new CodeAssociationsCollection();
			hierarchy.children = children;
			assertEquals("Should have children", children, hierarchy.children);
		}
	}
}