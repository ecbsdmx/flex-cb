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
	import mx.collections.ArrayCollection;
	import flash.utils.getQualifiedClassName;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.IViewCursor;
	import org.sdmx.model.v2.base.item.Item;
	import mx.collections.CursorBookmark;

	/**
	 * A collection of codes. It extends the AS3 ArrayCollection
	 * and simply restrict the items type to Code.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class CodesCollection extends ArrayCollection {
		
		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only codes are " + 
				"allowed in a codes collection. Got: ";
				
		private var _codeValueLength:uint;		
		
		private var _cursor:IViewCursor;	
		
		private var _firstItem:CursorBookmark;	
				
		/*===========================Constructor==============================*/
		
		public function CodesCollection(source:Array = null) {
			super(source);
		}
		
		/*============================Accessors===============================*/
		
		/**
	     * The maximum allowed length of a code in the code list.
	     */
		public function get codeValueLength():uint {
			return _codeValueLength;
		}
		
		/**
	     * @private
	     */
		public function set codeValueLength(codeValueLength:uint):void {
			if (null == _cursor) {
				createCodeCursor();
			}
			_cursor.seek(_firstItem);
			while(!_cursor.afterLast) {
				if (codeValueLength < (_cursor.current as Code).id.length) {
					throw new ArgumentError("Some code values are longer than" + 
							" the desired code value length. Shorten them " + 
							"first.");
				}
				_cursor.moveNext();
      		}
			_codeValueLength = codeValueLength;
		}
		
		
		/*==========================Public methods============================*/
				
		/**
		 * Returns the code identified by the supplied string.
		 *  
		 * @param id The code identifier
		 * @return The codeidentified by the supplied string, if any.
		 */
		public function getCode(id:String):Code {
			if (null == _cursor) {
				createCodeCursor();
			}
			return findById(id);
		}
		
		/*=========================Private methods============================*/
		
		private function findById(id:String):Code {
			return (_cursor.findAny({id:id})) ? _cursor.current as Code : null;
		}
		
		private function createCodeCursor():void
		{
			_cursor = createCursor();
			_firstItem = _cursor.bookmark;
			var sortById:Sort = new Sort();
            sortById.fields = [new SortField("id", true)];
            sort = sortById;
            refresh();
		}
	}
}