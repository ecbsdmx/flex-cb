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
package org.sdmx.model.v2.structure.organisation
{
	import org.sdmx.model.v2.base.InternationalString;
	import mx.collections.ArrayCollection;
	import org.sdmx.model.v2.base.SDMXArtefact;
	
	/**
	 * Contact information of a person within an organisation, responsible for
	 * certain aspects of a statistical process (e.g.: a data provider).
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see Organisation
	 */ 
	public class Contact implements SDMXArtefact {
		
		/*==============================Fields================================*/
		
		private var _id:String;
		
		private var _name:InternationalString;
		
		private var _department:InternationalString;
		
		private var _role:InternationalString;
		
		private var _contactDetails:Array;
		
		/*============================Constants===============================*/
		
		/**
		 * The contact information provided is a telephone number 
		 */
		public static const TELEPHONE:uint = 1;
		
		/**
		 * The contact information provided is a fax number 
		 */
		public static const FAX:uint = 2;
		
		/**
		 * The contact information provided is an email address 
		 */
		public static const EMAIL:uint = 3;
		
		/**
		 * The contact information provided is X400 address  
		 */
		public static const X400:uint = 4;
		
		/**
		 * The contact information provided is a URI (usually a URL)   
		 */
		public static const URI:uint = 5;
		
		/*===========================Constructor==============================*/
		
		public function Contact() {
			super();
			_contactDetails = new Array(null, null, null, null, null);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * A unique identifier for the contact 
		 */
		public function get id():String {
			return _id;
		}
		
		/**
	 	 * @private 
	 	 */
		public function set id(id:String):void {
			_id = id;
		}
		
		/**
		 * The contact name 
		 */
		public function get name():InternationalString {
			return _name;
		}
		
		/**
	 	 * @private 
	 	 */
		public function set name(name:InternationalString):void {
			_name = name;
		}
		
		/**
		 * The organisational structure within which the contact person works 
		 */
		public function get department():InternationalString {
			return _department;
		}
		
		/**
	 	 * @private 
	 	 */
		public function set department(department:InternationalString):void {
			_department = department;
		}
		
		/**
		 * The responsibility of the contact person 
		 */
		public function get role():InternationalString {
			return _role;
		}
		
		/**
	 	 * @private 
	 	 */
		public function set role(role:InternationalString):void {
			_role = role;
		}
		
		/**
		 *  The contact details of the contact person
		 */
		public function get contactDetails():Array {
			return _contactDetails;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Add contact information for the contact person.
		 *  
		 * @param type The type of contact information. Must be one of the 
		 * following:
		 * <ul>
		 * 	<li>1: Telephone</li>
		 *  <li>2: Fax</li>
		 *  <li>3: Email</li>
		 *  <li>4: X400</li>
		 *  <li>5: URI</li>
		 * </ul>
		 * @param details The contact details information (for example, the 
		 * phone number or the email address)
		 */
		public function addContactDetails(type:uint, details:String):void {
			if (type < 1 || type > 5) {
				throw new ArgumentError(type + " is not one of the acceptable " 
						+ "contact types.");
			}
			var collection:ArrayCollection = new ArrayCollection();
			if (undefined == _contactDetails[type]) {
				collection.addItem(details);
				_contactDetails[type] = collection;
			} else if (!(_contactDetails[type] as ArrayCollection).contains(
				details)) {
				collection = _contactDetails[type] as ArrayCollection;
				collection.addItem(details);
				_contactDetails[type] = collection;
			}
		}		
	}
}