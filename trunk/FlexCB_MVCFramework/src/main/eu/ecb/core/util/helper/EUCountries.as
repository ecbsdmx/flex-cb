// Copyright (C) 2009 European Central Bank. All rights reserved.
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
package eu.ecb.core.util.helper
{
	import mx.collections.ArrayCollection;
	
	/**
	 * Utility class with list of countries belonging to the European Union and
	 * the euro area. The class contains utility methods to get the country
	 * title out of country codes, to convert between 2- and 3-letters codes, 
	 * etc.
	 *
	 * @author Karine Feraboli   
	 * @author Xavier Sosnovsky
	 */
	public class EUCountries
	{
		/*==============================Fields================================*/
		
		private var _2To3Codes:Object;
		
		private var _3To2Codes:Object;
		
		private var _euroArea:ArrayCollection;
		
		private var _europeanUnion:ArrayCollection;
		
		private var _euroAreaJoinDates:Object;
		
		private var _useFixedComposition:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function EUCountries()
		{
			super();
			_2To3Codes = {AT: "AUT", BE: "BEL", CY: "CYP", DE: "DEU", ES: "ESP", 
				FI: "FIN", FR: "FRA", GR: "GRC", IE: "IRL", IT: "ITA", 
				LU: "LUX", MT: "MLT", NL: "NLD", PT: "PRT", SI: "SVN",
				LT: "LTU", GB: "GBR", DK: "DNK", PL: "POL", EE: "EST",
				LV: "LVA", CZ: "CZE", SK: "SVK", BG: "BGR", SE: "SWE",
				RO: "ROM", HU: "HUN"};
			_3To2Codes = {AUT: "AT", BEL: "BE", CYP: "CY", DEU: "DE", ESP: "ES", 
				FIN: "FI", FRA: "FR", GRC: "GR", IRL: "IE", ITA: "IT", 
				LUX: "LU", MLT: "MT", NLD: "NL", PRT: "PT", SVN: "SI", 
				LTU: "LT", GBR: "GB", DNK: "DK", POL: "PL", EST: "EE",
				LVA: "LV", CZE: "CZ", SVK: "SK", BGR: "BG", SWE: "SE",
				ROM: "RO", HUN: "HU"};
			_euroArea = new ArrayCollection(["AT", "BE", "CY", "DE", "EE", "ES", 
				"FI", "FR", "GR", "IE", "IT", "LU", "MT", "NL", "PT", "SI", 
				"SK"]);
			_europeanUnion = new ArrayCollection(_euroArea.toArray().concat([
				"LT", "GB", "DK", "PL", "LV", "CZ", "BG", "SE", "RO", 
				"HU"]));	
			_euroAreaJoinDates = {AT: "1996-01", BE: "1996-01", CY: "2008-01", 
				DE: "1996-01", EE: "2011-01", ES: "1996-01", FI: "1996-01", 
				FR: "1996-01", GR: "2001-01", IE: "1996-01", IT: "1996-01", 
				LU: "1996-01", MT: "2008-01", NL: "1996-01", PT: "1996-01", 
				SI: "2007-01", SK: "2009-01"};	
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Returns the list of countries belonging to the European Union. 
		 * 
		 * @return The list of countries belonging to the European Union
		 */
		public function get euMembers():ArrayCollection
		{
			return _europeanUnion;
		}
		
		/**
		 * Whether the fixed euro area composition should be used.
		 */ 
		public function set useFixedEuroAreaComposition(flag:Boolean):void
		{
			_useFixedComposition = flag;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Translates a 2-letters country code into a 3-letters one. 
		 * @param code A 2-letters country code
		 * @return The 3-letters country code
		 */
		public function translateTwoLettersCode(code:String):String
		{
			return _2To3Codes[code];
		}
		
		/**
		 * Translates a 3-letters country code into a 3-letters one. 
		 * @param code A 3-letters country code
		 * @return The 2-letters country code
		 */
		public function translateThreeLettersCode(code:String):String
		{
			return _3To2Codes[code];
		}
		
		/**
		 * Whether or not the country belongs to the euro area 
		 * @param code The country code
		 * @return Whether or not the country belongs to the euro area
		 */
		public function belongsToEuroArea(code:String, date:String):Boolean 
		{
			if (_useFixedComposition) {
				return belongsToLatestEuroAreaComposition(code);
			} else {
				if (null != code) {
					var targetCode:String;
					if (code.length == 2) {
						targetCode = code;
					} else if (code.length == 3 && 
						_3To2Codes.hasOwnProperty(code)) {
						targetCode = _3To2Codes[code];
					} else {
						return false;
					}
					if (date.length == 4) {
						date = date + "-01";
					}
					return _euroArea.contains(targetCode) && 
						date >= _euroAreaJoinDates[targetCode]; 
				} else {
					return false;
				}
			}
		}
		
		/**
		 * Whether or not the country belongs to the latest euro area 
		 * composition. 
		 * 
		 * @param code The country code
		 */
		public function belongsToLatestEuroAreaComposition(code:String):Boolean 
		{
			if (null != code) {
				var targetCode:String;
				if (code.length == 2) {
					targetCode = code;
				} else if (code.length == 3 && 
					_3To2Codes.hasOwnProperty(code)) {
					targetCode = _3To2Codes[code];
				} else {
					return false;
				}
				return _euroArea.contains(targetCode); 
			} else {
				return false;
			}
		}
		
		/**
		 * Whether or not the country belongs to the European Union
		 * @param code The country code
		 * @return Whether or not the country belongs to the European Union
		 */
		public function belongsToEuropeanUnion(code:String):Boolean 
		{
			if (null != code && code.length == 2) {
				return _europeanUnion.contains(code);
			} else if (null != code && code.length == 3 && 
				_3To2Codes.hasOwnProperty(code)) {
				return _europeanUnion.contains(_3To2Codes[code]);
			} else {
				return false;
			}
		}
	}
}