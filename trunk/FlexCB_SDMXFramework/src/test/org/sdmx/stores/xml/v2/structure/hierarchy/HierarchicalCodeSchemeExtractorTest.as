package org.sdmx.stores.xml.v2.structure.hierarchy
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.hierarchy.HierarchicalCodeScheme;
	import org.sdmx.model.v2.structure.hierarchy.Hierarchy;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	public class HierarchicalCodeSchemeExtractorTest extends TestCase
	{
		public function HierarchicalCodeSchemeExtractorTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(HierarchicalCodeSchemeExtractorTest);
		}
		
		public function testExtractHierarchicalCodeScheme():void {
			var xml:XML = 
				<HierarchicalCodelist version="1.0" agencyID="ECB" 
    		id="ICP_HIERARCHIES">
    				<Name>Hierarchies used for the HICP visualisation tools</Name>
		    		<CodelistRef>
		    			<AgencyID>ECB</AgencyID>
						<CodelistID>CL_ICP_ITEM</CodelistID>
						<Version>1.0</Version>
						<Alias>ICP_ITEM</Alias>
		    		</CodelistRef>
    				<Hierarchy id="H_ICP_ITEM_1">
    					<Name>Breakdown by purpose of consumption</Name>
    				</Hierarchy>
    				<Hierarchy id="H_ICP_ITEM_2">
    					<Name>Breakdown by type of products</Name>
    				</Hierarchy>	
    			</HierarchicalCodelist>
    			
    		var codeLists:CodeLists = new CodeLists();
    		var codeList1:CodeList = new CodeList("CL_FREQ", 
    			new InternationalString(), new MaintenanceAgency("ECB"));
    		var codeList2:CodeList = new CodeList("CL_ICP_ITEM", 
    			new InternationalString(), new MaintenanceAgency("ECB"));
    		codeLists.addItem(codeList1);
    		codeLists.addItem(codeList2);
    							
			var extractor:HierarchicalCodeSchemeExtractor =
				new HierarchicalCodeSchemeExtractor(codeLists);
			var item:HierarchicalCodeScheme = 
				extractor.extract(xml) as HierarchicalCodeScheme;
			assertNotNull("The scheme cannot be null", item);	
			assertEquals("The IDs should be equal", "ICP_HIERARCHIES", item.id);
			assertEquals("The ECB should be the maintenance agency", "ECB", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "Hierarchies used for the HICP visualisation tools", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("There should be hierarchies", item.hierarchies);
			assertEquals("There should be 2 hierarchies in the list", 2, item.hierarchies.length);
		}
	}
}