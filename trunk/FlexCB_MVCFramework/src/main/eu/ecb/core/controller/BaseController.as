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
package eu.ecb.core.controller
{
	import eu.ecb.core.model.IModel;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Event triggered after the controller has finished all pending tasks
	 * 
	 * @eventType eu.ecb.core.controller.ControllerAdapter.TASK_COMPLETED
	 */
	[Event(name="taskCompleted", type="flash.events.Event")]
	
	/**
	 * Event triggered when an error has been encountered by the controller when
	 * executing a task
	 * 
	 * @eventType eu.ecb.core.controller.ControllerAdapter.TASK_ERROR
	 */
	[Event(name="taskError", type="flash.events.ErrorEvent")]
	
	/**
	 * Event triggered when a task is running
	 * 
	 * @eventType eu.ecb.core.controller.ControllerAdapter.TASK_PROGRESS
	 */
	[Event(name="taskProgress", type="eu.ecb.core.event.ProgressEventMessage")]
	
	/**
	 * Event triggered when a task has started
	 * 
	 * @eventType eu.ecb.core.controller.ControllerAdapter.TASK_STARTED
	 */
	[Event(name="taskStarted", type="flash.events.Event")]
		
	/**
	 * Base implementation of the IController interface. It also contains a 
	 * few constants used by events.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class BaseController extends EventDispatcher 
		implements IController
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 
        protected var _model:IModel;
        
        /*=============================Constants==============================*/
		
		/**
		 * The ControllerAdapter.TASK_COMPLETED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>taskCompleted</code> event.
		 * 
		 * @eventType taskCompleted
		 */
		public static const TASK_COMPLETED:String = "taskCompleted";
		
		/**
		 * The ControllerAdapter.TASK_ERROR constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>taskError</code> event.
		 * 
		 * @eventType taskError
		 */  
		public static const TASK_ERROR:String = "taskError";
		
		/**
		 * The ControllerAdapter.TASK_PROGRESS constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>taskProgress</code> event.
		 * 
		 * @eventType taskProgress
		 */ 
		public static const TASK_PROGRESS:String = "taskProgress";
		
		/**
		 * The ControllerAdapter.TASK_STARTED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>taskStarted</code> event.
		 * 
		 * @eventType taskStarted
		 */ 
		public static const TASK_STARTED:String = "taskStarted";
		
		/*===========================Constructor==============================*/
			
		/**
		 * Instantiates a new controller object.
		 *  
		 * @param model The model that will be affected by the actions of the
		 * controller
		 * 
		 */
		public function BaseController(model:IModel) {
			super();
			this.model = model;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function get model():IModel {
			return _model;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set model(model:IModel):void {
			_model = model;
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * Handle errors.
		 * 
		 * @param event The event containing the error message.
		 */
		protected function handleError(event:ErrorEvent):void {
			dispatchEvent(new ErrorEvent(TASK_ERROR, false, false, event.text));
		}
	}
}