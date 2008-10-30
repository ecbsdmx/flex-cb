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
package eu.ecb.core.view.summary
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.reporting.dataset.UncodedObservation;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.reporting.dataset.Observation;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimePeriodsCollection;
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.controls.Text;

	/**
	 * @private
	 */ 
	public class SeriesSummaryBoxTest extends TestCase
	{
		public function SeriesSummaryBoxTest(methodName:String = null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(SeriesSummaryBoxTest);
		}
		
		public function testDisplay():void {
			var dim0:Dimension = new Dimension("dim0", new Concept("FREQ"));
			var dim1:Dimension = new Dimension("dim1", new Concept("CURRENCY"));
			var dim2:Dimension = new Dimension("dim2", new Concept("CURRENCY_DENOM"));
			var dim3:Dimension = new Dimension("dim3", new Concept("EXR_TYPE"));
			var dim4:Dimension = new Dimension("dim4", new Concept("EXR_SUFFIX"));

			var seriesKeyValues:KeyValuesCollection = new KeyValuesCollection();
			seriesKeyValues.addItem(new KeyValue(new Code("D"), dim0));
			seriesKeyValues.addItem(new KeyValue(new Code("RUB"), dim1));
			seriesKeyValues.addItem(new KeyValue(new Code("EUR"), dim2));
			seriesKeyValues.addItem(new KeyValue(new Code("S"), dim3));
			seriesKeyValues.addItem(new KeyValue(new Code("A"), dim4));	

			var key:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id"));
			key.keyValues = seriesKeyValues;
			
			var date1:Date = new Date(2007, 5, 17);
			var date2:Date = new Date(2007, 5, 21);
			var date3:Date = new Date(2007, 5, 22);
			var value1:Observation = new UncodedObservation("1.2580", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var value2:Observation = new UncodedObservation("1.3012", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var value3:Observation = new UncodedObservation("1.1759", new UncodedMeasure("measure", new Concept("OBS_VALUE")));						
			/*var period1:TimePeriod = new TimePeriod(date1, value1);
			var period2:TimePeriod = new TimePeriod(date2, value2);
			var period3:TimePeriod = new TimePeriod(date3, value3);*/						
			
			var collection:TimePeriodsCollection = new TimePeriodsCollection();
			/*collection.addItem(period1);
			collection.addItem(period2);
			collection.addItem(period3);*/
			key.timePeriods = collection;
			
			var container:HBox = new HBox();
			var view:SeriesSummaryBox = new SeriesSummaryBox();
			view.referenceSeriesFrequency = "D";
			view.referenceSeries = key;
			view.creationForTests();
			container.addChild(view);
			assertEquals("The view should have one child", 1, view.getChildren().length);
			assertTrue("The child should be an Text", view.getChildAt(0) is Text);
			/*assertEquals("The text should be equal", 
				"<b>Latest (22 June 2007): <font color='#000000' verticalAlign='bottom'>1.1759</font></b> <font color='#CC0000' size='10'>-0.1253 (-9.6%)</font>", (view.getChildAt(0) as Text).htmlText);*/	
		}
	}
}