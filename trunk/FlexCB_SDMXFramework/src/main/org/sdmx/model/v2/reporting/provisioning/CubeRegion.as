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
	import mx.collections.ArrayCollection;

	/**
	 * A set of Components and their values that defines a sub set or "slice" of 
	 * the total range of possible content of the Structure to which the 
	 * Constrainable Artefact is linked.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class CubeRegion {
		
		/*==============================Fields================================*/
		
		private var _isIncluded:Boolean;
		
		private var _members:MemberSelectionsCollection;

		/*===========================Constructor==============================*/
		
		public function CubeRegion() {
			super();
			_members = new MemberSelectionsCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set isIncluded(isIncluded:Boolean):void {
			_isIncluded = isIncluded;
		}
		
		/**
		 * Indicates whether the CubeRegion is included in the constraint
		 * definition or excluded.
		 */ 
		public function get isIncluded():Boolean {
			return _isIncluded;
		}
		
		/**
		 * @private
		 */
		public function set members(members:MemberSelectionsCollection):void {
			_members = members;
		}
		
		/**
		 * Associates the set of components that define the subset of values.
		 */ 
		public function get members():MemberSelectionsCollection {
			return _members;
		}
	}
}