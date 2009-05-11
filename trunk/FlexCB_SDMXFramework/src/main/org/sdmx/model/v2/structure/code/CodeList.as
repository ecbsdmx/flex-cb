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
	import org.sdmx.model.v2.base.item.ItemScheme;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import mx.collections.IViewCursor;

	/**
	 * A list from which some statistical concepts (coded concepts) take
	 * their values. For example, a concept such as frequency (FREQ) could take 
	 * its values from a code list named CL_FREQ, which would contains codes 
	 * such as A, Q and M for annual, quarterly and monthly frequency 
	 * respectively.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class CodeList extends ItemScheme {
		
		/*==============================Fields================================*/
		
		private var _codes:CodesCollection;
		
		/*===========================Constructor==============================*/
		
		public function CodeList(id:String, name:InternationalString, 
			maintenanceAgency:MaintenanceAgency) {
			super(id, name, maintenanceAgency);
			_codes = new CodesCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
	     * @private
	     */
		public function set codes(codes:CodesCollection):void {
			_codes = codes;
		}
		
		/**
		 * The codes included in the code list 
		 */
		public function get codes():CodesCollection {
			return _codes;
		}
	}
}