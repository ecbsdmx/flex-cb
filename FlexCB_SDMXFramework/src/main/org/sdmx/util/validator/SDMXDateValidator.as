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
package org.sdmx.util.validator
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	/**
	 * Validates whether the supplied object is a valid ISO 8601 date or a 
	 * valid SDMX period.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * TODO:
	 * 	- Improve validation of hours, minutes and seconds
	 * 	- Add handling of time zones
	 */ 
	public class SDMXDateValidator extends Validator 
	{	
		
		/*==============================Fields================================*/
		
		private var _results:Array;
		
		private var _gYearMonthDayTimePattern:RegExp;
		
		private var _gYearMonthDayPattern:RegExp;
		
		private var _gYearMonthPattern:RegExp;
		
		private var _gYearPattern:RegExp;
		
		/*===========================Constructor==============================*/
		
		public function SDMXDateValidator() 
		{
			super();
			_gYearMonthDayPattern = /^\d{4}-\d{2}-\d{2}/;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Whether the supplied String is in ISO 8601 GYear format 
		 * (e.g.: 2007)
		 */ 
		public function isGYear(value:String):Boolean 
		{
			if (null == _gYearPattern) {
				_gYearPattern = /^\d{4}/;
			} 
			return _gYearPattern.test(value);
		}
		
		/**
		 * Whether the supplied String is in ISO 8601 GYearMonth format 
		 * (e.g.: 2007-07)
		 */ 
		public function isGYearMonth(value:String):Boolean 
		{
			if (null == _gYearMonthPattern) {
				_gYearMonthPattern = /^\d{4}-\d{2}/;
			}
			return _gYearMonthPattern.test(value);
		} 
		
		/**
		 * Whether the supplied String is in ISO 8601 GYearMonthDay format 
		 * (e.g.: 2007-07-28)
		 */ 
		public function isGYearMonthDay(value:String):Boolean 
		{
			return _gYearMonthDayPattern.test(value);
		}
		
		/**
		 * Whether the supplied String is in ISO 8601 GYearMonthDatTime format 
		 * (e.g.: 2007-07-28T14:00:00)
		 */ 
		public function isGYearMonthDayTime(value:String):Boolean 
		{
			if (null == _gYearMonthDayTimePattern) {
				_gYearMonthDayTimePattern = 
					/^\d{4}-\d{2}-\d{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}/;
			}
			return _gYearMonthDayTimePattern.test(value);
		}
		
		/**
		 * Whether the supplied String is an SDMX period 
		 * (e.g.: 2007Q3)
		 */ 
		public function isSDMXPeriodType(value:String):Boolean 
		{
			var success:Boolean = false;
			var pattern:RegExp = /^\d{4}-[T|B|Q|W]\d{1,2}$/;
			if (pattern.test(value)) {
				var period:String = value.substr(5, 1);
				var periodNumber:Number = Number(value.substr(6, value.length));
				if ("Q" == period) {
					success = periodNumber >= 1 && periodNumber <= 4;
				} else if ("T" == period) {
					success = periodNumber >= 1 && periodNumber <= 3;
				} else if ("B" == period) {
					success = periodNumber >= 1 && periodNumber <= 2;
				} else if ("W" == period) {
					success = periodNumber >= 1 && periodNumber <= 52;
				}
			}
			return success;
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * @private
		 */ 
		protected override function doValidation(value:Object):Array 
		{
			_results = new Array();
			var check:String = value as String;
			var success:Boolean;
			if (4 <= check.length && 16 >= check.length) {
				success = isGYearMonthDay(check);
				if (success) {
					return _results;
				} else {
					if (7 <= check.length && 13 >= check.length) {
						_results = new Array();
						success = isGYearMonth(check);
					} 
					
					if (!success && (7 <= check.length && 
						8 >= check.length)) {
						_results = new Array();
						success = isSDMXPeriodType(check);
					}
					
					var pattern:RegExp = /^\d{4}-[T|B|Q|W]\d{1,2}$/;
					if (!success && 10 >= check.length &&
						!pattern.test(check)) {
						_results = new Array();
						success = isGYear(check);
					}
				} 
			} else if (19 <= check.length && 25 >= check.length) {
				success = isGYearMonthDayTime(check);
			} 
						
			if (!success) {
				_results.push(new ValidationResult(true, null, 
					"Not SDMX TimePeriod value", "The supplied date " + value + 
					" is not a valid " + "SDMX TimePeriod date."));	
			}
			return _results;
		}
	}
}