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
	import org.sdmx.model.v2.base.structure.Attribute;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.base.type.AttachmentLevel;

	/**
	 * A characteristic of an object or entity.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class DataAttribute extends Attribute {
		
		/*==============================Fields================================*/
		
		private var _attachmentLevel:String;
		
		private var _attachmentGroup:GroupKeyDescriptor;
		
		/*===========================Constructor==============================*/
		
		public function DataAttribute(identifier:String, 
			conceptIdentity:Concept) {
			super(identifier, conceptIdentity);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set attachmentLevel(attachmentLevel:String):void {
			if (!AttachmentLevel.contains(attachmentLevel)) {
				throw new TypeError(attachmentLevel + 
					" is not a valid SDMX attachment level");
			} else {
				_attachmentLevel = attachmentLevel;
			}
		}
		
		/**
		 * The attachment level of the attribute
		 * 
		 * @see org.sdmx.model.v2.base.type.AttachmentLevel
		 */ 
		public function get attachmentLevel():String {
			return _attachmentLevel;
		}
		
		/**
		 * @private 
		 */ 
		public function set attachmentGroup(
			attachmentGroup:GroupKeyDescriptor):void {
			if (_attachmentLevel != AttachmentLevel.GROUP) {
				throw new ArgumentError("Cannot attach group to data attribute" 
					+ " when attachement level is " + _attachmentLevel);
			} else {
				_attachmentGroup = attachmentGroup;
			}
		}
		
		/**
		 * The group to which the attribute is attached, if group is the
		 * attachment level
		 */ 
		public function get attachmentGroup():GroupKeyDescriptor {
			return _attachmentGroup;
		}
	}
}