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
	 * An ordered set of metadata concepts that, combined, classify a
	 * statistical series, such as a time series, and whose values, when 
	 * combined (the key) in an instance such as a data set, uniquely identify a
	 * specific series.
	 * 
	 * @author Xavier Sosnovsky 
	 */ 
	public class KeyDescriptor extends ComponentList {	
		
		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only dimensions are " + 
				"allowed in a KeyDescriptor. Got: ";
				
		private var _dimensions:Array;			
		
		/*===========================Constructor==============================*/
			
		public function KeyDescriptor(id:String = "Dimensions") {
			super(id);
			_dimensions = new Array();
		}
		
		/*==========================Public methods============================*/
		
		public override function addItemAt(item:Object, index:int):void {
			if (!(item is Dimension)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				_dimensions[(item as Dimension).conceptIdentity.id] = item;
				super.addItemAt(item, index);
			}
		}
		
		public override function setItemAt(item:Object, index:int):Object {
			if (!(item is Dimension)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				_dimensions[(item as Dimension).conceptIdentity.id] = item;
				return super.setItemAt(item, index);
			}
		}
		
		public function getDimension(conceptId:String):Dimension {
      		return (null != _dimensions[conceptId]) ? 
      			_dimensions[conceptId] : null;
		}
	}
}