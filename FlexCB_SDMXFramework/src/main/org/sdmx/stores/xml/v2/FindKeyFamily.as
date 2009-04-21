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
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	
	/**
	 * Event dispatched when the proper key family has been found.
	 * 
	 * @eventType eu.ecb.core.command.sdmx.FindKeyFamily.FOUND_KEY_FAMILY
	 */
	[Event(name="foundKeyFamily", type="org.sdmx.event.SDMXDataEvent")]

	/**
	 * This command finds the key family for the supplied data.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class FindKeyFamily
	{				
		/*===========================Constructor==============================*/
		
		public function FindKeyFamily()
		{
			super();
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Retreives the appropriate key family to interpret the data available 
		 * in the supplied XML file.
		 *   
		 * @param file The supplied XML data file
		 * @param keyFamilies The collection of available key families
		 * 
		 */
		public static function find(file:XML, keyFamilies:KeyFamilies):KeyFamily
		{
			var kf:KeyFamily;
			if (1 == keyFamilies.length) {
				kf = keyFamilies.getItemAt(0) as KeyFamily;
			} else {
				var dataSetNS:String = String((file.children()[1] 
					as XML).namespace());
				kf = keyFamilies.getKeyFamilyByURN(dataSetNS);
				if (null == kf && file..*::KeyFamilyRef.length() > 0) {
					var kfId:String = file..*::KeyFamilyRef[0];
					kf = keyFamilies.getKeyFamilyByID(kfId, "");
				}				
			}
			return kf;
		}
	}
}