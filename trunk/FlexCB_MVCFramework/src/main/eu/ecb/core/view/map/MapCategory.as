// Copyright (C) 2010 European Central Bank. All rights reserved.
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
package eu.ecb.core.view.map
{
	/**
	 * A category of data to be displayed on a map.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class MapCategory
	{
		/*==============================Fields================================*/
		
		private var _label:String;
			
		private var _styleName:String;
		
		private var _minValue:Number;
		
		private var _maxValue:Number;
		
		/*===========================Constructor==============================*/
		
		public function MapCategory()
		{
			super();			
		}
		
		/*============================Accessors===============================*/

		/**
		 * @private
		 */
		public function set label(label:String):void
		{
			_label = label;
		}
		
		/**
		 * A descriptive label for the category.
		 */ 	
		public function get label():String
		{
			return _label;
		}
		
		/**
		 * @private
		 */
		public function set styleName(style:String):void
		{
			_styleName = style;
		}
		
		/**
		 * The style to be applied to the geographical entities belonging to the
		 * category.
		 */
		public function get styleName():String
		{
			return _styleName;
		}
		
		/**
		 * @private
		 */
		public function set maxValue(value:Number):void
		{
			_maxValue = value;
		}
		
		/**
		 * The upper boundary for this category.
		 */ 
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		/**
		 * @private
		 */
		public function set minValue(value:Number):void
		{
			_minValue = value;
		}
		
		/**
		 * The lower boundary for this category.
		 */ 
		public function get minValue():Number
		{
			return _minValue;
		}
	}
}