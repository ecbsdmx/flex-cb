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
package org.sdmx.model.v2.structure.code
{
	import mx.collections.IViewCursor;
	import mx.collections.ArrayCollection;
	import flash.utils.getQualifiedClassName;
	import org.sdmx.model.v2.base.SDMXArtefact;

	/**
	 * A collection of code lists. It extends the AS3 ArrayCollection
	 * and simply restrict the items type to Code.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class CodeLists extends ArrayCollection implements SDMXArtefact {
		
		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only code lists are " + 
				"allowed in a code lists collection. Got: ";
		
		private var _id:String;
		
		/*===========================Constructor==============================*/
		
		public function CodeLists(id:String = "Code lists", source:Array = null) 
		{
			super(source);
			_id = id;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The identifier for the code lists collection
		 * 
		 * @default Code lists
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
			if (!(item is CodeList)) {
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
			if (!(item is CodeList)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				return super.setItemAt(item, index);
			}
		}
		
		/**
		 * Returns the code list identified with the supplied id, corresponding
		 * to the supplied version and maintained by the supplied agency.
		 * 
		 * @param codeListId The identifier for the code list
		 * @param codeListVersion The version of the code list
		 * @param codeListAgencyId The agency maintaining the code list
		 * 
		 * @return The corresponding code list.] 
		 */
		public function getCodeList(codeListId:String, 
			codeListVersion:String = null, 
			codeListAgencyId:String = null):CodeList {
			if (null == codeListId || 0 == codeListId.length) {
				throw new ArgumentError("The code list id is mandatory");
			}
			refresh();	
            var cursor:IViewCursor = createCursor();
            var returnedValue:CodeList = null;
            while (!cursor.afterLast) {
            	var codeList:CodeList = cursor.current as CodeList;
            	if (codeList.id == codeListId && 
            		(codeListVersion == null || codeListVersion.length == 0 || 
            		 codeList.version == codeListVersion) &&
            		(codeListAgencyId == null || codeListAgencyId.length == 0 || 
            		 codeList.maintainer.id == codeListAgencyId)) {
            		returnedValue = codeList;
            		break;		
				}
            	cursor.moveNext();
            }
			return returnedValue;
		}
	}
}