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
package org.sdmx.stores.xml.v2
{
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	
	/**
	 * This command guesses in which of the 4 SDMX-ML Data formats the supplied
	 * XML file is.
	 * 
	 * @author Xavier Sosnovsky
	 */  
	public class GuessDataType
	{		
		/*==========================Public methods============================*/
		
		/**
		 * Guesses the SDMX-ML Data format of the supplied data file. 
		 * 
		 * @param file The supplied data file. 
		 */
		public static function guessFormat(file:XML):String
		{
			var format:String;
			if ("MessageGroup" == file.localName()) {
				if (file.children().length() < 3 && ((file.children() as 
					XMLList))[1].children().length() > 0 && "KeyFamilyRef" == 
					((((file.children())[1] as XML).children())[0] as 
					XML).localName()) {
					format = SDMXDataFormats.SDMX_ML_GENERIC;
				} else if (file.children().length() < 3 && 
					file..*::Key.length() > 0) {
					format = SDMXDataFormats.SDMX_ML_UTILITY;
				} else if (file.children().length() < 3 &&
					file..*::Series.length() > 0) {
					format = SDMXDataFormats.SDMX_ML_COMPACT;
				}
			} else if ("CompactData" == file.localName()) {
				format = SDMXDataFormats.SDMX_ML_COMPACT;
			} else if ("GenericData" == file.localName()) {
				format = SDMXDataFormats.SDMX_ML_GENERIC;
			} else if ("UtilityData" == file.localName()) {
				format = SDMXDataFormats.SDMX_ML_UTILITY;
			} else if ("GenericTimeSeriesData" == file.localName()) {
				format = SDMXDataFormats.SDMX_ML_GENERIC;
			} else if ("StructureSpecificTimeSeriesData" == file.localName()) {
				format = SDMXDataFormats.SDMX_ML_COMPACT;
			} else if ("StructureSpecificData" == file.localName()) {
				format = SDMXDataFormats.SDMX_ML_COMPACT;
			} 
			return format; 
		}
	}
}