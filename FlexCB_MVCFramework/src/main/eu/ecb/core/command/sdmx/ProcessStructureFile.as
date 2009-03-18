// Copyright (C) 2009 European Central Bank. All rights reserved.
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
package eu.ecb.core.command.sdmx
{
	import eu.ecb.core.command.CommandAdapter;
	import eu.ecb.core.event.XMLDataEvent;
	import eu.ecb.core.util.net.LoaderAdapter;
	import eu.ecb.core.util.net.XMLLoader;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.stores.xml.v2.structure.StructureReader;
	
	/**
	 * Event dispatched when the XML file has been successfully fetched. It will 
	 * return the XML file.
	 * 
	 * @eventType eu.ecb.core.command.ProcessStructureFile.STRUCTURE_FETCHED
	 */
	[Event(name="structureFetched", type="eu.ecb.core.event.XMLDataEvent")]
	
	/**
	 * Event dispatched when the Structure file has been successfully parsed
	 * and interpreted. It will return the list of data structure definitions 
	 * extracted from the XML file.
	 * 
	 * @eventType eu.ecb.core.command.ProcessStructureFile.STRUCTURE_PROCESSED
	 */
	[Event(name="structureProcessed", type="org.sdmx.event.SDMXDataEvent")]

	/**
	 * This command is responsible for fetching and interpreting SDMX-ML
	 * Structure files.
	 *   
	 * @author Xavier Sosnovsky
	 */
	public class ProcessStructureFile extends CommandAdapter
	{
		/*=============================Constants==============================*/
		
		/**
		 * The ProcessStructureFile.STRUCTURE_FETCHED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>structureFetched</code> event.
		 * 
		 * @eventType structureFetched
		 */  
		public static const STRUCTURE_FETCHED:String = "structureFetched";
		
		/**
		 * The ProcessStructureFile.STRUCTURE_PROCESSED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>structureProcessed</code> event.
		 * 
		 * @eventType structureProcessed
		 */  
		public static const STRUCTURE_PROCESSED:String = "structureProcessed";
		
		/*==============================Fields================================*/
		
		private var _url:URLRequest;
		
		private var _xml:XML;
		
		private var _loader:XMLLoader;
		
		private var _reader:StructureReader;
		
		private var _fetchStructure:Boolean;
		
		/*============================Constructor=============================*/
		
		public function ProcessStructureFile()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The structure file to be fetched and interpreted.
		 *  
		 * @param structureFile
		 */
		public function set structureFile(structureFile:URLRequest):void
		{
			_fetchStructure = true;
			_url = structureFile;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			if (_fetchStructure) {
				fetchXML();
			} else {
				dispatchEvent(new Event(COMMAND_COMPLETED));
			}
		}
		
		/*==========================Private methods===========================*/
		
		private function fetchXML():void
		{
			if (null == _loader) {
				_loader = new XMLLoader();
				_loader.addEventListener(LoaderAdapter.DATA_LOADED, 
					handleDataLoaded);
				_loader.addEventListener(COMMAND_ERROR, handleError);	
			}
			_loader.file = _url;
			_loader.execute();
		}
		
		private function handleDataLoaded(event:XMLDataEvent):void
		{
			event.stopImmediatePropagation();
			_fetchStructure = false;
			_xml = event.data as XML;
			dispatchEvent(new XMLDataEvent(_xml, STRUCTURE_FETCHED));
			if (validStructureFile()) {
				if (null == _reader) {
					_reader = new StructureReader();
					_reader.addEventListener(StructureReader.KEY_FAMILIES_EVENT, 
						handleKeyFamilies);	
					_reader.dispatchKeyFamilies = true;
				}
				_reader.read(_xml);	
			} else  {
				dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
					false, false, "The structure file '" + _url + "' is not "  
					+ "in a format that this application can handle"));
			}
			event = null;
		}
		
		private function handleKeyFamilies(event:SDMXDataEvent):void 
		{
			dispatchEvent(new SDMXDataEvent(event.data, STRUCTURE_PROCESSED));
			dispatchEvent(new Event(COMMAND_COMPLETED));
			event.stopImmediatePropagation();
			event = null;
		}
		
		private function validStructureFile():Boolean
		{
			var messageNS:Namespace = new Namespace("message", 
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message");
			return _xml.messageNS::KeyFamilies.length() > 0;
		}
	}
}