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
package org.sdmx.model.v2.base
{
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	/**
	 * Default implementation of the MaintainableArtefact interface. 
	 * This class exists as convenience for creating MaintainableArtefact 
	 * objects.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class MaintainableArtefactAdapter extends VersionableArtefactAdapter 
		implements MaintainableArtefact {
			
		/*==============================Fields================================*/
		
		private var _isFinal:Boolean;
		
		private var _maintainer:MaintenanceAgency;
		
		/*===========================Constructor==============================*/
				
		/**
		 * Constructs a maintainable artefact.
		 *  
		 * @param id
		 * 		The object identifier (e.g.: CL_FREQ)
		 * @param objectName
		 * 		The object name (e.g.: Frequency code list)
		 * @param maintenanceAgency
		 * 		The agency responsible for maintaining the object (e.g.: ECB)
		 */
		public function MaintainableArtefactAdapter(id:String, 
			objectName:InternationalString, maintenanceAgency:MaintenanceAgency) 
		{
			super(id);
			name = objectName;
			maintainer = maintenanceAgency;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc 
		 */
		public function get maintainer():MaintenanceAgency {
			return _maintainer;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set maintainer(maintainer:MaintenanceAgency):void {
			if (null != maintainer) {
				_maintainer = maintainer;
			} else {
				throw new ArgumentError("The maintenance agency cannot be " + 
						"null");
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get isFinal():Boolean {
			return _isFinal;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set isFinal(isFinal:Boolean):void {
			_isFinal = isFinal;
		}
	}
}