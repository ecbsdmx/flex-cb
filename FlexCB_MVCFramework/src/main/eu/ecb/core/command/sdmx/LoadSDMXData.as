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
	import eu.ecb.core.command.ICommand;
	import eu.ecb.core.event.XMLDataEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	
	/**
	 * Event dispatched when the SDMX-ML structure and data files have been 
	 * successfully loaded. It will return the data set extracted from the file.
	 * 
	 * @eventType eu.ecb.core.command.LoadSDMXData.DATA_LOADED
	 */
	[Event(name="dataLoaded", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
	 * This command loads the data out of two SDMX-ML files: The Data Structure 
	 * Definition file (in SDMX-ML Structure format) and the data file 
	 * (in SDMX-ML Compact format).
	 * 
	 * @author Xavier Sosnovsky
	 */  
	public class LoadSDMXData extends CommandAdapter
	{	
		/*=============================Constants==============================*/
		
		/**
		 * The LoadSDMXData.DATA_LOADED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>dataLoaded</code> event.
		 * 
		 * @eventType dataLoaded
		 */  
		public static const DATA_LOADED:String = "dataLoaded";
					
		/*==============================Fields================================*/
		
		private var _keyFamilies:KeyFamilies;
		
		private var _keyFamily:KeyFamily;
		
		private var _structureToFetch:Boolean;
		
		private var _dataToFetch:Boolean;
		
		private var _dataFile:XML;
		
		/*===========================Constructor==============================*/
		
		public function LoadSDMXData()
		{
			super();
			_commands = new Object();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The data file to be loaded. This is a convenience method so that the
		 * same command can load different SDMX data files whose data structure
		 * definitions are defined in the same SDMX structure file.
		 *  
		 * @param dataFile
		 */
		public function set dataFile(dataFile:URLRequest):void
		{
			_dataToFetch = true;
			if (!(_commands.hasOwnProperty("processData"))) {
				createProcessDataCmd();
			}
			(_commands["processData"] as ProcessDataFile).dataFile = dataFile;
		}
		
		/**
		 * The structure file to be loaded.
		 *  
		 * @param structureFile
		 */
		public function set structureFile(structureFile:URLRequest):void
		{
			_structureToFetch = true;
			if (!(_commands.hasOwnProperty("processStructure"))) {
				addCommand("processStructure", new ProcessStructureFile(), 
					ProcessStructureFile.STRUCTURE_PROCESSED, handleStructure);
			}
			(_commands["processStructure"] as 
				ProcessStructureFile).structureFile = structureFile;
		}
		
		/**
		 * Whether or not observation-level attributes should be fetched. This
		 * can be set to false for performance reasons.
		 *  
		 * @param flag
		 */
		public function set disableObservationAttribute(flag:Boolean):void
		{
			if (!(_commands.hasOwnProperty("processData"))) {
				createProcessDataCmd();
			}
			(_commands["processData"] as 
				ProcessDataFile).disableObservationAttribute = flag;
		}
		
		/**
		 * The optimisation level defines which optimisation settings will be 
		 * applied when reading data.
		 * 
		 * @param level
		 */
		public function set optimisationLevel(level:uint):void
		{
			if (!(_commands.hasOwnProperty("processData"))) {
				createProcessDataCmd();
			}
			(_commands["processData"] as 
				ProcessDataFile).optimisationLevel = level;
		}
				
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function execute():void
		{
			if (null == _keyFamilies || _structureToFetch == true) {
				(_commands["processStructure"] as ICommand).execute();
			} else if (_dataToFetch) {
				(_commands["processData"] as ICommand).execute();
			}
		}
				
		/*==========================Private methods===========================*/
				
		private function handleStructure(event:SDMXDataEvent):void
		{
			event.stopImmediatePropagation();
			if (null == _keyFamilies) {
				_keyFamilies = new KeyFamilies();	
			}
			for each(var kf:KeyFamily in event.data as KeyFamilies) {
				_keyFamilies.addItem(kf);
			} 
			_structureToFetch = false;
			
			if (_dataToFetch) {
				(_commands["processData"] as ICommand).addEventListener(
					ProcessDataFile.DATA_FETCHED, handleDataFetched);				
				(_commands["processData"] as ICommand).execute();
			}
			event = null;
		}
		
		private function handleDataFetched(event:XMLDataEvent):void
		{
			event.stopImmediatePropagation();
			_dataToFetch = false;
			addCommand("findKeyFamily", new FindKeyFamily(_keyFamilies, 
				event.data), FindKeyFamily.FOUND_KEY_FAMILY, 
				handleFoundKeyFamily);
			(_commands["findKeyFamily"] as ICommand).execute();
			event = null;	 
		}
		
		private function handleFoundKeyFamily(event:SDMXDataEvent):void
		{
			event.stopImmediatePropagation();
			if (null != event.data) {
				_keyFamily = (event.data) as KeyFamily;
				(_commands["processData"] as ProcessDataFile).keyFamily = 
					_keyFamily; 
				(_commands["processData"] as ICommand).execute();				
			} else {
				//TODO: fetch the structure file from the keyFamilyURI
				dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
					false, false, "Could not find a key family to interpret" + 
					" the data"));
			}
			event = null;
		}
		
		private function handleData(event:SDMXDataEvent):void
		{
			event.stopImmediatePropagation();
			dispatchEvent(new SDMXDataEvent(event.data, DATA_LOADED));
			dispatchEvent(new Event(COMMAND_COMPLETED));
			event = null;
		}	
		
		private function createProcessDataCmd():void
		{
			addCommand("processData", new ProcessDataFile(), 
				ProcessDataFile.DATA_PROCESSED, handleData);
		}
	}
}