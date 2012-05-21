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
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.base.VersionableArtefact;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.stores.xml.v2.GuessSDMXVersion;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;

	/**
	 * Extracts Concepts out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo
	 *     - parent & parentAgency
	 *     - isExternal Reference
	 *     - TextFormat
	 *     - coreRepresentation & coreRepresentationAgency
	 */ 
	public class ConceptExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private namespace structure21 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure";		
		use namespace structure21;
		
		private var _codeLists:CodeLists;
		
		/*===========================Constructor==============================*/
		
		public function ConceptExtractor(codeLists:CodeLists) {
			super();
			_codeLists = codeLists;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(xml:XML):SDMXArtefact {
			var item:VersionableArtefact = (ExtractorPool.getInstance().
				versionableArtefactExtractor).extract(xml) as 
				VersionableArtefact;
			if (null == item.name) {
				throw new SyntaxError("The name element is mandatory for " + 
						"concepts!");
			}	
			var conceptItem:Concept = new Concept(item.id);
			conceptItem.annotations = item.annotations;
			conceptItem.description = item.description;
			conceptItem.name = item.name;
			conceptItem.uri = item.uri;
			conceptItem.urn = item.urn;
			conceptItem.version = item.version;
			
			if (GuessSDMXVersion.SDMX_v2_1 == GuessSDMXVersion.getSdmxVersion())
			{
				if (null != _codeLists) {	
					var codelistEl:String = null;
					var codelistVersionEl:String = null;
					var codelistAgencyEl:String = null;
					if (xml.CoreRepresentation.Enumeration.Ref.length() > 0) {
						codelistEl = (xml.CoreRepresentation.Enumeration.
							Ref.attribute("id").length() > 0) ? 
							xml.CoreRepresentation.Enumeration.Ref.@id : null;
						codelistVersionEl = (xml.CoreRepresentation.
							Enumeration.Ref.attribute("version").length() > 0) ? 
							xml.CoreRepresentation.Enumeration.Ref.@version : null;
						codelistAgencyEl = (xml.CoreRepresentation.
							Enumeration.Ref.attribute("agencyID").length() > 0) ? 
							xml.CoreRepresentation.Enumeration.Ref.@agencyID : null;
					} else if (xml.CoreRepresentation.Enumeration.URN.length() > 0) {
						var urn:String = 
							xml.CoreRepresentation.Enumeration.URN[0].toString();
						codelistEl = urn.substring(urn.lastIndexOf(":") + 1, urn.indexOf("("));
						codelistVersionEl = 
							urn.substring(urn.indexOf("(") + 1, urn.indexOf(")"));
						codelistAgencyEl = 
							urn.substring(urn.indexOf("=") + 1, urn.lastIndexOf(":"));
					} 
					if (null != codelistEl) {
						var codeList:CodeList = _codeLists.getCodeList(
							codelistEl, codelistVersionEl, codelistAgencyEl);
						if (null != codeList) {
							conceptItem.coreRepresentation = codeList;
						} else {
							throw new SyntaxError("Could not find any code list" + 
									" with id: " + codelistEl);
						}
					} 
				}	
			}
			return conceptItem;
		}
	}
}