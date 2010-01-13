package org.sdmx.model.v2.structure.hierarchy
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	
	public class HierarchicalCodeSchemesCollectionTest extends TestCase
	{
		public function HierarchicalCodeSchemesCollectionTest(
			methodName:String=null)
		{
			super(methodName);
		}

		public static function suite():TestSuite {
			return new TestSuite(HierarchicalCodeSchemesCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:HierarchicalCodeSchemesCollection = 
				new HierarchicalCodeSchemesCollection();
			try {
				collection.addItem("Wrong object");
				fail("HCS collections can only contain HCS");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:HierarchicalCodeSchemesCollection = 
				new HierarchicalCodeSchemesCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("HCS collections can only contain HCS");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:HierarchicalCodeSchemesCollection = 
				new HierarchicalCodeSchemesCollection();
			var hcs1:HierarchicalCodeScheme = new HierarchicalCodeScheme("A", 
				new InternationalString(), new MaintenanceAgency("ECB"));
			var hcs2:HierarchicalCodeScheme = new HierarchicalCodeScheme("AB",
				new InternationalString(), new MaintenanceAgency("ECB"));
			collection.addItem(hcs1);
			collection.setItemAt(hcs2, 0);
			assertEquals("There should be 1 hcs in the hcs list", 1, 
				collection.length);
			assertTrue("hcs", collection.contains(hcs2));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("HCS collections can only contain HCS");
			} catch (error:ArgumentError) {}
		}
	}
}