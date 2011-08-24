// Copyright (C) 2011 European Central Bank. All rights reserved.
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
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.LinkBar;
	import mx.controls.LinkButton;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.ItemClickEvent;
	
	import org.sdmx.model.v2.base.LocalisedString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	
	/**
	 * This component displays codes for certain dimension and supports
	 * filtering according to given dimension. It is visually represented as
	 * as link bars.
	 *  
	 * @author Rok Povse
	 * @author Steven Bagshaw
	 */
	public class LinkBarDimensionFilter extends DimensionFilter
	{
		/*==============================Fields================================*/
		
		private var _linkBar:LinkBar;
		private var _activeColor:String = "#C0C0C0"; //ECB default
		private var _inactiveColor:String = "#0031AD"; //ECB default
		private var _hoverColor:String; 
		private var _hideUnderlineOnHoverOverActive:Boolean = false; //ECB default
		
		/*===========================Constructor==============================*/
		
		public function LinkBarDimensionFilter(direction:String="vertical")
		{
			super(direction);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function get allowMultipleSelection():Boolean{
			return false;
		}
		
		public function set activeColor(value:String):void {
		    _activeColor = value;
		}
		
		public function set inactiveColor(value:String):void {
		    _inactiveColor = value;
		}
		
		public function set hoverColor(value:String):void {
		    _hoverColor = value;
		}
		
		/**
		 * By default, the currently active is underlined on
		 * mouse hover. This value can be set to true to stop 
		 * this behaviour.
		 * 
		 * param value
		 */
		public function set hideUnderlineOnHoverOverActive(value:Boolean):void {
		    _hideUnderlineOnHoverOverActive = value;
		}
		
		/*==========================Protected methods========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function drawComponent(codes:CodeList,
			displayCodes:ArrayCollection):void {				
			addLinkBarWithItems(codes,displayCodes);
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function cleanAll():void 
		{
			//remove linkbar
			if (_linkBar != null) {
				this.removeChild(_linkBar);
				_linkBar.removeEventListener(MouseEvent.MOUSE_OVER, onHoverOverUnderline);
				_linkBar.addEventListener(MouseEvent.MOUSE_OUT, onHoverOutUnderline);
				_linkBar.addEventListener(ItemClickEvent.ITEM_CLICK,handleClickEvent);
				_linkBar = null;
			}
		}
		
		/*===========================Private methods==========================*/
		
		/**
		 * Adds a LinkBar items representing displayed codes
		 */ 
		private function addLinkBarWithItems(codes:CodeList,
		 displayCodes:ArrayCollection = null):void {
			_linkBar = new LinkBar();
			_linkBar.direction = this.direction;
					
			_linkBar.addEventListener(MouseEvent.MOUSE_OVER, 
				onHoverOverUnderline, false, 0, true);
			_linkBar.addEventListener(MouseEvent.MOUSE_OUT, 
				onHoverOutUnderline, false, 0, true);
			_linkBar.addEventListener(ItemClickEvent.ITEM_CLICK, 
				handleClickEvent, false, 0, true);
			 _linkBar.addEventListener(ChildExistenceChangedEvent.
				CHILD_ADD, handleNewChild, false, 0, true);
			
			var items:ArrayCollection = new ArrayCollection();
			var item:String;
			for each (var displayedCode:String in displayCodes) {
				
				var code:Code = codes.codes.getCode(displayedCode);
				
				if (code != null) {
					item = (code.description.
					localisedStrings.getItemAt(0) as LocalisedString).label;
					
					if (displayCodes.contains(code.id)) {
						items.addItem(item);
					}
				}
				else {
					throw new ArgumentError("Unknown code " + displayedCode);
				}
			}
			
			_linkBar.setStyle("paddingLeft", 5);
			_linkBar.setStyle("color", _activeColor);
			_linkBar.setStyle("disabledColor", _inactiveColor);
			
			if (_hoverColor)
			    _linkBar.setStyle("textRollOverColor", _hoverColor);
			    
			_linkBar.dataProvider = items;	
		
			this.addChild(_linkBar);
		}
		
		private function handleNewChild(event:ChildExistenceChangedEvent):void 
		{
			event.stopImmediatePropagation();
			var button:LinkButton = event.relatedObject as LinkButton; //SBa
			event = null;
			
			//changed by SBa - we were previously looping through all links
			//to find the currently selected every time one was added
			if (_linkBar.numChildren - 1 == getSelectedCodeIndex())
				button.setStyle("color", _activeColor);
            else
                button.setStyle("color", _inactiveColor);
                
			/* var index:int = 0;
			 
			for each (var button:LinkButton in _linkBar.getChildren()) {
    			if (index == codeIndex)
    				button.setStyle("color", _activeColor);
                else
                    button.setStyle("color", _inactiveColor);
                    
                index++;
            } */
		}
		
		/**
		 * Convenience function to determine which is the currently selected code.
		 * It is needed because the LinkBar selectedIndex is not set (or able to 
		 * be set) correctly on initial startup.
		 * 
		 * @return int
		 */
		private function getSelectedCodeIndex():int
		{
		    if (_linkBar && _linkBar.selectedIndex >= 0)
		        return _linkBar.selectedIndex;
		        
		    var kf:KeyFamily = _keyFamilies.getItemAt(0) as KeyFamily;
			var dim:Dimension = findDimensionByDimensionId(kf, _dimensionId);
			var list:CodeList = dim.localRepresentation as CodeList;
			 
			return list.codes.getItemIndex(list.codes.getCode(_selectedCodes.getItemAt(0) as String));
		}
		
		private function onHoverOverUnderline(event:MouseEvent):void 
		{
			if (event.target is LinkButton) {
			    var linkBar:LinkBar = event.currentTarget as LinkBar;
			    var codeSelected:Boolean = linkBar.getChildAt(getSelectedCodeIndex()) == event.target;
			    
			    if (!codeSelected || !_hideUnderlineOnHoverOverActive)
			    {
		    	    event.target.setStyle("textDecoration", "underline");
		    	    event.target.setStyle("textRollOverColor", _hoverColor);
		    	}
		    	else
		    	    event.target.setStyle("textRollOverColor", _activeColor);
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
	    	for (var i:uint = 0; i < _linkBar.getChildren().length; i++) {
				var button:LinkButton = _linkBar.getChildAt(i) as LinkButton;
				button.setStyle("color", 
					(i == event.index) ? _activeColor : _inactiveColor);					
			}
			event = null;
			
			
			_selectedCodes = new ArrayCollection([_displayedCodes.getItemAt(
				_linkBar.selectedIndex)]);
			
			dispachFilterEvent();	
	    }	
	}
}