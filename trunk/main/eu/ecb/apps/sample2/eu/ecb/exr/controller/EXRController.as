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
package eu.ecb.exr.controller
{
	import eu.ecb.core.controller.SDMXDataController;
	import eu.ecb.core.model.ISDMXDataModel;
	import eu.ecb.exr.model.EXRModel;
	
	import flash.events.DataEvent;
	import flash.events.Event;

	public class EXRController extends SDMXDataController
	{
		public function EXRController(model:ISDMXDataModel, dataFile:String, 
			structureFile:String, disableObservationAttribute:Boolean = true)
		{
			super(model, dataFile, structureFile, disableObservationAttribute);
		}
		
		public function handleCurrencySwitched(event:Event):void
		{
			event.stopImmediatePropagation();
			event = null;
			(model as EXRModel).handleCurrencySwitched();
		}
		
		public function handleSeriesChanged(event:DataEvent):void
		{
			event.stopImmediatePropagation();
			(model as EXRModel).handleSeriesChanged(event.data);
			event = null;
		}
	}
}