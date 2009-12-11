package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.MeasureTypeDimension;
	import org.sdmx.model.v2.structure.keyfamily.UncodedXSMeasure;

	public class XSObservationsCollectionTest extends TestCase
	{
		public function XSObservationsCollectionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(XSObservationsCollectionTest);
		}
		
		public function testWrongAddItem():void {
			var collection:XSObservationsCollection = 
				new XSObservationsCollection();
			try {
				collection.addItem("Wrong object");
				fail("xs obs collections can only contain xs obs");
			} catch (error:ArgumentError) {}
		}
		
		public function testWrongAddItemAt():void {
			var collection:XSObservationsCollection = 
				new XSObservationsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("xs obs collections can only contain xs obs");
			} catch (error:ArgumentError) {}
		}
		
		public function testWrongSetItemAt():void {
			var collection:XSObservationsCollection = 
				new XSObservationsCollection();
			try {
				collection.setItemAt("Wrong object", 0);
				fail("xs obs collections can only contain xs obs");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddAndSetItemAt():void {
			var collection:XSObservationsCollection = 
				new XSObservationsCollection();
				
			var concept:Concept = new Concept("REF_AREA");
			var dimension:MeasureTypeDimension = 
				new MeasureTypeDimension("REF_AREA", concept);	
			var measure1:UncodedXSMeasure = new UncodedXSMeasure("measure1",
				concept, new Code("FR"), dimension);
			var measure2:UncodedXSMeasure = new UncodedXSMeasure("measure2",
				concept, new Code("RU"), dimension);		
			var obs1:UncodedXSObservation = 
				new UncodedXSObservation("1", measure1);
			var obs2:UncodedXSObservation = 
				new UncodedXSObservation("2", measure2);
			collection.addItem(obs1);
			collection.setItemAt(obs2, 0);	
			assertEquals("1", 1, collection.length);
			assertEquals("2nd", obs2, collection.getItemAt(0));
		}
		
		public function testGetCodeFromMeasure():void {
			var collection:XSObservationsCollection = 
				new XSObservationsCollection();
				
			var concept:Concept = new Concept("REF_AREA");
			var dimension:MeasureTypeDimension = 
				new MeasureTypeDimension("REF_AREA", concept);	
			var measure1:UncodedXSMeasure = new UncodedXSMeasure("measure1",
				concept, new Code("A"), dimension);
			var measure2:UncodedXSMeasure = new UncodedXSMeasure("measure2",
				concept, new Code("B"), dimension);		
			var measure3:UncodedXSMeasure = new UncodedXSMeasure("measure2",
				concept, new Code("C"), dimension);	
			var obs1:UncodedXSObservation = 
				new UncodedXSObservation("1", measure1);
			var obs2:UncodedXSObservation = 
				new UncodedXSObservation("2", measure2);
			var obs3:UncodedXSObservation = 
				new UncodedXSObservation("3", measure3);	
			collection.addItem(obs1);
			collection.addItem(obs2);
			collection.addItem(obs3);
			assertEquals("Should be 3 items in the collection", 
				3, collection.length);
			assertEquals("Should get obs B", obs2, 
				collection.getObsByCode("B"));
		}		
	}
}