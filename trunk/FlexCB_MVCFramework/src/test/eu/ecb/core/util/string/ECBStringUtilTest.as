package eu.ecb.core.util.string
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class ECBStringUtilTest extends TestCase
	{
		public function ECBStringUtilTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(ECBStringUtilTest);
		}
		
		public function testUCFirst():void
		{
			assertEquals("First letter should be capitalized", "Flex", 
				ECBStringUtil.ucfirst("flex"));		
		}
	}
}