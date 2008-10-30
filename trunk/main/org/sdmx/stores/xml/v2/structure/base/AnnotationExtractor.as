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
	import org.sdmx.model.v2.base.Annotation;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;

	/**
	 * Extracts Annotations out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class AnnotationExtractor implements ISDMXExtractor {
		
		/*==============================Fields================================*/
		
		private namespace common = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common";		
		use namespace common;
		
		/*===========================Constructor==============================*/
		
		public function AnnotationExtractor() {
			super();
		}
		
		/*==========================Public methods============================*/

		/**
		 * @inheritDoc
		 */ 
		public function extract(items:XML):SDMXArtefact {
			var annotation:Annotation = new Annotation();
			var title:QName = 
				new QName(
					"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common", 
					"AnnotationTitle");
			var type:QName = 
				new QName(
					"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common", 
					"AnnotationType");
			var url:QName = 
				new QName(
					"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common", 
					"AnnotationURL");
			var text:QName = 
				new QName(
					"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common", 
					"AnnotationText");						
					
			if (items.child(title).length() > 0) {
				annotation.title = String(items.AnnotationTitle);
			}	
					
			if (items.child(type).length() > 0) {
				annotation.type = String(items.AnnotationType);
			}
			
			if (items.child(url).length() > 0) {
				annotation.url = String(items.AnnotationURL)
			}	
					
			if (items.child(text).length() > 0) {
				var isExtractor:InternationalStringExtractor = 
					ExtractorPool.getInstance().internationalStringExtractor;
				annotation.text = isExtractor.extract(items.child(text)) 
					as InternationalString;
			}
			return annotation;
		}
	}
}