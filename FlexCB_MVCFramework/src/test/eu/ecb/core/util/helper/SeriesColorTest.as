package eu.ecb.core.util.helper
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.collections.ArrayCollection;

	public class SeriesColorTest extends TestCase
	{
		public function SeriesColorTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(SeriesColorTest);
		}
		
		public function testGetColorCollection():void
		{
			var collection:ArrayCollection = SeriesColors.getColors();
			assertNotNull("There should be a collection", collection);
			assertTrue("There should be some colors", collection.length > 0);
			for each (var color:Object in collection) {
				assertTrue("Should be a color", color is uint);			
			}		
		}
	}
}