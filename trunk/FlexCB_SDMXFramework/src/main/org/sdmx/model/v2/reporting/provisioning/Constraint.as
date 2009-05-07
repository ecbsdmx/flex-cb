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
	import org.sdmx.model.v2.base.IdentifiableArtefactAdapter;

	/**
	 * Specifies a sub set of the definition of the allowable content of a data 
	 * or metadata set in terms of the content or, for data only, in terms of 
	 * the set of key combinations to which specific attributes (as defined by 
	 * the Structure) may be attached.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class Constraint extends IdentifiableArtefactAdapter {
		
		/*==============================Fields================================*/
		
		private var _calendar:ReleaseCalendar;
		
		private var _availableDates:ReferencePeriod;
		
		private var _permittedContentKeys:KeySet;
		
		private var _permittedContentRegion:CubeRegionsCollection;
		
		/*===========================Constructor==============================*/
		
		public function Constraint(identifier:String) {
			super(identifier);
			_permittedContentRegion = new CubeRegionsCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set calendar(calendar:ReleaseCalendar):void {
			_calendar = calendar;
		}
		
		/**
		 * Association to a release calendar that defines dates on which the
		 * artefact is to be made available.
		 */ 
		public function get calendar():ReleaseCalendar {
			return _calendar;
		}
		
		/**
		 * @private
		 */
		public function set availableDates(availableDates:ReferencePeriod):void{
			_availableDates = availableDates;
		}
		
		/**
		 * Association to the set of time periods that identify the time ranges 
		 * for which data are available in the data source.
		 */ 
		public function get availableDates():ReferencePeriod {
			return _availableDates;
		}
		
		/**
		 * @private
		 */
		public function set permittedContentKeys(
			permittedContentKeys:KeySet):void {
			_permittedContentKeys = permittedContentKeys;
		}
		
		/**
		 * Association to a sub set of Keys that can be derived from the 
		 * definition of the Structure to which the Constrainable Artefact is 
		 * linked.
		 */
		public function get permittedContentKeys():KeySet {
			return _permittedContentKeys;
		}
		
		/**
		 * @private
		 */
		public function set permittedContentRegion(
			permittedContentRegion:CubeRegionsCollection):void {
			_permittedContentRegion = permittedContentRegion;
		}
		
		/**
		 * Association to a sub set of component values that can be derived from
		 * the definition of the Structure to which the Constrainable Artefact 
		 * is linked.
		 */ 
		public function get permittedContentRegion():CubeRegionsCollection {
			return _permittedContentRegion;
		}
	}
}