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
package eu.ecb.core.util.helper
{
	import mx.collections.ArrayCollection;
	
	/**
	 * A utility class that contains the list of valid colors for series
	 *   
	 * @author Xavier Sosnovsky
	 * @author Rok Povse
	 * 
	 * @todo
	 * 		- The list of colours should be in an XML file 
	 */
	public class SeriesColors
	{
		/*==============================Fields================================*/
		
		private static var _colors:ArrayCollection;
		private static var _seriesKeysColors:ArrayCollection;
		
		/*==========================Public methods============================*/
		
		/**
		 * Gets the list of colours 
		 * @return the list of colours 
		 */
		public static function getColors():ArrayCollection
		{
			if (null == _colors) {
				createColorsCollection();
			}
			return _colors;
		}
		
		/**
		 * Gets the color for given series key
		 * @return the color for series key
		 */ 
		public static function getColorForSeriesKey(seriesKey:String):uint {
			if (null == _colors) {
				createColorsCollection();
			}
			
			if (!_seriesKeysColors.contains(seriesKey)) {
				_seriesKeysColors.addItem(seriesKey);
		    }
		
			if (_seriesKeysColors.length > _colors.length) {
				_colors.addItem(Math.round( Math.random() * 0xFFFFFF ));
			}
			
			return _colors.getItemAt(_seriesKeysColors.getItemIndex(seriesKey))
				as uint;
		}
		
		/**
		 * Clears stored seriesKeys
		 */ 
		public static function resetSeriesKeysColors():void {
			_seriesKeysColors = new ArrayCollection();
		}
		
		/**
		 * Returns stored series keys collection
		 */ 
		public static function getSeriesKeys():ArrayCollection {
			return _seriesKeysColors;
		}
		
		/*==========================Private methods===========================*/
		
		private static function createColorsCollection():void 
		{
			_seriesKeysColors = new ArrayCollection();
			_colors = new ArrayCollection();
			_colors.addItem(0x2C70AA);
			_colors.addItem(0xDECF4D);
			_colors.addItem(0xB38D4A);
			_colors.addItem(0x648668);
			_colors.addItem(0xF79B37);
			_colors.addItem(0x89807C);
			_colors.addItem(0x78A9D7);
			_colors.addItem(0x77AA7D);
			_colors.addItem(0xDBB487);
			_colors.addItem(0x005975);
			_colors.addItem(0xDD882C);
			_colors.addItem(0x91B095);
			_colors.addItem(0x246AAD);
			_colors.addItem(0xCB8234);
			_colors.addItem(0xFEB24C);
			_colors.addItem(0x3690C0);
			_colors.addItem(0x525252);
		}
	}
}