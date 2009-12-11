package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.MeasureTypeDimension;
	import org.sdmx.model.v2.structure.keyfamily.UncodedXSMeasure;
	
	public class UncodedXSObservationTest extends XSObsTest
	{
		private var _value:String;
		
		private var _measure:UncodedXSMeasure;
		
		public function UncodedXSObservationTest()
		{
			super();
		}
		
		override public function createXSObs():XSObservation
		{
			_value = "1.5";
			var concept:Concept = new Concept("CURRENCY");
			_measure = new UncodedXSMeasure("measure", concept,	new Code("USD"), 
				new MeasureTypeDimension("CURRENCY", concept)); 
			return new UncodedXSObservation(_value, _measure);
		}  
		
		public static function suite():TestSuite 
		{
			return new TestSuite(UncodedXSObservationTest);
		}
		
		public function testGetValue():void
		{
			var obs:UncodedXSObservation = 
				createXSObs() as UncodedXSObservation;
			assertEquals("Value should be equal", _value, obs.value);
			try {
				obs.value = "";
				fail("Should not be possible to set null code");
			} catch (e:ArgumentError) {}
		}
		
		public function testGetMeasure():void
		{
			var obs:UncodedXSObservation = 
				createXSObs() as UncodedXSObservation;
			assertEquals("Measure should be equal", _measure, obs.measure);	
			try {
				obs.measure = null;
				fail("Should not be possible to set null measure");
			} catch (e:ArgumentError) {}	
		}
	}
}