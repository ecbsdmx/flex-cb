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
package eu.ecb.core.view
{
	import mx.collections.ArrayCollection;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	
	/**
	 * Contract to be implemented by classes supporting visual representations
	 * of SDMX data.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public interface ISDMXView extends ISDMXServiceView
	{
		/**
		 * The SDMX data set containing all the data available in the model. 
		 */ 
		function set fullDataSet(dataSet:DataSet):void;
		
		/**
		 * The SDMX data set, after all its series have been filtered
		 * in order to display only observations falling within the defined
		 * time frame.
		 */ 
		function set filteredDataSet(dataSet:DataSet):void;
		
		/**
		 * The reference series. 
		 * 
		 * <p>This is typically used in case mulitple series are plotted on a 
		 * chart. In this case, certain views, like the period slider or the 
		 * series summary box, need to know which series must act as the 
		 * reference series.</p>
		 */ 
		function set referenceSeries(series:TimeseriesKey):void; 
		
		/**
		 * The filtered reference series. 
		 * 
		 * <p>It is basically the same as the reference series but, after being
		 * filtered to only include data within the selected period. It is 
		 * used in case mulitple series are plotted on a chart. In this case, 
		 * certain views, like the period slider or the chart summary box, need 
		 * to know which series must act as the reference series.</p>
		 */ 
		function set filteredReferenceSeries(series:TimeseriesKey):void; 
		
		/**
		 * The frequency of the currently selected series. 
		 * 
		 * <p>This is typically used for formatting purposes</p>
		 */ 
		function set referenceSeriesFrequency(freq:String):void;
		
		/**
		 * The collection of periods that can used by a user to filter the data.
		 * 
		 * <p>The collection contains objects, that will have the following
		 * properties:</p>
		 * <ul>
		 * <li>label: The label for the period (e.g.: 1Y)</li>
		 * <li>tooltip: The text for the period (e.g.: Display data for the last year)</li>
		 * <li>selected: Whether or not the period is the one currently selected</li>
		 * </ul>
		 */ 
		function set periods(periods:ArrayCollection):void
		
		/**
		 *  Whether or not the data being displayed represent percentage
		 */
		function set isPercentage(isPercentage:Boolean):void		
	}
}