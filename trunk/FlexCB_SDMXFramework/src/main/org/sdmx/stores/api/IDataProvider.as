// Copyright (C) 2009 European Central Bank. All rights reserved.
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
package org.sdmx.stores.api
{
	import flash.events.IEventDispatcher;
	
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	
	/**
	 * This interface defines the contract to be fullfilled by data providers 
	 * that return SDMX data.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public interface IDataProvider extends IEventDispatcher
	{
		/**
		 * Returns the data matching the supplied critiera. If no parameters are
		 * supplied, all available data are returned.
		 * 
		 * @param params The parameters defining the data to be retrieved.
		 * @param format The SDMX-ML format of the data. If null, attempt will
		 * be made to guess it.
		 */
		function getData(params:SDMXQueryParameters = null):void;
		
		/**
		 * The data structure definitions defining the data to be retrieved.
		 *  
		 * @param kf The data structure definitions defining the data to be 
		 * retrieved.
		 */
		function set keyFamilies(kf:KeyFamilies):void;
		
		/**
		 * Whether or not observation-level attributes should be fetched. This
		 * can be set to false for performance reasons.
		 *  
		 * @param flag
		 */
		function set disableObservationAttribute(flag:Boolean):void;
		
		/**
		 * Whether or not attributes should be fetched. This can be set to false
		 * for performance reasons.
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
		 * The optimisation level defines which optimisation settings will be 
		 * applied when reading data.
		 * 
		 * @param level
		 */
		function set optimisationLevel(level:uint):void;
	}
}