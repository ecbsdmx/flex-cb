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
	import flash.utils.getQualifiedClassName;
	
	import org.sdmx.model.v2.base.structure.ComponentList;


	/**
	 * A set of metadata concepts that define the attributes of a key family.
	 * It extends the AS3 ArrayCollection and simply restrict the items type to 
	 * DataAttribute.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see DataAttribute
	 */ 
	public class AttributeDescriptor extends ComponentList {
		
		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only data attributes are " + 
				"allowed in an AttributeDescriptor. Got: ";	
		private var _attributes:Array;		
		
		/*===========================Constructor==============================*/
		
		public function AttributeDescriptor(id:String = "Attributes") {
			super(id);
			_attributes = new Array();
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @private 
		 */
		public override function addItemAt(item:Object, index:int):void {
			if (!(item is DataAttribute)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				_attributes[(item as DataAttribute).conceptIdentity.id] = item;
				super.addItemAt(item, index);
			}
		}
		
		/**
		 * @private 
		 */
		public override function setItemAt(item:Object, index:int):Object {
			if (!(item is DataAttribute)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				_attributes[(item as DataAttribute).conceptIdentity.id] = item;
				return super.setItemAt(item, index);
			}
		}
		
		/**
		 * Gets the data attribute identified by the supplied id
		 * 
		 * @param conceptId The identifier for the data attribute to be returned
		 * 
		 * @return The data attribute identified by the supplied id
		 */
		public function getAttribute(id:String):DataAttribute {
      		return (null != _attributes[id]) ? _attributes[id] : null;
		}
	}
}