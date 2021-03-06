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
	import org.sdmx.model.v2.base.item.Item;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.concept.ConceptScheme;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.base.MaintainableArtefactExtractor;

	/**
	 * Extracts Concept schemes out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo 
	 *     - isExternalReference
	 */ 
	public class ConceptSchemeExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/
		
		private namespace structure_v2_0 = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";	
		use namespace structure_v2_0;	
		private namespace structure_v2_1 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure";	
		use namespace structure_v2_1;
		
		private var _codeLists:CodeLists;
		
		/*===========================Constructor==============================*/
		
		public function ConceptSchemeExtractor(codeLists:CodeLists) {
			super();
			_codeLists = codeLists;
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
			var conceptScheme:ConceptScheme = new ConceptScheme(itemScheme.id, 
				itemScheme.name, itemScheme.maintainer);
			conceptScheme.description = itemScheme.description;	
			conceptScheme.version = itemScheme.version;
			conceptScheme.uri = itemScheme.uri;
			conceptScheme.urn = itemScheme.urn;
			conceptScheme.isFinal = itemScheme.isFinal;
			conceptScheme.validFrom = itemScheme.validFrom;
			conceptScheme.validTo = itemScheme.validTo;
			conceptScheme.annotations = itemScheme.annotations;
			var conceptExtractor:ConceptExtractor = 
				new ConceptExtractor(_codeLists);
			for each (var concept:XML in items.Concept) {
				conceptScheme.concepts.addItem(
					conceptExtractor.extract(concept) as Item);
			}
			return conceptScheme;
		}
	}
}