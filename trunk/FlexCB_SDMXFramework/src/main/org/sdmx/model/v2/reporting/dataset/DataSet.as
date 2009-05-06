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
package org.sdmx.model.v2.reporting.dataset
{
	import org.sdmx.util.date.SDMXDate;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.base.SDMXArtefact;
	
	/**
	 * An organised collection of data. The DataSet must conform to the 
	 * KeyFamily definition associated to the DataflowDefinition for which this 
	 * DataSet is an "instance of data".
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo
	 * 		o DataSet extends IdentifiableArtefact
	 */ 
	public class DataSet extends AttachableArtefactAdapter 
		implements SDMXArtefact {
		
		/*==============================Fields================================*/
		
		private var _reportingBeginDate:Date;
		
		private var _reportingEndDate:Date;
		
		private var _dataExtractionDate:Date;
		
		private var _describedBy:DataflowDefinition;
		
		private var _groupKeys:GroupKeysCollection;
		
		private var _timeseriesKeys:TimeseriesKeysCollection;
		
		/*===========================Constructor==============================*/
		
		public function DataSet() {
			super();
			_groupKeys = new GroupKeysCollection();
			_timeseriesKeys = new TimeseriesKeysCollection();
			_attributeValues = new AttributeValuesCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
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
		 * A specific time period that identifies the beginning period of a 
		 * report.
		 */ 
		public function get reportingBeginDate():Date {
			return _reportingBeginDate;
		}
		
		/**
		 * @private
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
		 * A specific time period that identifies the end period of a 
		 * report.
		 */ 
		public function get reportingEndDate():Date {
			return _reportingEndDate;
		}
		
		/**
		 * @private
		 */
		public function set dataExtractionDate(extractionDate:Date):void {
			_dataExtractionDate = extractionDate;
		}
		
		/**
		 * A specific time period that identifies the date and time that the 
		 * data are extracted from a data source.
		 */ 
		public function get dataExtractionDate():Date {
			return _dataExtractionDate;
		}
		
		/**
		 * @private
		 */
		public function set describedBy(describedBy:DataflowDefinition):void {
			_describedBy = describedBy;
		}
		
		/**
		 * Associates a data flow definition and thereby a Key Family to the 
		 * data set.
		 */ 
		public function get describedBy():DataflowDefinition {
			return _describedBy;
		}
		
		/**
		 * @private
		 */
		public function set groupKeys(groupKeys:GroupKeysCollection):void {
			_groupKeys = groupKeys;
		} 
		
		/**
		 * The collection of groups belonging to the group
		 */
		public function get groupKeys():GroupKeysCollection {
			return _groupKeys;
		}
		
		/**
		 * @private
		 */
		public function set timeseriesKeys(
			timeseriesKeys:TimeseriesKeysCollection):void {
			_timeseriesKeys = timeseriesKeys;
		} 
		
		/**
		 * The collection of series belonging to the dataset
		 */ 
		public function get timeseriesKeys():TimeseriesKeysCollection {
			return _timeseriesKeys;
		}
	}
}