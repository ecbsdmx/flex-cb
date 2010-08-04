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
	import org.sdmx.model.v2.base.IdentifiableArtefactAdapter;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;

	/**
	 * Extracts Identifiable artefacts out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class IdentifiableArtefactExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/
		
		private namespace xml = "http://www.w3.org/XML/1998/namespace";
		use namespace xml;
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private var _isExtractor:InternationalStringExtractor;
		
		private static var _nameQName:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"Name");
		
		private static var _descQName:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"Description");		
			
		/*===========================Constructor==============================*/
		
		public function IdentifiableArtefactExtractor() {
			super();
			_isExtractor = 
				ExtractorPool.getInstance().internationalStringExtractor;
		}
		
		/*==========================Public methods============================*/

		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact {
			var id:String = null;		
			if (items.attribute("id").length() > 0) {
				id = items.@id;
			} else if (items.attribute("value").length() > 0) {
				id = items.@value;
			} else {
				throw new SyntaxError(
					"Could not find the id attribute but it is mandatory.");
			} 
			
			var item:IdentifiableArtefactAdapter = 
				new IdentifiableArtefactAdapter(id);
			
			if (items.attribute("uri").length() > 0) {
				item.uri = items.@uri;
			}
			
			if (items.attribute("urn").length() > 0) {
				item.urn = items.@urn;
			}
			
			if (items.child(_nameQName).length() > 0) {
				item.name = _isExtractor.extract(items.Name) 
					as InternationalString;
			}

			if (items.child(_descQName).length() > 0) {
				item.description = _isExtractor.extract(items.Description) 
					as InternationalString;
			}

			/* Disabled annotation fetching for small performance improvement
			var annotationsElement:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"Annotations");
			if (items.child(annotationsElement).length() > 0) {	
				var annotationExtractor:AnnotationExtractor =
					new AnnotationExtractor();
				var annotations:AnnotationsCollection = 
					new AnnotationsCollection();
				for each (var annotationItem:XML in items.child(
					annotationsElement).child(new QName(
					"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common", 
					"Annotation"))) {
					annotations.addItem(
						annotationExtractor.extract(annotationItem));
				}
				item.annotations = annotations
			}*/	
			return item;
		}
	}
}