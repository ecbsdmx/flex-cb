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
package eu.ecb.core.util.config
{
	import eu.ecb.core.command.ICommand;
	import eu.ecb.core.event.SDMXObjectEvent;
	import eu.ecb.core.util.net.locator.ISeriesLocator;
	import eu.ecb.core.view.ISDMXComposite;
	import eu.ecb.core.view.ISDMXServiceView;
	import eu.ecb.core.view.ISDMXView;
	import eu.ecb.core.view.map.IMap;
	import eu.ecb.core.view.map.IMapComponent;
	import eu.ecb.core.view.map.MapCategory;
	import eu.ecb.core.view.map.MapComponentHelper;
	
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.sdmx.event.XMLDataEvent;
	import org.sdmx.util.net.LoaderAdapter;
	import org.sdmx.util.net.XMLLoader;
	
	/**
	 * Event triggered when an event has been extracted from the configuration 
	 * file.
	 * 
	 * @eventType eu.ecb.core.util.config.ECBConfigurationParser.EVENT_EXTRACTED
	 */
	[Event(name="eventExtracted", type="eu.ecb.core.event.SDMXObjectEvent")]
	
	/**
	 * Event triggered when a view has been extracted from the configuration 
	 * file.
	 * 
	 * @eventType eu.ecb.core.util.config.ECBConfigurationParser.VIEW_EXTRACTED
	 */
	[Event(name="viewExtracted", type="eu.ecb.core.event.SDMXObjectEvent")]
	
	/**
	 * Event triggered when all information related to data extraction has been
	 * extracted.
	 * 
	 * @eventType eu.ecb.core.util.config.ECBConfigurationParser.DATA_INFO_EXTRACTED
	 */
	[Event(name="dataInfoExtracted", type="eu.ecb.core.event.SDMXObjectEvent")]
	
	/**
	 * Event triggered when all dashboard settings have been extracted.
	 * 
	 * @eventType eu.ecb.core.util.config.ECBConfigurationParser.DBOARD_SETTINGS_EXTRACTED
	 */
	[Event(name="dboardSettingsExtracted", type="eu.ecb.core.event.SDMXObjectEvent")]
	
	/**
	 * The base implementation of the IConfigurationParser interface. 
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	public class BasicConfigurationParser extends EventDispatcher 
		implements IConfigurationParser
	{
		/*=============================Constants==============================*/
		
		/**
		 * The ECBConfigurationParser.EVENT_EXTRACTED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>eventExtracted</code> event.
		 * 
		 * @eventType eventExtracted
		 */
		public static const EVENT_EXTRACTED:String = "eventExtracted";
		
		/**
		 * The ECBConfigurationParser.VIEW_EXTRACTED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>viewExtracted</code> event.
		 * 
		 * @eventType viewExtracted
		 */
		public static const VIEW_EXTRACTED:String = "viewExtracted";
				
		/**
		 * The ECBConfigurationParser.DATA_INFO_EXTRACTED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>dataInfoExtracted</code> event.
		 * 
		 * @eventType dataInfoExtracted
		 */
		public static const DATA_INFO_EXTRACTED:String = "dataInfoExtracted";
		
		/**
		 * The ECBConfigurationParser.DBOARD_SETTINGS_EXTRACTED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>dboardSettingsExtracted</code> event.
		 * 
		 * @eventType dboardSettingsExtracted
		 */
		public static const DBOARD_SETTINGS_EXTRACTED:String = 
			"dboardSettingsExtracted";
		
		/*==============================Fields================================*/
		
		/**
		 * The logger class for the dashboard. 
		 */
		protected var _logger:ILogger;
		
		/**
		 * The loader that will load the XML file containing the dashboard
		 * settings.
		 */ 
		protected var _loader:XMLLoader;
				
		/*===========================Constructor==============================*/
		
		public function BasicConfigurationParser()
		{
			super();
			_logger = Log.getLogger(String(getQualifiedClassName(this)).
				replace(/::/g, "."));
			_logger.debug("Creating new instance of: " + 
				getQualifiedClassName(this));
		}
		
		/*===========================Public methods===========================*/

		public function parse(settings:URLRequest):void
		{
			_logger.debug("Fetching dashboard settings file: " + settings.url);
			if (null == _loader) {
				_loader = new XMLLoader();
				_loader.addEventListener(LoaderAdapter.DATA_LOADED, 
					handleSettingsLoaded);
			}
			_loader.file = settings;
			_loader.execute();
		}
		
		/*===========================Private methods==========================*/
		
		/**
		 * Handles the reception of the XML data holding the settings.
		 * 
		 * @param event
		 */
		private function handleSettingsLoaded(event:XMLDataEvent):void 
		{
			event.stopPropagation();
			var configurationXML:XML = event.data;	
			
			var panelSettings:Object = new Object();
			checkMandatoryAttribute("id", configurationXML);
			checkMandatoryAttribute("keyFamilyURI", configurationXML);
			panelSettings["id"] = configurationXML.@id;
			if (configurationXML.attribute("startDate").length() > 0) {
				var dateSplit:Array = 
					(configurationXML.@startDate).split("-");
				panelSettings["startDate"] = 
					new Date(Number(dateSplit[0]), Number(dateSplit[1]) - 1, 
						Number(dateSplit[2]));	
			}
			
			if (configurationXML.child("seriesLocator").length() > 0) {
				var LocClass:Class = getClassFromString(
					configurationXML.seriesLocator.@className);
				var fileLocator:ISeriesLocator = 
					new LocClass() as ISeriesLocator;	
				if ((configurationXML.seriesLocator as XMLList).
					attribute("dataflowId").length() > 0) {
					fileLocator.dataflowId = 
						configurationXML.seriesLocator.@dataflowId;
				}
				if ((configurationXML.seriesLocator as XMLList).
					attribute("isCompressed").length() > 0) {
					fileLocator.isCompressed = 
						"true" == configurationXML.seriesLocator.@isCompressed ?
							true : false;
				} 
				panelSettings["fileLocator"] = fileLocator;
			}
			
			panelSettings["keyFamilyURI"] = 
				new URLRequest(configurationXML.@keyFamilyURI);
			dispatchEvent(new SDMXObjectEvent(DBOARD_SETTINGS_EXTRACTED, 
				panelSettings));
							
			for each (var viewXML:XML in configurationXML.views.view) {
				var view:ISDMXView = extractSDMXView(viewXML, null, true);
			}
			
			var seriesCollection:ArrayCollection = new ArrayCollection();
			for each (var seriesXML:XML in 
				configurationXML.data.series) {
				if (!(seriesCollection.contains(String(seriesXML.@key)))) {
					seriesCollection.addItem(String(seriesXML.@key));
				}
			}
			
			for each (var eventXML:XML in configurationXML.events.event) {
				extractEvent(eventXML);
			}
			
			var data:Object = new Object();
			data["files"] = seriesCollection;
			dispatchEvent(new SDMXObjectEvent(DATA_INFO_EXTRACTED, data));
			
			event = null;
		}
		
		private function checkMandatoryAttribute(attribute:String, xml:XML):void
        {
        	if (xml.attribute(attribute).length() == 0) {
				throwError("Mandatory attribute not found: " + attribute);
			}
        }
        
        private function throwError(msg:String, type:String = "argument", 
        	level:String = "fatal"):void
        {
        	if (level == "fatal") {
        		_logger.fatal(msg);
        	}
        	if (type == "argument") {
        		throw new ArgumentError(msg);
        	}
        }
        
        private function getClassFromString(className:String):Class 
        {
			return getDefinitionByName(className) as Class;
        }
        
        private function extractEvent(eventXML:XML):void {
        	checkMandatoryAttribute("sources", eventXML);
        	checkMandatoryAttribute("type", eventXML);
        	checkMandatoryAttribute("invoker", eventXML);
        	checkMandatoryAttribute("command", eventXML);
        	checkMandatoryAttribute("receivers", eventXML);
        	var sources:String = String(eventXML.@sources);
        	if (-1 < sources.indexOf(",")) {
        		var targets:Array = sources.split(",");
				for each (var target:String in targets) {
					createEvent(eventXML, target);	
				}
        	} else {
        		createEvent(eventXML, sources);
        	}
		}
		
		private function createEvent(eventXML:XML, source:String):void
		{
			var event:Object = new Object();
			event["source"]  = source;
			event["type"]    = String(eventXML.@type);
			event["invoker"] = String(eventXML.@invoker);
			event["command"] = String(eventXML.@command);
			event["command_options"] = eventXML.options;
			event["runOnce"] = eventXML.attribute("runOnce").length() > 0 &&
				String(eventXML.@runOnce) == "true";
			var receivers:String = String(eventXML.@receivers);	
			if (-1 < receivers.indexOf(",")) {	
				var targets:Array = receivers.split(",");
				for each (var target:String in targets) {
					prepareEventDispatch(target, event);
				} 
			} else {
				prepareEventDispatch(receivers, event);
			}
		}
		
		private function prepareEventDispatch(target:String, event:Object):void{
			if (-1 < event["command"].indexOf(",")) {	
				var commands:Array = event["command"].split(",");
				for each (var cmd:String in commands) {
					prepareCommandDispatch(cmd, target, event);
				} 
			} else {
				prepareCommandDispatch(event["command"], target, event);
			}
		}
		
		private function prepareCommandDispatch(command:String, target:String,
			event:Object):void {
			var dispatchedEvent:Object = new Object();
			dispatchedEvent["source"] = event["source"];
			dispatchedEvent["type"] = event["type"];
			dispatchedEvent["invoker"] = event["invoker"];
			var CmdClass:Class = getClassFromString(command);					
			var cmd:ICommand = new CmdClass() as ICommand;
			setOptions(cmd,event["command_options"]);
			dispatchedEvent["command"] = cmd;
			dispatchedEvent["runOnce"] = event["runOnce"];
			dispatchedEvent["receiver"] = target;
			dispatchEvent(new SDMXObjectEvent(EVENT_EXTRACTED, 
				dispatchedEvent));
		}
		
		private function extractSDMXView(xml:XML, 
			container:ISDMXServiceView, isRoot:Boolean = false):ISDMXView
		{
			checkMandatoryAttribute("className", xml);
			checkMandatoryAttribute("id", xml);
			
			var ViewClass:Class = getClassFromString(xml.@className);
			var sdmxView:ISDMXView = new ViewClass() as ISDMXView;	
			sdmxView.id = xml.@id;	 						
			setOptions(sdmxView, xml.options);
			
			var view:Object = new Object();
			view["view"]  = sdmxView;
			if (container != null) {
				view["panel"] = container.id;
			}
			view["isRoot"] = isRoot;
			dispatchEvent(new SDMXObjectEvent(VIEW_EXTRACTED, view));
			
			for each (var viewXML:XML in xml.views.view) {
				if (!(sdmxView is ISDMXComposite)) {
					throwError("Only ISDMXComposite classes are " + 
						"allowed to contain sub views");
				}
				(sdmxView as ISDMXComposite).addView(extractSDMXView(viewXML, 
					container));
			}
			
			if (sdmxView is IMapComponent && xml.child("init").length() > 0 &&
				xml.init.child("categories").length() > 0) {
				var categories:ArrayCollection = new ArrayCollection();
				for each (var catXML:XML in xml.init.categories.category) {
					checkMandatoryAttribute("styleName", catXML);
					var category:MapCategory = new MapCategory();
					if (catXML.attribute("label").length() > 0) {
						category.label = catXML.@label;
					}
					category.styleName = catXML.@styleName;
					if (catXML.attribute("minValue").length() > 0) {
						category.minValue = catXML.@minValue;
					}
					if (catXML.attribute("maxValue").length() > 0) {
						category.maxValue = catXML.@maxValue;
					}
					categories.addItem(category);
				}
				var mapHelper:MapComponentHelper = new MapComponentHelper();
				mapHelper.categories = categories;
				(sdmxView as IMapComponent).helper = mapHelper;
				
				if (sdmxView is IMap && 
					xml.init.child("mapLegend").length() > 0) {
					var LegendClass:Class = 
						getClassFromString(xml.init.mapLegend.@className);
					var mapLegendView:IMapComponent = 
						new LegendClass() as IMapComponent;	
					mapLegendView.helper = mapHelper;	
					(sdmxView as IMap).mapLegend = mapLegendView; 
				}
			}
			return sdmxView;
		}
		
		private function setOptions(target:*, xml:XMLList):void
        {
        	for each (var optionXML:XML in xml.option) {
				checkMandatoryAttribute("name", optionXML);
				var optionName:String = optionXML.@name;
				var optionValue:*;
				
				if (optionXML.attribute("valueType").length() > 0) {
					var type:String = optionXML.@valueType;
					if (type != "arrayCollection") {
						checkMandatoryAttribute("value", optionXML);
					}
					switch (type) {
						case "boolean": 
							optionValue = 
								(optionXML.@value == "true") ? true : false; 
							break;
						case "number": 
							optionValue = Number(optionXML.@value); 
							break;	
						case "string":
							optionValue = String(optionXML.@value); 
							break;
						case "arrayCollection":
							checkMandatoryAttribute("itemsValueType", optionXML);
							var itemType:String = optionXML.@itemsValueType
							
							optionValue=new ArrayCollection();
							
							for each (var itemXML:XML in optionXML.item) {
								switch(itemType) {
									case "string":
										(optionValue as ArrayCollection).addItem(String(itemXML));
										break;
									case "number":
										(optionValue as ArrayCollection).addItem(Number(itemXML));
										break;
									default:
										throwError("Unknown valueType: " + itemType);
								}
							}
							break;
						default:
							throwError("Unknown valueType: " + type);
					}
				} else {
					optionValue = String(optionXML.@value); 
				}
				target[optionName] = optionValue;
			}
        }
	}
}