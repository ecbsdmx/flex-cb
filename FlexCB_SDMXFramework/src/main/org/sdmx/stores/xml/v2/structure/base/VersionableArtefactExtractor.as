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
package org.sdmx.stores.xml.v2.structure.base
{
	import org.sdmx.model.v2.base.IdentifiableArtefact;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.base.VersionableArtefactAdapter;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.util.date.SDMXDate;

	/**
	 * Extracts Versionable artefacts out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class VersionableArtefactExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/
		
		/*private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;*/
		private var _iaExtractor:IdentifiableArtefactExtractor;
		private var _sdmxDate:SDMXDate; 
		private var _identifiableArtefact:IdentifiableArtefact;
		
		/*===========================Constructor==============================*/
		
		public function VersionableArtefactExtractor() {
			super();
			_iaExtractor = 
				ExtractorPool.getInstance().identifiableArtefactExtractor;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact {
			_identifiableArtefact = 
				_iaExtractor.extract(items) as IdentifiableArtefact;	
			var versionableArtefact:VersionableArtefactAdapter = 
				new VersionableArtefactAdapter(_identifiableArtefact.id);
			versionableArtefact.annotations = _identifiableArtefact.annotations;
			versionableArtefact.description = _identifiableArtefact.description;
			versionableArtefact.name = _identifiableArtefact.name;
			versionableArtefact.uri = _identifiableArtefact.uri;
			versionableArtefact.urn = _identifiableArtefact.urn;	
			if (items.attribute("version").length() > 0) {
				versionableArtefact.version = items.@version;
			}
			if (items.attribute("validFrom").length() > 0) {
				if (null == _sdmxDate) {
					_sdmxDate = new SDMXDate();
				}
				versionableArtefact.validFrom = 
					_sdmxDate.getDate(items.@validFrom);
			}
			if (items.attribute("validTo").length() > 0) {
				if (null == _sdmxDate) {
					_sdmxDate = new SDMXDate();
				}
				versionableArtefact.validTo = _sdmxDate.getDate(items.@validTo);
			}
			return versionableArtefact;
		}
	}
}