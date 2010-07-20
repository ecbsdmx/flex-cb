// Copyright (C) 2010 European Central Bank. All rights reserved.
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
package eu.ecb.core.command
{
	import flash.events.Event;
	
	/**
	 * Contract to be implemented by invokers. Invokers execute commands when
	 * certain events are dispatched. They act as mediator between the source of
	 * an event and the listeners to the event.
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	public interface IInvoker
	{
		/**
		 * Add a command to the list of commands managed by the invoker.
		 *  
		 * @param eventType 
		 * 		The event type that will trigger the execution of the command.
		 * @param eventSource
		 * 		The source of the event.
		 * @param command
		 * 		The command to be executed, upon reception of the event 
		 * 		dispatched by the supplied source.
		 * @param receiver
		 * 		The components which are listening to the event.
		 */
		function addCommand(eventType:String, eventSource:String, 
			command:ICommand, receiver:*):void;
			
		/**
		 * Handles the supplied event. The commands registered for the supplied
		 * event will be executed.
		 * 
		 * @param event
		 */
		function handleEvent(event:Event):void;	
	}
}