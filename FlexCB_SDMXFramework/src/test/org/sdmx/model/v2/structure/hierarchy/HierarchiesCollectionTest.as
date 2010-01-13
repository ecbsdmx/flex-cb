package org.sdmx.model.v2.structure.hierarchy
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class HierarchiesCollectionTest extends TestCase
	{
		public function HierarchiesCollectionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(HierarchiesCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:HierarchiesCollection = new HierarchiesCollection();
			try {
				collection.addItem("Wrong object");
				fail("Hierarchies collections can only contain hierarchies");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:HierarchiesCollection = new HierarchiesCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Hierarchies collections can only contain hierarchies");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:HierarchiesCollection = new HierarchiesCollection();
			var h1:Hierarchy = new Hierarchy("A");
			var h2:Hierarchy = new Hierarchy("AB");
			collection.addItem(h1);
			collection.setItemAt(h2, 0);
			assertEquals("There should be 1 hierarchy in the list", 1, 
				collection.length);
			assertTrue("h2", collection.contains(h2));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Hierarchies collections can only contain hierarchies");
			} catch (error:ArgumentError) {}
		}
	}
}