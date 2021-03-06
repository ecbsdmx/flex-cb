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
	/**
	 * The value of an attribute, such as the instance of a Coded Attribute or
	 * of an Uncoded Attribute in a structure such as a Key Family.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class AttributeValue {
		
		/*==============================Fields================================*/
		
		private var _attachesTo:AttachableArtefact;
		
		/*===========================Constructor==============================*/
		
		public function AttributeValue(attachmentTarget:AttachableArtefact) {
			super();
			attachesTo = attachmentTarget;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set attachesTo(
			attachmentTarget:AttachableArtefact):void {
			if (null == attachmentTarget) {
				throw new ArgumentError("The attachment target cannot be null");	
			} else {
				_attachesTo = attachmentTarget;
			}
		}
		
		/**
		 * Associates the attribute to the object to which it is attached.
		 */
		public function get attachesTo():AttachableArtefact {
			return _attachesTo;
		}
	}
}