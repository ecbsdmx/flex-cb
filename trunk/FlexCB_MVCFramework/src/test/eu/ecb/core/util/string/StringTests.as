package eu.ecb.core.util.string
{
	import flexunit.framework.TestSuite;
	
	public class StringTests
	{
		public static function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(ECBStringUtilTest.suite());
 			return suite;
		}
	}
}