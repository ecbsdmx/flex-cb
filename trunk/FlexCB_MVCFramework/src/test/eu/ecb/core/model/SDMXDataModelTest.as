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
package eu.ecb.core.model
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimePeriodsCollection;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.UncodedObservation;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.Observation;
	import org.sdmx.model.v2.base.type.ConceptRole;

	/**
	 *	@private 
	 */ 
	public class SDMXDataModelTest extends TestCase
	{
		public function SDMXDataModelTest(methodName:String = null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(SDMXDataModelTest);
		}
		
		public function testSetNullDataSet():void {
			var model:SDMXDataModel = new SDMXDataModel();
			var dataSet:DataSet;
			try {
				model.fullDataSet = dataSet;
				fail("It should not be possible to set a null dataSet");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetEmptyDataSet():void {
			var model:SDMXDataModel =  new SDMXDataModel();
			var dataSet:DataSet = new DataSet();
			try {
				model.fullDataSet = dataSet;
				fail("It should not be possible to set an empty dataSet");
			}  catch (error:ArgumentError) {}
		}
		
		public function testGetAndSetDataSet():void {
			var model:SDMXDataModel =  new SDMXDataModel();
			var keys:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			var keyDescriptor:KeyDescriptor = new KeyDescriptor("test");
			var series1:TimeseriesKey = new TimeseriesKey(keyDescriptor);
			var series2:TimeseriesKey = new TimeseriesKey(keyDescriptor);
			series1.keyValues = getKeyValues();
			series2.keyValues = getKeyValues();
			keys.addItem(series1);
			keys.addItem(series2);
			var dataSet:DataSet = new DataSet();
			dataSet.timeseriesKeys = keys;
			model.dataSet = dataSet;
			assertEquals("The datasets should be equal", dataSet, model.dataSet);
		}
		
		public function testSortTimeSeries():void {
			var model:SDMXDataModel =  new SDMXDataModel();		

			var key:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id"));
			key.keyValues = getKeyValues();
			
			var date1:Date = new Date(2007, 5, 21);
			var date2:Date = new Date(2007, 5, 22);
			var date3:Date = new Date(2007, 5, 17);
			var value1:Observation = new UncodedObservation("1.258", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var value2:Observation = new UncodedObservation("1.301", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var value3:Observation = new UncodedObservation("1.175", new UncodedMeasure("measure", new Concept("OBS_VALUE")));						
			/*var period1:TimePeriod = new TimePeriod(date1, value1);
			var period2:TimePeriod = new TimePeriod(date2, value2);
			var period3:TimePeriod = new TimePeriod(date3, value3);*/						
			
			var collection:TimePeriodsCollection = new TimePeriodsCollection();
			/*collection.addItem(period1);
			collection.addItem(period2);
			collection.addItem(period3);/
			key.timePeriods = collection;
			
			var keys:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			keys.addItem(key);
			var dataSet:DataSet = new DataSet();
			dataSet.timeseriesKeys = keys;
			model.dataSet = dataSet;
			/*assertEquals("There should be 3 observations", 3, 
				(model.dataSet.timeseriesKeys.getItemAt(0) as TimeseriesKey).timePeriods.length);
			assertEquals("The 1st obs should be 2007-05-17", period3, 
				(model.dataSet.timeseriesKeys.getItemAt(0) as TimeseriesKey).timePeriods.getItemAt(0));
			assertEquals("The last obs should be 2007-05-22", period2, 
				(model.dataSet.timeseriesKeys.getItemAt(0) as TimeseriesKey).timePeriods.getItemAt(2));*/		
		}
				
		public function testGetDefaultSelectedSeries():void {
			var model:SDMXDataModel =  new SDMXDataModel();
			var keys:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			var keyDescriptor:KeyDescriptor = new KeyDescriptor("test");
			var series1:TimeseriesKey = new TimeseriesKey(keyDescriptor);
			series1.keyValues = getKeyValues();
			var series2:TimeseriesKey = new TimeseriesKey(keyDescriptor);
			series2.keyValues = getKeyValues();
			keys.addItem(series1);
			keys.addItem(series2);
			var dataSet:DataSet = new DataSet();
			dataSet.timeseriesKeys = keys;
			model.dataSet = dataSet;			
			assertEquals("By default, the 1st series should be the selected one", series1, model.referenceSeries);
		}
		
		public function testGetFrequency():void {
			var model:SDMXDataModel =  new SDMXDataModel();		

			var key:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id"));
			key.keyValues = getKeyValues();
			
			var keys:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			keys.addItem(key);
			var dataSet:DataSet = new DataSet();
			dataSet.timeseriesKeys = keys;
			model.dataSet = dataSet;
			assertEquals("The frequency should be daily", "D", model.referenceSeriesFrequency);
		}
		
		public function testNoFrequencyFound():void {
			var model:SDMXDataModel =  new SDMXDataModel();		

			var key:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id"));
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
			key.keyValues = seriesKeyValues;
			
			var keys:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			keys.addItem(key);
			var dataSet:DataSet = new DataSet();
			dataSet.timeseriesKeys = keys;
			try {
				model.dataSet = dataSet;
				fail("No frequency could be found.");
			} catch (error:ArgumentError) {}
		}
		
		private function getKeyValues():KeyValuesCollection {
			var dim0:Dimension = new Dimension("dim0", new Concept("FREQ"));
			dim0.conceptRole = ConceptRole.FREQUENCY;
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
			
			return seriesKeyValues;
		}
	}
}