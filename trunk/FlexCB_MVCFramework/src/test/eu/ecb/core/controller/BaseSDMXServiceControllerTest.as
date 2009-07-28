package eu.ecb.core.controller
{
	import eu.ecb.core.model.BaseSDMXServiceModel;
	
	import flexunit.framework.TestSuite;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.sdmx.stores.xml.v2.SDMXDataFormats;
	
	public class BaseSDMXServiceControllerTest extends ControllerAdapterTest
	{
		public function BaseSDMXServiceControllerTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(BaseSDMXServiceControllerTest);
		}
		
		override public function createController():IController {
			_model = new BaseSDMXServiceModel();
			return new BaseSDMXServiceController(_model 
				as BaseSDMXServiceModel);
		}
		
		public function testSetAndGetDataFile():void
		{
			assertNull("No data file by default", 
				(_controller as BaseSDMXServiceController).dataFile);
			var dataFile:URLRequest = new URLRequest("test.xml");
			(_controller as BaseSDMXServiceController).dataFile = dataFile;
			assertEquals("data files should be equal", dataFile,
				(_controller as BaseSDMXServiceController).dataFile);	
		}
		
		public function testSetAndGetStructureFile():void
		{
			assertNull("No structure file by default", 
				(_controller as BaseSDMXServiceController).structureFile);
			var file:URLRequest = new URLRequest("testS.xml");
			(_controller as BaseSDMXServiceController).structureFile = file;
			assertEquals("structure files should be equal", file,
				(_controller as BaseSDMXServiceController).structureFile);	
		}
		
		public function testSetAndGetObservationAttributeFLag():void
		{
			assertFalse("Flag not disabled by default", (_controller as 
				BaseSDMXServiceController).disableObservationAttribute);
			(_controller as BaseSDMXServiceController).
				disableObservationAttribute = true;	
			assertTrue("Flag should now be disabled", (_controller as 
				BaseSDMXServiceController).disableObservationAttribute);	
		}
		
		public function testSetAndGetOptimisationLevel():void
		{
			assertEquals("No optimisation by default", 0, (_controller as 
				BaseSDMXServiceController).optimisationLevel);
			(_controller as BaseSDMXServiceController).optimisationLevel = 1
			assertEquals("Optimisation level should be 1", 1, (_controller as 
				BaseSDMXServiceController).optimisationLevel);
		}
		
		public function testFetchKeyFamily():void
		{
			(_controller as BaseSDMXServiceController).structureFile = 
				new URLRequest("testData/ecb_exr1.xml");
			_model.addEventListener(BaseSDMXServiceModel.
				KEY_FAMILIES_UPDATED, addAsync(handleKF, 3000));
			(_controller as BaseSDMXServiceController).fetchKeyFamily();	
		}
		
		public function testFetchDataSet():void
		{
			(_controller as BaseSDMXServiceController).structureFile = 
				new URLRequest("testData/ecb_exr1.xml");
			(_controller as BaseSDMXServiceController).dataFile = 
				new URLRequest("testData/aud_monthly.xml");	
			_model.addEventListener(BaseSDMXServiceModel.
				DATA_SET_UPDATED, addAsync(handleDS, 3000));
			(_controller as BaseSDMXServiceController).fetchData();	
		}
		
		public function testFetchDataSetWithFormat():void
		{
			(_controller as BaseSDMXServiceController).structureFile = 
				new URLRequest("testData/ecb_exr1.xml");
			(_controller as BaseSDMXServiceController).dataFile = 
				new URLRequest("testData/aud_monthly.xml");	
			_model.addEventListener(BaseSDMXServiceModel.
				DATA_SET_UPDATED, addAsync(handleDS, 3000));
			(_controller as BaseSDMXServiceController).fetchData(null, 
				SDMXDataFormats.SDMX_ML_COMPACT);	
		}
	
		
		protected function handleKF(event:Event):void
		{
			assertNotNull("There should be some kf",
				(_model as BaseSDMXServiceModel).keyFamilies);
			assertTrue("There should be some kf in the collection",
				(_model as BaseSDMXServiceModel).keyFamilies.length > 0);
		}
		
		protected function handleDS(event:Event):void
		{
			assertNotNull("There should be some ds",
				(_model as BaseSDMXServiceModel).dataSet);
			assertTrue("There should be some time series in the collection",
				(_model as BaseSDMXServiceModel).dataSet.timeseriesKeys.length
					 > 0);
		}
	}
}