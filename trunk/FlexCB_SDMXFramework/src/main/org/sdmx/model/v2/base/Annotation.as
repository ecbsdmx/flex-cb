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
	/**
	 * Additional descriptive information attached to an object.
	 * 
	 * An annotation (or note) is used to convey extra information to describe 
	 * any SDMX construct. Annotations have a name, are identified by a type, 
	 * can have a link to a URL and can have a link to a multi-lingual 
	 * description (provided by an InternationalString).
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see InternationalString
	 * 
	 * @todo
	 * 		Add a validator for the URL
	 */
	public class Annotation implements SDMXArtefact {
		
		/*==============================Fields================================*/
		
		private var _title:String;

		private var _type:String;
		
		private var _url:String;
		
		private var _text:InternationalString;
		
		/*===========================Constructor==============================*/
		
		public function Annotation() {
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
	     * The name used to identify an annotation.
	     */
		public function get title():String {
			return _title;
		}
		
		/**
	     * @private
	     */
		public function set title(title:String):void {
			_title = title;
		}
		
		/**
	     * Specifies how the annotation is to be processed. It is used to
	     * distinguish between annotations designed to support various uses. The
	     * types are not enumerated, as these can be specified by the user or
	     * creator of the annotations. The definitions and use of annotation 
	     * types should be documented by their creator.
	     */
		public function get type():String {
			return _type;
		}
		
		/**
	     * @private
	     */
		public function set type(type:String):void {
			_type = type;
		}
		
		/**
	     * A link to an external descriptive text. It points to an external 
	     * resource which may contain or supplement the annotation. If a 
	     * specific behavior is desired, an annotation type should be defined 
	     * which specifies the use of this field more exactly.
	     */
		public function get url():String {
			return _url;
		}
		
		/**
	     * @private
	     */
		public function set url(url:String):void {
			_url = url;
		}
		
		/**
		 * List of multilingual representations of the text of the annotation.
	     */
		public function get text():InternationalString {
			return _text;
		}
		
		/**
	     * @private
	     */
		public function set text(text:InternationalString):void {
			_text = text;
		}
	}
}