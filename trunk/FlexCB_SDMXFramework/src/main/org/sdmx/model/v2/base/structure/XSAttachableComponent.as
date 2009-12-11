// Copyright (C) 2009 European Central Bank. All rights reserved.
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
package org.sdmx.model.v2.base.structure
{
	import org.sdmx.model.v2.base.type.XSAttachmentLevel;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * Specifies, in cross-sectional key families, to which level (DataSet,
	 * Group, Section, XSObservation) the dimensions and attributes should be 
	 * attached.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see ComponentList
	 * @see org.sdmx.model.v2.base.type.XSAttachmentLevel
	 */
	public class XSAttachableComponent extends Component
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 
		protected var _xsAttachmentLevel:String;
		
		/*===========================Constructor==============================*/
		
		public function XSAttachableComponent(identifier:String, 
			concept:Concept)
		{
			super(identifier, concept);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set xsAttachmentLevel(level:String):void
		{
			if (!(XSAttachmentLevel.contains(level))) {
				throw new ArgumentError(level + " not in the list of allowed" + 
					"cross-sectional attachment levels");
			}
			_xsAttachmentLevel = level;
		}
		
		/**
		 * The cross-sectional attachement level of the component
		 */ 
		public function get xsAttachmentLevel():String
		{
			return _xsAttachmentLevel;
		}
	}
}