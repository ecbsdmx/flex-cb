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
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.base.VersionableArtefact;
	import org.sdmx.model.v2.structure.category.Category;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.base.VersionableArtefactExtractor;

	/**
	 * Extracts Categories out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo 
	 *     - parent
	 *     - isExternal Reference
	 *     - TextFormat
	 *     - MetadatflowRef
	 */ 
	public class CategoryExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/
		
		private var _dataflows:DataflowsCollection;
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
			
		/*===========================Constructor==============================*/
		
		public function CategoryExtractor(dataflows:DataflowsCollection = null) 
		{
			super();
			_dataflows = dataflows;
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
			var category:Category = new Category(item.id);
			category.annotations = item.annotations;
			category.description = item.description;
			category.name = item.name;
			category.uri = item.uri;
			category.urn = item.urn;
			category.version = item.version;
			if (items.DataflowRef.length() > 0 
				&& items.DataflowRef.AgencyID.length() > 0 
				&& items.DataflowRef.DataflowID.length() > 0) {
				for each (var dataflowRef:XML in items.DataflowRef) {
					var dataflow:DataflowDefinition;
					if (null != _dataflows) {
						dataflow = _dataflows.getDataflowById(
							dataflowRef.DataflowID,	dataflowRef.AgencyID, 
							dataflowRef.Version);
					} else {
						dataflow = new DataflowDefinition(
							dataflowRef.DataflowID, new InternationalString(),
							new MaintenanceAgency(dataflowRef.AgencyID), null);
						dataflow.version = dataflowRef.Version;	
					}
					
					if (null != dataflow) {	
						category.dataflows.addItem(dataflow);	
					}	
				}
			}
			
			var categoryExtractor:CategoryExtractor = 
				new CategoryExtractor(_dataflows);
			for each (var subcategory:XML in items.Category) {
				category.categories.addItem(
					categoryExtractor.extract(subcategory));
			}
			return category;
		}
	}
}