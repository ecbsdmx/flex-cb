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
package org.sdmx.model.v2.base.structure
{
	import mx.collections.ArrayCollection;
	
	import org.sdmx.model.v2.base.AnnotationsCollection;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.VersionableArtefact;
	import org.sdmx.model.v2.base.VersionableArtefactAdapter;

	/**
	 * An abstract definition of a list of components. A concrete example is a 
	 * key descriptor which defines the list of dimensions that make up a key 
	 * for a key family.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class ComponentList extends ArrayCollection 
		implements VersionableArtefact {
			
		/*==============================Fields================================*/
		
		private var _versionableArtefact:VersionableArtefact;	
					
		/*===========================Constructor==============================*/
		
		public function ComponentList(id:String, source:Array=null) {
			super(source);
			_versionableArtefact = new VersionableArtefactAdapter(id);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc 
		 */
		public function get version():String {
			return _versionableArtefact.version;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set version(version:String):void {
			_versionableArtefact.version = version;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get validTo():Date {
			return _versionableArtefact.validTo;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set validTo(date:Date):void {
			_versionableArtefact.validTo = date;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get validFrom():Date {
			return _versionableArtefact.validFrom;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set validFrom(date:Date):void {
			_versionableArtefact.validFrom = date;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get urn():String {
			return _versionableArtefact.urn;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set urn(urn:String):void {
			_versionableArtefact.urn = urn;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get name():InternationalString {
			return _versionableArtefact.name;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set name(name:InternationalString):void {
			_versionableArtefact.name = name;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get description():InternationalString {
			return _versionableArtefact.description;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set description(description:InternationalString):void {
			_versionableArtefact.description = description;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get uri():String {
			return _versionableArtefact.uri;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set uri(uri:String):void {
			_versionableArtefact.uri = uri;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get id():String {
			return _versionableArtefact.id;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set id(id:String):void {
			_versionableArtefact.id = id;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set annotations(annotations:AnnotationsCollection):void {
			_versionableArtefact.annotations = annotations;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get annotations():AnnotationsCollection {
			return _versionableArtefact.annotations;
		}
	}
}