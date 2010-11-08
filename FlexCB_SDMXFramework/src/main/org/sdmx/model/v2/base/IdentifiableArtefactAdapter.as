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
package org.sdmx.model.v2.base
{
	import mx.utils.StringUtil;

	/**
	 * Default implementation of the IdentifiableArtefact interface. 
	 * This class exists as convenience for creating IdentifiableArtefacts 
	 * objects.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo
	 * 		o Create validators for id, uri and urn.
	 * 		o The id should be optional.
	 */
	public class IdentifiableArtefactAdapter extends AnnotableArtefactAdapter 
		implements IdentifiableArtefact {
			
		/*==============================Fields================================*/
			
		private var _id:String;
		
		private var _uri:String;
		
		private var _urn:String;
		
		private var _name:InternationalString;
		
		private var _description:InternationalString;
		
		/*===========================Constructor==============================*/
		
		/**
		 * Constructs an identifiable artefact 
		 * 
		 * @param identifier
		 * 		The object identifier
		 */
		public function IdentifiableArtefactAdapter(identifier:String) {
			super();
			id = identifier;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc 
		 */
		public function get urn():String {
			return _urn;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set urn(urn:String):void {
			_urn = urn;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get name():InternationalString {
			return _name;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set name(name:InternationalString):void {
			if (null != name && name.localisedStrings.length > 0) {
				_name = name;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get description():InternationalString {
			return _description;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set description(description:InternationalString):void {
			if (null != description && description.localisedStrings.length > 0){
				_description = description;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get uri():String {
			return _uri;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set uri(uri:String):void {
			_uri = uri;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get id():String {
			return _id;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set id(id:String):void {
			if (null == id || "" == StringUtil.trim(id)) {
				throw new ArgumentError("The id cannot be null or empty");
			} else {
				_id = id;
			}
		}
	}
}