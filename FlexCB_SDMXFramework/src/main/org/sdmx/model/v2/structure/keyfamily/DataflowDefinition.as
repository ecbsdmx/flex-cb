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
	import org.sdmx.model.v2.base.structure.StructureUsage;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.reporting.provisioning.ConstrainableArtefact;
	import org.sdmx.model.v2.reporting.provisioning.ContentConstraint;
	import org.sdmx.model.v2.reporting.provisioning.AttachmentConstraintsCollection;
	import org.sdmx.model.v2.reporting.provisioning.ProvisionAgreementsCollection;

	/**
	 * Abstract concept of a flow of data that providers will provide for
	 * different reference periods.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo
	 * 		o Add datasets collection
	 */ 
	public class DataflowDefinition extends StructureUsage 
		implements ConstrainableArtefact {
			
		/*==============================Fields================================*/
			
		private var _contentConstraint:ContentConstraint;
		
		private var _attachmentConstraints:AttachmentConstraintsCollection;
		
		private var _provisionAgreements:ProvisionAgreementsCollection;	
		
		/*===========================Constructor==============================*/
		
		public function DataflowDefinition(id:String, 
			objectName:InternationalString, maintenanceAgency:MaintenanceAgency,
			keyFamily:KeyFamily) {
			super(id, objectName, maintenanceAgency, keyFamily);
			_attachmentConstraints = new AttachmentConstraintsCollection();
			_provisionAgreements = new ProvisionAgreementsCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private 
		 */ 
		public function set contentConstraint(
			contentConstraint:ContentConstraint):void {
			_contentConstraint = contentConstraint;
		}
		
		/**
		 * The content constraints that apply to the data flow
		 */ 
		public function get contentConstraint():ContentConstraint {
			return _contentConstraint;
		}
		
		/**
		 * @private 
		 */
		public function set attachmentConstraints(
			attachmentConstraints:AttachmentConstraintsCollection):void {
			_attachmentConstraints = attachmentConstraints;
		}
		
		/**
		 * The attachment constraints that apply to the data flow
		 */ 
		public function get attachmentConstraints():
			AttachmentConstraintsCollection {
			return _attachmentConstraints;
		}
		
		/**
		 * @private 
		 */
		public function set provisionAgreements(
			provisionAgreements:ProvisionAgreementsCollection):void {
			_provisionAgreements = provisionAgreements;
		}
		
		/**
		 * The provision agreements (SLA) covering the provision of data for
		 * the data flow 
		 */
		public function get provisionAgreements():ProvisionAgreementsCollection{
			return _provisionAgreements;
		}
	}
}