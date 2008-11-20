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
	import org.sdmx.model.v2.base.VersionableArtefactAdapter;
	import org.sdmx.model.v2.structure.organisation.DataProvider;
	
	/**
	 * Links the data provider to the relevant dataflow definition for which
	 * the provider supplies data or metadata. The agreement may constrain the
	 * scope of the data or metadata that can be provided.
	 * 
	 * @todo 
	 * 		o indexTimeSeries, indexDataSet, indexReportingPeriod
	 * 		o action type
	 * 		o metadataflow ref
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class ProvisionAgreement extends VersionableArtefactAdapter 
		implements ConstrainableArtefact {
		
		/*==============================Fields================================*/
			
		private var _contentConstraint:ContentConstraint;
		
		private var _attachmentConstraints:AttachmentConstraintsCollection;
		
		private var _dataProvider:DataProvider;
		
		private var _source:QueryDatasource;
		
		/*===========================Constructor==============================*/
		
		public function ProvisionAgreement(id:String, dataProvider:DataProvider) 
		{
			super(id);
			this.dataProvider = dataProvider;
		}

		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */
		public function set contentConstraint(
			contentConstraint:ContentConstraint):void {
			_contentConstraint = contentConstraint;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentConstraint():ContentConstraint {
			return _contentConstraint;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set attachmentConstraints(
			attachmentConstraints:AttachmentConstraintsCollection):void {
			_attachmentConstraints = attachmentConstraints;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get 
			attachmentConstraints():AttachmentConstraintsCollection {
			return _attachmentConstraints;
		}
		
		/**
		 * @private
		 */
		public function set dataProvider(dataProvider:DataProvider):void {
			_dataProvider = dataProvider;
		}
		
		/**
		 * The provider of the data that falls under this provision agreement
		 */
		public function get dataProvider():DataProvider {
			return _dataProvider;
		}
		
		/**
		 * @private
		 */
		public function set source(source:QueryDatasource):void {
			_source = source;
		}
		
		/**
		 * The source where the data that falls under the current provision 
		 * agreement can be found
		 */ 
		public function get source():QueryDatasource {
			return _source;
		}
	}
}