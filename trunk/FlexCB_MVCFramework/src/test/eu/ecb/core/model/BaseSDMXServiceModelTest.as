package eu.ecb.core.model
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
	import org.sdmx.model.v2.structure.category.CategorieSchemesCollection;
	import org.sdmx.model.v2.structure.category.CategoryScheme;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	public class BaseSDMXServiceModelTest extends TestCase
	{
		protected var _model:ISDMXServiceModel; 
		
		public function BaseSDMXServiceModelTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
			_model = createModel();
			assertNotNull("Problem creating model", _model);
		}
		
		public function createModel():ISDMXServiceModel {
			return new BaseSDMXServiceModel();
		}
		
		public static function suite():TestSuite {
			return new TestSuite(BaseSDMXServiceModelTest);
		}
		
		public function testCategorySchemes():void
		{
			assertNull("By default, no categories", _model.categorySchemes);
			assertNull("By default, no categories 2", 
				_model.allCategorySchemes);
			var csa1:CategorieSchemesCollection = 
				new CategorieSchemesCollection();
			var cs1:CategoryScheme = new CategoryScheme("cs1", 
				new InternationalString(), new MaintenanceAgency("ecb"));
			csa1.addItem(cs1);
			_model.categorySchemes = csa1;
			assertNotNull("There should be some cs", _model.categorySchemes);
			assertEquals("There should be one cs", 1, 
				_model.categorySchemes.length);					 
			assertEquals("There should be one cs in total", 1, 
				_model.allCategorySchemes.length);
			assertTrue("cs1 should be in both collections", 
				_model.categorySchemes.contains(cs1) && 
				_model.allCategorySchemes.contains(cs1));	
			var csa2:CategorieSchemesCollection = 
				new CategorieSchemesCollection();
			var cs2:CategoryScheme = new CategoryScheme("cs2", 
				new InternationalString(), new MaintenanceAgency("bis"));
			csa2.addItem(cs2);
			_model.categorySchemes = csa2;
			assertNotNull("There should be some cs", _model.categorySchemes);
			assertEquals("There should be one cs", 1, 
				_model.categorySchemes.length);					 
			assertEquals("There should be 2 cs in total", 2, 
				_model.allCategorySchemes.length);
			assertFalse("cs1 should not be in the light collection",  
				_model.categorySchemes.contains(cs1));	
			assertTrue("cs1 should be in the full collection",  
				_model.allCategorySchemes.contains(cs1));	
			assertTrue("cs2 should be in both collections", 
				_model.categorySchemes.contains(cs2) && 
				_model.allCategorySchemes.contains(cs2));	
		}
		
		public function testDataflows():void
		{
			var key:KeyDescriptor = new KeyDescriptor("key");
			var dimension1:Dimension = 
				new Dimension("dim1", new Concept("FREQ"));
			var dimension2:Dimension = 
				new Dimension("dim2", new Concept("CURRENCY"));
			var dimension3:Dimension = 
				new Dimension("dim3", new Concept("CURRENCY_DENOM"));
			var dimension4:Dimension = 
				new Dimension("dim4", new Concept("EXR_TYPE"));
			var dimension5:Dimension = 
				new Dimension("dim5", new Concept("EXR_SUFFIX"));
			key.addItem(dimension1);
			key.addItem(dimension2);
			key.addItem(dimension3);
			key.addItem(dimension4);
			key.addItem(dimension5);	
			var measure:MeasureDescriptor = new MeasureDescriptor("measures");
			measure.addItem(new UncodedMeasure("measure", 
				new Concept("OBS_VALUE")));
			var kf:KeyFamily = 
				new KeyFamily("ECB_EXR1", new InternationalString(), 
				new MaintenanceAgency("ecb"), key, measure);	
			assertNull("By default, no df", _model.dataflowDefinitions);
			assertNull("By default, no df 2", _model.allDataflowDefinitions);
			var dfa1:DataflowsCollection = new DataflowsCollection();
			var df1:DataflowDefinition = new DataflowDefinition("cs1", 
				new InternationalString(), new MaintenanceAgency("ecb"), kf);
			dfa1.addItem(df1);
			_model.dataflowDefinitions = dfa1;
			assertNotNull("There should be some df", 
				_model.dataflowDefinitions);
			assertEquals("There should be one df", 1, 
				_model.dataflowDefinitions.length);					 
			assertEquals("There should be one df in total", 1, 
				_model.allDataflowDefinitions.length);
			assertTrue("df1 should be in both collections", 
				_model.dataflowDefinitions.contains(df1) && 
				_model.allDataflowDefinitions.contains(df1));	
			var dfa2:DataflowsCollection = new DataflowsCollection();
			var df2:DataflowDefinition = new DataflowDefinition("df2", 
				new InternationalString(), new MaintenanceAgency("bis"), kf);
			dfa2.addItem(df2);
			_model.dataflowDefinitions = dfa2;
			assertNotNull("There should be some df", 
				_model.dataflowDefinitions);
			assertEquals("There should be one df", 1, 
				_model.dataflowDefinitions.length);					 
			assertEquals("There should be 2 df in total", 2, 
				_model.allDataflowDefinitions.length);
			assertFalse("df1 should not be in the light collection",  
				_model.dataflowDefinitions.contains(df1));	
			assertTrue("df1 should be in the full collection",  
				_model.allDataflowDefinitions.contains(df2));	
			assertTrue("df2 should be in both collections", 
				_model.dataflowDefinitions.contains(df2) && 
				_model.allDataflowDefinitions.contains(df2));	
		}
		
		public function testKeyFamilies():void
		{
			var key:KeyDescriptor = new KeyDescriptor("key");
			var dimension1:Dimension = 
				new Dimension("dim1", new Concept("FREQ"));
			var dimension2:Dimension = 
				new Dimension("dim2", new Concept("CURRENCY"));
			var dimension3:Dimension = 
				new Dimension("dim3", new Concept("CURRENCY_DENOM"));
			var dimension4:Dimension = 
				new Dimension("dim4", new Concept("EXR_TYPE"));
			var dimension5:Dimension = 
				new Dimension("dim5", new Concept("EXR_SUFFIX"));
			key.addItem(dimension1);
			key.addItem(dimension2);
			key.addItem(dimension3);
			key.addItem(dimension4);
			key.addItem(dimension5);	
			var measure:MeasureDescriptor = new MeasureDescriptor("measures");
			measure.addItem(new UncodedMeasure("measure", 
				new Concept("OBS_VALUE")));
			var kf1:KeyFamily = 
				new KeyFamily("ECB_EXR1", new InternationalString(), 
				new MaintenanceAgency("ecb"), key, measure);	
			var kf2:KeyFamily = 
				new KeyFamily("ECB_BSI1", new InternationalString(), 
				new MaintenanceAgency("bis"), key, measure);	
			assertNull("By default, no kf", _model.keyFamilies);
			assertNull("By default, no kf 2", _model.allKeyFamilies);
			var kfa1:KeyFamilies = new KeyFamilies();
			kfa1.addItem(kf1);
			_model.keyFamilies = kfa1;
			assertNotNull("There should be some kf", _model.keyFamilies);
			assertEquals("There should be one kf", 1, 
				_model.keyFamilies.length);					 
			assertEquals("There should be one kf in total", 1, 
				_model.allKeyFamilies.length);
			assertTrue("kf should be in both collections", 
				_model.keyFamilies.contains(kf1) && 
				_model.allKeyFamilies.contains(kf1));	
			var kfa2:KeyFamilies = new KeyFamilies();
			kfa2.addItem(kf2);
			_model.keyFamilies = kfa2;
			assertNotNull("There should be some kf", _model.keyFamilies);
			assertEquals("There should be one kf", 1, 
				_model.keyFamilies.length);					 
			assertEquals("There should be 2 kf in total", 2, 
				_model.allKeyFamilies.length);
			assertFalse("kf1 should not be in the light collection",  
				_model.keyFamilies.contains(kf1));	
			assertTrue("kf1 should be in the full collection",  
				_model.allKeyFamilies.contains(kf2));	
			assertTrue("kf2 should be in both collections", 
				_model.keyFamilies.contains(kf2) && 
				_model.allKeyFamilies.contains(kf2));
		}
		
		public function testDataSets():void
		{
			var keys1:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			var keyDescriptor:KeyDescriptor = new KeyDescriptor("test");
			keys1.addItem(new TimeseriesKey(keyDescriptor));
			var groups1:GroupKeysCollection = new GroupKeysCollection();
			var groupDescriptor:GroupKeyDescriptor = 
				new GroupKeyDescriptor("Test");
			groups1.addItem(new GroupKey(groupDescriptor));
			var ds1:DataSet = new DataSet();
			ds1.timeseriesKeys = keys1;
			ds1.groupKeys = groups1;
						
			var keys2:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			var keyDescriptor:KeyDescriptor = new KeyDescriptor("test");
			keys2.addItem(new TimeseriesKey(keyDescriptor));
			var groups2:GroupKeysCollection = new GroupKeysCollection();
			var groupDescriptor:GroupKeyDescriptor = 
				new GroupKeyDescriptor("Test2");
			groups2.addItem(new GroupKey(groupDescriptor));
			var ds2:DataSet = new DataSet();
			ds2.timeseriesKeys = keys2;
			ds2.groupKeys = groups2;
			
			assertNull("By default, no ds", _model.dataSet);
			assertNull("By default, no ds 2", _model.allDataSets);
			_model.dataSet = ds1;
			assertNotNull("There should be some ds", _model.dataSet);
			assertEquals("It should be ds 1", ds1, _model.dataSet);					 
			assertEquals("There should be one series in total", 1, 
				_model.allDataSets.timeseriesKeys.length );
			assertEquals("There should be one group in total", 1, 
				_model.allDataSets.groupKeys.length );	
			_model.dataSet = ds2;
			assertNotNull("There should be some ds", _model.dataSet);
			assertEquals("It should be ds2", ds2, _model.dataSet);					 
			assertEquals("There should be 2 series in total", 2, 
				_model.allDataSets.timeseriesKeys.length);
			assertEquals("There should be 2 groups in total", 2, 
				_model.allDataSets.groupKeys.length);	
		}
	}
}