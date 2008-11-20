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
	import mx.controls.LinkButton;
	import flash.events.MouseEvent;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import mx.containers.HBox;
	import flash.events.Event;
	import mx.managers.HistoryManager;
	import mx.managers.IHistoryManagerClient;
	import mx.controls.Alert;
	import eu.ecb.core.view.SDMXViewAdapter;
	
	public class EXRBaseCurrencySwitcher extends SDMXViewAdapter 
		implements IHistoryManagerClient
	{
		/*==============================Fields================================*/
		
		private var _currencySwitcher:LinkButton;
				
		/*===========================Constructor==============================*/
		
		public function EXRBaseCurrencySwitcher(direction:String = "horizontal")
		{
			super(direction);
			styleName = "textBoxRight";
			HistoryManager.register(this);
		}
		
		/*=========================Public methods==========================*/
		
		public function saveState():Object 
		{
	    	return {baseCurrency: (_filteredReferenceSeries.keyValues.
	    		getItemAt(2) as KeyValue).value.id};
	    }
	    
	    public function loadState(state:Object):void 
	    {
			if (null != state && state.baseCurrency != 
				(_filteredReferenceSeries.keyValues.getItemAt(2) as KeyValue).
					value.id){
				dispatchEvent(new Event("currencySwitched"));
		 	}
	    }
		
		/*=========================Protected methods==========================*/
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (null == _currencySwitcher) {
				_currencySwitcher = new LinkButton();
				_currencySwitcher.addEventListener(MouseEvent.MOUSE_OVER, 
					handleMouseOver, false, 0, true);
				_currencySwitcher.addEventListener(MouseEvent.MOUSE_OUT,
					handleMouseOut, false, 0, true);	
				_currencySwitcher.addEventListener(MouseEvent.CLICK,
					handleMouseClick, false, 0, true);
				addChild(_currencySwitcher);	
			}	
		}

		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_filteredReferenceSeriesChanged) {				
				_filteredReferenceSeriesChanged = false;
				_currencySwitcher.label = "See " + (_filteredReferenceSeries.
					keyValues.getItemAt(2) as KeyValue).value.id + " vs. " + 
					(_filteredReferenceSeries.keyValues.getItemAt(1) as 
					KeyValue).value.id;
			}
		}		
		
		/*==========================Private methods===========================*/
		
		private function handleMouseOver(event:MouseEvent):void 
		{
			event.stopImmediatePropagation();
			if (event.target is LinkButton) {
		    	event.target.setStyle("textDecoration", "underline");
			}
			event = null;
	    }
		    
	    private function handleMouseOut(event:MouseEvent):void 
	    {
	    	event.target.setStyle("textDecoration", "none");
	    	event.stopImmediatePropagation();
	    	event = null;
	    }
	    
	    private function handleMouseClick(event:MouseEvent):void 
	    {
	    	event.stopImmediatePropagation();
	    	event = null;
			dispatchEvent(new Event("currencySwitched"));
			HistoryManager.save();
	    }
	}
}