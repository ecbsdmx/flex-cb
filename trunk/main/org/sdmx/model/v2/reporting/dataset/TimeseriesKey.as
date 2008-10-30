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
package org.sdmx.model.v2.reporting.dataset
{
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import mx.collections.IViewCursor;
	
	/**
	 * Comprises the cross product of values of all the dimensions that
	 * identify uniquely a time series.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class TimeseriesKey extends Key {
		
		/*==============================Fields================================*/
		
		private var _timePeriods:TimePeriodsCollection;
		
		private var _valueFor:KeyDescriptor;
		
		/*===========================Constructor==============================*/
		
		public function TimeseriesKey(keyDescriptor:KeyDescriptor) {
			super();
			_timePeriods = new TimePeriodsCollection();
			valueFor = keyDescriptor;
		}
		
		/*============================Accessors===============================*/
		
		/**
	 	 * @private
	 	 */
		public function set valueFor(keyDescriptor:KeyDescriptor):void {
			if (null == keyDescriptor) {
				throw new ArgumentError("The key descriptor cannot be null");
			} else {
				_valueFor = keyDescriptor;
			}
		}
		
		/**
		 * Associates the key descriptor defined in the key family.
		 */ 
		public function get valueFor():KeyDescriptor {
			return _valueFor;
		}

		/**
	 	 * @private
	 	 */
		public function set timePeriods(timePeriods:TimePeriodsCollection):void{
			_timePeriods = timePeriods;
		}
		
		/**
		 * The collection of periods belonging to a time series
		 */ 
		public function get timePeriods():TimePeriodsCollection {
			return _timePeriods;
		}
		
		/**
		 * The series key identifying the series 
		 */
		public function get seriesKey():String {
			return (null == keyValues) ? null : keyValues.seriesKey;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Whether the time series belongs to the group identified by the
		 * supplied collection of key values
		 *  
		 * @param keyValuesCollection The collection of key values for the group
		 * @return true if the time series belongs to the group identified by 
		 * the supplied collection of key values, false otherwise.
		 */
		public function belongsToGroup(
			keyValuesCollection:KeyValuesCollection):Boolean {
			var groupCursor:IViewCursor = keyValuesCollection.createCursor();
			var seriesCursor:IViewCursor = keyValues.createCursor();
			var result:Boolean = false;
			while (!groupCursor.afterLast) {
				var currentGroup:KeyValue = groupCursor.current as KeyValue;
				var currentSeries:KeyValue = seriesCursor.current as KeyValue;
				if (currentGroup.valueFor.conceptIdentity.id 
					== currentSeries.valueFor.conceptIdentity.id) {
					if (currentGroup.value.id == currentSeries.value.id) {
						result = true;
					} else {
						result = false;
						break;
					}
					groupCursor.moveNext();
					seriesCursor.moveNext();
				} else {
					seriesCursor.moveNext();
				}
			}
			return result;
		}
	}
}