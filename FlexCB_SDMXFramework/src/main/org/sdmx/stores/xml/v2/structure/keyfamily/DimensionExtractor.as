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
package org.sdmx.stores.xml.v2.structure.keyfamily
{
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.base.type.XSAttachmentLevel;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.concept.Concepts;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.MeasureTypeDimension;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;

	/**
	 * Extracts dimensions out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo 
	 * 		o TextFormat & cross-sectional attachments
	 */  
	internal class DimensionExtractor implements ISDMXExtractor
	{
		
		/*==============================Fields================================*/
		
		private var _codeLists:CodeLists;
		
		private var _concepts:Concepts;
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private namespace structure21 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure";		
		use namespace structure21;
		
		/*===========================Constructor==============================*/
		
		public function DimensionExtractor(codeLists:CodeLists, 
			concepts:Concepts) {
			super();
			_codeLists = codeLists;
			_concepts = concepts;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact {
			var conceptRef:String = (items.attribute("conceptRef").length() > 
				0) ? items.@conceptRef : null;
			var conceptSchemeRef:String = (items.attribute("conceptSchemeRef").
				length() > 0) ? items.@conceptSchemeRef : null;
			if (null == conceptRef) {
				throw new SyntaxError("Could not find the conceptRef attribute:" 
					+ items);
			}
			var concept:Concept = 
				_concepts.getConcept(conceptRef, conceptSchemeRef);
			if (null == concept) {
				throw new SyntaxError("Could not find any concept with id: " + 
					items.@conceptRef);
			}
			var isXSMeasure:Boolean = (items.attribute(
				"isMeasureDimension").length() > 0 && 
				items.@isMeasureDimension == "true") ? true : false;
			var dimension:Dimension = (isXSMeasure) ?
				new MeasureTypeDimension(concept.id, concept) :  
				new Dimension(concept.id, concept);
			if (null != _codeLists) {	
				var codelistEl:String = (items.attribute("codelist").length() > 
					0) ? items.@codelist : null;
				var codelistVersionEl:String = (items.attribute(
					"codelistVersion").length() > 0) ? items.@codelistVersion : 
					null;
				var codelistAgencyEl:String = (items.attribute(
					"codelistAgency").length() > 0) ? items.@codelistAgency : 
					null;
				if (null != codelistEl) {
					var codeList:CodeList = _codeLists.getCodeList(
						codelistEl, codelistVersionEl, codelistAgencyEl);
					if (null != codeList) {
						dimension.localRepresentation = codeList;
					} else {
						throw new SyntaxError("Could not find any code list" + 
								" with id: " + codelistEl);
					}
				} 
			}	
			if (items.@isMeasureDimension == true) {
				dimension.conceptRole = ConceptRole.MEASURE_TYPE;
			} else if (items.@isFrequencyDimension == true) {
				dimension.conceptRole = ConceptRole.FREQUENCY;
			} else if (items.@isCountDimension == true) {
				dimension.conceptRole = ConceptRole.COUNT;
			} else if (items.@isNonObservationTimeDimension == true) {
				dimension.conceptRole = ConceptRole.NON_OBS_TIME;
			} else if (items.@isIdentityDimension == true) {
				dimension.conceptRole = ConceptRole.IDENTITY;
			}
			
			//cross-sectional attachement levels
			if (items.@crossSectionalAttachObservation == true) {
				dimension.xsAttachmentLevel = XSAttachmentLevel.XSOBSERVATION;
			} else if (items.@crossSectionalAttachSection == true) {
				dimension.xsAttachmentLevel = XSAttachmentLevel.SECTION;
			} else if (items.@crossSectionalAttachGroup == true) {
				dimension.xsAttachmentLevel = XSAttachmentLevel.GROUP;
			} else if (items.@crossSectionalAttachDataSet == true) {
				dimension.xsAttachmentLevel = XSAttachmentLevel.XSDATASET;
			}
			return dimension;
		}
		
		/**
		 * @inheritDoc
		 */
		public function extract21(items:XML):SDMXArtefact {
			var conceptRef:String = null;
			var conceptSchemeRef:String = null
			if (items.ConceptIdentity.Ref.length() > 0) {
				conceptRef = (items.ConceptIdentity.Ref.attribute("id").
					length() > 0) ? items.ConceptIdentity.Ref.@id : null;
				conceptSchemeRef = (items.ConceptIdentity.Ref.
					attribute("maintainableParentID").length() > 0) ? 
					items.ConceptIdentity.Ref.@maintainableParentID : null; 
			} else if (items.ConceptIdentity.URN.length() > 0) {
				var urn:String = items.ConceptIdentity.URN[0].toString();
				conceptRef = urn.substring(urn.lastIndexOf(".") + 1, urn.length);
				conceptSchemeRef = urn.substring(urn.lastIndexOf(":") + 1, urn.indexOf("("));
			}
			if (null == conceptRef) {
				throw new SyntaxError("Could not find the concept reference:" 
					+ items);
			}
			var concept:Concept = 
				_concepts.getConcept(conceptRef, conceptSchemeRef);
			if (null == concept) {
				throw new SyntaxError("Could not find any concept with id: " + 
					items.@conceptRef);
			}
			var dimension:Dimension = new Dimension(concept.id, concept);
			if (null != _codeLists) {	
				var codelistEl:String = null;
				var codelistVersionEl:String = null;
				var codelistAgencyEl:String = null;
				if (items.LocalRepresentation.Enumeration.Ref.length() > 0) {
					codelistEl = (items.LocalRepresentation.Enumeration.
						Ref.attribute("id").length() > 0) ? 
						items.LocalRepresentation.Enumeration.Ref.@id : null;
					codelistVersionEl = (items.LocalRepresentation.
						Enumeration.Ref.attribute("version").length() > 0) ? 
						items.LocalRepresentation.Enumeration.Ref.@version : null;
					codelistAgencyEl = (items.LocalRepresentation.
						Enumeration.Ref.attribute("agencyID").length() > 0) ? 
						items.LocalRepresentation.Enumeration.Ref.@agencyID : null;
				} else if (items.LocalRepresentation.Enumeration.URN.length() > 0) {
					var urn:String = 
						items.LocalRepresentation.Enumeration.URN[0].toString();
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
						dimension.localRepresentation = codeList;
					} else {
						throw new SyntaxError("Could not find any code list" + 
								" with id: " + codelistEl);
					}
				} 
			}	
			if ((items.ConceptRole.length() > 0 && 
				items.ConceptRole.Ref.@id == "FREQ") || conceptRef == "FREQ") {
				dimension.conceptRole = ConceptRole.FREQUENCY;
			}
			return dimension;
		}
	}
}