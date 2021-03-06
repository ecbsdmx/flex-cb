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
	import eu.ecb.core.view.BaseSDMXView;
	
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
	[Event(name="stackItemSelected", type="flash.events.DataEvent")]
	
	[Event(name="componentsToHide", type="flash.events.DataEvent")]
	
	[Event(name="componentToUnhide", type="flash.events.DataEvent")]

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
	 * @author Steven Bagshaw
	 */
	public class ViewSelector extends BaseSDMXView
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
			"stackItemSelected";
			
		public static const COMPONENTS_TO_HIDE:String = "componentsToHide";
		public static const COMPONENT_TO_UNHIDE:String = "componentToUnhide";
			
		/*==============================Fields================================*/
		
		private var _links:LinkBar;
		
		private var _views:ArrayCollection;
		
		private var _viewsChanged:Boolean;
		
		private var _selectedViewIndex:uint;
		
		private var _selectedViewIndexChanged:Boolean;
		
		/**
		 * Components by ID that should be hidden for certain views. SBa
		 * Comma-delimited.
		 */
		private var _componentHideLists:ArrayCollection;
		
		private var _activeColor:String = "#C0C0C0"; //ECB default
		private var _inactiveColor:String = "#0031AD"; //ECB default
		private var _hoverColor:String; 
		private var _hideUnderlineOnHoverOverActive:Boolean = false; //ECB default
		
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
		
		public function set componentHideLists(componentHideLists:ArrayCollection):void
		{
			_componentHideLists = componentHideLists;
		}
		
		public function get componentHideLists():ArrayCollection
		{
			return componentHideLists;
		}
		
		public function set activeColor(value:String):void 
		{
		    _activeColor = value;
		}
		
		public function set inactiveColor(value:String):void 
		{
		    _inactiveColor = value;
		}
		
		public function set hoverColor(value:String):void 
		{
		    _hoverColor = value;
		}
		
		/**
		 * By default, the currently active is underlined on
		 * mouse hover. This value can be set to true to stop 
		 * this behaviour.
		 * 
		 * @param value
		 */
		public function set hideUnderlineOnHoverOverActive(value:Boolean):void 
		{
		    _hideUnderlineOnHoverOverActive = value;
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
						(i == position) ? _activeColor : _inactiveColor);					
				}
			}
		}
		
		/*=========================Private methods============================*/
		
		private function handleNewChild(event:ChildExistenceChangedEvent):void 
		{
			event.stopImmediatePropagation();
			event = null;
			
			/* if (_links.getChildren().length == _views.length) {
				(_links.getChildAt(_selectedViewIndex) as 
					LinkButton).setStyle("color", _activeColor);
			} */
			
			if (_links.numChildren - 1 == _selectedViewIndex)
				(_links.getChildAt(_selectedViewIndex) as LinkButton).setStyle("color", _activeColor);
            else
                (_links.getChildAt(_links.numChildren - 1) as LinkButton).setStyle("color", _inactiveColor);
		}
		
		private function onHoverOverUnderline(event:MouseEvent):void 
		{
			var codeSelected:Boolean = _links.getChildAt(_links.selectedIndex) == event.target;
			
			if (event.target is LinkButton && (!codeSelected || !_hideUnderlineOnHoverOverActive))
			{
		    	event.target.setStyle("textDecoration", "underline");
		        event.target.setStyle("textRollOverColor", _hoverColor);
		    }
		    else
		    	event.target.setStyle("textRollOverColor", _activeColor);
		 	
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
				button.setStyle("color", (i == event.index) ? _activeColor : _inactiveColor);	
			}
	    	dispatchEvent(new DataEvent(SELECTED_VIEW_CHANGED, false, false, 
	    		String(event.index)));
	    	
	    	//start added SBa
	    	if (_componentHideLists != null && _componentHideLists.length > 0)
	    	{
    	    	var componentsToHide:String = String(_componentHideLists.getItemAt(event.index));
    	    	var hiddenComponents:String = String(_componentHideLists.getItemAt(_selectedViewIndex)); //currently hidden
    	    	
    	    	if (componentsToHide)
    	    	    dispatchEvent(new DataEvent(COMPONENTS_TO_HIDE, false, false, componentsToHide));
    	    	
    	    	//if there were some components hidden and now they should no longer be...
    	    	if (hiddenComponents.length > 0)
    	    	{
    	    	    for each(var hidden:String in hiddenComponents.split(","))
    	    	    {
    	    	        var unhideIt:Boolean = true;
    	    	        
    	    	        for each(var toHide:String in componentsToHide.split(","))
    	    	        {
    	    	            if (hidden == toHide) //i.e. it is still in the toHide list for the new view
    	    	                unhideIt = false;
    	    	        }
    	    	        
    	    	        if (unhideIt)
    	    	            dispatchEvent(new DataEvent(COMPONENT_TO_UNHIDE, false, false, hidden));   
    	    	    }
    	    	}
    	    } 
	    	
	    	_selectedViewIndex = event.index; 
	    	//end added SBa			
			
			event = null;	
	    }		
	}
}