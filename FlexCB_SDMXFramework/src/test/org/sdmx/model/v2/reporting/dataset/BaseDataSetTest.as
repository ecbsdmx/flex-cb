package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	public class BaseDataSetTest extends AttachableArtefactAdapterTest
	{
		public function BaseDataSetTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function createAttachableArtefact():AttachableArtefact
		{
			return createDataSet();
		}
		
		public function createDataSet():IDataSet {
			return new BaseDataSet();
		}
		
		public static function suite():TestSuite {
			return new TestSuite(BaseDataSetTest);
		}
		
		public function testSetAndGetReportingBeginDate():void {
			var date:Date = new Date(2007, 5, 22);
			var dataSet:IDataSet = createDataSet();
			dataSet.reportingBeginDate = date;
			assertEquals("The begin dates should be equal", date, dataSet.reportingBeginDate);
		}
		
		public function testSetAndGetReportingEndDate():void {
			var date:Date = new Date(2007, 5, 22);
			var dataSet:IDataSet = createDataSet();
			dataSet.reportingEndDate = date;
			assertEquals("The end dates should be equal", date, dataSet.reportingEndDate);
		}
		
		public function testSetWrongReportingDates():void {
			var beginDate:Date = new Date(2007, 5, 22);
			var endDate:Date = new Date(2007, 5, 15);
			var dataSet:IDataSet = createDataSet();
			dataSet.reportingBeginDate = beginDate;
			try {
				dataSet.reportingEndDate = endDate;
				fail("The end date cannot be before the begin date");
			} catch (error:ArgumentError) {}
			endDate = new Date(2007, 5, 29);
			dataSet.reportingEndDate = endDate;
			beginDate = new Date(2007, 5, 30);
			try {
				dataSet.reportingBeginDate = beginDate;
				fail("The begin date cannot be after the end date");
			} catch (error:ArgumentError) {}
			beginDate = new Date(2007, 5, 22);
			dataSet.reportingBeginDate = beginDate;
			assertEquals("The begin dates should be equal", beginDate, dataSet.reportingBeginDate);
			assertEquals("The end dates should be equal", endDate, dataSet.reportingEndDate);
		}
		
		public function testSetAndGetDataExtractionDate():void {
			var date:Date = new Date(2007, 5, 22);
			var dataSet:IDataSet = createDataSet();
			dataSet.dataExtractionDate = date;
			assertEquals("The end dates should be equal", date, dataSet.dataExtractionDate);
		}
		
		public function testSetAndGetDescribedBy():void {
			var key:KeyDescriptor = new KeyDescriptor("key");
			var dimension1:Dimension = new Dimension("dim1", new Concept("FREQ"));
			var dimension2:Dimension = new Dimension("dim2", new Concept("CURRENCY"));
			var dimension3:Dimension = new Dimension("dim3", new Concept("CURRENCY_DENOM"));
			var dimension4:Dimension = new Dimension("dim4", new Concept("EXR_TYPE"));
			var dimension5:Dimension = new Dimension("dim5", new Concept("EXR_SUFFIX"));
			key.addItem(dimension1);
			key.addItem(dimension2);
			key.addItem(dimension3);
			key.addItem(dimension4);
			key.addItem(dimension5);	
			var measure:MeasureDescriptor = new MeasureDescriptor("measures");
			measure.addItem(new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var dataflow:DataflowDefinition = new DataflowDefinition("test", 
				new InternationalString(), new MaintenanceAgency("ECB"), 
				new KeyFamily("ECB_EXR", new InternationalString(), 
				new MaintenanceAgency("ECB"), key, measure));
			var dataSet:IDataSet = createDataSet();	
			dataSet.describedBy = dataflow;
			assertEquals("The dataflow definitions should be equal", dataflow, 
				dataSet.describedBy);						
		}
	}
}