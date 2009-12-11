package org.sdmx.model.v2.base.structure
{
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.type.XSAttachmentLevel;
	
	public class XSAttachableComponentTest extends ComponentTest
	{
		public function XSAttachableComponentTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function createComponent():Component 
		{
			return new XSAttachableComponent(_id, _item);
		}
				
		public static function suite():TestSuite 
		{
			return new TestSuite(XSAttachableComponentTest);
		}
		
		public function testSetAndGetXSAttachmentLevel():void
		{
			var component:XSAttachableComponent = createComponent() as 
				XSAttachableComponent;
				
			assertNull("By default, no attachment level", 
				component.xsAttachmentLevel);
			var level:String = XSAttachmentLevel.SECTION;
			component.xsAttachmentLevel = level;	
			assertEquals("Attachment levels should be equal", level, 
				component.xsAttachmentLevel);			
		}
		
		public function testSetXSWrongAttachmentLevel():void
		{
			var component:XSAttachableComponent = createComponent() as 
				XSAttachableComponent;
			try {
				component.xsAttachmentLevel = "wrong";
				fail("Should not be possible to set wrong xsAttachmentLevel");
			} catch (e:ArgumentError) {}	
				
		}
	}
}