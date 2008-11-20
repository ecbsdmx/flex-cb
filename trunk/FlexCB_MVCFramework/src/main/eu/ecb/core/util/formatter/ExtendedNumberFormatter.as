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
package eu.ecb.core.util.formatter
{
	import mx.formatters.NumberFormatter;
	
	/**
     * Extension of the standard NumberFormatter to include features such as
     * the use of the "+" sign, etc.
     * 
     * @author Xavier Sosnovsky 
     */ 
	public class ExtendedNumberFormatter extends NumberFormatter {
		
		/*==============================Fields================================*/
		
		private var _forceSigned:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function ExtendedNumberFormatter() 
		{
			super();
			rounding = "nearest";
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set forceSigned(forceSigned:Boolean):void 
		{
			_forceSigned = forceSigned;
		}
		
		/**
		 * Whether or not formatted values should always be signed (+)
		 */ 
		public function get forceSigned():Boolean 
		{
			return _forceSigned;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public override function format(value:Object):String 
		{
			if (value is Number) {
				var number:Number = value as Number;
				var formattedValue:String = super.format(value);
				if (number < 1 && number > 0 && Number(formattedValue) != 0 && 
					formattedValue.substr(0, 2) != "0.") {
	            	formattedValue = "0" + formattedValue;
			    } else if (number < 0 && number > -1 && 
			    	formattedValue.substr(1, 2) != "0.") {
		            formattedValue = formattedValue.substr(0, 1) + "0" + 
		            	formattedValue.substr(1, formattedValue.length - 1);
		        }
		        if (number > 0 && _forceSigned && Number(formattedValue) != 0) {
	            	formattedValue = "+" + formattedValue;
	            }
		        return formattedValue;
			} else {
				throw new ArgumentError(value + " is not a valid argument for "
					+ "this formatter.");
			}
		}
	}
}