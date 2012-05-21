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
	import org.sdmx.model.v2.base.MaintainableArtefact;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.hierarchy.HierarchicalCodeScheme;
	import org.sdmx.model.v2.structure.hierarchy.HierarchiesCollection;
	import org.sdmx.stores.xml.v2.GuessSDMXVersion;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.base.MaintainableArtefactExtractor;

	/**
	 * Extracts hierarchical code schemes out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky 
	 * @author Karine Feraboli
	 */ 
	public class HierarchicalCodeSchemeExtractor implements ISDMXExtractor
	{
		/*==============================Fields================================*/
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private namespace structure21 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure";		
		use namespace structure21;
		
		private var _codelists:CodeLists;
		
		/*===========================Constructor==============================*/
		
		public function HierarchicalCodeSchemeExtractor(codelists:CodeLists)
		{
			super();
			_codelists = codelists;	
		}

		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact
		{
			var isExtractor:MaintainableArtefactExtractor = 
				ExtractorPool.getInstance().maintainableArtefactExtractor;
			var artefact:MaintainableArtefact 
				= isExtractor.extract(items) as MaintainableArtefact;
			var scheme:HierarchicalCodeScheme 
				= new HierarchicalCodeScheme(artefact.id, artefact.name, 
					artefact.maintainer);
			scheme.description = artefact.description;	
			scheme.version = artefact.version;
			scheme.uri = artefact.uri;
			scheme.urn = artefact.urn;
			scheme.isFinal = artefact.isFinal;
			scheme.validFrom = artefact.validFrom;
			scheme.validTo = artefact.validTo;
			scheme.annotations = artefact.annotations;
			
			var referencedCodeLists:Object = new Object();
			if ("2.1" == GuessSDMXVersion.getSdmxVersion()) {
				extractCodelistRef21(referencedCodeLists, items);
			} else {
				extractCodelistRef(referencedCodeLists, items);
			}
			
			var hierarchies:HierarchiesCollection = new HierarchiesCollection();
			var hierarchyExtractor:HierarchyExtractor = 
				new HierarchyExtractor(referencedCodeLists);
			for each (var hierarchyXML:XML in items.Hierarchy) {
				hierarchies.addItem(hierarchyExtractor.extract(hierarchyXML));
			}
			scheme.hierarchies = hierarchies;
			return scheme;
		}
		
		private function extractCodelistRef(referencedCodeLists:Object, 
			items:XML):void {
			for each (var codeListRef:XML in items.CodelistRef) {
				if (codeListRef.child(new QName(
					"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
					"Alias")).length() == 0) {
					throw new ArgumentError("Alias not found on code list" + 
						" reference: " + codeListRef);
				}
				var alias:String = String(codeListRef.Alias);
				
				if (codeListRef.child(new QName(
					"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
					"CodelistID")).length() == 0) {
					throw new ArgumentError("Code list id needed by the " + 
						" extractor but not available: " + codeListRef);
				}
				var codeListID:String = String(codeListRef.CodelistID);
				
				if (codeListRef.child(new QName(
					"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
					"AgencyID")).length() == 0) {
					throw new ArgumentError("Agency id needed by the " + 
						" extractor but not available: " + codeListRef);
				}
				var agencyID:String = String(codeListRef.AgencyID);
				
				var version:String = (codeListRef.child(new QName(
					"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
					"Version")).length() == 0) ? 
						"1.0" : String(codeListRef.Version);
						
				var codeList:CodeList = _codelists.getCodeList(codeListID, 
					version, agencyID);
				if (null == codeList) {
					throw new ArgumentError("Could not find code list with " + 
						codeListID + " - " + agencyID + " - " + version);
				}			
				referencedCodeLists[alias] = codeList; 
			}
		}
		
		private function extractCodelistRef21(referencedCodeLists:Object, 
			items:XML):void {
			for each (var codeListRef:XML in items.IncludedCodelist) {
				var alias:String = codeListRef.@alias;
				var codeListID:String = codeListRef.Ref.@id;
				var agencyID:String = codeListRef.Ref.@agencyId;				
				var version:String = "1.0";
				var codeList:CodeList = _codelists.getCodeList(codeListID, 
					version, agencyID);
				if (null == codeList) {
					throw new ArgumentError("Could not find code list with " + 
						codeListID + " - " + agencyID + " - " + version);
				}			
				referencedCodeLists[alias] = codeList; 
			}
		}
	}
}