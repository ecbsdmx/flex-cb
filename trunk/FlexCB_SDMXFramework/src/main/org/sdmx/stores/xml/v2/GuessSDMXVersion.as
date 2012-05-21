// Copyright (C) 2011 European Central Bank. All rights reserved.
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
package org.sdmx.stores.xml.v2
{
	public class GuessSDMXVersion
	{
		private static var _sdmxVersion:String;
		
		public static const SDMX_v1_0:String = "1.0";
		public static const SDMX_v2_0:String = "2.0";
		public static const SDMX_v2_1:String = "2.1"; 

		public static function setSdmxVersion(file:XML):void
		{
			for each (var ns:String in file.namespaceDeclarations()) {
				if (-1 < ns.toLowerCase().indexOf("www.sdmx.org")) {
					if (-1 < ns.indexOf("v1_0")) {
						_sdmxVersion = "1.0";
					} else if (-1 < ns.indexOf("v2_0")) {
						_sdmxVersion = "2.0";
					} else if (-1 < ns.indexOf("v2_1")) {
						_sdmxVersion = "2.1";
					} else {
						throw new ArgumentError("Unknown SDMX version: " + ns);
					}
					break;
				}
			}
			if (null == _sdmxVersion) {
				throw new ArgumentError("Could not find any SDMX message");
			}
		}
		
		public static function getSdmxVersion():String
		{
			return _sdmxVersion;
		}
	}
}