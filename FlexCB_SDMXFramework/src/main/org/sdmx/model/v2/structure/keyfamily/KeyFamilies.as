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
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import org.sdmx.model.v2.base.SDMXArtefact;

	/**
	 * A collection of key families. It extends the AS3 ArrayCollection
	 * and simply restrict the items type to KeyFamily.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see KeyFamily
	 * 
	 * @todo
	 * 	Guarantee uniqueness constraints for each of the key family IDs
	 */ 
	public class KeyFamilies extends ArrayCollection implements SDMXArtefact {
		
		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only key families " + 
				"are allowed in an collection of key families. Got: ";
		
		private var _id:String;
		
		/*===========================Constructor==============================*/

		public function KeyFamilies(id:String = "Key families", 
			source:Array=null) {
			super(source);
			_id = id;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The identifier for the collection of key families
		 * 
		 * @default Key families
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
		
		/*==========================Public methods============================*/
		
		/**
		 * @private
		 */
		public override function addItemAt(item:Object, index:int):void {
			if (!(item is KeyFamily)) {
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
			if (!(item is KeyFamily)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				return super.setItemAt(item, index);
			}
		}
		
		/**
		 * Returns the key family identified by the supplied URN 
		 * 
		 * @param keyFamilyURN The URN identifiying the key family
		 * @return The key family identified by the supplied URN
		 */
		public function getKeyFamilyByURN(keyFamilyURN:String):KeyFamily {
			var sortByURN:Sort = new Sort();
            sortByURN.fields = [new SortField("urn", true)];
            sort = sortByURN;
			refresh();
            var cursor:IViewCursor = createCursor();
			var found:Boolean = cursor.findAny({urn:keyFamilyURN});
			if (found && (cursor.current as KeyFamily).urn == keyFamilyURN) {
				return cursor.current as KeyFamily;
			} else {
				return null;
			}
		}
		
		/**
		 * Returns the key family identified by the supplied URI 
		 * 
		 * @param keyFamilyURI The URI identifiying the key family
		 * @return The key family identified by the supplied URI
		 */
		public function getKeyFamilyByURI(keyFamilyURI:String):KeyFamily {
			var sortByURI:Sort = new Sort();
            sortByURI.fields = [new SortField("uri", true)];
            sort = sortByURI;
			refresh();
            var cursor:IViewCursor = createCursor();
			var found:Boolean = cursor.findAny({uri:keyFamilyURI});
			if (found && (cursor.current as KeyFamily).uri == keyFamilyURI) {
				return cursor.current as KeyFamily;
			} else {
				return null;
			}
		}
		
		/**
		 * Returns the key family identified by the supplied id and maintained
		 * by the supplied maintenance agency 
		 * 
		 * @param keyFamilyID The URI identifiying the key family
		 * @param keyFamilyAgency The agency maintaining the key family 
		 * 	definition
		 * @return The key family identified by the supplied id and maintained
		 * by the supplied maintenance agency
		 */
		public function getKeyFamilyByID(keyFamilyID:String, 
			keyFamilyAgency:String = null, 
			versionNumber:String = null):KeyFamily {
			refresh();	
			var cursor:IViewCursor = createCursor();
			var keyFamily:KeyFamily = null;
			while(!cursor.afterLast) {
				if ((cursor.current as KeyFamily).id == keyFamilyID && 
					((cursor.current as KeyFamily).maintainer.id == 
					keyFamilyAgency || keyFamilyAgency == null || 
					keyFamilyAgency == "") && ((cursor.current as KeyFamily).
					version == versionNumber || versionNumber == null || 
					versionNumber == "")) {
					keyFamily = cursor.current as KeyFamily;
					break;	
				}
				cursor.moveNext();
			}
			return keyFamily;
		}
	}
}