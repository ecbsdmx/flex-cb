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
package eu.ecb.core.util.formatter
{
	import mx.formatters.DateBase;
	import mx.formatters.DateFormatter;

	[ResourceBundle("flex_cb_mvc_lang")]
	/**
     * Utility class that extends the standard Flex date formatter, to 
     * accomodate default ECB formatting and frequencies.
     * 
     * There are two possible formats, a short one and a verbose one. 
     * By default, the short one will be displayed. The format will be 
     * depending on the frequency. If no frequency is set, an exception will be
     * thrown.
     * 
     * @author Xavier Sosnovsky
     */ 
	public class SDMXDateFormatter extends DateFormatter {
		
		/*==============================Fields================================*/
		
		private var _frequency:String;
		
		private var _isShortFormat:Boolean;

		/*===========================Constructor==============================*/
		
		public function SDMXDateFormatter() 
		{
			super();
			DateBase.monthNamesLong = resourceManager.getString(
				"flex_cb_mvc_lang", "monthNamesLong").split(",");
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set frequency(frequency:String):void 
		{
			_frequency = frequency;
			switch (frequency) {
				case "B":
				case "D":
					formatString = 
						(isShortFormat) ? "D MMM YYYY" : "D MMMM YYYY";				
					break;
				case "M":
					formatString = (isShortFormat) ? "MMM YYYY" : "MMMM YYYY";				
					break;
				case "Q":
					break; //Will depend on the value passed (see format method)	
				case "A":
					formatString = "YYYY";
					break;	
				default:
					throw new ArgumentError("Unknown frequency: " + frequency);
					break;
			}
		}
		
		/**
		 * The frequency to be used by the formatter 
		 */
		public function get frequency():String 
		{
			return _frequency;
		}
		
		/**
		 * @private
		 */ 
		public function set isShortFormat(isShortFormat:Boolean):void 
		{
			_isShortFormat = isShortFormat;
		}
		
		/**
		 * Whether or not the short format should be used
		 */ 
		public function get isShortFormat():Boolean 
		{
			return _isShortFormat;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public override function format(value:Object):String 
		{
			if (!(value is Date)) {
				throw new ArgumentError("This formatter can only format date " +
					"objects.");
			}
			
			if (frequency == "Q") {
				var quarter:String;
				if (value.month >= 0 && value.month < 3) {
					quarter = "Q1";
				} else if (value.month >= 3 && value.month < 6) {
					quarter = "Q2";
				} else if (value.month >= 6 && value.month < 9) {
					quarter = "Q3";
				} else if (value.month >= 9) {
					quarter = "Q4";
				}
				formatString = "YYYY " + quarter;
			}
			return super.format(value);
		}
	}
}