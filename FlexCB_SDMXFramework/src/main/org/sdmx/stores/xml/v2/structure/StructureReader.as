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
package org.sdmx.stores.xml.v2.structure
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.structure.category.CategorieSchemesCollection;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.concept.Concepts;
	import org.sdmx.model.v2.structure.hierarchy.HierarchicalCodeSchemesCollection;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.organisation.OrganisationSchemes;
	import org.sdmx.stores.xml.v2.structure.collection.CategorySchemeExtractor;
	import org.sdmx.stores.xml.v2.structure.collection.CodeListExtractor;
	import org.sdmx.stores.xml.v2.structure.collection.ConceptExtractor;
	import org.sdmx.stores.xml.v2.structure.collection.ConceptSchemeExtractor;
	import org.sdmx.stores.xml.v2.structure.collection.OrganisationSchemeExtractor;
	import org.sdmx.stores.xml.v2.structure.hierarchy.HierarchicalCodeSchemeExtractor;
	import org.sdmx.stores.xml.v2.structure.keyfamily.DataflowExtractor;
	import org.sdmx.stores.xml.v2.structure.keyfamily.KeyFamilyExtractor;
		
	/**
	 * Event triggered when code lists have been extracted from the Structure
	 * file.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.structure.StructureReader.CODE_LISTS_EVENT
	 */
	[Event(name="codeListsEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
	 * Event triggered when concepts and concept schemes have been extracted 
	 * from the Structure file.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.structure.StructureReader.CONCEPTS_EVENT
	 */
	[Event(name="conceptsEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
	 * Event triggered when key families have been extracted from the Structure
	 * file.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.structure.StructureReader.KEY_FAMILIES_EVENT
	 */
	[Event(name="keyFamiliesEvent", type="org.sdmx.event.SDMXDataEvent")]

	
	/**
	 * Event triggered when dataflows have been extracted from the Structure
	 * file.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.structure.StructureReader.DATAFLOWS_EVENT
	 */
	[Event(name="dataflowsEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	
	/**
	 * Event triggered when category schemes have been extracted from the 
	 * Structure file.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.structure.StructureReader.CATEGORY_SCHEMES_EVENT
	 */
	[Event(name="categorySchemesEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
	 * Event triggered when organisation schemes have been extracted from the 
	 * Structure file.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.structure.StructureReader.ORGANISATION_SCHEMES_EVENT
	 */
	[Event(name="organisationSchemesEvent", 
		type="org.sdmx.event.SDMXDataEvent")]
		
	/**
	 * Event triggered when hierarchical code schemes have been extracted from 
	 * the Structure file.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.structure.StructureReader.HIERARCHICAL_CODE_SCHEMES_EVENT
	 */
	[Event(name="hierarchicalCodeSchemesEvent", 
		type="org.sdmx.event.SDMXDataEvent")]	
	
	/**
	 * Reads an SDMX-ML Structure file and returns the corresponding SDMX
	 * artefacts.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class StructureReader extends EventDispatcher {
		
		/*=============================Constants==============================*/
		
		/**
		 * The StructureReader.CODE_LISTS_EVENT constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>codeListsEvent</code> event.
		 * 
		 * @eventType codeListsEvent
		 */
		public static const CODE_LISTS_EVENT:String = "codeListsEvent";

		/**
		 * The StructureReader.CONCEPTS_EVENT constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>conceptsEvent</code> event.
		 * 
		 * @eventType conceptsEvent
		 */
		public static const CONCEPTS_EVENT:String = "conceptsEvent";

		/**
		 * The StructureReader.KEY_FAMILIES_EVENT constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>keyFamiliesEvent</code> event.
		 * 
		 * @eventType keyFamiliesEvent
		 */
		public static const KEY_FAMILIES_EVENT:String = "keyFamiliesEvent";
		
		/**
		 * The StructureReader.DATAFLOWS_EVENT constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>dataflowsEvent</code> event.
		 * 
		 * @eventType dataflowsEvent
		 */
		public static const DATAFLOWS_EVENT:String = "dataflowsEvent";
		
		/**
		 * The StructureReader.CATEGORY_SCHEMES_EVENT constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>categorySchemesEvent</code> event.
		 * 
		 * @eventType categorySchemesEvent
		 */
		public static const CATEGORY_SCHEMES_EVENT:String = 
			"categorySchemesEvent";
		
		/**
		 * The StructureReader.ORGANISATION_SCHEMES_EVENT constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>organisationSchemesEvent</code> event.
		 * 
		 * @eventType organisationSchemesEvent
		 */
		public static const ORGANISATION_SCHEMES_EVENT:String = 
			"organisationSchemesEvent";
			
		/**
		 * The StructureReader.HIERARCHICAL_CODE_SCHEMES_EVENT constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>hierarchicalCodeSchemesEvent</code> event.
		 * 
		 * @eventType hierarchicalCodeSchemesEvent
		 */
		public static const HIERARCHICAL_CODE_SCHEMES_EVENT:String = 
			"hierarchicalCodeSchemesEvent";	
		
		/*==============================Fields================================*/
		
		private var _dispatchOrganisationSchemes:Boolean;
		
		private var _dispatchDataflows:Boolean;
		
		private var _dispatchCategorySchemes:Boolean;
		
		private var _dispatchCodeLists:Boolean;
		
		private var _dispatchConcepts:Boolean;
		
		private var _dispatchKeyFamilies:Boolean;
		
		private var _dispatchHierarchicalCodeSchemes:Boolean;
		
		private var _data:XML;
		
		private var _codeLists:CodeLists;
		
		private var _concepts:Concepts;
		
		private var _keyFamilies:KeyFamilies;
		
		private var _dataflows:DataflowsCollection;
		
		private var _hierarchies:HierarchicalCodeSchemesCollection;
		
		/*============================Namespaces==============================*/
		
		private namespace message = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message";
		use namespace message;
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
				
		/*===========================Constructor==============================*/
		
		public function StructureReader(target:IEventDispatcher = null) 
		{
			super();
		}
		
		/*=============================Accessors==============================*/
		
		/**
		 * Whether organisation schemes should be extracted from the structure 
		 * file 
		 */
		public function set dispatchOrganisationSchemes(flag:Boolean):void 
		{
			_dispatchOrganisationSchemes = flag;
		}
		
		/**
		 * Whether dataflows should be extracted from the structure file 
		 */
		public function set dispatchDataflows(flag:Boolean):void 
		{
			_dispatchDataflows = flag;
		}

		/**
		 * Whether category schemes should be extracted from the structure file 
		 */		
		public function set dispatchCategorySchemes(flag:Boolean):void 
		{
			_dispatchCategorySchemes = flag;
		}

		/**
		 * Whether code lists should be extracted from the structure file 
		 */		
		public function set dispatchCodeLists(flag:Boolean):void 
		{
			_dispatchCodeLists = flag;
		}

		/**
		 * Whether concepts and concepts schemes should be extracted from the 
		 * structure file 
		 */
		public function set dispatchConcepts(flag:Boolean):void {
			_dispatchConcepts = flag;
		}

		/**
		 * Whether key families should be extracted from the structure file 
		 */		
		public function set dispatchKeyFamilies(flag:Boolean):void 
		{
			_dispatchKeyFamilies = flag
		}
		
		/**
		 * Whether hierarchical code schemes should be extracted from the 
		 * structure file 
		 */	
		public function set dispatchHierarchicalCodeSchemes(flag:Boolean):void
		{
			_dispatchHierarchicalCodeSchemes = flag;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Parses the supplied SDMX-ML Structure file. Events will be dispatched
		 * that contains the extracted SDMX artefacts (e.g.: code lists, key
		 * families, etc). 
		 * 
		 * @param data The SDMX-ML Structure file to be processed.
		 */
		public function read(data:XML):void 
		{
			_data = data;
			if (_dispatchOrganisationSchemes) {
				extractOrganisationSchemes();
			}
			if (_dispatchCodeLists) {
				extractCodeLists();
			}
			if (_dispatchConcepts) {
				extractConceptSchemes();
			}
			if (_dispatchKeyFamilies) {		
				extractCodeLists();
				extractConceptSchemes();
				extractKeyFamilies();
			}
			if (_dispatchDataflows) {
				extractDataflowDefinitions();
			}
			if (_dispatchCategorySchemes) {
				extractCategories();
			}
			
			var extractCL:Boolean = 
				(_dispatchCodeLists || _dispatchKeyFamilies) ? false : true;
			if (_dispatchHierarchicalCodeSchemes) {
				if (extractCL) {
					extractCodeLists();
				}
				extractHierarchicalCodeSchemes();
			}
		}
		
		/*==========================Private methods===========================*/
		
		private function extractOrganisationSchemes():void 
		{
			var organisations:OrganisationSchemes = new OrganisationSchemes();
			var orgExtractor:OrganisationSchemeExtractor = 
				new OrganisationSchemeExtractor();
			for each (var organisationScheme:XML in 
				_data.OrganisationSchemes.OrganisationScheme) {
				organisations.addItem(
					orgExtractor.extract(organisationScheme));
			}	
			if (organisations.length > 0) {
				dispatchEvent(new SDMXDataEvent(organisations, 
					ORGANISATION_SCHEMES_EVENT));
			}	
		}
		
		private function extractCodeLists():void 
		{
			_codeLists = new CodeLists();
			var clExtractor:CodeListExtractor = new CodeListExtractor();
			for each (var codeList:XML in _data.CodeLists.CodeList) {
				_codeLists.addItem(clExtractor.extract(codeList));
			}	
			if (_codeLists.length > 0) {
				dispatchEvent(new SDMXDataEvent(_codeLists, CODE_LISTS_EVENT));
			}
		}
		
		private function extractConceptSchemes():void 
		{
			_concepts = new Concepts();
			var conceptExtractor:ConceptExtractor = new ConceptExtractor();
			var csExtractor:ConceptSchemeExtractor = 
				new ConceptSchemeExtractor();
			for each (var concept:XML in _data.Concepts.Concept) {
				_concepts.addItem(conceptExtractor.extract(concept));
			}
			for each (var conceptScheme:XML in _data.Concepts.ConceptScheme) {
				_concepts.addItem(csExtractor.extract(conceptScheme));
			}
			if (_concepts.length > 0) {
				dispatchEvent(new SDMXDataEvent(_concepts, CONCEPTS_EVENT));
			}
		}
		
		private function extractKeyFamilies():void 
		{
			_keyFamilies = new KeyFamilies();
			var kfExtractor:KeyFamilyExtractor = 
				new KeyFamilyExtractor(_codeLists, _concepts);
			for each (var keyFamily:XML in _data.KeyFamilies.KeyFamily) {
				_keyFamilies.addItem(kfExtractor.extract(keyFamily));
			}
			if (_keyFamilies.length > 0) {
				dispatchEvent(new SDMXDataEvent(_keyFamilies, 
					KEY_FAMILIES_EVENT));
			}
		}
		
		private function extractDataflowDefinitions():void 
		{
			_dataflows = new DataflowsCollection();
			var dfExtractor:DataflowExtractor = 
				new DataflowExtractor(_keyFamilies);
			for each (var dataflow:XML in _data.Dataflows.Dataflow) {
				_dataflows.addItem(dfExtractor.extract(dataflow));
			}
			if (_dataflows.length > 0) {
				dispatchEvent(new SDMXDataEvent(_dataflows, DATAFLOWS_EVENT));
			}
		}
		
		private function extractCategories():void 
		{
			var categories:CategorieSchemesCollection = 
				new CategorieSchemesCollection();
			var catExtractor:CategorySchemeExtractor 
				= new CategorySchemeExtractor(_dataflows);
			for each (var scheme:XML in _data.CategorySchemes.CategoryScheme) {
				categories.addItem(catExtractor.extract(scheme));
			}
			if (categories.length > 0) {
				dispatchEvent(new SDMXDataEvent(categories, 
					CATEGORY_SCHEMES_EVENT));
			}
		}
		
		private function extractHierarchicalCodeSchemes():void
		{
			_hierarchies = new HierarchicalCodeSchemesCollection();
			var hcsExtractor:HierarchicalCodeSchemeExtractor = 
				new HierarchicalCodeSchemeExtractor(_codeLists);
			for each (var hcs:XML in 
				_data.HierarchicalCodelists.HierarchicalCodelist) {
				_hierarchies.addItem(hcsExtractor.extract(hcs));
			}	
			if (_hierarchies.length > 0) {
				dispatchEvent(new SDMXDataEvent(_hierarchies, 
					HIERARCHICAL_CODE_SCHEMES_EVENT));
			}
		}
	}
}