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
package eu.ecb.core.view
{
	import org.sdmx.model.v2.reporting.dataset.IDataSet;
	import org.sdmx.model.v2.structure.category.CategorieSchemesCollection;
	import org.sdmx.model.v2.structure.hierarchy.HierarchicalCodeSchemesCollection;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	
	/**
	 * Contract to be implemented by views of applications offering a set of 
	 * SDMX compliant services.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public interface ISDMXServiceView extends IView
	{
		/**
		 * @private
		 */ 
		function set id(id:String):void;
		
		/**
		 * Each Flex-CB view can be identified by an ID. 
		 */ 
		function get id():String;
		
		/**
		 * The category schemes to be displayed by the view 
		 */
		function set categorySchemes(cs:CategorieSchemesCollection):void;
		
		/**
		 * The dataflow definition to be displayed by the view 
		 */
		function set dataflowDefinitions(dd:DataflowsCollection):void;
		
		/**
		 * The hierarchical code schemes to be displayed by the view 
		 */
		function set hierarchicalCodeSchemes(
			hcs:HierarchicalCodeSchemesCollection):void;
		
		/**
		 * The key families to be displayed by the view. 
		 */
		function set keyFamilies(kf:KeyFamilies):void;
		
		/**
		 * The SDMX data set containing the desired subset of data to be 
		 * displayed by the view. 
		 */ 
		function set dataSet(ds:IDataSet):void;
	}
}