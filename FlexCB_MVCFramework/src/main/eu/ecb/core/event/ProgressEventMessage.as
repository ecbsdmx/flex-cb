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
package eu.ecb.core.event
{
	import flash.events.ProgressEvent;
	import flash.events.Event;

	/**
	 * Extension of the Flex ProgressEvent to include a message describing the
	 * progress event.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class ProgressEventMessage extends ProgressEvent
	{
		/*==============================Fields================================*/
        
        /** The description of the progress event */ 
		private var _message:String;
		
		/*=============================Constants==============================*/
		
		public function ProgressEventMessage(type:String, 
			bubbles:Boolean = false, cancelable:Boolean = false, 
			bytesLoaded:uint = 0.0, bytesTotal:uint = 0.0, message:String = "" )
		{
			super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
			_message = message;
		}
		
		 /*==========================Public methods============================*/
        
        override public function clone():Event {
            return new ProgressEventMessage(type, bubbles, cancelable, 
            	bytesLoaded, bytesTotal, _message);
        }
        
        /**
         * Returns a message describing the status of the progress 
         * @return A message describing the status of the progress
         */
        public function get message():String {
            return _message;
        }
	}
}