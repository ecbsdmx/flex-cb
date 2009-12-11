package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	
	public class XSGroupTest extends BaseXSComponentTest
	{
		public function XSGroupTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function createXSComponent():IXSComponent {
			return new XSGroup();
		}
		
		public static function suite():TestSuite {
			return new TestSuite(XSGroupTest);
		}
		
		public function testSetAndGetSections():void
		{
			var group:XSGroup = createXSComponent() as XSGroup;
			
			assertEquals("There should be no section by default", 0, 
				group.sections.length);
				
			var sections:SectionsCollection = new SectionsCollection();
			group.sections = sections;
			
			assertEquals("Sections should be equal", sections, group.sections); 				
		}
		
	}
}