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
package org.sdmx.model.v2.reporting.dataset
{
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.code.Code;
	
	/**
	 * The value of a component of a key such as the value of the instance a
	 * Dimension in a multidimensional structure, like the Key Descriptor of 
	 * a Key Family.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class KeyValue {
		
		/*==============================Fields================================*/
		
		private var _value:Code;
		
		private var _valueFor:Dimension;
		
		/*===========================Constructor==============================*/
		
		public function KeyValue(value:Code, dimension:Dimension) {
			super();
			this.value = value;
			valueFor = dimension;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */
		public function set value(value:Code):void {
			if (null == value) {
				throw new ArgumentError("The value cannot be null");				
			} else {
				_value = value;
			}
		}
		
		/**
		 * The value of the dimension (for instance, "M" for monthly frequency).
		 */ 
		public function get value():Code {
			return _value;
		}
		
		/**
		 * @private
		 */
		public function set valueFor(dimension:Dimension):void {
			if (null == dimension) {
				throw new ArgumentError("The dimension cannot be null");
			} else {
				_valueFor = dimension;
			}
		}
		
		/**
		 * Associates a dimension to the Key Value, and thereby to the Concept
		 * that is the semantic of the dimension (for instance, "FREQ" for the
		 * concept of frequency.
		 */ 
		public function get valueFor():Dimension {
			return _valueFor;
		}
	}
}