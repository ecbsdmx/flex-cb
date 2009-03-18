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
	
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	/**
	 * Event triggered after a command has been successfully executed.
	 * 
	 * @eventType eu.ecb.core.command.CommandAdapter.COMMAND_COMPLETED
	 */
	[Event(name="commandCompleted", type="flash.events.Event")]
	
	/**
	 * Event triggered when an error has been encountered when executing 
	 * the command.
	 * 
	 * @eventType eu.ecb.core.command.CommandAdapter.COMMAND_ERROR
	 */
	[Event(name="commandError", type="flash.events.ErrorEvent")]
	
	/**
	 * Event thrown when the command is being executed.
	 * 
	 * @eventType eu.ecb.core.command.CommandAdapter.COMMAND_PROGRESS
	 */
	[Event(name="commandProgress", type="eu.ecb.event.ProgressEventMessage")]  
	
	/**
	 * Default implementation of the ICommand interface. The execute command
	 * must be implemented in the subclasses, else it will throw an
	 * IllegalOperationError.
	 * 
	 * A Command will dispatch:
	 * 1. A "commandCompleted" event when the command has successfully executed.
	 * 2. A "commandProgress" at each step of the command execution.
	 * 3. A "commandError" in case an error occurs when executing the command.
	 *  
	 * @author Xavier Sosnovsky
	 */ 
	public class CommandAdapter extends EventDispatcher implements ICommand
	{
		/*=============================Constants==============================*/
		
		/**
		 * The CommandAdapter.COMMAND_COMPLETED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>commandCompleted</code> event.
		 * 
		 * @eventType commandCompleted
		 */
		public static const COMMAND_COMPLETED:String = "commandCompleted";
		
		/**
		 * The CommandAdapter.COMMAND_ERROR constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>commandError</code> event.
		 * 
		 * @eventType commandError
		 */
		public static const COMMAND_ERROR:String = "commandError";
		
		/**
		 * The CommandAdapter.COMMAND_PROGRESS constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>commandProgress</code> event.
		 * 
		 * @eventType commandProgress
		 */ 
		public static const COMMAND_PROGRESS:String = "commandProgress";
		
		/*==============================Fields================================*/
		
		/**
		 * Commands may also contain commands to be executed. If so, these
		 * sub-commands can be stored here.  
		 */
		protected var _commands:Object;
		
		/*===========================Constructor==============================*/
		
		/**
		 * Instantiates a new Command adapter, with the desired receiver. 
		 * 
		 * @param receiver The class who knows how to perform the work needed
		 * to carry out the request.
		 */
		public function CommandAdapter() 
		{
			super();
			_commands = new Object();
		}

		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			throw new IllegalOperationError("The execute method must be " + 
					"implemented in the subclass");
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * Handles the reception of "completed" events thrown by receivers and
		 * dispatches the CommandAdapter.COMMAND_COMPLETED event.
		 * 
		 * @param event "completed" event thrown by receivers
		 */
		protected function handleCompleted(event:Event):void 
		{
			event.stopImmediatePropagation();
			dispatchEvent(new Event(CommandAdapter.COMMAND_COMPLETED));
			event = null;		
		}
		
		/**
		 * Handles the reception of "error" events thrown by receivers and
		 * dispatches the CommandAdapter.COMMAND_ERROR event.
		 * 
		 * @param event "error" event thrown by receivers
		 */
		protected function handleError(event:ErrorEvent):void 
		{
			event.stopImmediatePropagation();
			dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
					false, false, event.text));
			event = null;		
		}
		
		/**
		 * Handles the reception of "progress" events thrown by receivers and
		 * dispatches the CommandAdapter.COMMAND_PROGRESS event.
		 * 
		 * @param event "progress" event thrown by receivers
		 */
		protected function handleProgress(event:ProgressEvent):void 
		{
			event.stopImmediatePropagation();
			dispatchEvent(new ProgressEventMessage(
				CommandAdapter.COMMAND_PROGRESS, false, false, 
				event.bytesLoaded, event.bytesTotal, ""));
			event = null;	
		}
		
		/**
		 * Add a command to the list of subcommands to be executed by the class.
		 *  
		 * @param commandID The id of the command
		 * @param command The command to be executed
		 * @param event The event that will be dispatched when the command has
		 * been successfully executed
		 * @param eventHandler The function that will handle the reception of 
		 * the event when the command has been successfully executed.
		 * 
		 */
		protected function addCommand(commandID:String, command:ICommand, 
			event:String, eventHandler:Function):void
		{
			_commands[commandID] = command;
			command.addEventListener(event, eventHandler); 
			command.addEventListener(CommandAdapter.COMMAND_ERROR, 
				handleError);
		}	
	}
}