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
package org.sdmx.model.v2.reporting.provisioning
{
	import org.sdmx.model.v2.base.structure.Component;
	import mx.collections.ArrayCollection;
	
	/**
	 * A set of permissible values for one of the component of the axis.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class MemberSelection {
		
		/*==============================Fields================================*/
		
		private var _isIncluded:Boolean;
		
		private var _structureComponent:Component;
		
		private var _values:ArrayCollection;
		
		/*===========================Constructor==============================*/
		
		public function MemberSelection() {
			super();
			_values = new ArrayCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set isIncluded(isIncluded:Boolean):void {
			_isIncluded = isIncluded;
		}
		
		/**
		 * Indicates whether the Member Selection is included in the constraint
		 * definition or excluded.
		 */
		public function get isIncluded():Boolean {
			return _isIncluded;
		}
		
		/**
		 * @private
		 */
		public function set structureComponent(
			structureComponent:Component):void {
			_structureComponent = structureComponent;
		}
		
		/**
		 * Association to the Component in the Structure to which the 
		 * ConstrainableArtefact is linked, which defines the valid
		 * representation for the member values.
		 */
		public function get structureComponent():Component {
			return _structureComponent;
		}
		
		/**
		 * @private
		 */
		public function set values(values:ArrayCollection):void {
			_values = values;
		}
		
		/**
		 * The list of values.
		 */
		public function get values():ArrayCollection {
			return _values;
		}
	}
}