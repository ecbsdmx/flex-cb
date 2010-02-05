package org.sdmx.model.v2.structure.hierarchy
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	public class CodeAssociationsCollectionTest extends TestCase
	{
		public function CodeAssociationsCollectionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CodeAssociationsCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:CodeAssociationsCollection = 
				new CodeAssociationsCollection();
			try {
				collection.addItem("Wrong object");
				fail("CA collections can only contain CA");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:CodeAssociationsCollection = 
				new CodeAssociationsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("CA collections can only contain CA");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:CodeAssociationsCollection = 
				new CodeAssociationsCollection();
			var list:CodeList = new CodeList("TEST", new InternationalString(), 
				new MaintenanceAgency("ECB"));	
			var assoc1:CodeAssociation = 
				new CodeAssociation(new Code("A"), list);
			var assoc2:CodeAssociation = 
				new CodeAssociation(new Code("B"), list);
			collection.addItem(assoc1);
			collection.setItemAt(assoc2, 0);
			assertEquals("There should be 1 assoc in the code list", 1, 
				collection.length);
			assertTrue("Assoc2", collection.contains(assoc2));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("CA collections can only contain CA");
			} catch (error:ArgumentError) {}
		}
	}
}