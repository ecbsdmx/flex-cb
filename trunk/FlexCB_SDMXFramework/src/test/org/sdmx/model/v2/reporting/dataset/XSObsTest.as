package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	
	public class XSObsTest extends BaseXSComponentTest
	{
		public function XSObsTest()
		{
			super();
		}
		
		override public function createXSComponent():IXSComponent {
			return createXSObs();
		}
		
		public function createXSObs():XSObservation
		{
			return new XSObservation();
		}  
		
		public static function suite():TestSuite {
			return new TestSuite(XSObsTest);
		}
	}
}