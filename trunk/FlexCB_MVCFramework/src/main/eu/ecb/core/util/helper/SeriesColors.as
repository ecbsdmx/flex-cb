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
	 * @author Steven Bagshaw
	 * 
	 * @todo
	 * 		- The list of colours should be in an XML file 
	 */
	public class SeriesColors
	{
		/*==============================Fields================================*/
		
		private static var _colors:ArrayCollection;
		private static var _seriesKeysColors:ArrayCollection;
		private static var _codeColors:ArrayCollection; //SBa
		private static var _codeColorPicker:ArrayCollection; //SBa
		private static var _codeWeightPicker:ArrayCollection; //SBa
		private static var _codePatternPicker:ArrayCollection; //SBa
		
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
		 * Gets a colour by index.
		 * 
		 * @return an RGB colour
		 */
		public static function getColorByIndex(index:int):uint
		{
		    if (null == _colors) {
				createColorsCollection();
			}
			
			if (index >= _colors.length)
			    _colors.addItem(Math.round( Math.random() * 0xFFFFFF ));
			    
			return _colors.getItemAt(index) as uint;
		}
		
		/**
		 * Gets the colour for a particular code. This can be used instead of
		 * a full series key when the colour used is always driven
		 * by a specific dimension.
		 * 
		 * The function automatically generates a consistent colour for the
		 * code, but allows no specific control of colours.
		 * 
		 * @param code a code ID
		 * @return an RGB colour
		 */
		public static function getColorForCode(code:String):uint {
		    if (_codeColors == null)
				initColorPicker();

			if (_codeColors.contains(code))
			    return _codeColorPicker.getItemAt(_codeColors.getItemIndex(code)) as uint;

			//no colour for this code yet, so we'll pick one from the list
			_codeColors.addItem(code);
		    
			if (_codeColors.length > _codeColorPicker.length)
				_codeColorPicker.addItem(Math.round( Math.random() * 0xFFFFFF ));
			
			return _codeColorPicker.getItemAt(_codeColors.length - 1) as uint;
		}
		
		/**
		 * Returns a weighting for display of a specific code. This
		 * weighting can be applied however you like, but is 
		 * intended to allow a visual distinction between series.
		 * 
		 * For example, when displaying a lot of series at once,
		 * thicker lines (i.e. higher weight values) can be used
		 * to distinguish between similar colours.
		 * 
		 * @param code a code ID
		 * @return an integer value, minimum value of 1
		 */ 
		public static function getWeightForCode(code:String):uint {
		    if (_codeColors == null)
				initColorPicker();

			if (_codeColors.contains(code))
			    return _codeWeightPicker.getItemAt(_codeColors.getItemIndex(code)) as uint;

			//no colour for this code yet, so we'll pick one from the list
			_codeColors.addItem(code);
		    
			if (_codeColors.length > _codeWeightPicker.length)
				_codeWeightPicker.addItem(Math.round( Math.random() * 0xFFFFFF ));
			
			return _codeWeightPicker.getItemAt(_codeColors.length - 1) as uint;
		}
		
		/**
		 * Returns a weighting for display of a specific code. This
		 * weighting can be applied however you like, but is 
		 * intended to allow a visual distinction between series.
		 * 
		 * For example, when displaying a lot of series at once,
		 * thicker lines (i.e. higher weight values) can be used
		 * to distinguish between similar colours.
		 * 
		 * @param code a code ID
		 * @return array like {pattern: [10,20,2,15]}
		 */ 
		public static function getPatternForCode(code:String):Object {
		    if (_codeColors == null)
				initColorPicker();

			if (_codeColors.contains(code))
			    return  _codePatternPicker.getItemAt(_codeColors.getItemIndex(code));

			//no colour for this code yet, so we'll pick one from the list
			_codeColors.addItem(code);
		    
		    //just a solid line for series over our array length
			if (_codeColors.length > _codePatternPicker.length)
				return {pattern: [10000]};
			
			return _codePatternPicker.getItemAt(_codeColors.length - 1);
		}
		
		/**
		 * Gets the color for given series key
		 * @return the color for series key
		 */ 
		public static function getColorForSeriesKey(seriesKey:String):uint {
			if (null == _seriesKeysColors)
				initColorPicker();
			
		    if (_seriesKeysColors.contains(seriesKey))
			    return _colors.getItemAt(_seriesKeysColors.getItemIndex(seriesKey)) as uint;
			    
			//no colour for this series yet, so we'll pick one from the list
			_seriesKeysColors.addItem(seriesKey);
		    
			if (_seriesKeysColors.length > _codeColorPicker.length)
				_colors.addItem(Math.round( Math.random() * 0xFFFFFF ));
			
			return _colors.getItemAt(_seriesKeysColors.length - 1) as uint;
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
		
		private static function initColorPicker():void
		{
		    _codeColors = new ArrayCollection();
		    _seriesKeysColors = new ArrayCollection();
		    
		    _codeColorPicker = new ArrayCollection(
		                        [0xCD5C5C, 0xADFF2F, 0x8FBC8F,0x00FFFF, 0xFFC0CB,
		                        0xF4A460, 0xFFD700, 0xDCDCDC, 0x7B68EE, 0xF08080,
		                        0x006400, 0xFFEBCD, 0xFF69B4, 0x7FFFD4, 0xA9A9A9, 
                                0x9400D3, 0xDEB887, 0xFFFF00, 0xDC143C, 0xE9967A, 
                                0xFA8072, 0x00FF00, 0x00FA9A, 0x8B0000, 0x00008B, 
                                0x8B4513, 0xC71585, 0xFF0000, 0x4B0082, 0x3CB371, 
                                0x0000FF, 0xFF8C00, 0x808000, 0xFF7F50, 0x4169E1, 
                                0xDAA520, 0x228B22, 0xBDB76B, 0x00BFFF, 0x9ACD32, 
                                0x6B8E23, 0x556B2F, 0xFF4500, 0x32CD32, 0xAFEEEE, 
                                0x2E8B57, 0xDB7093, 0xB0C4DE, 0x48D1CC, 0xB22222, 
                                0xFFA500, 0xFF1493, 0x000000, 0x1E90FF, 0x008B8B, 
                                0xDEB887, 0x4682B4, 0x191970 ]);
                                
		    _codeWeightPicker = new ArrayCollection();
		    _codePatternPicker = new ArrayCollection();
		    
		    for (var i:uint; i < _codeColorPicker.length; i++) {
		        switch (i % 3) {
		            case 0:
		                _codeWeightPicker.addItem(1);
		                _codePatternPicker.addItem(i % 2 == 0 ? {pattern: [10000]} : {pattern: [7, 3]});
		                break;
		            
		            case 1:
		                _codeWeightPicker.addItem(2);
		                _codePatternPicker.addItem(i % 2 == 0 ? {pattern: [5]} : {pattern: [25, 5]});
		                break;
		                
		            default:
		                _codeWeightPicker.addItem(3);
		                _codePatternPicker.addItem(i % 2 == 0 ? {pattern: [10000]} : {pattern: [10]});
		        }
		    }
		}
	}
}