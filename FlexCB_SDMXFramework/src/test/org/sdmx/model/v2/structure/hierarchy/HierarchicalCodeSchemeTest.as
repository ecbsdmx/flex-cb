package org.sdmx.model.v2.structure.hierarchy
{
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.MaintainableArtefact;
	import org.sdmx.model.v2.base.MaintainableArtefactAdapterTest;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	public class HierarchicalCodeSchemeTest 
		extends MaintainableArtefactAdapterTest
	{
		public function HierarchicalCodeSchemeTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(HierarchicalCodeSchemeTest);
		}
		
		override public function createMaintainableArtefact():MaintainableArtefact 
		{
			_id = "HCS";
			_name = new InternationalString();
			_maintainer = new MaintenanceAgency("ECB");
			return new HierarchicalCodeScheme(_id, _name, _maintainer);
		}
		
		public function testSetAndGetHierarchies():void
		{
			var hcs:HierarchicalCodeScheme = createMaintainableArtefact() 
				as HierarchicalCodeScheme;
			assertNull("By default, there should be no hierarchies", 
				hcs.hierarchies);
			var hierarchies:HierarchiesCollection = new HierarchiesCollection();
			hcs.hierarchies = hierarchies;
			assertEquals("Should have hierarchies", hierarchies, 
				hcs.hierarchies);
		}
	}
}