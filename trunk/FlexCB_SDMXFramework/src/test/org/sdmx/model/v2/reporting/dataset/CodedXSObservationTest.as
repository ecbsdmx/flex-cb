package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.CodedXSMeasure;
	import org.sdmx.model.v2.structure.keyfamily.MeasureTypeDimension;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	
	public class CodedXSObservationTest extends XSObsTest
	{
		private var _value:Code;
		
		private var _measure:CodedXSMeasure;
		
		public function CodedXSObservationTest()
		{
			super();
		}
		
		override public function createXSObs():XSObservation
		{
			_value = new Code("A");
			var concept:Concept = new Concept("CURRENCY");
			_measure = new CodedXSMeasure("measure", concept, new Code("USD"), 
				new MeasureTypeDimension("CURRENCY", concept), new CodeList(
				"CL", new InternationalString(), new MaintenanceAgency("ECB"))); 
			return new CodedXSObservation(_value, _measure);
		}  
		
		public static function suite():TestSuite 
		{
			return new TestSuite(CodedXSObservationTest);
		}
		
		public function testGetValue():void
		{
			var obs:CodedXSObservation = 
				createXSObs() as CodedXSObservation;
			assertEquals("Value should be equal", _value, obs.value);
			try {
				obs.value = null;
				fail("Should not be possible to set null code");
			} catch (e:ArgumentError) {}
		}
		
		public function testGetMeasure():void
		{
			var obs:CodedXSObservation = 
				createXSObs() as CodedXSObservation;
			assertEquals("Measure should be equal", _measure, obs.measure);
			try {
				obs.measure = null;
				fail("Should not be possible to set null measure");
			} catch (e:ArgumentError) {}	
		}
	}
}