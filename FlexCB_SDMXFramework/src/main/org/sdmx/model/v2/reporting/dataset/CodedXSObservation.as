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
package org.sdmx.model.v2.reporting.dataset
{
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.keyfamily.CodedXSMeasure;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;

	/**
	 * An observation in a cross-sectional dataset that takes its value from
	 * a code list.
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	public class CodedXSObservation extends XSObservation
	{
		/*==============================Fields================================*/
		
		private var _value:Code;
		
		private var _measure:CodedXSMeasure;
		
		/*===========================Constructor==============================*/
		
		public function CodedXSObservation(code:Code, measure:CodedXSMeasure)
		{
			super();
			this.value = code;
			this.measure = measure;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */
		public function set value(code:Code):void 
		{
			if (null == code) {
				throw new ArgumentError("The code cannot be null");	
			} else {
				_value = code;
			}
		}
		
		/**
		 * The code that is the value of the observation
		 */ 
		public function get value():Code 
		{
			return _value;
		}
		
		/**
		 * @private
		 */
		public function set measure(measure:CodedXSMeasure):void 
		{
			if (null == measure) {
				throw new ArgumentError("The measure cannot be null");	
			} else {
				_measure = measure;
			}
		}
		
		/**
		 * Associates the coded cross-sectional measure defined in the 
		 * key family.
		 */
		public function get measure():CodedXSMeasure 
		{
			return _measure;
		}
	}
}