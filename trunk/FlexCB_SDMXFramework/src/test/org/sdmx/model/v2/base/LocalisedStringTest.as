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
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import mx.resources.Locale;
	import mx.utils.ObjectUtil;
	
	/**
	 *	@private 
	 */
	public class LocalisedStringTest extends TestCase
	{
		public function LocalisedStringTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(LocalisedStringTest);
		}
		
		public function testConstructLocalizedString():void {
			var label:String = "test";
			var locale:Locale = new Locale("en");
			var ls:LocalisedString = new LocalisedString(locale, label);
			assertEquals("Labels should be equal", label, ls.label);
			assertEquals("Locales should be equal", locale, ls.locale);
		}
		
		public function testSetLabel():void {
			var label:String = "test";
			var locale:Locale = new Locale("en");
			var ls:LocalisedString = new LocalisedString(locale, label);
			assertEquals("Labels should be equal", label, ls.label);
			assertEquals("Locales should be equal", locale, ls.locale);
			var label2:String = label + "_new";
			ls.label = label2;
			assertEquals("Labels should be equal after setter", label2, ls.label);
		}
		
		public function testSetLocale():void {
			var label:String = "test";
			var locale:Locale = new Locale("en");
			var ls:LocalisedString = new LocalisedString(locale, label);
			assertEquals("Labels should be equal", label, ls.label);
			assertEquals("Locales should be equal", locale, ls.locale);
			var locale2:Locale = new Locale("fr");
			ls.locale = locale2;
			assertEquals("Locales should be equal after setter", locale2, ls.locale);
		}
		
		public function testEquality():void {
			var label:String = "test";
			var locale:Locale = new Locale("en");
			var ls:LocalisedString = new LocalisedString(locale, label);
			var ls2:LocalisedString = new LocalisedString(locale, label);
			assertTrue("The localized strings should be equal", 0 == ObjectUtil.compare(ls, ls2));
			var locale2:Locale = new Locale("fr");
			ls2.locale = locale2;
			assertFalse("The localized strings should not be equal", 0 == ObjectUtil.compare(ls, ls2));
			ls2.locale = locale;
			assertTrue("The localized strings should be equal again", 0 == ObjectUtil.compare(ls, ls2));
		}
	}
}