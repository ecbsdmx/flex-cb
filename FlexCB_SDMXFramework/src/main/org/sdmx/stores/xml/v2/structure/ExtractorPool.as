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
	import org.sdmx.stores.xml.v2.structure.base.IdentifiableArtefactExtractor;
	import org.sdmx.stores.xml.v2.structure.base.InternationalStringExtractor;
	import org.sdmx.stores.xml.v2.structure.base.MaintainableArtefactExtractor;
	import org.sdmx.stores.xml.v2.structure.base.VersionableArtefactExtractor;
	import org.sdmx.stores.xml.v2.structure.collection.CodeExtractor;
	
	/**
	 * This class acts as a factory for extractors, creating them when needed
	 * and returning them upon request. The class is implemented as a singleton.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class ExtractorPool
	{
		
		/*==============================Fields================================*/
		
       	private static var _instance:ExtractorPool;
       	
       	private var _identifiableExtractor:IdentifiableArtefactExtractor;
       	
       	private var _versionableExtractor:VersionableArtefactExtractor;
       	
       	private var _maintainableExtractor:MaintainableArtefactExtractor;
       	
       	private var _internationalStringExtractor:InternationalStringExtractor;
       	
       	private var _codeExtractor:CodeExtractor;
		
		/*===========================Constructor==============================*/
			
		public function ExtractorPool(enforcer:SingletonEnforcer) {
			super();
		}			
		
		/*==========================Public methods============================*/
		
		/**
		 * Gets the instance of the ExtractorPool class to be used by the 
		 * application. 
		 * 
		 * @return The instance of the ExtractorPool class to be used by the 
		 * application.
		 */
		static public function getInstance():ExtractorPool 
		{
			if (null == _instance) {
				_instance = new ExtractorPool(new SingletonEnforcer());
			}
			return _instance;
		}
		
		/**
		 * Gets an extractor of identifiable artefacts
		 *  
		 * @return An extractor of identifiable artefacts
		 */
		public function get identifiableArtefactExtractor():
			IdentifiableArtefactExtractor
		{
			if (null == _identifiableExtractor) {
				_identifiableExtractor = new IdentifiableArtefactExtractor();
			}
			return _identifiableExtractor;
		}
		
		/**
		 * Gets an extractor of versionable artefacts
		 *  
		 * @return An extractor of versionable artefacts
		 */
		public function get versionableArtefactExtractor():
			VersionableArtefactExtractor
		{
			if (null == _versionableExtractor) {
				_versionableExtractor = new VersionableArtefactExtractor();
			}
			return _versionableExtractor;
		}
		
		/**
		 * Gets an extractor of maintainable artefacts
		 *  
		 * @return An extractor of maintainable artefacts
		 */
		public function get maintainableArtefactExtractor():
			MaintainableArtefactExtractor
		{
			if (null == _maintainableExtractor) {
				_maintainableExtractor = new MaintainableArtefactExtractor();
			}
			return _maintainableExtractor;
		}
		
		/**
		 * Gets an extractor of international strings
		 *  
		 * @return An extractor of international strings
		 */
		public function get internationalStringExtractor():
			InternationalStringExtractor
		{
			if (null == _internationalStringExtractor) {
				_internationalStringExtractor = 
					new InternationalStringExtractor();
			}
			return _internationalStringExtractor;
		}
		
		/**
		 * Gets an extractor of codes
		 *  
		 * @return An extractor of codes
		 */
		public function get codeExtractor():
			CodeExtractor
		{
			if (null == _codeExtractor) {
				_codeExtractor = 
					new CodeExtractor();
			}
			return _codeExtractor;
		}
	}
}

class SingletonEnforcer{}