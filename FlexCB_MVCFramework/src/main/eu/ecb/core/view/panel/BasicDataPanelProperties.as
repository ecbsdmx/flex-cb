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
package eu.ecb.core.view.panel
{
	public class BasicDataPanelProperties {
		
		private var _showChange:Boolean;
		
		private var _showSeriesSummaryBox:Boolean;
		
		private var _showChartSummaryBox:Boolean;
		
		private var _showTableView:Boolean; 
		
		private var _showChangePercentage:Boolean;
		
		private var _showSlider:Boolean;
		
		private var _showViewSelector:Boolean;
		
		private var _showMetadataView:Boolean;
		
		private var _showFilterBox:Boolean;
		
		private var _chartTitle:String;
		
		private var _dateFilterList:String;
		
		/**
		 * Creates a visual properties configuration object for the BasicDataPanel.
		 *  
		 * @param showChange Whether to show the period to period change.
		 * @param showSeriesSummaryBox Whether to show the text at top
		 * 			that displays the observation value and date.
		 * @param showChartSummaryBox Wether to show the box that summarizes
		 * 			dates and range of values.
		 * @param showTableView Wether to show the 'table' option in FilterBox.
		 * @param showChangePercentage Wether to show the column of change percentage in table
		 * @param showSlider Wether to show the entire date filter slider area.
		 * @param showViewSelector Wether to show the entire view selector (chart, table, explanation).
		 * @param showMetadataView Wether to show the 'Explanation' option of FilterBox.
		 * @param showFilterBox Whether to show the entire FilterBox component (useful set to 'off' for very small layouts)
		 * @param chartTitle The Y-Axis label for the chart.
		 * @param dateFilterList The list of values for the date filter list in the filterBox.
		 * 			Choose from (1m,3m,6m,1y,2y,5y,10y,All).
		 */
		public function BasicDataPanelProperties( 	
									showChange:Boolean, 
									showSeriesSummaryBox:Boolean, 
									showChartSummaryBox:Boolean,
									showTableView:Boolean,
									showChangePercentage:Boolean,
									showSlider:Boolean,
									showViewSelector:Boolean,
									showMetadataView:Boolean,
									showFilterBox:Boolean,
									chartTitle:String = "",
									dateFilterList:String = null)  {
			_showChange = showChange;
			_showSeriesSummaryBox = showSeriesSummaryBox;
			_showChartSummaryBox = showChartSummaryBox;
			_showTableView = showTableView; 
			_showChangePercentage = showChangePercentage;
			_showSlider = showSlider;
			_showViewSelector = showViewSelector;
			_showMetadataView = showMetadataView;
			_showFilterBox = showFilterBox;
			_chartTitle = chartTitle;
			_dateFilterList = dateFilterList;
		}
		
		public function get showChange():Boolean {
			return this._showChange;
		}
		
		public function get showSeriesSummaryBox():Boolean {
			return this._showSeriesSummaryBox;
		}
		
		public function get showChartSummaryBox():Boolean {
			return this._showChartSummaryBox;
		}
		
		public function get showTableView():Boolean {
			return this._showTableView;
		}
		
		public function get showChangePercentage():Boolean {
			return this._showChangePercentage;
		}
		
		public function get showSlider():Boolean {
			return this._showSlider;
		}
		
		public function get showViewSelector():Boolean {
			return this._showViewSelector;
		}
		
		public function get showMetadataView():Boolean {
			return this._showMetadataView;
		}
		
		public function get showFilterBox():Boolean {
			return this._showFilterBox;
		}

		public function get chartTitle():String {
			return this._chartTitle;
		}
				
		public function get dateFilterList():String {
			return this._dateFilterList;
		}
		
		public static function getDefault():BasicDataPanelProperties {
			return new BasicDataPanelProperties(true, true, true, true, true, true, true, true, true);
		}
	}
}