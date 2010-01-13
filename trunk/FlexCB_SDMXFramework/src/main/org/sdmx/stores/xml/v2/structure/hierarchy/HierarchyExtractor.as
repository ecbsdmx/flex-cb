// Copyright (C) 2010 European Central Bank. All rights reserved.
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
package org.sdmx.stores.xml.v2.structure.hierarchy
{
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.base.VersionableArtefact;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.hierarchy.CodeAssociationsCollection;
	import org.sdmx.model.v2.structure.hierarchy.Hierarchy;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.base.VersionableArtefactExtractor;

	/**
	 * Extracts hierarchies out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky 
	 * @author Karine Feraboli
	 */
	public class HierarchyExtractor implements ISDMXExtractor
	{
		/*==============================Fields================================*/
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private var _codeListRef:Object;
		
		/*===========================Constructor==============================*/
		
		public function HierarchyExtractor(codeListRef:Object)
		{
			super();
			_codeListRef = codeListRef;
		}
		
		/*==========================Public methods============================*/

		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact
		{
			var vaExtractor:VersionableArtefactExtractor = 
				ExtractorPool.getInstance().versionableArtefactExtractor;	
			var item:VersionableArtefact 
				= vaExtractor.extract(items) as VersionableArtefact;	
			var hierarchy:Hierarchy = new Hierarchy(item.id);
			hierarchy.annotations = item.annotations;
			hierarchy.description = item.description;
			hierarchy.name = item.name;
			hierarchy.uri = item.uri;
			hierarchy.urn = item.urn;
			hierarchy.version = item.version;
			hierarchy.validFrom = item.validFrom;
			hierarchy.validTo = item.validTo;
			
			var codeAssociations:CodeAssociationsCollection = 
				new CodeAssociationsCollection();
			var caExtractor:CodeAssociationExtractor = 
				new CodeAssociationExtractor(_codeListRef);
			for each (var codeRefXML:XML in items.CodeRef) {
				codeAssociations.addItem(caExtractor.extract(codeRefXML));
			}
			hierarchy.children = codeAssociations;
			return hierarchy;
		}
	}
}