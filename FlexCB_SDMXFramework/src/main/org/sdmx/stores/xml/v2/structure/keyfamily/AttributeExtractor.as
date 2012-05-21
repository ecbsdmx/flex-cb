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
	import org.sdmx.model.v2.base.structure.LengthRange;
	import org.sdmx.model.v2.base.type.AttachmentLevel;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.base.type.DataType;
	import org.sdmx.model.v2.base.type.XSAttachmentLevel;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.concept.Concepts;
	import org.sdmx.model.v2.structure.keyfamily.CodedDataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.DataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.UncodedDataAttribute;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;

	/**
	 * Extracts Attributes out of SDMX-ML structure file.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo 
	 * 		o Cross-sectional and AttachmentMeasure
	 * 		o Other kinds of TextFormats (+ review facets)
	 */ 
	internal class AttributeExtractor implements ISDMXExtractor
	{
		/*==============================Fields================================*/
		
		private var _codeLists:CodeLists;
		
		private var _concepts:Concepts;
		
		private var _group:GroupKeyDescriptor;
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private namespace structure21 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure";		
		use namespace structure21;
		
		/*===========================Constructor==============================*/
		
		public function AttributeExtractor(codeLists:CodeLists, 
			concepts:Concepts, group:GroupKeyDescriptor) {
			super();
			_codeLists = codeLists;
			_concepts = concepts;
			_group = group;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact {
			var conceptRef:String = (items.attribute("conceptRef").length() > 0) 
				? items.@conceptRef : null;
			var conceptSchemeRef:String = (items.attribute("conceptSchemeRef").
				length() > 0) ? items.@conceptSchemeRef : null;
			if (null == conceptRef) {
				throw new SyntaxError("Could not find the conceptRef attribute:" 
					+ items);
			}
			var concept:Concept = 
				_concepts.getConcept(conceptRef, conceptSchemeRef);
			if (null == concept) {
				throw new SyntaxError("Could not find any concept with id: " 
					+ items.@conceptRef);
			}
			var attribute:DataAttribute;
			var codeList:CodeList;
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
					codeList = _codeLists.getCodeList(items.@codelist, 
					items.@codelistVersion, items.@codelistAgency);
				} 
			}
			
			if (null != codeList) {
				attribute = 
					new CodedDataAttribute(concept.id, concept, codeList);
			} else {
				attribute = 
					new UncodedDataAttribute(concept.id, concept);
				var tf:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"TextFormat");
				if (items.child(tf).length() > 0) {
					if (items.TextFormat.@maxLength) {
						if (items.TextFormat.@textType == "String") {
							attribute.localRepresentation = 
								new LengthRange(0, items.TextFormat.@maxLength, 
									DataType.STRING);
						} else if (items.TextFormat.@textType == "Integer") {
							attribute.localRepresentation = 
								new LengthRange(0, items.TextFormat.@maxLength, 
									DataType.INTEGER);
						}
					} else if (items.TextFormat.attribute("textType").
						length() == 0) {
						attribute.localRepresentation = 
							new LengthRange(NaN, NaN, DataType.STRING);
					} else {
						throw new SyntaxError("Unknown local representation: " + 
							items.TextFormat);
					}
				}
			}
			if (items.@isEntityAttribute == true) {
				attribute.conceptRole = ConceptRole.ENTITY;
			} else if (items.@isNonObservationalTimeAttribute == true) {
				attribute.conceptRole = ConceptRole.NON_OBS_TIME;
			} else if (items.@isCountAttribute == true) {
				attribute.conceptRole = ConceptRole.COUNT;
			} else if (items.@isFrequencyAttribute == true) {
				attribute.conceptRole = ConceptRole.FREQUENCY;
			} else if (items.@isIdentityAttribute == true) {
				attribute.conceptRole = ConceptRole.IDENTITY;
			} else if (items.@isTimeFormat == true) {
				attribute.conceptRole = ConceptRole.TIME_FORMAT;
			}
			attribute.usageStatus = items.@assignmentStatus;
			attribute.attachmentLevel = items.@attachmentLevel;
			var ag:QName = 
				new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"AttachmentGroup");
			if (items.child(ag).length() > 0) {
				if (items.AttachmentGroup == _group.id) {
					attribute.attachmentGroup = _group;
				} else {
					throw new SyntaxError("Unknown group: " + 
						items.attachmentGroup);
				}
			}
			//cross-sectional attachement levels
			if (items.@crossSectionalAttachObservation == true) {
				attribute.xsAttachmentLevel = XSAttachmentLevel.XSOBSERVATION;
			} else if (items.@crossSectionalAttachSection == true) {
				attribute.xsAttachmentLevel = XSAttachmentLevel.SECTION;
			} else if (items.@crossSectionalAttachGroup == true) {
				attribute.xsAttachmentLevel = XSAttachmentLevel.GROUP;
			} else if (items.@crossSectionalAttachDataSet == true) {
				attribute.xsAttachmentLevel = XSAttachmentLevel.XSDATASET;
			}
			return attribute;
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
			var attribute:DataAttribute;
			var codeList:CodeList;
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
					codeList = _codeLists.getCodeList(
						codelistEl, codelistVersionEl, codelistAgencyEl);
				} 
			}	
			if (null != codeList) {
				attribute = 
					new CodedDataAttribute(concept.id, concept, codeList);
			} else {
				attribute = 
					new UncodedDataAttribute(concept.id, concept);
				var tf:QName = new QName(
				"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure", 
				"TextFormat");
				if (items.LocalRepresentation.child(tf).length() > 0) {
					if (items.LocalRepresentation.TextFormat.@maxLength) {
						attribute.localRepresentation = 
								new LengthRange(0, items.LocalRepresentation.
									TextFormat.@maxLength, 
									DataType.INTEGER);
					} else if (items.LocalRepresentation.TextFormat.
						attribute("textType").length() == 0) {
						attribute.localRepresentation = 
							new LengthRange(NaN, NaN, DataType.STRING);
					} else {
						throw new SyntaxError("Unknown local representation: " + 
							items.LocalRepresentation.TextFormat);
					}
				}
			}
			
			if (conceptRef == "TIME_FORMAT") {
				attribute.conceptRole = ConceptRole.TIME_FORMAT;
			}
			attribute.usageStatus = items.@assignmentStatus;
			var groupLvlName:QName = new QName(
				"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure", 
				"Group");
			var obsLvlName:QName = new QName(
				"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure", 
				"PrimaryMeasure");
			if(items.AttributeRelationship.child(groupLvlName).length() > 0) {
				attribute.attachmentLevel = AttachmentLevel.GROUP;
			} else if(items.AttributeRelationship.child(
				obsLvlName).length() > 0) {
				attribute.attachmentLevel = AttachmentLevel.OBSERVATION;
			} else {
				attribute.attachmentLevel = AttachmentLevel.SERIES;
			}
			
			return attribute;
		}
	}
}