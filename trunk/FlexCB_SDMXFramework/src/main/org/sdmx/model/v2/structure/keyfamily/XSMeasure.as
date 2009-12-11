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
package org.sdmx.model.v2.structure.keyfamily
{
	import org.sdmx.model.v2.base.structure.Component;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * The phenomenon to be measured in a cross-sectional dataset.
	 * 
     * @author Xavier Sosnovsky
	 */ 
	public class XSMeasure extends Component
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 
		protected var _code:Code;
		
		/**
		 * @private
		 */
		protected var _measureDimension:MeasureTypeDimension;
		
		/*===========================Constructor==============================*/
		
		public function XSMeasure(identifier:String, concept:Concept, code:Code,
			dimension:MeasureTypeDimension)
		{
			super(identifier, concept);
			this.code = code;
			measureDimension = dimension; 
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set code(code:Code):void
		{
			_code = code;
		}
		
		/**
		 * The code value for the measure type dimension that defines the 
		 * measure. If the measure type dimension is, for example, "REF_AREA",
		 * a valid code would be "FR".
		 */ 
		public function get code():Code
		{	
			return _code;
		}
		
		/**
		 * @private
		 */ 
		public function set measureDimension(
			dimension:MeasureTypeDimension):void
		{
			_measureDimension = dimension; 
		}
		
		/**
		 * The measure type dimension (e.g.: REF_AREA) that gives its
		 * identity to the cross-sectional measure.
		 */ 
		public function get measureDimension():MeasureTypeDimension
		{
			return _measureDimension;
		}
	}
}