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
package eu.ecb.exr.view
{
	import ca.boc.exr.buttons.LocaleSwitchButton;
	
	import eu.ecb.core.controller.ISDMXViewController;
	import eu.ecb.core.model.ISDMXViewModel;
	import eu.ecb.core.util.formatter.observation.EXRObservationFormatter;
	import eu.ecb.core.util.formatter.series.AttributesSeriesTitleFormatter;
	import eu.ecb.core.view.filter.FiltersPanel;
	import eu.ecb.core.view.panel.BasicDataPanel;
	import eu.ecb.core.view.panel.BasicDataPanelProperties;
	import eu.ecb.core.view.summary.EXRSeriesSummaryBox;
	import eu.ecb.exr.controller.EXRController;
	
	import flash.events.DataEvent;
	import flash.events.Event;

	public class EXRDataPanel extends BasicDataPanel
	{
		/*==============================Fields================================*/
		
		private var _currencySwitcher:EXRBaseCurrencySwitcher;
		
		private var _filtersPanel:FiltersPanel;
		
		private var _localeButton:LocaleSwitchButton;
		
		private var _initial:Boolean = true;
		
		/*===========================Constructor==============================*/
		
		public function EXRDataPanel(model:ISDMXViewModel, 
			controller:ISDMXViewController, showChange:Boolean = false)
		{
			var dataPanelProperties:BasicDataPanelProperties = 
					new BasicDataPanelProperties(showChange, true, true, true, true, true, true, true, "", null);					
			super(model, controller, dataPanelProperties);
		}
		
		/*========================Protected methods===========================*/
		
		override protected function createChildren():void 
		{
			if (null == _localeButton) {
				_localeButton = new LocaleSwitchButton();
				_localeButton.percentWidth = 100;
				addChild(_localeButton);
			}
			
			if (null == _filtersPanel) {
				_filtersPanel = new FiltersPanel();
				_filtersPanel.addEventListener(FiltersPanel.SERIES_KEY_CHANGED, 
					handleSeriesChanged);
				_filtersPanel.percentWidth = 100;
				addChild(_filtersPanel);
				_initial = true;
			}
			
			if (null == _seriesSummaryBox) {
				_seriesSummaryBox = new EXRSeriesSummaryBox();
				_seriesSummaryBox.showChange = _showChange;
				addChild(_seriesSummaryBox);
			}

			super.createChildren();
			
			if (null == _currencySwitcher) {
				_currencySwitcher = new EXRBaseCurrencySwitcher();
				_currencySwitcher.addEventListener("currencySwitched", 
					handleCurrencySwitched, false, 0, true);
				_currencySwitcher.percentHeight = 100;
				_filterBox.addChild(_currencySwitcher);
			}
			
			if (null != _legend) {
				(_legend.titleFormatter as AttributesSeriesTitleFormatter).
					attribute = "CURRENCY";
			}
			
			if (null != _chart) {
				_chart.observationValueFormatter = 
					new EXRObservationFormatter();
			}
		}
		
		override protected function commitFullDataSet():void
		{
			if (_initial) {
				_filtersPanel.fullDataSet = _fullDataSet;
				_initial = false;
			}
		}
		
		override protected function commitFilteredReferenceSeries():void
		{
			super.commitFilteredReferenceSeries();
			_currencySwitcher.filteredReferenceSeries = 
				_filteredReferenceSeries;
		}
		
		/**
		 * @inheritDoc
		 */ 		
		override protected function commitFilteredDataSet():void 
		{
			super.commitFilteredDataSet();
			_filtersPanel.width = _chart.getExplicitOrMeasuredWidth();
			_localeButton.width = _chart.getExplicitOrMeasuredWidth();
		}
		
		override protected function handleChangedWidth(event:Event):void
		{
			super.handleChangedWidth(event);
			_filtersPanel.width = _localeButton.width = width - 25;
		}
		
		private function handleCurrencySwitched(event:Event):void
		{
			event.stopImmediatePropagation();
			(_controller as EXRController).handleCurrencySwitched(event);
		}
		
		private function handleSeriesChanged(event:DataEvent):void
		{
			event.stopImmediatePropagation();
			(_controller as EXRController).handleSeriesChanged(event);
		}
	}
}