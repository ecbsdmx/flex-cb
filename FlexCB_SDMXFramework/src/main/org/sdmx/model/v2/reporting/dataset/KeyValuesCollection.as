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
package org.sdmx.model.v2.reporting.dataset
{
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;

	/**
	 * A collection of keys values. It extends the AS3 ArrayCollection
	 * and simply restrict the items type to KeyValue.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see KeyValue
	 */
	public class KeyValuesCollection extends ArrayCollection {

		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only group keys are " + 
				"allowed in a group keys collection. Got: ";
		private var _seriesKey:String = "";		

		/*===========================Constructor==============================*/
		
		public function KeyValuesCollection(source:Array=null) {
			super(source);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The series key representing the combination of key values included
		 * in the collection 
		 */
		public function get seriesKey():String {
			if (_seriesKey == "") {
				for (var i:uint = 0; i < length; i++) {
					_seriesKey = _seriesKey + "." + 
						(getItemAt(i) as KeyValue).value.id;
				}
				_seriesKey =  _seriesKey.substr(1, _seriesKey.length);
			}	
			return _seriesKey;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @private
		 */
		public override function addItemAt(item:Object, index:int):void {
			if (!(item is KeyValue)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				super.addItemAt(item, index);
				_seriesKey = "";
			}
		}
		
		/**
		 * @private
		 */
		public override function setItemAt(item:Object, index:int):Object {
			if (!(item is KeyValue)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				var returnedObject:Object = super.setItemAt(item, index);
				return returnedObject;
				_seriesKey = "";
			}
		}
		
		/**
		 * @private
		 */
		public override function removeAll():void {
			super.removeAll();
			_seriesKey = "";
		}
		
		/**
		 * @private
		 */
		public override function removeItemAt(index:int):Object {
			_seriesKey = "";
			return super.removeItemAt(index);
		}
	}
}