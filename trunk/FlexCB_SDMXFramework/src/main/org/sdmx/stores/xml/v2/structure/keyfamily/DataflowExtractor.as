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
	import mx.collections.ArrayCollection;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.MaintainableArtefact;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.base.structure.Component;
	import org.sdmx.model.v2.reporting.provisioning.ContentConstraint;
	import org.sdmx.model.v2.reporting.provisioning.CubeRegion;
	import org.sdmx.model.v2.reporting.provisioning.CubeRegionsCollection;
	import org.sdmx.model.v2.reporting.provisioning.MemberSelection;
	import org.sdmx.model.v2.reporting.provisioning.MemberSelectionsCollection;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.base.MaintainableArtefactExtractor;

	/**
	 * Extracts Dataflows out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo 
	 * 		o Extract categorRref;
	 * 		o Extract URN from KeyFamilyRefType
	 */ 
	public class DataflowExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/
		
		private var _keyFamilies:KeyFamilies;
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private namespace common = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common";		
		use namespace common;
		
		/*===========================Constructor==============================*/
		
		public function DataflowExtractor(keyFamilies:KeyFamilies) {
			super();
			_keyFamilies = keyFamilies;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact {
			var maExtractor:MaintainableArtefactExtractor = 
				ExtractorPool.getInstance().maintainableArtefactExtractor;
			var maintenableArtefact:MaintainableArtefact 
				= maExtractor.extract(items) as MaintainableArtefact;
			if (null == maintenableArtefact) {
				throw new SyntaxError("Could not get maintainable artefact");
			}
			var keyFamily:KeyFamily = null;
			var agencyIdEl:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"KeyFamilyAgencyID");
			var kfIdEl:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"KeyFamilyID");
			if (items.KeyFamilyRef.child(agencyIdEl).length() > 0 && 
				items.KeyFamilyRef.child(kfIdEl).length() > 0) {
				if (null != _keyFamilies) {
					keyFamily = _keyFamilies.getKeyFamilyByID(items.KeyFamilyRef
						.KeyFamilyID, items.KeyFamilyRef.KeyFamilyAgencyID);
				} else {
					keyFamily = new KeyFamily(items.KeyFamilyRef.KeyFamilyID,
						new InternationalString(), new MaintenanceAgency(items.
						KeyFamilyRef.KeyFamilyAgencyID), null, null, true);
					keyFamily.version = items.KeyFamilyRef.Version; 	
				}
			}
			if (null == keyFamily) {
				throw new SyntaxError("Could not find key family");
			}
			var dataflow:DataflowDefinition = 
				new DataflowDefinition(maintenableArtefact.id, 
					maintenableArtefact.name, maintenableArtefact.maintainer, 
					keyFamily);
			dataflow.annotations = maintenableArtefact.annotations;	
			dataflow.description = maintenableArtefact.description;	
			dataflow.uri = maintenableArtefact.uri;
			dataflow.urn = maintenableArtefact.urn;
			dataflow.version = maintenableArtefact.version;
			dataflow.validFrom = maintenableArtefact.validFrom;
			dataflow.validTo = maintenableArtefact.validTo;
			dataflow.version = maintenableArtefact.version;
			dataflow.isFinal = maintenableArtefact.isFinal;
			
			//Fetching constraints (works only with cube regions for now)
			if (items.Constraint.length() > 0 && items.Constraint.CubeRegion) {
				var constraint:ContentConstraint = 
					new ContentConstraint(items.Constraint.ConstraintID);
				var cubeCollection:CubeRegionsCollection = 
					new CubeRegionsCollection();
				for each (var cube:XML in items.Constraint.CubeRegion) {
					var region:CubeRegion = new CubeRegion();
					region.isIncluded = 
						(cube.@isIncluded == true) ? true : false;
					cubeCollection.addItem(region);
					if (cube.Member.length() > 0) {
						var members:MemberSelectionsCollection = 
							new MemberSelectionsCollection();
						for each (var mem:XML in 
							items.Constraint.CubeRegion.Member) {
							var member:MemberSelection = new MemberSelection();
							member.isIncluded = 
								(mem.@isIncluded == "true") ? true : false;
							var component:Component = new Component(mem.
								ComponentRef, new Concept(mem.ComponentRef));
							member.structureComponent = component;
							var values:ArrayCollection = new ArrayCollection();
							for each (var val:XML in mem.MemberValue) {
								values.addItem(val.Value); 
							}		
							member.values = values;
							members.addItem(member);			
						}
						region.members = members;	
					}
				}		
				constraint.permittedContentRegion = cubeCollection;
				dataflow.contentConstraint = constraint;
			}
			return dataflow;	
		}
	}
}