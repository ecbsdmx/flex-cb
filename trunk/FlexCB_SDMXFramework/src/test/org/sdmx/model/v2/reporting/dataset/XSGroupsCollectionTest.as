package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class XSGroupsCollectionTest extends TestCase
	{
		public function XSGroupsCollectionTest(methodName:String=null)
		{
			super(methodName);
		}
	
		public static function suite():TestSuite {
			return new TestSuite(XSGroupsCollectionTest);
		}
		
		public function testWrongAddItem():void {
			var collection:XSGroupsCollection = new XSGroupsCollection();
			try {
				collection.addItem("Wrong object");
				fail("xs groups collections can only contain xs groups");
			} catch (error:ArgumentError) {}
		}
		
		public function testWrongAddItemAt():void {
			var collection:XSGroupsCollection = new XSGroupsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("xs groups collections can only contain xs groups");
			} catch (error:ArgumentError) {}
		}
		
		public function testWrongSetItemAt():void {
			var collection:XSGroupsCollection = new XSGroupsCollection();
			try {
				collection.setItemAt("Wrong object", 0);
				fail("xs groups collections can only contain xs groups");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddAndSetItemAt():void {
			var collection:XSGroupsCollection = new XSGroupsCollection();
			var group1:XSGroup = new XSGroup();
			var group2:XSGroup = new XSGroup();
			collection.addItem(group1);
			collection.setItemAt(group2, 0);	
			assertEquals("1", 1, collection.length);
			assertEquals("2nd", group2, collection.getItemAt(0));
		}		
	}
}