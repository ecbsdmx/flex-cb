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
package eu.ecb.core.controller
{
	import org.sdmx.stores.api.SDMXQueryParameters;
	
	/**
	 * Contract to be fullfilled by controllers of applications offering a
	 * set of SDMX services.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public interface ISDMXServiceController extends IController
	{
		/**
		 * Retrieves the category scheme identified by the supplied parameters. 
		 * 
		 * <p>If no parameters are supplied, all category schemes available in 
		 * the SDMX data source will be returned by the data provider.</p>
		 * 
		 * @param categorySchemeID The unique identifier for the category scheme
		 * @param agencyID The id of the maintenance agency responsible for the 
		 * category scheme
		 * @param version The version of the category scheme
		 */
		function fetchCategoryScheme(categorySchemeID:String = null, 
			agencyID:String = null, version:String = null):void;
		
		/**
		 * Retrieves the dataflow identified by the supplied parameters.  
		 *  
		 * <p>If no parameters are supplied, all dataflows available in the 
		 * SDMX data source will be returned by the data provider.</p>
		 *  
		 * @param dataflowID The unique identifier for the dataflow
		 * @param agencyID The id of the maintenance agency responsible for the 
		 * dataflow
		 * @param version The version of the dataflow
		 */
		function fetchDataflowDefinition(dataflowID:String = null, 
			agencyID:String = null, version:String = null):void; 
		
		/**
		 * Retrieves the key family identified by the supplied parameters.  
		 *  
		 * <p>If no parameters are supplied, all key families available in the 
		 * SDMX data source will be returned by the data provider.</p>
		 *  
		 * @param keyFamilyID The unique identifier for the key family
		 * @param agencyID The id of the maintenance agency responsible for the 
		 * key family
		 * @param version The version of the key family
		 */	
		function fetchKeyFamily(keyFamilyID:String = null, 
			agencyID:String = null, version:String = null):void; 
			
		/**
		 * Retrieves data indentified by the supplied paramaters, in the 
		 * requested format. If no format is specified, the data providers will
		 * be responsible for returning the appropriate one.
		 *  
		 * @param criteria The criteria for data selection
		 * 
		 * @param format The SDMX-ML data format to be returned
		 */
		function fetchData(criteria:SDMXQueryParameters = null, 
			format:String = null):void;
	}
}