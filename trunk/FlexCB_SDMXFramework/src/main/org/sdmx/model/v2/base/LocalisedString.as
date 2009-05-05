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
	import mx.resources.Locale;
	
	/**
	 * Supports the representation of a description in one locale.
	 * Multiple language versions of a specific description are grouped together 
	 * in an InternationalString.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see LocalisedStringsCollection
	 */
	public class LocalisedString {
		
		/*==============================Fields================================*/
		
		private var _label:String;
		
		private var _locale:Locale;
		
		/*===========================Constructor==============================*/
		
		 /**
	     * Creates a new LocalisedString instance, taking a locale and a
	     * language specific representation of a description as parameters.
	     * 
	     * @param locale The locale of the string (e.g: en).
	     * @param label The language specific representation of a description
	     * (e.g.: Statistics) 
	     */
		public function LocalisedString(locale:Locale, label:String) {
			super();
			_label = label;
			_locale = locale;
		}
		
		/*============================Accessors===============================*/
		
		/**
	     * The language-specific text
	     */
		public function get label():String {
			return _label;
		}
		
		/**
	     * @private
	     */
		public function set label(label:String):void {
			_label = label;
		}
		
		/**
	     * The locale of the current LocalisedString instance
	     */
		public function get locale():Locale {
			return _locale;
		}
		
		/**
	     * @private
	     */
		public function set locale(locale:Locale):void {
			_locale = locale;
		}		
	}
}