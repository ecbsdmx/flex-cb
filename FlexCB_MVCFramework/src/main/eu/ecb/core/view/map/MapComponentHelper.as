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
	import mx.collections.ArrayCollection;
	
	/**
	 * A utility class containing the hierarchy used for grouping geographical 
	 * entities. It also contains methods used by the map components to 
	 * interact with the hierarchy.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class MapComponentHelper
	{
		/*==============================Fields================================*/
		
		private var _categories:ArrayCollection;
		
		/*===========================Constructor==============================*/
		
		public function MapComponentHelper()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set categories(cat:ArrayCollection):void
		{
			_categories = cat;
		}
		
		/**
		 * The categories to be used on the map.
		 */ 
		public function get categories():ArrayCollection
		{
			return _categories;
		}
		
		/**
		 * The name of the style to be applied to the geographical entities 
		 * belonging to the category.
		 */ 
		public function getStyleName(value:Number):String
		{
			var styleName:String;
			for each (var category:MapCategory in categories) {
				if ((isNaN(category.minValue) || category.minValue <= value) &&
					(isNaN(category.maxValue) || value < category.maxValue)) {
					styleName = category.styleName;
					break;
				}
			}
			if (null == styleName) {
				throw new ArgumentError("No category found for value: "
					 + value);
			}
			return styleName;
		}
		
		/**
		 * The category whose range covers the supplied value.
		 */ 
		public function getCategory(value:Number):MapCategory
		{
			var category:MapCategory
			for each (var curCat:MapCategory in categories) {
				if ((isNaN(curCat.minValue) || curCat.minValue <= value) &&
					(isNaN(curCat.maxValue) || value < curCat.maxValue)) {
					category = curCat;
					break;
				}
			}
			if (null == category) {
				throw new ArgumentError("No category found for value: "
					 + value);
			}
			return category;
		}
	}
}