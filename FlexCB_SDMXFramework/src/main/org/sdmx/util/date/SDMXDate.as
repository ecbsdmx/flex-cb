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
package org.sdmx.util.date
{
	import org.sdmx.util.validator.SDMXDateValidator;
	
	/**
	 * Utility class that converts an ISO 8601 or an SDMX period string into
	 * a date object.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo 
	 * 	o SDMXPeriodType 
	 * 	o Time zone management
	 */
	public class SDMXDate
	{
		/*==============================Fields================================*/
		
		private static var _validator:SDMXDateValidator = 
			new SDMXDateValidator();
		private var _dates:Array;
		
		/*===========================Constructor==============================*/
		
		public function SDMXDate()
		{
			super();
			_dates = new Array();	
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Gets a date object out of an ISO 8601 or an SDMX period string.
		 * 
		 * @param date The ISO8601 date string to be converted into a date
		 * 	object
		 */ 
		public function getDate(date:String):Date {
			if (null != _dates[date]) {
				return _dates[date]; 
			} else {
				if (date.length == 10) {
					_dates[date] = new Date(Number(date.substr(0, 4)), 
						Number(date.substr(5, 2)) - 1, 
						Number(date.substr(8, 2)));				
				} else if (date.length == 7 && 
					!(_validator.isSDMXPeriodType(date))) {
					_dates[date] = new Date(Number(date.substr(0, 4)), 
						Number(date.substr(5, 2)) - 1, 1);
				} else if (date.length == 4) {		
					_dates[date] = new Date(Number(date.substr(0, 4)), 0, 1);			
				} else if (_validator.isGYearMonthDayTime(date) && 
					date.length >= 19) {
					_dates[date] = new Date(Number(date.substr(0, 4)), 
						Number(date.substr(5, 2)) - 1, Number(date.substr(8, 
						2)), Number(date.substr(11,	2)), Number(date.substr(14, 
						2)), Number(date.substr(17, 2)), 0);
				} else if (_validator.isSDMXPeriodType(date)) {
					var target:String = date.charAt(5);
					if ("Q" == target) {
						switch (date.charAt(6)) {
							case "1":
								_dates[date] = 
									new Date(Number(date.substr(0, 4)), 0, 1);
								break;
							case "2":
								_dates[date] = 
									new Date(Number(date.substr(0, 4)), 3, 1);
								break;
							case "3":
								_dates[date] = 
									new Date(Number(date.substr(0, 4)), 6, 1);
								break;
							case "4":
								_dates[date] = 
									new Date(Number(date.substr(0, 4)), 9, 1);
								break;
							default:
								throw new Error("Not yet implemented");				
						}
					} else if ("B" == target) {
						switch (date.charAt(6)) {
							case "1":
								_dates[date] = 
									new Date(Number(date.substr(0, 4)), 0, 1);
								break;
							case "2":
								_dates[date] = 
									new Date(Number(date.substr(0, 4)), 6, 1);
								break;
							default:
								throw new Error("Not yet implemented");				
						}
					}
					
				} else {
					throw new ArgumentError(date + 
						" is not a valid SDMX date.");
				}
				return _dates[date];
			}
		}
	}
}