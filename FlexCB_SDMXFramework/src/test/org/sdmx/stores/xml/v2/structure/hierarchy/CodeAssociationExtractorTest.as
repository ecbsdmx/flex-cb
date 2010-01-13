package org.sdmx.stores.xml.v2.structure.hierarchy
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.hierarchy.CodeAssociation;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	public class CodeAssociationExtractorTest extends TestCase
	{
		public function CodeAssociationExtractorTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(CodeAssociationExtractorTest);
		}
		
		public function testExtractCodeAssociation():void
		{
			var xml:XML = 
				<CodeRef>
    				<CodelistAliasRef>ICP_ITEM</CodelistAliasRef>
    				<CodeID>126000</CodeID>
    				<CodeRef>
	    				<CodelistAliasRef>ICP_ITEM</CodelistAliasRef>
	    				<CodeID>126100</CodeID>
	    				<CodeRef>
		    				<CodelistAliasRef>ICP_ITEM</CodelistAliasRef>
		    				<CodeID>126110</CodeID>
		    			</CodeRef>
	    			</CodeRef>
	    			<CodeRef>
	    				<CodelistAliasRef>ICP_ITEM</CodelistAliasRef>
	    				<CodeID>126200</CodeID>
	    			</CodeRef>
    			</CodeRef>
    			
    		var codeList:CodeList = new CodeList("CL_ICP_ITEM", 
    			new InternationalString(), new MaintenanceAgency("ECB"));
    		var code1:Code = new Code("126000");
    		var code2:Code = new Code("126100");
    		var code3:Code = new Code("126110");
    		var code4:Code = new Code("126200");
    		var code5:Code = new Code("127000");
    		codeList.codes.addItem(code5);
    		codeList.codes.addItem(code1);
    		codeList.codes.addItem(code2);
    		codeList.codes.addItem(code3);	
    		codeList.codes.addItem(code4);
    		var codeLists:Object = {"ICP_ITEM": codeList};
    		
    		var extractor:CodeAssociationExtractor = 
    			new CodeAssociationExtractor(codeLists);
			var item:CodeAssociation = 
				extractor.extract(xml) as CodeAssociation;
			assertNotNull("The item cannot be null", item);	
			assertEquals("Code 1 is the root", code1, item.code);
			assertNotNull("There should be some children", item.children);
			assertEquals("There should be 2 items", 2, item.children.length);
			var child1:CodeAssociation = 
				item.children.getItemAt(0) as CodeAssociation;	
			var child2:CodeAssociation = 
				item.children.getItemAt(1) as CodeAssociation;
			assertEquals("Code 2 is the 1st child", code2, child1.code);
			assertEquals("Code 4 is the 2nd child", code4, child2.code);
			assertNotNull("There should be some children for 1st child", child1.children);
			assertEquals("There should be 1 child for child1", 1, child1.children.length);
			var child11:CodeAssociation = 
				child1.children.getItemAt(0) as CodeAssociation;
			assertEquals("Code 3 is the child of child 1", code3, child11.code);	
			assertEquals("There should be no children for the child of child 1", 0, child11.children.length);		
			assertEquals("There should be no children for 2nd child", 0, child2.children.length);
		}
	}
}