// Copyright (C) 2010 European Central Bank. All rights reserved.
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
package org.sdmx.model.v2.structure.hierarchy
{
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;

	/**
	 * A collection of concepts. It extends the AS3 ArrayCollection and simply 
	 * restrict the items type to CodeAssociation.
	 * 
	 * WARNING: This is based on the draft version of SDMX 2.1. Until the
	 * proposal has been endorsed, the information model is still subject to
	 * changes.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class CodeAssociationsCollection extends ArrayCollection
	{
		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only code associations are " + 
			"allowed in a code associations collection. Got: ";	
				
		/*===========================Constructor==============================*/		
				
		public function CodeAssociationsCollection(source:Array=null)
		{
			super(source);
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc 
		 */
		public override function addItemAt(item:Object, index:int):void {
			if (!(item is CodeAssociation)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			}
			super.addItemAt(item, index);
		}
		
		/**
		 * @inheritDoc 
		 */
		public override function setItemAt(item:Object, index:int):Object {
			if (!(item is CodeAssociation)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				return super.setItemAt(item, index);
			}
		}
	}
}