package org.sdmx.model.v2.structure.hierarchy
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	public class CodeAssociationTest extends TestCase
	{
		public function CodeAssociationTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(CodeAssociationTest);
		}
		
		public function testSetAndGetCode():void
		{
			var code:Code = new Code("A");
			var ca:CodeAssociation = new CodeAssociation(code, new CodeList(
				"TEST", new InternationalString(), 
				new MaintenanceAgency("ECB")));
			assertEquals("Codes should be equals", code, ca.code);
		}
		
		public function testSetAndGetCodeList():void
		{
			var list:CodeList = new CodeList("TEST", new InternationalString(), 
				new MaintenanceAgency("ECB"));
			var ca:CodeAssociation = new CodeAssociation(new Code("A"), list);
			assertEquals("Code lists should be equals", list, ca.codeList);
		}
		
		public function testSetAndGetId():void
		{
			var ca:CodeAssociation = new CodeAssociation(new Code("A"), 
				new CodeList("TEST", new InternationalString(), 
				new MaintenanceAgency("ECB")));
			assertNull("No ID by default", ca.id);
			var id:String = "id";
			ca.id = id;
			assertEquals("IDs should be equals", id, ca.id);
		}
		
		public function testSetAndGetChildren():void
		{
			var ca:CodeAssociation = new CodeAssociation(new Code("A"), 
				new CodeList("TEST", new InternationalString(), 
				new MaintenanceAgency("ECB")));
			assertNull("No children by default", ca.children);
			var children:CodeAssociationsCollection = 
				new CodeAssociationsCollection();
			ca.children = children;
			assertEquals("children should be equals", children, ca.children);
		}
	}
}