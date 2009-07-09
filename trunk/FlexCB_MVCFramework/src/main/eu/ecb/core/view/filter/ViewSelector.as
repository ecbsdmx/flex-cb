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
	import eu.ecb.core.view.SDMXViewAdapter;
	
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.LinkBar;
	import mx.controls.LinkButton;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.ItemClickEvent;

	/**
	 * Event triggered when a new view has been selected in the view selector.
	 * 
	 * @eventType eu.ecb.core.view.filter.ViewSelector.SELECTED_VIEW_CHANGED
	 */
	[Event(name="selectedViewChanged", type="org.sdmx.event.DataEvent")]

	/**
	 * This component displays a link bar with all possible views of the data
	 * (e.g.: a line chart, a statistical table and a metadata panel).
	 * 
	 * After initialisation, the component needs to receive the list of 
	 * desired views.
	 * 
	 * When the user changes the desired view, it dispatchs an event 
	 * ("selectedViewChanged"), containing the new desired view.
	 * 
	 * @author Xavier Sosnovsky 
	 */
	public class ViewSelector extends SDMXViewAdapter
	{
		/*=============================Constants==============================*/
		
		/**
		 * The ViewSelector.SELECTED_VIEW_CHANGED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>selectedViewChanged</code> event.
		 * 
		 * @eventType selectedViewChanged
		 */  
		public static const SELECTED_VIEW_CHANGED:String = 
			"selectedViewChanged";
			
		/*==============================Fields================================*/
		
		private var _links:LinkBar;
		
		private var _views:ArrayCollection;
		
		private var _viewsChanged:Boolean;
		
		private var _selectedViewIndex:uint;
		
		private var _selectedViewIndexChanged:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function ViewSelector(direction:String="vertical")
		{
			super(direction);
			styleName = "textBox";
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set views(views:ArrayCollection):void
		{
			_views = views;
			_viewsChanged = true;
			invalidateProperties();
			
		}
		
		/**
		 * The views to be displayed in the selector (e.g.: chart, table, etc)
		 */ 
		public function get views():ArrayCollection
		{
			return _views;
		}
		
		/**
		 * @private
		 */ 
		public function set selectedView(index:uint):void
		{
			_selectedViewIndex = index;	
			_selectedViewIndexChanged = true;
			invalidateProperties();
		}
		
		/**
		 * The view that should be displayed as highlighted in the selector.
		 * Normally this should only be used at start up, if the initially
		 * selected view is not the 1st item in the selector.
		 */ 
		public function get selectedView():uint
		{
			return _selectedViewIndex;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * inheritDoc
		 */
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (null == _links) {
				_links = new LinkBar();
				_links.addEventListener(MouseEvent.MOUSE_OVER, 
					onHoverOverUnderline, false, 0, true);
				_links.addEventListener(MouseEvent.MOUSE_OUT, 
					onHoverOutUnderline, false, 0, true);
				_links.addEventListener(ItemClickEvent.ITEM_CLICK, 
					handleClickEvent, false, 0, true);
				_links.addEventListener(ChildExistenceChangedEvent.
					CHILD_ADD, handleNewChild, false, 0, true);	
				addChild(_links);	
			}
		}
		
		/**
		 * inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_viewsChanged) {
				_viewsChanged = false;
				_links.dataProvider = _views;					
			}
			
			if (_selectedViewIndexChanged) {
				_selectedViewIndexChanged = false;
				var position:uint = (_selectedViewIndex < 
					_links.getChildren().length) ? _selectedViewIndex : 0;
				for (var i:uint = 0; i < _links.getChildren().length; i++) {
					var button:LinkButton = _links.getChildAt(i) as LinkButton;
					button.setStyle("color", 
						(i == position) ? "#C0C0C0" : "#0031AD");					
				}
			}
		}
		
		/*=========================Private methods============================*/
		
		private function handleNewChild(event:ChildExistenceChangedEvent):void 
		{
			event.stopImmediatePropagation();
			event = null;
			if (_links.getChildren().length == _views.length) {
				(_links.getChildAt(_selectedViewIndex) as 
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
	    	for (var i:uint = 0; i < _links.getChildren().length; i++) {
				var button:LinkButton = _links.getChildAt(i) as LinkButton;
				button.setStyle("color", 
					(i == event.index) ? "#C0C0C0" : "#0031AD");					
			}
	    	dispatchEvent(new DataEvent(SELECTED_VIEW_CHANGED, false, false, 
	    		String(event.index)));
			event = null;	
	    }		
	}
}