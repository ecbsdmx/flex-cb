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
package org.sdmx.model.v2.reporting.dataset
{
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	
	/**
	 * Base implementation of the IDataSet interface.
	 *  
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	internal class BaseDataSet extends AttachableArtefactAdapter 
		implements IDataSet
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 
		protected var _reportingBeginDate:Date;
		
		/**
		 * @private
		 */ 
		protected var _reportingEndDate:Date;
		
		/**
		 * @private
		 */ 
		protected var _dataExtractionDate:Date;
		
		/**
		 * @private
		 */ 
		protected var _describedBy:DataflowDefinition;
		
		/*===========================Constructor==============================*/
		
		public function BaseDataSet()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function set reportingBeginDate(beginDate:Date):void {
			if (null != _reportingEndDate && null != beginDate 
				&& beginDate > _reportingEndDate) {
					throw new ArgumentError("The start of the reporting " + 
							"period cannot be after the end of the reporting " + 
							"period");
			} else {
				_reportingBeginDate = beginDate;
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get reportingBeginDate():Date {
			return _reportingBeginDate;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set reportingEndDate(endDate:Date):void {
			if (null != _reportingBeginDate && null != endDate 
				&& endDate < _reportingBeginDate) {
					throw new ArgumentError("The end of the reporting period " + 
							"cannot be before the start of the reporting " + 
							"period");
			} else {
				_reportingEndDate = endDate;
			}
		}
		
		/**
		 * @inheritDoc
		 */  
		public function get reportingEndDate():Date {
			return _reportingEndDate;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set dataExtractionDate(extractionDate:Date):void {
			_dataExtractionDate = extractionDate;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get dataExtractionDate():Date {
			return _dataExtractionDate;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set describedBy(describedBy:DataflowDefinition):void {
			_describedBy = describedBy;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get describedBy():DataflowDefinition {
			return _describedBy;
		}
	}
}