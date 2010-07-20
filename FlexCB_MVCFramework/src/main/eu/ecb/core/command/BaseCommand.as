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
	 * The base implementation of the ICommand interface.
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	public class BaseCommand implements ICommand
	{
		/*==============================Fields================================*/
		/**
		 * @private
		 */ 
		protected var _event:Event;
		
		/**
		 * @private
		 */
		protected var _receiver:*;
		
		/**
		 * @private
		 */
		protected var _model:IModel;
		
		/**
		 * @private
		 */
		protected var _controller:IController;
		
		/**
		 * @private
		 */
		protected var _fileLocator:ISeriesLocator;
		
		/**
		 * @private
		 */
		protected var _views:Object;
		
		/**
		 * @private
		 */
		protected var _panelSeries:Object;
		
		/**
		 * @private
		 */
		protected var _hierarchies:Object;
		
		/**
		 * @private
		 */
		protected var _statusMessages:Object;
		
		/**
		 * @private
		 */
		protected var _formatters:Object;
		
		/*===========================Constructor==============================*/
		
		public function BaseCommand()
		{
			super();
		}
		
		/*============================Accessors===============================*/

		/**
		 * @inheritDoc
		 */ 
		public function set event(event:Event):void
		{
			_event = event;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set receiver(receiver:*):void
		{
			_receiver = receiver;	
		}
		
		/**
		 * @inheritDoc
		 */
		public function set model(model:IModel):void
		{
			_model = model;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set controller(controller:IController):void
		{
			_controller = controller;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set fileLocator(locator:ISeriesLocator):void
		{
			_fileLocator = locator;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set views(views:Object):void
		{
			_views = views;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set panelSeries(series:Object):void
		{
			_panelSeries = series;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set hierarchies(hierarchies:Object):void
		{
			_hierarchies = hierarchies;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set statusMessages(messages:Object):void
		{
			_statusMessages = messages;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set formatters(formatters:Object):void
		{
			_formatters = formatters;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			throw new ArgumentError("This method must be implemented by" + 
				" subclasses");
		}
	}
}