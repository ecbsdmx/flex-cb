package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	
	public class SectionTest extends BaseXSComponentTest
	{
		public function SectionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function createXSComponent():IXSComponent {
			return new Section();
		}
		
		public static function suite():TestSuite {
			return new TestSuite(SectionTest);
		}
		
		public function testSetAndGetObservations():void
		{
			var section:Section = createXSComponent() as Section;
			
			assertEquals("There should be no observations by default", 0, 
				section.observations.length);
				
			var obs:XSObservationsCollection = new XSObservationsCollection();
			section.observations = obs;
			
			assertEquals("Observations should be equal", obs, 
				section.observations); 				
		}
	}
}