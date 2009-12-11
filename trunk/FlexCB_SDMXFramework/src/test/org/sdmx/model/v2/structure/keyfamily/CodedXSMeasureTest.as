package org.sdmx.model.v2.structure.keyfamily
{
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	
	public class CodedXSMeasureTest extends XSMeasureTest
	{
		private var _codeList:CodeList;
		
		public function CodedXSMeasureTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CodedXSMeasureTest);
		}
		
		override public function createMeasure():XSMeasure {
			_code = new Code("RU");
			_dimension = 
				new MeasureTypeDimension("REF_AREA", new Concept("REF_AREA"));
			_codeList = new CodeList("cl", new InternationalString(), 
				new MaintenanceAgency("ECB"));	
			return new CodedXSMeasure(_id, _item, _code, _dimension, _codeList);
		}
		
		public function testSetAndGetCodeList():void
		{
			var measure:CodedXSMeasure = createMeasure() as CodedXSMeasure;
			assertNotNull("measure is not null", measure);
			assertNotNull("code list cannot be null", 
				measure.localRepresentation);
			assertEquals("code lists should be equal", _codeList, 
				measure.localRepresentation);
		}
	}
}