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
package org.sdmx.stores.api
{
	import flash.events.IEventDispatcher;
	
	/**
	 * This interface defines the contract to be fullfilled by data providers 
	 * that return SDMX maintainable artefacts.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public interface IMaintainableArtefactProvider extends IEventDispatcher
	{
		/**
		 * Retrieves a maintainable artefact from an SDMX data source. 
		 *    
		 * @param artefactID The ID of the artefact to be 
		 * retrieved. If null, all available artefacts will be 
		 * retrieved.
		 * @param maintenanceAgencyID The maintenance agency maintaining the
		 * artefact. If null, matching artefacts from ANY 
		 * maintenance agency will be retrieved.
		 * @param versionNumber The version number of the artefact.
		 * If null, the latest available version will be returned.
		 */
		function getMaintainableArtefact(artefactID:String = null, 
			maintenanceAgencyID:String=null, 
			versionNumber:String=null):void;
	}
}