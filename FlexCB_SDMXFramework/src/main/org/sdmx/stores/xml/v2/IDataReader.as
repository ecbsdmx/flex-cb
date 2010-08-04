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
package org.sdmx.stores.xml.v2
{
	import flash.events.IEventDispatcher;
	
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	
	/**
	 * Contract to be implemented by readers of SDMX-ML data files.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public interface IDataReader extends IEventDispatcher
	{
		/**
		 * Sets whether extraction of observation-level attributes should be 
		 * disabled. By default, observation attributes will be extracted but
		 * this can be turned off for performance purposes.
		 */
		function set disableObservationAttribute(flag:Boolean):void;
				
		/**
		 * Sets whether extraction of attributes at any level should be 
		 * disabled. By default, dataset, group, series and observation-level 
		 * attributes will be extracted but this can be turned off for 
		 * performance purposes.
		 */
		function set disableAllAttributes(flag:Boolean):void;
		
		/**
		 * Whether groups should be extracted. By default, groups will be 
		 * extracted but this can be turned off for performance purposes. 
		 * In case the extraction of attributes has been disabled, it will most 
		 * likely make sense to also turn off the extraction of groups, as the
		 * main purpose of groups is to attach attributes.
		 */
		function set disableGroups(flag:Boolean):void;
		
		/**
		 * The SDMX information model specify that time series contain a 
		 * collection of time periods. Each time period is made of a time value
		 * and an observation. Each observation contains a value, a reference
		 * to the measure and the attributes attached to the observation. In 
		 * concrete terms, this means that for each data point to be displayed, 
		 * there are 2 objects, the observation and the time period containing 
		 * the observation. As there are already getters for the observation 
		 * value in the time period, it is not strictly speaking necessary to 
		 * embed the observation object in the time period, except if 
		 * observation level attributes are important. Disabling the creation
		 * of observations will improve performance.   
		 */
		function set disableObservationsCreation(flag:Boolean):void;
		
		/**
		 * The SDMX-ML data file to be parsed by the reader. The SDMX-ML data
		 * file selected must be in one of the 4 supported SDMX-ML data formats
		 * (Compact, Generic, Utility, Cross-sectional). The assignement of a
		 * data file should trigger some basic checks and prepare the inital
		 * data set, before a query can be performed. Once this is done, an
		 * initReady event will be triggered.
		 * 
		 * @see #query()
		 * 
		 * @throws Error <code>Error</code> If no matching data could be found
		 */
		function set dataFile(dataFile:XML):void;
		
		/**
		 * The key family structuring the data to be extracted.
		 */
		function set keyFamily(kf:KeyFamily):void;
		
		/**
		 * The desired optimisation algorithm.
		 */
		function set optimisationLevel(level:uint):void;
		
		/**
		 * Triggers a query against the supplied data file. 
		 * 
		 * <p>The data will be returned in an SDMXDataEvent.</p> 
		 * 
		 * <p>If no query object is supplied, the reader will extract all 
		 * available data from the data file (all series and observations).</p>
		 * <p>If a query object is supplied, it will return only the matching 
		 * data. The query object should be an AS3 object, where the key is the 
		 * dimension name and the value, the dimension value.</p> 
		 * 
		 * @example Supposing the concept of frequency is represented by 
		 * the FREQ dimension, and the country dimension is represented by the 
		 * REF_AREA dimension, and we want to retrieve monthly series ("M") for 
		 * France ("FR"), the query object would look as follow: 
		 * <listing version="3.0">{FREQ: "M", REF_AREA: "FR"}</listing>
		 *  
		 * @param query If supplied, only the series matching the values for the
		 * supplied dimensions will be returned.
		 */
		function query(query:Object = null):void;
		
		/**
		 * This method should be called when a data file has been updated, so
		 * that previousely fetched data is cleaned from memory.  
		 */
		function cleanDataSet():void;
	}
}