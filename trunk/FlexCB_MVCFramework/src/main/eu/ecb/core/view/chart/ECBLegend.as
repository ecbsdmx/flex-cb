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
package eu.ecb.core.view.chart
{
	import eu.ecb.core.util.formatter.series.AttributesSeriesTitleFormatter;
	import eu.ecb.core.util.formatter.series.ISeriesTitleFormatter;
	import eu.ecb.core.util.helper.SeriesColors;
	import eu.ecb.core.view.BaseSDMXView;
	
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	import org.sdmx.model.v2.base.type.AttachmentLevel;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;

	/**
	 * Event triggered when one of the items in the legend has been selected or
	 * deselected by clicking on it.
	 */
	[Event(name="legendSelected", type="flash.events.DataEvent")]
	
	/**
	 * Event triggered when one of the items in the legend has been highlighted 
	 * by hovering over it, or when focus has been removed from it by mousing 
	 * out from the label.
	 */
	[Event(name="legendHighlighted", type="flash.events.DataEvent")]
	
	/**
	 * The chart legend
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class ECBLegend extends BaseSDMXView
	{
		
		/*==============================Fields================================*/
		
		private var _attributeTitle:String;
		
		private var _highlightedSeries:ArrayCollection;
		
		private var _mouseOverEnabled:Boolean;
		
		private var _autoHide:Boolean;
		
		private var _forceHide:Boolean;
		
		private var _maxLabelWidth:Number;
		
		private var _formatter:ISeriesTitleFormatter;
		
		/*===========================Constructor==============================*/
		
		public function ECBLegend(direction:String = "vertical")
		{
			super();
			_autoHide = true;
			_maxLabelWidth = 0;
			_formatter = new AttributesSeriesTitleFormatter();
			_attributeTitle = "TITLE_COMPL";
			(_formatter as AttributesSeriesTitleFormatter).attribute = 
				_attributeTitle;
			(_formatter as AttributesSeriesTitleFormatter).attachmentLevel = 
				AttachmentLevel.GROUP;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Whether or not highlight and select functionality of legend items
		 * should be enabled.
		 *  
		 * @param flag
		 */
		public function set mouseOverEnabled(flag:Boolean):void
		{
			_mouseOverEnabled = flag;
		}
		
		/**
		 * Whether or not the component should auothide itself, when the dataset
		 * only contains one series
		 */ 
		public function set autoHide(flag:Boolean):void
		{
			_autoHide = flag;
		}
		
		/**
		 * Whether or not the component should be hidden, even if its dataset
		 * contains more than one series. 
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
		
		/*========================Protected methods===========================*/
		
		/**
		 * @private
		 */ 
		override protected function commitProperties():void
	 	{
	 		if (_dataSetChanged && _dataSet is DataSet) {
	 			_dataSetChanged = false;
	 			_maxLabelWidth = 0;
		 		removeAllChildren();
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
						var uicomponent:UIComponent = new UIComponent();
						if (i < SeriesColors.getColors().length) {
							uicomponent.graphics.beginFill(uint(SeriesColors.
								getColors().getItemAt(i)));
						} else {
							uicomponent.graphics.beginFill(
								Math.random()*0xFFFFFF, Math.random());
						}		
						uicomponent.graphics.drawCircle(5, 11, 5);
						addChild(uicomponent);
						var legendItem:Text = new Text();
						if (maxWidth > 0) {
							legendItem.maxWidth = maxWidth;
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
						legendItem.setStyle("paddingLeft", 12);
						legendItem.text = seriesTitle; 
							
						var legendItemWidth:Number = 
							measureText(legendItem.text).width + 5;
						if (legendItemWidth > _maxLabelWidth) {
							_maxLabelWidth = legendItemWidth;
						}
								
						addChild(legendItem);
					}
					invalidateDisplayList();
				}
	 		}
	 	}
	 	
	 	override protected function updateDisplayList(unscaledWidth:Number, 
	 		unscaledHeight:Number):void
 		{
 			super.updateDisplayList(unscaledWidth, unscaledHeight);
 			
 			if (_dataSet is DataSet) {
	 			if (_forceHide || (_autoHide && null != _dataSet && 
	 				null != (_dataSet as DataSet).timeseriesKeys	&& 
	 				1 >= (_dataSet as DataSet).timeseriesKeys.length)) {
					this.width   = 0;
					this.visible = false;
				} else if (null != _dataSet && null != (_dataSet as DataSet).
					timeseriesKeys && 1 < (_dataSet as DataSet).timeseriesKeys.
					length) {
					this.width = (!(isNaN(maxWidth)) && 0 < maxWidth && 
						maxWidth < _maxLabelWidth + 12) ? 
						maxWidth : _maxLabelWidth + 12;
					this.visible = true;
				}		
			}
 		}
	 	
	 	private function handleLegendClicked(event:MouseEvent):void
	 	{
	 		if (null == _highlightedSeries) {
	 			_highlightedSeries = new ArrayCollection();
	 		}
	 		var key:String = event.currentTarget.id; 
	 		if (_highlightedSeries.contains(key)) {
	 			_highlightedSeries.removeItemAt(
	 				_highlightedSeries.getItemIndex(key));
	 			event.currentTarget.styleName = "";	
	 		} else {
	 			_highlightedSeries.addItem(key);
	 			event.currentTarget.styleName = "legendItemSelected";
	 		}
	 		dispatchEvent(new DataEvent("legendSelected", false, false, key)); 
	 	}
	 	
	 	private function handleMouseOver(event:MouseEvent):void
	 	{
	 		var key:String = event.currentTarget.id; 
	 		if (null == _highlightedSeries || (null != _highlightedSeries && 
	 			!(_highlightedSeries.contains(key)))) {
	 			event.currentTarget.styleName = "legendItemSelected";
	 			dispatchEvent(new DataEvent("legendHighlighted", false, false, 
	 				key));
	 		}
	 		 
	 	}
	 	
	 	private function handleMouseOut(event:MouseEvent):void
	 	{
	 		var key:String = event.currentTarget.id; 
	 		if (null == _highlightedSeries || (null != _highlightedSeries &&
	 			!(_highlightedSeries.contains(key)))) {
	 			event.currentTarget.styleName = "";
	 			dispatchEvent(new DataEvent("legendHighlighted", false, false, 
	 				key));
	 		}
	 	}
	}
}