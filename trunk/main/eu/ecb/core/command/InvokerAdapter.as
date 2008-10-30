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
package eu.ecb.core.command
{
	import eu.ecb.core.event.ProgressEventMessage;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	/**
	 * Event triggered after the invoker has finished invoking all commands.
	 * 
	 * @eventType eu.ecb.core.command.InvokerAdapter.INVOCATION_COMPLETED
	 */
	[Event(name="invocationCompleted", type="flash.events.Event")]
	
	/**
	 * Event triggered when an error has been encountered when invoking a
	 * command.
	 * 
	 * @eventType eu.ecb.core.command.InvokerAdapter.INVOCATION_ERROR
	 */
	[Event(name="invocationError", type="flash.events.ErrorEvent")]
	
	/**
	 * Event triggered when the invocation is in progress
	 * 
	 * @eventType eu.ecb.core.command.InvokerAdapter.INVOCATION_PROGRESS
	 */
	[Event(name="invocationProgress", type="eu.ecb.event.ProgressEventMessage")]
	
	/**
	 * Default implementation of the IInvoker interface. The invoker will,
	 * upon requests, invoke the execute method of all commands that have
	 * been assigned to it, either in parallel (the default), or one after the 
	 * other.
	 * 
	 * An Invoker will dispatch:
	 * 1. A "invocationCompleted" event when the invoker has finished invoking 
	 * 	  all commands.
	 * 2. A "invocationError" when an error has been encountered when invoking a
	 *    command.
	 * 3. A "invocationProgress" when an invocation is in progress.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class InvokerAdapter extends EventDispatcher implements IInvoker
	{
		/*==============================Fields================================*/
		
		private var _commands:ArrayCollection;
		
		private var _counter:uint;
		
		/*=============================Constants==============================*/
		
		/**
		 * The InvokerAdapter.INVOCATION_COMPLETED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>invocationCompleted</code> event.
		 * 
		 * @eventType invocationCompleted
		 */
		public static const INVOCATION_COMPLETED:String = "invocationCompleted";
		
		/**
		 * The InvokerAdapter.INVOCATION_ERROR constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>invocationError</code> event.
		 * 
		 * @eventType invocationError
		 */  
		public static const INVOCATION_ERROR:String = "invocationError";
		
		/**
		 * The InvokerAdapter.INVOCATION_PROGRESS constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>invocationProgress</code> event.
		 * 
		 * @eventType invocationProgress
		 */ 
		public static const INVOCATION_PROGRESS:String = 
			"invocationProgress";
		
		/*===========================Constructor==============================*/
		
		public function InvokerAdapter(target:IEventDispatcher=null)
		{
			super(target);
			_commands = new ArrayCollection;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function addCommand(command:ICommand):void
		{
			_commands.addItem(command);	
		}
		
		/**
		 * @inheritDoc
		 */
		public function invokeCommands(queued:Boolean = false):void
		{
			if (queued) {
				_counter = 0;	
				fetchCommand();	
			} else {
				for each (var command:ICommand in _commands) {
					executeCommand(command);
					_counter++;
				}
			}
		}		
		
		/*==========================Private methods===========================*/
		
		private function fetchCommand():void 
		{
			if (_counter < _commands.length - 1) {
				executeCommand(_commands.getItemAt(_counter) as ICommand);
			}
		}
		
		private function executeCommand(command:ICommand):void {
			command.addEventListener(CommandAdapter.COMMAND_COMPLETED, 
				handleCommandCompleted);
			command.addEventListener(CommandAdapter.COMMAND_ERROR, 
				handleCommandError);		
			command.execute();
		}
		
		private function handleCommandCompleted(event:Event):void {
			event.stopImmediatePropagation();
			event = null;
			if (_counter == _commands.length -1)  {
				dispatchEvent(new Event(INVOCATION_COMPLETED));
			} else {
				dispatchEvent(new ProgressEventMessage(
					INVOCATION_PROGRESS, false, false, _counter, 
					_commands.length, "Finished executing " + (_counter + 1) + 
					" out of " + _commands.length + "command(s)"));
			}
			_counter++;
			fetchCommand();
		}
		
		private function handleCommandError(event:ErrorEvent):void {
			dispatchEvent(new ErrorEvent(INVOCATION_ERROR, false, false, 
				event.text));
			event.stopImmediatePropagation();
			event = null;	
		}
	}
}