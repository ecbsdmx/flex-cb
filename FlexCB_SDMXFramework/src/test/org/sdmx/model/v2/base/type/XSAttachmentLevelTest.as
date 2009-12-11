package org.sdmx.model.v2.base.type
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class XSAttachmentLevelTest extends TestCase
	{
		public function XSAttachmentLevelTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(XSAttachmentLevelTest);
		}
		
		public function testContains():void {
			assertTrue("This should be a valid SDMX xs attachment level: XSDataSet", XSAttachmentLevel.contains("XSDataSet"));
			assertTrue("This should be a valid SDMX xs attachment level: Group", XSAttachmentLevel.contains("Group"));						
			assertTrue("This should be a valid SDMX xsattachment level: Section", XSAttachmentLevel.contains("Section"));
			assertTrue("This should be a valid SDMX xs attachment level: XSObservation", XSAttachmentLevel.contains("XSObservation"));			
			assertFalse("This should not be a valid SDMX xs attachment level", XSAttachmentLevel.contains("My own self-made level"));
		}
	}
}