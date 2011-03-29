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
package eu.ecb.core.view.chart
{
	import eu.ecb.core.util.formatter.series.AttributesSeriesTitleFormatter;
	import eu.ecb.core.util.formatter.series.ISeriesTitleFormatter;
	import eu.ecb.core.util.helper.SeriesColors;
	import eu.ecb.core.view.BaseSDMXView;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flexlib.containers.FlowBox;
	
	import mx.charts.LegendItem;
	import mx.charts.renderers.CircleItemRenderer;
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.core.Container;
	import mx.core.IFactory;
	
	import org.sdmx.model.v2.base.type.AttachmentLevel;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;

	/**
	 * Event triggered when one of the items in the legend has been selected or
	 * deselected by clicking on it.
	 */
	[Event(name="legendItemSelected", type="flash.events.DataEvent")]
	
	/**
	 * Event triggered when one of the items in the legend has been highlighted 
	 * by hovering over it, or when focus has been removed from it by mousing 
	 * out from the label.
	 */
	[Event(name="legendItemHighlighted", type="flash.events.DataEvent")]
	
	/**
	 * The chart legend
	 * 
	 * @author Xavier Sosnovsky
	 * @author Mike Eltsufin
	 */
	public class ECBLegend extends BaseSDMXView
	{
		
		/*==============================Fields================================*/
				
		private var _attributeTitle:String;
		private var _highlightedSeries:ArrayCollection;
		private var _mouseOverEnabled:Boolean;
		private var _autoHide:Boolean;
		private var _forceHide:Boolean;
		private var _formatter:ISeriesTitleFormatter;
		private var _disableContentCheck:Boolean;
		private var _legendContainer:Container;
		private var _legendMarkerFactory:IFactory;
		private var _labels:ArrayCollection; 
		
		/*===========================Constructor==============================*/
		
		public function ECBLegend(direction:String = "vertical")
		{
			super();
			_autoHide = true;
			_formatter = new AttributesSeriesTitleFormatter();
			_attributeTitle = "TITLE_COMPL";
			(_formatter as AttributesSeriesTitleFormatter).attribute = 
				_attributeTitle;
			(_formatter as AttributesSeriesTitleFormatter).attachmentLevel = 
				AttachmentLevel.GROUP;
			_legendMarkerFactory = new ClassFactory(CircleItemRenderer);
	 		_legendContainer = new FlowBox();
			_legendContainer.styleName = "ecbLegendContainer";	 
			if (direction == "horizontal") {
				percentWidth = 100;
				_legendContainer.percentWidth = 100;
			}		
	 		addChild(_legendContainer);		
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Whether highlight and select functionality of legend items should be 
		 * enabled. Defaults to false.
		 *  
		 * @param flag
		 */
		public function set mouseOverEnabled(flag:Boolean):void
		{
			_mouseOverEnabled = flag;
		}
		
		/**
		 * Whether the component should auothide itself, when the dataset only 
		 * contains one series. Defaults to true.
		 */ 
		public function set autoHide(flag:Boolean):void
		{
			_autoHide = flag;
		}
		
		/**
		 * Whether the component should be hidden, even if its dataset contains 
		 * more than one series. Defaults to false.
		 */
		public function set forceHide(flag:Boolean):void
		{
			_forceHide = flag;
		}
		
		/**
		 * @private
		 */ 
		public function set titleFormatter(formatter:ISeriesTitleFormatter):void
		{
			if (null != formatter) {
				_formatter = formatter;
			}
		}
		
		/**
		 * The formatter to be used for the series title 
		 */
		public function get titleFormatter():ISeriesTitleFormatter
		{
			return _formatter;
		}
		
		/**
		 * Whether checks should be performed that the legend contains no
		 * duplicates. Default to false.
		 * 
		 * @param flag
		 */
		public function set disableContentCheck(flag:Boolean):void
		{
			_disableContentCheck = flag;
		}

		/**
		 * The container that holds the legend items
		 */
		public function get legendContainer():Container
		{
			return _legendContainer;
		}
		
		/**
		 * The item renderer factory for legend markers 
		 */
		public function get legendMarkerFactory():IFactory
		{
			return _legendMarkerFactory;
		}
		
		/**
		 * @private
		 */ 
		public function set legendMarkerFactory(markerFactory:IFactory):void
		{
			_legendMarkerFactory = markerFactory;
		}
				
		/*==========================Public methods============================*/
		
		/**
		 * Handles the event that instructs the component to hide itself.
		 * 
		 * @param event 
		 */
		public function enableForceHide(event:Event):void
		{
			_forceHide = true;
			invalidateDisplayList();
		}
		
		/**
		 * Handles the event that instructs the component to show itself.
		 * 
		 * @param event 
		 */
		public function disableForceHide(event:Event):void
		{
			_forceHide = false;
			invalidateDisplayList();
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDocs
		 */ 
		override protected function commitProperties():void
	 	{
	 		if (_dataSetChanged && _dataSet is DataSet) {
	 			_dataSetChanged = false;
		 		_legendContainer.removeAllChildren();
		 		_labels = new ArrayCollection(); 
				if (!_autoHide || (_dataSet as DataSet).timeseriesKeys.
					length > 1) {
					for (var i:uint = 0; i < (_dataSet as DataSet).
						timeseriesKeys.length; i++) {
						var series:TimeseriesKey = (_dataSet as DataSet).
							timeseriesKeys.getItemAt(i) as TimeseriesKey;
						if (_formatter is AttributesSeriesTitleFormatter && 
							(_formatter as AttributesSeriesTitleFormatter).
								attachmentLevel == AttachmentLevel.GROUP) {
							(_formatter as AttributesSeriesTitleFormatter).
								titleSupplier = (_dataSet as DataSet).groupKeys.
								getGroupsForTimeseries(series).getItemAt(0)
								as GroupKey;		
						}
						var seriesTitle:String = 
							_formatter.getSeriesTitle(series);
						if (null == seriesTitle) {
							throw new ArgumentError("Could not find the " + 
								"series title.");	
						}						
						var legendItem:LegendItem = new LegendItem();
						if (i < SeriesColors.getColors().length) {
							legendItem.setStyle("fill",
								uint(SeriesColors.getColors().getItemAt(i)));
						} else {
							legendItem.setStyle("fill",
								Math.random()*0xFFFFFF);
						}		
						if (_mouseOverEnabled) {
							legendItem.addEventListener(MouseEvent.CLICK, 
								handleLegendClicked);
							legendItem.addEventListener(MouseEvent.MOUSE_OVER,
								handleMouseOver);	
							legendItem.addEventListener(MouseEvent.MOUSE_OUT,
								handleMouseOut);	
						}
						legendItem.id = series.seriesKey;						
						if (!(_labels.contains(seriesTitle))) {
							_labels.addItem(seriesTitle);
						}
						legendItem.label = seriesTitle;																	
						legendItem.setStyle("legendMarkerRenderer", 
							_legendMarkerFactory);
						legendItem.markerAspectRatio = 1; 						
						legendItem.styleName = "ecbLegendItem";	
						_legendContainer.addChild(legendItem);
					}
				}
	 		}
	 	}
	 	
	 	/**
		 * @inheritDocs
		 */
	 	override protected function updateDisplayList(unscaledWidth:Number, 
	 		unscaledHeight:Number):void
 		{
 			super.updateDisplayList(unscaledWidth, unscaledHeight);
 			checkForceHide();
 			if (_dataSet is DataSet) {
	 			if (_forceHide || (_autoHide && null != _dataSet && 
	 				null != (_dataSet as DataSet).timeseriesKeys && 
	 				1 >= (_dataSet as DataSet).timeseriesKeys.length)) {
					this.width   = 0;
					this.visible = false;
				} else if (null != _dataSet && null != (_dataSet as DataSet).
					timeseriesKeys && (1 < (_dataSet as DataSet).timeseriesKeys.
					length || !_autoHide)) {
					this.visible = true;
					this.width  = _legendContainer.width;
					this.height = _legendContainer.height;
				}		
			}
			
 		}
 		
 		/*=========================Private methods============================*/
	 	
	 	private function handleLegendClicked(event:MouseEvent):void
	 	{
	 		if (null == _highlightedSeries) {
	 			_highlightedSeries = new ArrayCollection();
	 		}
	 		var key:String = event.currentTarget.id; 
	 		if (_highlightedSeries.contains(key)) {
	 			_highlightedSeries.removeItemAt(
	 				_highlightedSeries.getItemIndex(key));
	 			event.currentTarget.styleName = "ecbLegendItem";	
	 		} else {
	 			_highlightedSeries.addItem(key);
	 			event.currentTarget.styleName = "legendItemSelected";
	 		}
	 		dispatchEvent(new DataEvent("legendItemSelected", false, false, key)); 
	 	}
	 	
	 	private function handleMouseOver(event:MouseEvent):void
	 	{
	 		var key:String = event.currentTarget.id; 
	 		if (null == _highlightedSeries || (null != _highlightedSeries && 
	 			!(_highlightedSeries.contains(key)))) {
	 			event.currentTarget.styleName = "legendItemSelected";
	 			dispatchEvent(new DataEvent("legendItemHighlighted", false, false, 
	 				key));
	 		}
	 	}
	 	
	 	private function handleMouseOut(event:MouseEvent):void
	 	{
	 		var key:String = event.currentTarget.id; 
	 		if (null == _highlightedSeries || (null != _highlightedSeries &&
	 			!(_highlightedSeries.contains(key)))) {
	 			event.currentTarget.styleName = "ecbLegendItem";
	 			dispatchEvent(new DataEvent("legendItemHighlighted", false, false, 
	 				key));
	 		}
	 	}
	 	
	 	private function checkForceHide():void {
	 		if (!_disableContentCheck && _labels != null) {
				if (_labels.length == 1) {
					_forceHide = true;
				} else {
					_forceHide = false;
				}
			}
	 	}
	}
}