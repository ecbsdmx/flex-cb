package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	
	public class XSDataSetTest extends BaseDataSetTest
	{
		public function XSDataSetTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(XSDataSetTest);
		}
		
		override public function createDataSet():IDataSet {
			return new XSDataSet();
		}
		
		public function testSetAndGetGroups():void
		{
			var dataSet:XSDataSet = createDataSet() as XSDataSet;
			
			assertEquals("There should be no group by default", 0, 
				dataSet.groups.length);
				
			var groups:XSGroupsCollection = new XSGroupsCollection();	
			dataSet.groups = groups;
			
			assertEquals("Groups should be equal", groups, dataSet.groups); 				
		}
		
		public function testSetAndGetKeyValues():void
		{
			var keyValues:KeyValuesCollection = new KeyValuesCollection();
			var keyValue1:KeyValue = new KeyValue(new Code("M"), 
				new Dimension("FREQ", new Concept("FREQ")));
			var keyValue2:KeyValue = new KeyValue(new Code("U2"), 
				new Dimension("REF_AREA", new Concept("REF_AREA")));
			keyValues.addItem(keyValue1);		
			keyValues.addItem(keyValue2);
			
			var component:IXSComponent = createDataSet() as XSDataSet;
			
			assertNull("No key values by default", component.keyValues);
			component.keyValues = keyValues;
			assertEquals("Key values should be equal", keyValues, 
				component.keyValues);
		}
		
		public function testSetAndGetValueFor():void
		{
			var component:IXSComponent = createDataSet() as XSDataSet;
			assertNull("No key by default", component.valueFor);
			var valueFor:KeyDescriptor = new KeyDescriptor();
			component.valueFor = valueFor;
			assertEquals("The key should be equal", valueFor, 
				component.valueFor);
		}
	}
}