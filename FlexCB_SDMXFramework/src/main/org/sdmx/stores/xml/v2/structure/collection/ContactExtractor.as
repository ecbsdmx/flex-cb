// ECB/SIS Public License, version 1.0, document reference SIS/2001/116
//
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
package org.sdmx.stores.xml.v2.structure.collection
{
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.structure.organisation.Contact;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;
	import org.sdmx.stores.xml.v2.structure.ExtractorPool;
	import org.sdmx.stores.xml.v2.structure.base.InternationalStringExtractor;

	/**
	 * Extracts Contacts information schemes out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class ContactExtractor implements ISDMXExtractor
	{
		
		/*==============================Fields================================*/
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		/*===========================Constructor==============================*/
		
		public function ContactExtractor() {
			super();
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact {
			var contact:Contact = new Contact();
			var nameElement:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"Name");		
			var isExtractor:InternationalStringExtractor = 
				ExtractorPool.getInstance().internationalStringExtractor;
			if (items.child(nameElement).length() > 0) {	
				var name:InternationalString = isExtractor.extract(
					items.child(nameElement)) as InternationalString;			
				contact.name = name;
			}
			var idElement:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"id");
			if (items.child(idElement).length() > 0) {	
				contact.id = items.id;
			}	
			var dptElement:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"Department");
			if (items.child(dptElement).length() > 0) {	
				var dpt:InternationalString = isExtractor.extract(
					items.child(dptElement)) as InternationalString;			
				contact.department = dpt;
			}
			var roleElement:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"Role");
			if (items.child(roleElement).length() > 0) {	
				var role:InternationalString = isExtractor.extract(
					items.child(roleElement)) as InternationalString;			
				contact.role = role;
			}
			for each (var phone:XML in items.Telephone) {
				contact.addContactDetails(Contact.TELEPHONE, phone);
			}
			for each (var fax:XML in items.Fax) {
				contact.addContactDetails(Contact.FAX, fax);
			}
			for each (var x400:XML in items.X400) {
				contact.addContactDetails(Contact.X400, x400);
			}
			for each (var uri:XML in items.URI) {
				contact.addContactDetails(Contact.URI, uri);
			}
			for each (var email:XML in items.Email) {
				contact.addContactDetails(Contact.EMAIL, email);
			}
			return contact;
		}
	}
}