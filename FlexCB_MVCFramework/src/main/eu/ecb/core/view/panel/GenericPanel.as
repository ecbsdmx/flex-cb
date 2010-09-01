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
package eu.ecb.core.view.panel
{
	import eu.ecb.core.command.ICommand;
	import eu.ecb.core.command.IInvoker;
	import eu.ecb.core.controller.BaseController;
	import eu.ecb.core.controller.ISDMXServiceController;
	import eu.ecb.core.controller.ISDMXViewController;
	import eu.ecb.core.event.ProgressEventMessage;
	import eu.ecb.core.event.SDMXObjectEvent;
	import eu.ecb.core.model.IModel;
	import eu.ecb.core.model.ISDMXServiceModel;
	import eu.ecb.core.util.config.BasicConfigurationParser;
	import eu.ecb.core.util.config.IConfigurationParser;
	import eu.ecb.core.util.net.locator.ISeriesLocator;
	import eu.ecb.core.view.BaseSDMXMediator;
	import eu.ecb.core.view.util.ProgressBox;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.managers.PopUpManager;

	/**
	 * Generic Flex-CB panel, driven by an XML configuration file. 
	 * 
	 * @author Xavier Sosnovsky
	 * @author Rok Povse
	 */
	public class GenericPanel extends BaseSDMXMediator implements IInvoker
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 	
		protected var _fileLocator:ISeriesLocator;
		private var _pBar:ProgressBox;
		private var _commands:Object;
		private var _views:Object;
		private var _runOnceEvents:Object;
		
		
		/*===========================Constructor==============================*/
		
		public function GenericPanel(model:ISDMXServiceModel, 
			controller:ISDMXServiceController, settings:URLRequest)
		{
			super(model, controller, "vertical");
			_views = new Object();
			setTaskProgressHandlers();
			setConfigParserHandlers(settings);
		}
		
		/*==========================Public methods============================*/

		/**
		 * @inheritDoc
		 */ 
		public function addCommand(eventType:String, eventSource:String, 
			command:ICommand, receiver:*):void {
			
			if (null == _commands) {
				_commands = new Object();
			}
			if (!(_commands.hasOwnProperty(eventType))) {
				_commands[eventType] = new Object();
			}
			if (!(_commands[eventType].hasOwnProperty(eventSource))) {
				_commands[eventType][eventSource] = new ArrayCollection();
			}
			command.receiver = receiver;
			command.model = _model;
			(_commands[eventType][eventSource] as ArrayCollection).
				addItem(command);
		}
		
		/**
		 * @inheritDoc
		 */	
		public function handleEvent(event:Event):void {
			var source:String = (event.currentTarget is IModel) ? 
				"model" : event.currentTarget.id;
			if (_commands.hasOwnProperty(event.type)) {
				if (_commands[event.type].hasOwnProperty(source)) {
					for each (var command:ICommand in _commands[event.type]
						[source] as ArrayCollection) {
						command.event = event;	
						command.execute();	
					}	
				}
			}
		}
		
		/*==========================Protected methods=========================*/
		
		/**
		 * Handles the extraction of settings applying to the mediator, such as
		 * startDate, fileLocator, etc.
		 *  
		 * @param event
		 */
		protected function handleDBoardSettingsExtracted(
			event:SDMXObjectEvent):void {
			event.stopImmediatePropagation();
			var sdmxObject:Object = event.sdmxObject;
			
			if (sdmxObject.hasOwnProperty("id")) {
				id = sdmxObject.id;
			}
			if (sdmxObject.hasOwnProperty("startDate")) {
				(_controller as ISDMXViewController).changeStartDate(
					sdmxObject.startDate);	
			}
			if (sdmxObject.hasOwnProperty("fileLocator")) {
				_fileLocator = sdmxObject.fileLocator;	
			}
			var root:Object = new Object();
			root["view"] = this;
			root["panel"] = null;
			_views[id] = root; 
			if (sdmxObject.hasOwnProperty("keyFamilyURI")) {
				_controller.structureSource = sdmxObject.keyFamilyURI;
			}	
			event = null;	
		}
		
		/**
		 * Handles the progress event dispatched by the controller, for example
		 * when fetching a data file.
		 *  
		 * @param event
		 */
		protected function handleProgress(event:ProgressEventMessage):void
		{
			if (null != _pBar) {
				_pBar.showWait(event);
			}
		}
		
		/**
		 * Handles the start task event dispatched by the controller, for 
		 * example when initiating a request for a data file.
		 *  
		 * @param event
		 */
		protected function handleTaskStarted(event:Event):void
		{
			if (null == _pBar) {
				_pBar =
					PopUpManager.createPopUp(this.parent, 
						ProgressBox,true) as ProgressBox;
				PopUpManager.centerPopUp(_pBar);
			}
		}
		
		/**
		 * Handles the end task event dispatched by the controller, for 
		 * example when closing a request for a data file.
		 *  
		 * @param event
		 */
		protected function handleTaskCompleted(event:Event):void
		{
			if (null != _pBar) {
				PopUpManager.removePopUp(_pBar);
				_pBar = null;
			}
		}	
		
		/**
		 * Defines the handlers to be used to handle the task-related events
		 * dispatched by the controller.  
		 */
		protected function setTaskProgressHandlers():void
		{
			controller.addEventListener(BaseController.TASK_STARTED, 
				handleTaskStarted);
			controller.addEventListener(BaseController.TASK_PROGRESS, 
				handleProgress);		
			controller.addEventListener(BaseController.TASK_COMPLETED, 
				handleTaskCompleted);
		}
		
		/**
		 * Defines the handlers to be used to handle the events dispatched by 
		 * the configuration parser.  
		 */
		protected function setConfigParserHandlers(settings:URLRequest):void
		{
			var configurationParser:IConfigurationParser = 
				new BasicConfigurationParser();
			configurationParser.addEventListener(
				BasicConfigurationParser.DBOARD_SETTINGS_EXTRACTED,
				 handleDBoardSettingsExtracted,false,0,true);
			configurationParser.addEventListener(
				BasicConfigurationParser.DATA_INFO_EXTRACTED, 
				handleDataInfoExtracted,false,0,true);
			configurationParser.addEventListener(
				BasicConfigurationParser.EVENT_EXTRACTED,
				 handleEventExtracted,false,0,true);
			configurationParser.addEventListener(
				BasicConfigurationParser.VIEW_EXTRACTED,
				 handleViewExtracted,false,0,true);
			configurationParser.parse(settings);
		}
		
		/**
		 * Handles the request to fetch data files.  
		 */
		protected function handleDataInfoExtracted(event:SDMXObjectEvent):void {
			event.stopImmediatePropagation();
			
			var collection:ArrayCollection = new ArrayCollection();
			for each (var missing:String in event.sdmxObject.files) {
				if (null != _fileLocator) {
					collection.addItem(
						_fileLocator.getFileForSeries(missing));
				} else {
					collection.addItem(missing);	
				}
			}	
			
			if (collection.length > 0) {
				_controller.fetchDataFiles(collection);
			}
			event = null;
		}
		
		/*==========================Private methods===========================*/
		
		private function handleEventExtracted(event:SDMXObjectEvent):void {
			event.stopImmediatePropagation();
			var obj:Object = event.sdmxObject; 						
			var source:IEventDispatcher = (obj["source"] == "model") ? 
				_model : _views[obj["source"]]["view"];
			var receiver:* = (obj["receiver"] == "controller") ? 
				_controller : _views[obj["receiver"]]["view"];
			source.addEventListener(obj["type"], _views[obj["invoker"]]
				["view"]["handleEvent"], false); 
			source.addEventListener(obj["type"], _views[obj["invoker"]]
				["view"]["handleEvent"], true);			
			addCommand(obj["type"], obj["source"], obj["command"], receiver);		
			if (obj.hasOwnProperty("runOnce") && obj["runOnce"]) {
				if (null == _runOnceEvents) {
					_runOnceEvents = new Object();
				}
				if (!(_runOnceEvents.hasOwnProperty(obj["type"]))) {
					_runOnceEvents[obj["type"]] = new ArrayCollection();
				}
				(_runOnceEvents[obj["type"]] as ArrayCollection).
					addItem(receiver);
			}
			event = null;
		}
		
		private function handleViewExtracted(event:SDMXObjectEvent):void {
			event.stopImmediatePropagation();
			_views[event.sdmxObject.view.id] = event.sdmxObject;
			if (event.sdmxObject.isRoot) {
				addView(event.sdmxObject.view);
			}
			event = null;
		}
	}
}