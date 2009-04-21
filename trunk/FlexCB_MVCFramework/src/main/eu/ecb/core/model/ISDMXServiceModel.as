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
package eu.ecb.core.model
{
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.structure.category.CategorieSchemesCollection;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;

	/**
	 * Contract to be fullfilled by models of applications offering a set of 
	 * SDMX compliant services.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public interface ISDMXServiceModel extends IModel
	{
		/**
		 * The last list of category schemes that has been stored by the model.
		 * @return The last list of category schemes that has been stored by the 
		 * model.
		 */
		function get categorySchemes():CategorieSchemesCollection; 
		
		/**
		 * @private
		 */ 
		function set categorySchemes(cs:CategorieSchemesCollection):void; 
		
		/**
		 * The list of all the category schemes stored by the model.
		 * @return 
		 */
		function get allCategorySchemes():CategorieSchemesCollection;
		
		/**
		 * The last list of dataflow definitions stored by the model.
		 * 
		 * @return The last list of dataflow definitions stored by the model.
		 */
		function get dataflowDefinitions():DataflowsCollection;
		
		/**
		 * @private
		 */
		function set dataflowDefinitions(dd:DataflowsCollection):void;
		
		/**
		 * The list of all dataflow definitions stored by the model.
		 * 
		 * @return All the dataflow definitions stored by the model.
		 */
		function get allDataflowDefinitions():DataflowsCollection;
		
		/**
		 * The last list of key families stored by the model.
		 * 
		 * @return The last list of key families stored by the model.
		 */
		function get keyFamilies():KeyFamilies;
		
		/**
		 * @private
		 */
		function set keyFamilies(kf:KeyFamilies):void;
		
		/**
		 * The list of all key families stored by the model.
		 * 
		 * @return All key families stored by the model.
		 */
		function get allKeyFamilies():KeyFamilies;
		
		/**
		 * The last data set stored in the model.  
		 * 
		 * @return The last data set stored in the model. 
		 */
		function get dataSet():DataSet;
		
		/**
		 * @private
		 */
		function set dataSet(ds:DataSet):void;
		
		/**
		 * The data set containing all series and groups stored in the model. 
		 * 
		 * @return The data set containing all series and groups stored in the 
		 * model. 
		 */
		function get allDataSets():DataSet;
		
		/**
		 * @private
		 */
		function set allDataSets(ds:DataSet):void;
	}
}