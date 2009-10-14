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
	import flash.net.URLRequest;
	
	/**
	 * This interface defines the contract to be fullfilled by factories which
	 * manage access to specialized data providers. The data providers will
	 * then connect to an SDMX data source and fulfill the requests of the 
	 * controller.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public interface ISDMXDaoFactory extends IEventDispatcher
	{
		/**
		 * The data source to be used by the factory.
		 * 
		 * @param url The data source to be used by the factory.
		 */
		function set sourceURL(url:URLRequest):void;
		
		/**
		 * Returns a specialized data provider that retrieves category schemes 
		 * from an SDMX data source.
		 *  
		 * @return A specialized data provider that retrieves category schemes.
		 */
		function getCategorySchemeDAO():IMaintainableArtefactProvider;
		
		/**
		 * Returns a specialized data provider that retrieves dataflows 
		 * from an SDMX data source.
		 *  
		 * @return A specialized data provider that retrieves dataflows.
		 */
		function getDataflowDAO():IMaintainableArtefactProvider;
		
		/**
		 * Returns a specialized data provider that retrieves concept schemes 
		 * from an SDMX data source.
		 *  
		 * @return A specialized data provider that retrieves concept schemes.
		 */
		function getConceptSchemeDAO():IMaintainableArtefactProvider;
		
		/**
		 * Returns a specialized data provider that retrieves code lists 
		 * from an SDMX data source.
		 *  
		 * @return A specialized data provider that retrieves code lists.
		 */
		function getCodeListDAO():IMaintainableArtefactProvider;
		
		/**
		 * Returns a specialized data provider that retrieves organisation 
		 * schemes from an SDMX data source.
		 *  
		 * @return A specialized data provider that retrieves organisation
		 * schemes.
		 */
		function getOrganisationSchemeDAO():IMaintainableArtefactProvider;
		
		/**
		 * Returns a specialized data provider that retrieves key families from 
		 * an SDMX data source.
		 *  
		 * @return A specialized data provider that retrieves key families 
		 */
		function getKeyFamilyDAO():IMaintainableArtefactProvider;
		
		/**
		 * Returns a specialized data provider that retrieves statistical data
		 * from an SDMX data source. As the SDMX-ML Data format used is not 
		 * specified, the data provider is responsible for determining the
		 * appropriate one. 
		 */ 
		function getDataDAO():IDataProvider;
		
		/**
		 * Returns a specialized data provider that retrieves statistical data
		 * in the SDMX-ML Compact Data format from an SDMX data source.
		 */ 
		function getCompactDataDAO():IDataProvider;
		
		/**
		 * Returns a specialized data provider that retrieves statistical data
		 * in the SDMX-ML Generic Data format from an SDMX data source.
		 */ 
		function getGenericDataDAO():IDataProvider;
		
		/**
		 * Returns a specialized data provider that retrieves statistical data
		 * in the SDMX-ML Utility Data format from an SDMX data source.
		 */ 
		function getUtilityDataDAO():IDataProvider;
		
		/**
		 * Configure the SDMX data provider so as to fetch (or not) 
		 * observation-level attributes. For example, this can be set to false 
		 * for performance reasons.
		 *  
		 * @param flag
		 */
		function set disableObservationAttribute(flag:Boolean):void;
		
		/**
		 * Configure the optimisation level of the SDMX data provider.
		 * 
		 * @param level
		 */
		function set optimisationLevel(level:uint):void;
	}
}