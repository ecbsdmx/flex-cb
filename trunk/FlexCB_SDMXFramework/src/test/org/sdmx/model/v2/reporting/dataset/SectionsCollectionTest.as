package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class SectionsCollectionTest extends TestCase
	{
		public function SectionsCollectionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(SectionsCollectionTest);
		}
		
		public function testWrongAddItem():void {
			var collection:SectionsCollection = new SectionsCollection();
			try {
				collection.addItem("Wrong object");
				fail("xs sections collections can only contain xs sections");
			} catch (error:ArgumentError) {}
		}
		
		public function testWrongAddItemAt():void {
			var collection:SectionsCollection = new SectionsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("xs sections collections can only contain xs sections");
			} catch (error:ArgumentError) {}
		}
		
		public function testWrongSetItemAt():void {
			var collection:SectionsCollection = new SectionsCollection();
			try {
				collection.setItemAt("Wrong object", 0);
				fail("xs sections collections can only contain xs sections");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddAndSetItemAt():void {
			var collection:SectionsCollection = new SectionsCollection();
			var section1:Section = new Section();
			var section2:Section = new Section();
			collection.addItem(section1);
			collection.setItemAt(section2, 0);	
			assertEquals("1", 1, collection.length);
			assertEquals("2nd", section2, collection.getItemAt(0));
		}	
	}
}