// ECB/SIS Public License, version 1.0, document reference SIS/2001/116
//
// Copyright (C) 2008 European Central Bank. All rights reserved.
//
// Redistribution and use in source and binary forms,
// with or without modification, are permitted
// provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// Neither the name of the European Central Bank
// nor the names of its contributors may be used to endorse or promote products
// derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
package eu.ecb.core.util.formatter.observation
{
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.structure.keyfamily.CodedDataAttribute;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.reporting.dataset.AttributeValuesCollection;
	
	/**
	 *	@private 
	 */
	public class EXRObservationFormatterTest extends ObservationAdapterFormatterTest
	{
		private var _formatter:EXRObservationFormatter;
		
		public function EXRObservationFormatterTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(EXRObservationFormatterTest);
		}
		
		public override function setUp():void 
		{
			super.setUp();
			_formatter = createEXRFormatter();
			assertNotNull("Problem creating EXR formatter", _formatter);
		}
		
		public override function createFormatter():ObservationAdapterFormatter 
		{
			return createEXRFormatter();
		}
		
		public function createEXRFormatter():EXRObservationFormatter 
		{
			return new EXRObservationFormatter();
		}
		
		public function testFormat():void
		{
			var dim0:Dimension = new Dimension("dim0", new Concept("FREQ"));
			var dim1:Dimension = new Dimension("dim1", new Concept("CURRENCY"));
			var dim2:Dimension = new Dimension("dim2", new Concept("CURRENCY_DENOM"));
			var dim3:Dimension = new Dimension("dim3", new Concept("EXR_TYPE"));
			var dim4:Dimension = new Dimension("dim4", new Concept("EXR_SUFFIX"));

			var groupKeyValues:KeyValuesCollection = new KeyValuesCollection();
			groupKeyValues.addItem(new KeyValue(new Code("RUB"), dim1));
			groupKeyValues.addItem(new KeyValue(new Code("EUR"), dim2));
			groupKeyValues.addItem(new KeyValue(new Code("S"), dim3));
			groupKeyValues.addItem(new KeyValue(new Code("A"), dim4));
			var group:GroupKey = new GroupKey(new GroupKeyDescriptor("group"));
			group.keyValues = groupKeyValues;
			var unitMult:CodedAttributeValue = new CodedAttributeValue(group, 
				new Code("0"), new CodedDataAttribute("UNIT_MULT", 
				new Concept("UNIT_MULT"), new CodeList("CL_UNIT_MULT", 
				new InternationalString(), new MaintenanceAgency("ECB"))));
			var attributes:AttributeValuesCollection = 
				new AttributeValuesCollection();
			attributes.addItem(unitMult);		
			group.attributeValues = attributes;

			var seriesKeyValues:KeyValuesCollection = new KeyValuesCollection();
			seriesKeyValues.addItem(new KeyValue(new Code("D"), dim0));
			seriesKeyValues.addItem(new KeyValue(new Code("RUB"), dim1));
			seriesKeyValues.addItem(new KeyValue(new Code("EUR"), dim2));
			seriesKeyValues.addItem(new KeyValue(new Code("S"), dim3));
			seriesKeyValues.addItem(new KeyValue(new Code("A"), dim4));
			
			var key:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id"));
			key.keyValues = seriesKeyValues;
			
			_formatter.series = key;
			_formatter.group  = group;
			assertEquals("The formatted texts should be equal", 
				"EUR 1 = RUB 35.4126", _formatter.format("35.4126"));
		}
	}
}