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
	import eu.ecb.core.controller.IController;
	import eu.ecb.core.model.IModel;
	import eu.ecb.core.util.net.locator.ISeriesLocator;
	
	import flash.events.Event;
	
	/**
	 * Contract to be implemented by commands. Invokers execute commands when
	 * certain events are dispatched.  
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	public interface ICommand
	{
		/**
		 * The event that triggered the command execution.
		 */ 
		function set event(event:Event):void;
		
		/**
		 * The classes that are listening to the event.
		 */ 
		function set receiver(receiver:*):void;
		
		/**
		 * The model used by the application.
		 */ 
		function set model(model:IModel):void;
		
		/**
		 * The controller used by the application.
		 */ 
		function set controller(controller:IController):void;
		
		/**
		 * The file locator used by the application.
		 */ 
		function set fileLocator(locator:ISeriesLocator):void;
		
		/**
		 * A collection with all views used by the application.
		 */ 
		function set views(views:Object):void;
		
		/**
		 * A collection view all series used by the application, organised by
		 * panels.
		 */ 
		function set panelSeries(series:Object):void;
		
		/**
		 * A collection containing any hierarchical code list used by the 
		 * application.
		 */ 
		function set hierarchies(hierarchies:Object):void;
		
		/**
		 * The status messages defined by the application.
		 */ 
		function set statusMessages(messages:Object):void;
		
		/**
		 * The formatters used by the application.
		 */ 
		function set formatters(formatters:Object):void;
		
		/**
		 * Instructs the command to perform its task.
		 */ 
		function execute():void;
	}
}