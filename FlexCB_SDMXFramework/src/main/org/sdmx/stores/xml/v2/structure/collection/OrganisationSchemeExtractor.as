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
	import org.sdmx.model.v2.structure.organisation.DataProvider;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.structure.organisation.Organisation;
	import org.sdmx.model.v2.structure.organisation.OrganisationScheme;
	import org.sdmx.stores.xml.v2.GuessSDMXVersion;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.base.MaintainableArtefactExtractor;

	/**
	 * Extracts organisation schemes out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 *
	 * @todo 
	 * 		o DataConsumer
	 */ 
	public class OrganisationSchemeExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/
		
		private namespace structure_v2_0 = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";	
		use namespace structure_v2_0;	
		private namespace structure_v2_1 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure";	
		use namespace structure_v2_1;
		
		/*===========================Constructor==============================*/
	
		public function OrganisationSchemeExtractor() {
			super();
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact {
			GuessSDMXVersion.setSdmxVersion(items);
			var isExtractor:MaintainableArtefactExtractor = 
				ExtractorPool.getInstance().maintainableArtefactExtractor;
			var itemScheme:MaintainableArtefact 
				= isExtractor.extract(items) as MaintainableArtefact;
			var organisationScheme:OrganisationScheme 
				= new OrganisationScheme(itemScheme.id, itemScheme.name, 
					itemScheme.maintainer);
			organisationScheme.description = itemScheme.description;	
			organisationScheme.version = itemScheme.version;
			organisationScheme.uri = itemScheme.uri;
			organisationScheme.urn = itemScheme.urn;
			organisationScheme.isFinal = itemScheme.isFinal;
			organisationScheme.validFrom = itemScheme.validFrom;
			organisationScheme.validTo = itemScheme.validTo;
			organisationScheme.annotations = itemScheme.annotations;
			var organisationExtractor:OrganisationExtractor = 
				new OrganisationExtractor();
			var providers:XMLList = 
				GuessSDMXVersion.SDMX_v2_0 == GuessSDMXVersion.getSdmxVersion()?
					items..DataProvider : items.DataProvider;
			for each (var provider:XML in providers) {
				organisationScheme.organisations.addItem(
					castToDataProvider(organisationExtractor.extract(provider) 
					as Organisation));
			}
			for each (var agency:XML in items..Agency) {
				organisationScheme.organisations.addItem(
					castToMaintenanceAgency(organisationExtractor.extract(
					agency) as Organisation));
			}
			return organisationScheme;
		}	
		
		private function castToDataProvider(
			organisation:Organisation):DataProvider {
			var provider:DataProvider = new DataProvider(organisation.id);
			provider.annotations = organisation.annotations;
			provider.contacts = organisation.contacts;
			provider.description = organisation.description;
			provider.name = organisation.name;
			provider.uri = organisation.uri;
			provider.urn = organisation.urn;
			provider.validFrom = organisation.validFrom;
			provider.validTo = organisation.validTo;
			provider.version = organisation.version;
			return provider;
		}
		
		private function castToMaintenanceAgency(
			organisation:Organisation):MaintenanceAgency {
			var agency:MaintenanceAgency = 
				new MaintenanceAgency(organisation.id);
			agency.annotations = organisation.annotations;
			agency.contacts = organisation.contacts;
			agency.description = organisation.description;
			agency.name = organisation.name;
			agency.uri = organisation.uri;
			agency.urn = organisation.urn;
			agency.validFrom = organisation.validFrom;
			agency.validTo = organisation.validTo;
			agency.version = organisation.version;
			return agency;
		}
	}
}