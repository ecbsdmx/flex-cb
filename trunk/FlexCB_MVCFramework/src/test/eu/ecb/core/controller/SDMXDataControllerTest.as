package eu.ecb.core.controller
{
	import eu.ecb.core.model.BaseSDMXServiceModel;
	import eu.ecb.core.model.ISDMXDataModel;
	import eu.ecb.core.model.SDMXDataModel;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import flexunit.framework.TestSuite;
	
	import mx.collections.ArrayCollection;
	
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
	
	public class SDMXDataControllerTest extends PassiveSDMXDataControllerTest
	{
		public function SDMXDataControllerTest()
		{
			super();
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(SDMXDataControllerTest);
		}
		
		override public function createController():IController 
		{
			_model = new SDMXDataModel();
			return new SDMXDataController(_model as ISDMXDataModel, 
				new URLRequest("testData/aud_monthly.xml"), 
				new URLRequest("testData/ecb_exr1.xml"), false);
		}
		
		override public function testSetAndGetDataFile():void
		{
			assertEquals("Data files should be = ", "testData/aud_monthly.xml", 
				(_controller as SDMXDataController).dataFile.url);
		}
		
		override public function testSetAndGetStructureFile():void
		{
			assertEquals("Structure files should be = ", 
				"testData/ecb_exr1.xml", 
				(_controller as SDMXDataController).structureFile.url);	
		}
		
		public function testLoadData():void
		{
			_model.addEventListener(BaseSDMXServiceModel.
				DATA_SET_UPDATED, addAsync(handleDS, 3000));
			(_controller as SDMXDataController).loadData();	
		}
		
		public function testFetchingMultipleFiles():void
		{
			_model.addEventListener(BaseSDMXServiceModel.
				DATA_SET_UPDATED, addAsync(handleMultipleDS, 3000));
			var files:ArrayCollection = new ArrayCollection();
			files.addItem(new URLRequest("testData/neer.xml"));
			files.addItem(new URLRequest("testData/aud_monthly.xml"));	
			(_controller as SDMXDataController).fetchFiles(files);
		}
		
		protected function handleMultipleDS(event:Event):void
		{
			assertNotNull("There should be some ds",
				(_model as BaseSDMXServiceModel).dataSet);
			var series:TimeseriesKeysCollection = 
				(_model as BaseSDMXServiceModel).dataSet.timeseriesKeys;	
			assertEquals("There should be 2 time series kf in the collection", 
				2, series.length);
			assertEquals("1 series should be = ", "D.Z59.EUR.EN00.A", 
				(series.getItemAt(0) as TimeseriesKey).seriesKey);	
			assertEquals("2nd series should be =", "M.AUD.EUR.SP00.A",
				(series.getItemAt(1) as TimeseriesKey).seriesKey);	
		}
	}
}