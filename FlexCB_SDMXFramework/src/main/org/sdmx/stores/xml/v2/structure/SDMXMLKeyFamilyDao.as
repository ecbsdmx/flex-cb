// Copyright (C) 2009 European Central Bank. All rights reserved.
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
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.stores.api.BaseSDMXDaoFactory;
	import org.sdmx.stores.api.IMaintainableArtefactProvider;

	/**
	 * Provides access to the key families available in the supplied SDMX-ML
	 * Structure file. 
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class SDMXMLKeyFamilyDao extends EventDispatcher implements 
		IMaintainableArtefactProvider
	{
		/*==============================Fields================================*/
		
		private var _reader:StructureReader;
		
		private var _structureXML:XML;
		
		private var _parseStructure:Boolean;
		
		private var _artefactID:String;
		
		private var _maintenanceAgencyID:String;
		
		private var _versionNumber:String;
		
		private var _keyFamilies:KeyFamilies;
		
		/*============================Constructor=============================*/
		
		public function SDMXMLKeyFamilyDao()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The structure file to be parsed and interpreted.
		 *  
		 * @param file The structure file to be parsed and interpreted.
		 */
		public function set structureFile(file:XML):void
		{
			if (validStructureFile(file)) {
				_structureXML = file;
				_parseStructure = true;
			} else  {
				throw new ArgumentError("The structure file '" + file + "' is" + 
					" not in a format that this application can handle");
			}
		}
		
		/*==========================Public methods============================*/		
		
		/**
		 * @inheritDoc
		 */ 
		public function getMaintainableArtefact(artefactID:String=null, 
			maintenanceAgencyID:String=null, versionNumber:String=null):void
		{
			_artefactID = artefactID;
			_maintenanceAgencyID = maintenanceAgencyID;
			_versionNumber = versionNumber;
			if (_parseStructure) {
				if (null == _reader) {
					_reader = new StructureReader();
					_reader.addEventListener(StructureReader.KEY_FAMILIES_EVENT, 
						handleKeyFamilies);	
					_reader.dispatchKeyFamilies = true;
				}
				_reader.read(_structureXML);	
			} else {
				dispatchResults();
			}
		}
		
		/*==========================Private methods===========================*/
		
		private function handleKeyFamilies(event:SDMXDataEvent):void 
		{
			_keyFamilies = event.data as KeyFamilies;
			event.stopImmediatePropagation();
			event = null;
			dispatchResults();
		}
		
		private function validStructureFile(file:XML):Boolean
		{
			// Check for 2.0
			var messageNS:Namespace = new Namespace("message", 
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message");
			var valid:Boolean = file.messageNS::KeyFamilies.length() > 0;
			
			// Check for 2.1
			if (!valid) {
				var messageNS21:Namespace = new Namespace("message", 
				"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message");
				var structureNS21:Namespace = new Namespace("structure", 
				"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure");
				valid = file.messageNS21::Structures.structureNS21::DataStructures.length() > 0;
			} 	
			return valid;
		}
		
		private function dispatchResults():void
		{
			if (null != _artefactID || null != _maintenanceAgencyID || 
				null != _versionNumber) {
				var kf:KeyFamily = _keyFamilies.getKeyFamilyByID(_artefactID, 
					_maintenanceAgencyID, _versionNumber);
				var results:KeyFamilies = new KeyFamilies();
				if (null != kf) {
					results.addItem(kf);
				}
				dispatchEvent(new SDMXDataEvent(results, 
					BaseSDMXDaoFactory.KEY_FAMILIES_EVENT));	 
			} else {
				dispatchEvent(new SDMXDataEvent(_keyFamilies, 
					BaseSDMXDaoFactory.KEY_FAMILIES_EVENT));
			}
		}
	}
}