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
package eu.ecb.core.view.filter
{
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.controls.LinkBar;
	import mx.controls.LinkButton;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.ItemClickEvent;
	import mx.managers.HistoryManager;
	import mx.managers.IHistoryManagerClient;
	import eu.ecb.core.view.SDMXViewAdapter;
	
	/**
	 * Event triggered when a new period has been selected in the period
	 * zoom box.
	 * 
	 * @eventType eu.ecb.core.view.filter.PeriodZoomBox.SELECTED_PERIOD_CHANGED
	 */
	[Event(name="selectedPeriodChanged", type="org.sdmx.event.DataEvent")]

	/**
	 * This component displays a link bar with all available periods for 
	 * zooming.
	 * 
	 * After initialisation, the component needs to receive the list of all 
	 * periods for the zoom.
	 * 
	 * When the user changes the desired period, it dispatchs an event 
	 * ("periodZoomChanged"), containing the new desired period.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class PeriodZoomBox extends SDMXViewAdapter implements 
		IHistoryManagerClient {
			
		/*=============================Constants==============================*/
		
		/**
		 * The PeriodZoomBox.SELECTED_PERIOD_CHANGED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>selectedPeriodChanged</code> event.
		 * 
		 * @eventType selectedPeriodChanged
		 */  
		public static const SELECTED_PERIOD_CHANGED:String = 
			"selectedPeriodChanged";
		
		/*==============================Fields================================*/
		
		private var _zoomLabelField:Label;
		
		private var _periodsZoomField:LinkBar;

		private var _initialIndex:Number;
		
		private var _previousIndex:uint;
		
		private var _changesHistory:Array;
		
		/*===========================Constructor==============================*/

		public function PeriodZoomBox(direction:String = "horizontal") {
			super(direction);
			styleName = "textBox";
			HistoryManager.register(this);
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * inheritDoc
		 */ 
	    public function saveState():Object
		{	
			var historyState:Object = new Object();
			historyState.periodIndex = _previousIndex;
			if (null == _changesHistory) {
				_changesHistory = new Array();
			}
			_changesHistory.push(_previousIndex);
			return historyState;
		}
		
		/**
		 * inheritDoc
		 */
		public function loadState(historyState:Object):void
		{
			if (null != _changesHistory && _changesHistory.length != 0) {
				var _lastInHistory:uint = _changesHistory.pop();
				if (_lastInHistory != _previousIndex) {
					dispatchEvent(new DataEvent(
						SELECTED_PERIOD_CHANGED, false, false, 
			    		(_periodsZoomField.getChildAt(_lastInHistory) as Object)
			    			.label));	
				}
			}
		}
		
		/**
		 * Instructs the period zoom box to remove the colour highlight set
		 * on the currently selected period. 
		 */
		public function removeSelectedPeriodHighlight():void
		{
			(_periodsZoomField.getChildAt(_previousIndex) as 
				LinkButton).setStyle("color", "#0031AD");
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * inheritDoc
		 */
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (null == _zoomLabelField) {
				_zoomLabelField = new Label();
				addChild(_zoomLabelField);
			}
			
			if (null == _periodsZoomField) {
				_periodsZoomField = new LinkBar();
				_periodsZoomField.addEventListener(MouseEvent.MOUSE_OVER, 
					onHoverOverUnderline, false, 0, true);
				_periodsZoomField.addEventListener(MouseEvent.MOUSE_OUT, 
					onHoverOutUnderline, false, 0, true);
				_periodsZoomField.addEventListener(ItemClickEvent.ITEM_CLICK, 
					handleClickEvent, false, 0, true);
				_periodsZoomField.addEventListener(ChildExistenceChangedEvent.
					CHILD_ADD, handleNewChild, false, 0, true);
				addChild(_periodsZoomField);	
			}
		}
		
		/**
		 * inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_periodsChanged) {
				_periodsChanged = false;
				for each (var period:Object in _periods) {
					if (period.hasOwnProperty("selected") && 
						period["selected"] == true) {
						_previousIndex = 
							_periods.getItemIndex(period);
						if (isNaN(_initialIndex)) {
							_initialIndex = _previousIndex;	
						} 
						break;	
					}
				}
				if (_periods.length >= 2) {
					_zoomLabelField.text = "Select date range: ";
					_periodsZoomField.dataProvider = _periods;
				}	
			}
		}
		
		/*=========================Private methods============================*/
		
		private function handleNewChild(event:ChildExistenceChangedEvent):void 
		{
			event.stopImmediatePropagation();
			event = null;
			if (_periodsZoomField.getChildren().length == _periods.length) {
				(_periodsZoomField.getChildAt(_previousIndex) as 
					LinkButton).setStyle("color", "#C0C0C0");
			}
		}
		
		private function onHoverOverUnderline(event:MouseEvent):void 
		{
			if (event.target is LinkButton) {
		    	event.target.setStyle("textDecoration", "underline");
		 	}
		 	event.stopImmediatePropagation();
			event = null;
	    }
	    
	    private function onHoverOutUnderline(event:MouseEvent):void 
	    {
	    	if (event.target is LinkButton) {
		    	event.target.setStyle("textDecoration", "none"); 
		 	}
	    	event.stopImmediatePropagation();
			event = null;
	    }
	    
	    private function handleClickEvent(event:ItemClickEvent):void 
	    {
	    	event.stopImmediatePropagation();
	    	HistoryManager.save();
	    	dispatchEvent(new DataEvent(SELECTED_PERIOD_CHANGED, false, false, 
	    		(_periodsZoomField.getChildAt(event.index) as Object).label));
	    	_previousIndex = event.index;	
			event = null;	
	    }
	    
	    internal function creationForTests():void {
			createChildren();
		}
	}
}