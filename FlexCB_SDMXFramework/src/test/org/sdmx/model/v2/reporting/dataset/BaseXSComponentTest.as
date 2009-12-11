package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	
	public class BaseXSComponentTest extends AttachableArtefactAdapterTest
	{
		public function BaseXSComponentTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function createAttachableArtefact():AttachableArtefact
		{
			return createXSComponent();
		}
		
		public function createXSComponent():IXSComponent {
			return new BaseXSComponent();
		}
		
		public static function suite():TestSuite {
			return new TestSuite(BaseXSComponentTest);
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
			
			var component:IXSComponent = createXSComponent();
			
			assertNull("No key values by default", component.keyValues);
			component.keyValues = keyValues;
			assertEquals("Key values should be equal", keyValues, 
				component.keyValues);
		}
		
		public function testSetAndGetValueFor():void
		{
			var component:IXSComponent = createXSComponent();
			assertNull("No key by default", component.valueFor);
			var valueFor:KeyDescriptor = new KeyDescriptor();
			component.valueFor = valueFor;
			assertEquals("The key should be equal", valueFor, 
				component.valueFor);
				
			try {
				component.valueFor = null;
				fail("Should not be possible to set null keys");
			} catch (error:ArgumentError) {}	
		}
	}
}