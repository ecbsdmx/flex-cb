package eu.ecb.core.util.helper
{
	import flexunit.framework.TestSuite;
	
	public class HelperTests
	{
		public static function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(SeriesColorTest.suite());
 			return suite;
		}
	}
}