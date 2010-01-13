package org.sdmx.stores.xml.v2.structure.hierarchy
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.hierarchy.Hierarchy;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	public class HierarchyExtractorTest extends TestCase
	{
		public function HierarchyExtractorTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(HierarchyExtractorTest);
		}
		
		public function testExtractHierarchy():void 
		{
			var xml:XML = 
				<Hierarchy id="H_ICP_ITEM_1">
    				<Name>Breakdown by purpose of consumption</Name>
    				<CodeRef>
	    				<CodelistAliasRef>ICP_ITEM</CodelistAliasRef>
	    				<CodeID>126000</CodeID>
	    			</CodeRef>
	    			<CodeRef>
	    				<CodelistAliasRef>ICP_ITEM</CodelistAliasRef>
	    				<CodeID>127000</CodeID>
	    			</CodeRef>
    			</Hierarchy>
    			
    		var codeList:CodeList = new CodeList("CL_ICP_ITEM", 
    			new InternationalString(), new MaintenanceAgency("ECB"));
    		var code1:Code = new Code("125000");
    		var code2:Code = new Code("126000");
    		var code3:Code = new Code("127000");
    		codeList.codes.addItem(code1);
    		codeList.codes.addItem(code2);
    		codeList.codes.addItem(code3);	
    		var codeLists:Object = {"ICP_ITEM": codeList};
    		
    		var extractor:HierarchyExtractor = 
    			new HierarchyExtractor(codeLists);
			var item:Hierarchy = extractor.extract(xml) as Hierarchy;
			assertNotNull("The item cannot be null", item);	
			assertEquals("The IDs should be equal", "H_ICP_ITEM_1", item.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "Breakdown by purpose of consumption", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("There should be some codes", item.children);
			assertEquals("There should be 2 items", 2, item.children.length);					
		}
	}
}