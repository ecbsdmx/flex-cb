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
package org.sdmx.model.v2.structure.keyfamily
{
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.structure.Structure;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	/**
	 * A collection of metadata concepts, their structure and usage when used to
	 * collect or disseminate data.
	 * 
	 * @author Xavier Sosnovsky 
	 */ 
	public class KeyFamily extends Structure {
		
		/*==============================Fields================================*/
		
		private var _keyDescriptor:KeyDescriptor;
		
		private var _measureDescriptor:MeasureDescriptor;
		
		private var _attributeDescriptor:AttributeDescriptor;
		
		private var _groupDescriptors:GroupKeyDescriptorsCollection;
		
		private var _isKeyFamilyReference:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function KeyFamily(id:String, name:InternationalString, 
			maintenanceAgency:MaintenanceAgency, keyDescriptor:KeyDescriptor,
			measureDescriptor:MeasureDescriptor, reference:Boolean = false) {
			super(id, name, maintenanceAgency);
			_isKeyFamilyReference = reference;
			this.keyDescriptor = keyDescriptor;
			this.measureDescriptor = measureDescriptor;
			_groupDescriptors = new GroupKeyDescriptorsCollection();
		}	
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set keyDescriptor(keyDescriptor:KeyDescriptor):void {
			if (!_isKeyFamilyReference) {
				if (null == keyDescriptor){
					throw new ArgumentError("The key descriptor cannot be " + 
							"null");
				} else if (0 == keyDescriptor.length) {
					throw new ArgumentError("The key descriptor cannot be " + 
							"empty");
				}
			}
			_keyDescriptor = keyDescriptor;
		}
		
		/**
		 * The list of dimensions defined in the key family
		 */ 
		public function get keyDescriptor():KeyDescriptor {
			return _keyDescriptor;
		}
		
		/**
		 * @private
		 */
		public function set measureDescriptor(
			measureDescriptor:MeasureDescriptor):void {
			if (!_isKeyFamilyReference) {	
				if (null == measureDescriptor){
					throw new ArgumentError("The measure descriptor " + 
							"cannot be null");
				} else if (0 == measureDescriptor.length) {
					throw new ArgumentError("The measure descriptor " + 
							"cannot be empty");
				}
			}
			_measureDescriptor = measureDescriptor;
		}
		
		/**
		 * The list of measures defined in the key family
		 */ 
		public function get measureDescriptor():MeasureDescriptor {
			return _measureDescriptor;
		}
		
		/**
		 * @private
		 */
		public function set attributeDescriptor(
			attributeDescriptor:AttributeDescriptor):void {
			_attributeDescriptor = attributeDescriptor;
		}
		
		/**
		 * The list of attributes defined in the key family
		 */ 
		public function get attributeDescriptor():AttributeDescriptor {
			return _attributeDescriptor;
		}
		
		/**
		 * @private
		 */
		public function set groupDescriptors(
			groupDescriptors:GroupKeyDescriptorsCollection):void {
			_groupDescriptors = groupDescriptors;
		}
		
		/**
		 * The list of groups defined in the key family
		 */ 
		public function get groupDescriptors():GroupKeyDescriptorsCollection {
			return _groupDescriptors;
		}
	}
}