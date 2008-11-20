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
	import org.sdmx.model.v2.base.structure.ComponentList;
	import mx.collections.IViewCursor;
	import mx.collections.CursorBookmark;
	import flash.utils.getQualifiedClassName;

	/**
	 * A set metadata concepts that define a partial key derived from the Key
	 * Descriptor in a Key Family. It extends the AS3 ArrayCollection
	 * and simply restrict the items type to Dimension.
	 * 
	 * @author Xavier Sosnovsky 
	 * 
	 * @see Dimension
	 * 
	 * @todo 
	 * 	- AttachmentConstraint
	 */ 
	public class GroupKeyDescriptor extends ComponentList {	
		
		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only dimensions are " + 
				"allowed in a GroupDescriptor. Got: ";
				
		private var _cursor:IViewCursor;	
		
		private var _firstItem:CursorBookmark;
		
		/*===========================Constructor==============================*/
		
		public function GroupKeyDescriptor(id:String) {
			super(id);
			_cursor = createCursor();
			_firstItem = _cursor.bookmark;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The group key for the descriptor (for example: U2.N.000000.4.ANR) 
		 */
		public function get groupKey():String {
			var key:String = "";
			_cursor.seek(_firstItem);
			while(!_cursor.afterLast) {
				key = key 
					+ (_cursor.current as Dimension).conceptIdentity.id;
				var notLast:Boolean = _cursor.moveNext();
				if (notLast) {
					key = key + ".";
				}
      		}
			return key;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @private
		 */ 
		public override function addItemAt(item:Object, index:int):void {
			if (!(item is Dimension)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				super.addItemAt(item, index);
			}
		}
		
		/**
		 * @private
		 */
		public override function setItemAt(item:Object, index:int):Object {
			if (!(item is Dimension)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				return super.setItemAt(item, index);
			}
		}
		
		/**
		 * Whether the descriptor contains the supplied dimension 
		 * @param dimension The dimension to be searched in the descriptor
		 * @return true if the descriptor contains the supplied dimension, false
		 * otherwise
		 */
		public function containsDimension(dimension:String):Boolean
		{
			var containDimension:Boolean = false;
			_cursor.seek(_firstItem);
			while(!_cursor.afterLast) {
				if (dimension == (_cursor.current as Dimension).
					conceptIdentity.id) {
					containDimension = true;
					break;	
				}
				_cursor.moveNext();
      		}
      		return containDimension;
		}
	}
}