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
package org.sdmx.model.v2.base.structure
{
	import org.sdmx.model.v2.base.type.DataType;
	
	/**
	 * A length range, defined by a minimum and maximum lengths.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see org.sdmx.model.v2.base.type.DataType
	 */ 
	public class LengthRange implements Representation {
		
		/*==============================Fields================================*/
		
		private var _minLength:Number;
		
		private var _maxLength:Number;
		
		private var _dataType:String;
		
		/*===========================Constructor==============================*/
		
		/**
		 * Constructs an object defining the data type and the minimum and 
		 * maximum allowed length of a representation.
		 * 
		 * @param minLength The minimum length allowed
		 * @param maxLength The maximum length allowed
		 * @param type The type of data
		 */
		public function LengthRange(minLength:Number = NaN, 
			maxLength:Number = NaN, type:String = null) {
			super();
			_minLength = minLength;
			_maxLength = maxLength;
			dataType = type;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private 
		 */
		public function set minLength(minLength:Number):void {
			_minLength = minLength;
		}
		
		/**
		 * The minimum length allowed
		 */
		public function get minLength():Number {
			return _minLength;
		}
		
		/**
		 * @private 
		 */
		public function set maxLength(maxLength:Number):void {
			_maxLength = maxLength;
		}
		
		/**
		 * The maximum length allowed
		 */
		public function get maxLength():Number {
			return _maxLength;
		}
		
		/**
		 * @private 
		 */
		public function set dataType(dataType:String):void {
			if (dataType != null && !DataType.contains(dataType)) {
				throw new ArgumentError(dataType + " is not a valid SDMX" + 
						" data type.");
			} else {
				_dataType = dataType;
			}
		}
		
		/**
		 * The type of data as defined in org.sdmx.model.v2.base.type.DataType.
		 * 
		 * @throws ArgumentError <code>ArgumentError</code>: If the supplied 
		 * data type is not a valid SDMX data type.
		 */
		public function get dataType():String {
			return _dataType;
		}
	}
}