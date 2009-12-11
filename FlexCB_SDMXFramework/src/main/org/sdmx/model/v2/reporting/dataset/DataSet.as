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
	public class DataSet extends BaseDataSet {
		
		/*==============================Fields================================*/
				
		private var _groupKeys:GroupKeysCollection;
		
		private var _timeseriesKeys:TimeseriesKeysCollection;
		
		/*===========================Constructor==============================*/
		
		public function DataSet() {
			super();
			_groupKeys = new GroupKeysCollection();
			_timeseriesKeys = new TimeseriesKeysCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */
		public function set groupKeys(groupKeys:GroupKeysCollection):void {
			_groupKeys = groupKeys;
		} 
		
		/**
		 * The collection of groups belonging to the dataset
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