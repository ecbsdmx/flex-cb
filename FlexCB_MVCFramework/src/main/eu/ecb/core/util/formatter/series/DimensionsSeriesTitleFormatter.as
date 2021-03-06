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
package eu.ecb.core.util.formatter.series
{
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;

	/**
     * Uses the description (in English) of a dimension as series title. 
     * 
     * @author Xavier Sosnovsky 
     */
	public class DimensionsSeriesTitleFormatter implements ISeriesTitleFormatter
	{
		/*==============================Fields================================*/
		
		private var _dimensionCode:String;
		
		/*===========================Constructor==============================*/
		
		public function DimensionsSeriesTitleFormatter()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The id of the dimension (e.g.: REF_AREA, FREQ, etc) to be used for
		 * the series title.
		 */ 
		public function set dimension(code:String):void
		{
			_dimensionCode = code;
		}

		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function getSeriesTitle(series:TimeseriesKey):String
		{
			if (null == _dimensionCode) {
				throw new ArgumentError("Dimension from which the title must" + 
					" be fetched has not been set");
			}
			var title:String;
			for each (var dimension:KeyValue in series.keyValues) {
				if(dimension.valueFor.conceptIdentity.id == _dimensionCode) {
					title = dimension.value.description.localisedStrings.
						getDescriptionByLocale("en");
					break;
				}
			}
			if (null == title) {
				throw new ArgumentError("Title could not be found");
			}
			return title;
		}
	}
}