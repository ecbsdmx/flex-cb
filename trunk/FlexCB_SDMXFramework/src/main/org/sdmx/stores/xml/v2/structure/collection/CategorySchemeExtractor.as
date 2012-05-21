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
package org.sdmx.stores.xml.v2.structure.collection
{
	import org.sdmx.model.v2.base.MaintainableArtefact;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.structure.category.CategoryScheme;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.stores.xml.v2.GuessSDMXVersion;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.base.MaintainableArtefactExtractor;

	/**
	 * Extracts CategorySchemes out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo 
	 *     - isExternal Reference
	 */ 
	public class CategorySchemeExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private namespace structure_v2_1 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure";	
		use namespace structure_v2_1;
		
		private var _dataflows:DataflowsCollection;
		
		private var _referencedFlows;
		
		/*===========================Constructor==============================*/
		
		public function CategorySchemeExtractor(dataflows:DataflowsCollection) {
			super();
			_dataflows = dataflows;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc 
		 */
		public function get flows():Object {
			return _referencedFlows;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set flows(flows:Object):void {
			_referencedFlows = flows;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact {
			var isExtractor:MaintainableArtefactExtractor = 
				ExtractorPool.getInstance().maintainableArtefactExtractor;
			var itemScheme:MaintainableArtefact 
				= isExtractor.extract(items) as MaintainableArtefact;
			var categoryScheme:CategoryScheme 
				= new CategoryScheme(itemScheme.id, itemScheme.name, 
					itemScheme.maintainer);
			categoryScheme.description = itemScheme.description;	
			categoryScheme.version = itemScheme.version;
			categoryScheme.uri = itemScheme.uri;
			categoryScheme.urn = itemScheme.urn;
			categoryScheme.isFinal = itemScheme.isFinal;
			categoryScheme.validFrom = itemScheme.validFrom;
			categoryScheme.validTo = itemScheme.validTo;
			categoryScheme.annotations = itemScheme.annotations;
			var categoryExtractor:CategoryExtractor = 
				new CategoryExtractor(_dataflows);
			for each (var category:XML in items.Category) {
				if ("2.1" == GuessSDMXVersion.getSdmxVersion()) {
					categoryScheme.categories.addItem(
						categoryExtractor.extract21(category, flows));
				} else {
					categoryScheme.categories.addItem(
						categoryExtractor.extract(category));
				}
			}
			return categoryScheme;
		}
	}
}