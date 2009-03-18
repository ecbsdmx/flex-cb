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
	
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	
	/**
	 * Event dispatched when the format of the supplied XML file has been 
	 * guessed.
	 * 
	 * @eventType eu.ecb.core.command.sdmx.GuessDataType.TYPE_GUESSED
	 */
	[Event(name="typeGuessed", type="flash.events.DataEvent")]

	/**
	 * This command guesses in which of the 4 SDMX-ML Data formats the supplied
	 * XML file is.
	 * 
	 * @author Xavier Sosnovsky
	 */  
	public class GuessDataType extends CommandAdapter
	{
		/*=============================Constants==============================*/
		
		/**
		 * The GuessDataType.TYPE_GUESSED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>typeGuessed</code> event.
		 * 
		 * @eventType typeGuessed
		 */  
		public static const TYPE_GUESSED:String = "typeGuessed";
		
		/**
		 * Type of the reader of SDMX-ML Compact Data files
		 */
		public static const SDMX_ML_Compact:String = "compact";
		
		/**
		 * Type of the reader of SDMX-ML Utility Data files
		 */
		public static const SDMX_ML_Utility:String = "utility";
		
		/**
		 * Type of the reader of SDMX-ML Generic Data files
		 */
		public static const SDMX_ML_Generic:String = "generic";
		
		/*==============================Fields================================*/
		
		private var _dataFile:XML;
		
		/*===========================Constructor==============================*/
		
		public function GuessDataType(dataFile:XML)
		{
			super();
			_dataFile = dataFile;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function execute():void
		{
			if ("CompactData" == _dataFile.localName()) {
				dispatchEvent(new DataEvent(TYPE_GUESSED, false, false, 
					SDMX_ML_Compact));
			} else if ("GenericData" == _dataFile.localName()) {
				dispatchEvent(new DataEvent(TYPE_GUESSED, false, false, 
					SDMX_ML_Generic));
			} else if ("UtilityData" == _dataFile.localName()) {
				dispatchEvent(new DataEvent(TYPE_GUESSED, false, false, 
					SDMX_ML_Utility));
			} else if ("MessageGroup" == _dataFile.localName()) {
				if (_dataFile.children().length() != 2) {
					dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
						false, false, "Only files containing one header" + 
						" and one DataSet are currently supported"));
				} else if ("KeyFamilyRef" == ((((_dataFile.children())[1] as 
					XML).children())[0] as XML).localName()) {
					dispatchEvent(new DataEvent(TYPE_GUESSED, false, false, 
						SDMX_ML_Generic));
				} else if (_dataFile..*::Key.length() > 0) {
					dispatchEvent(new DataEvent(TYPE_GUESSED, false, false, 
						SDMX_ML_Utility));
				} else if (_dataFile..*::Series.length() > 0) {
					dispatchEvent(new DataEvent(TYPE_GUESSED, false, false, 
						SDMX_ML_Compact));
				} else {
					dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
						false, false, "The format of the supplied data" + 
						" file could not be guessed"));
				}
			} else {
				dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
					false, false, "The format of the supplied data file" + 
					" could not be guessed"));
			}
		}
	}
}