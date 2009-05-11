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
package org.sdmx.model.v2.structure.category
{
	import org.sdmx.model.v2.base.item.Item;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;

	/**
	 * An item at any level within a classification, typically economic 
	 * concepts, subject matter domains, etc.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo
	 * 		- Implement possibility to have child items.
	 * 		- Implement restriction so that a child item can only have one
	 * 		  parent item.
	 * 		- Implement the possibility to have metadataflows
	 */
	public class Category extends Item {
		
		/*==============================Fields================================*/
		
		private var _dataflows:DataflowsCollection;
			
		private var _categories:CategoriesCollection;
		
		/*===========================Constructor==============================*/
		
		public function Category(id:String) {
			super(id);
			_dataflows = new DataflowsCollection();
			_categories = new CategoriesCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */
		public function set dataflows(dataflows:DataflowsCollection):void {
			_dataflows = dataflows;
		}
		
		/**
		 * The list of dataflows attached to this category 
		 */
		public function get dataflows():DataflowsCollection {
			return _dataflows;
		}
		
		/**
		 * @private
		 */
		public function set categories(categories:CategoriesCollection):void {
			_categories = categories;
		}
		
		/**
		 * The list of subcategories belonging to the category 
		 */
		public function get categories():CategoriesCollection {
			return _categories;
		}
	}
}