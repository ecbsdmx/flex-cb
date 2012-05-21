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
	import org.sdmx.model.v2.base.MaintainableArtefact;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.concept.Concepts;
	import org.sdmx.model.v2.structure.keyfamily.AttributeDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptorsCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.stores.xml.v2.GuessSDMXVersion;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.base.MaintainableArtefactExtractor;

	/**
	 * Extracts key families out of SDMX-ML Structure files.
	 * 
	 * @todo
	 * 		Cross-sectional measure.
	 */
	public class KeyFamilyExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/

		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private namespace structure21 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure";		
		use namespace structure21;
		
		private var _codeLists:CodeLists;
		
		private var _concepts:Concepts;
		
		/*===========================Constructor==============================*/
		
		public function KeyFamilyExtractor(codeLists:CodeLists, concepts:Concepts) {
			super();
			_codeLists = codeLists;
			_concepts = concepts;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact {
			// Extract key family object
			var extractor:MaintainableArtefactExtractor = 
				ExtractorPool.getInstance().maintainableArtefactExtractor;
			var maintainableArtefact:MaintainableArtefact = 
				extractor.extract(items) as MaintainableArtefact;
			
			// Add dimensions
			var dimExtractor:DimensionExtractor = 
				new DimensionExtractor(_codeLists, _concepts);
			var dimensions:KeyDescriptor = new KeyDescriptor("Dimensions");
			if ("2.1" == GuessSDMXVersion.getSdmxVersion()) {
				for each (var dimension:XML in items.DataStructureComponents.DimensionList.Dimension) {
					dimensions.addItem(dimExtractor.extract21(dimension));
				}
			} else {			
				for each (var dimension:XML in items.Components.Dimension) {
					dimensions.addItem(dimExtractor.extract(dimension));
				}
			}
			
			// Add time dimension
			var tdExtractor:TimeDimensionExtractor = 
				new TimeDimensionExtractor(_codeLists, _concepts);
			if ("2.1" == GuessSDMXVersion.getSdmxVersion()) {
				dimensions.addItem(tdExtractor.extract21(
					items.DataStructureComponents.DimensionList.TimeDimension[0]));
			} else {			
				dimensions.addItem(tdExtractor.extract(
					items.Components.TimeDimension[0]));
			}	
			
			// Add groups
			var groupExtractor:GroupExtractor = new GroupExtractor(dimensions);
			var groups:GroupKeyDescriptorsCollection = 
				new GroupKeyDescriptorsCollection();
			if ("2.1" == GuessSDMXVersion.getSdmxVersion()) {				
				for each (var group:XML in items.DataStructureComponents.Group) {
					groups.addItem(groupExtractor.extract21(group));
				}
			} else {
				for each (var group:XML in items.Components.Group) {
					groups.addItem(groupExtractor.extract(group));
				}
			}
			
			// Add measures
			var measureExtractor:PrimaryMeasureExtractor = 
				new PrimaryMeasureExtractor(_codeLists, _concepts);
			var measures:MeasureDescriptor = new MeasureDescriptor("Measures");
			if ("2.1" == GuessSDMXVersion.getSdmxVersion()) {
				measures.addItem(measureExtractor.extract21(
					items.DataStructureComponents.MeasureList.PrimaryMeasure[0]));
			} else {
				measures.addItem(measureExtractor.extract(
					items.Components.PrimaryMeasure[0]));
			}
			
			// Add attributes
			var firstGroup:GroupKeyDescriptor = null;
			if (groups.length > 0) {
				firstGroup = groups.getItemAt(0) as GroupKeyDescriptor;
			}
			var attributeExtractor:AttributeExtractor = 
				new AttributeExtractor(_codeLists, _concepts, firstGroup);
			var attributes:AttributeDescriptor = 
				new AttributeDescriptor("Attributes");
			if ("2.1" == GuessSDMXVersion.getSdmxVersion()) {
				for each (var attribute:XML in 
					items.DataStructureComponents.AttributeList.Attribute) {
					attributes.addItem(attributeExtractor.extract21(attribute));
				}
			} else {
				for each (var attribute:XML in items.Components.Attribute) {
					attributes.addItem(attributeExtractor.extract(attribute));
				}
			}	
			
			// Create key family
			var keyFamily:KeyFamily = new KeyFamily(maintainableArtefact.id, 
				maintainableArtefact.name, maintainableArtefact.maintainer,
				dimensions, measures);
			keyFamily.description = maintainableArtefact.description;	
			keyFamily.version = maintainableArtefact.version;
			keyFamily.uri = maintainableArtefact.uri;
			keyFamily.urn = maintainableArtefact.urn;
			keyFamily.isFinal = maintainableArtefact.isFinal;
			keyFamily.validFrom = maintainableArtefact.validFrom;
			keyFamily.validTo = maintainableArtefact.validTo;
			if (attributes.length > 0) {
				keyFamily.attributeDescriptor = attributes;
			}
			if (groups.length > 0) {
				keyFamily.groupDescriptors = groups;
			}
			return keyFamily;
		}
	}
}