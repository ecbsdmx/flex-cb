package org.sdmx.model.v2.structure.hierarchy
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.structure.code.Code;

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
			var ca:CodeAssociation = new CodeAssociation(code);
			assertEquals("Codes should be equals", code, ca.code);
		}
		
		public function testSetAndGetId():void
		{
			var ca:CodeAssociation = new CodeAssociation(new Code("A"));
			assertNull("No ID by default", ca.id);
			var id:String = "id";
			ca.id = id;
			assertEquals("IDs should be equals", id, ca.id);
		}
		
		public function testSetAndGetChildren():void
		{
			var ca:CodeAssociation = new CodeAssociation(new Code("A"));
			assertNull("No children by default", ca.children);
			var children:CodeAssociationsCollection = 
				new CodeAssociationsCollection();
			ca.children = children;
			assertEquals("children should be equals", children, ca.children);
		}
	}
}