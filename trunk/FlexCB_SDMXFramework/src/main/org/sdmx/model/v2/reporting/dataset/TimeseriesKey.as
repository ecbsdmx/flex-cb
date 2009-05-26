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
	import mx.collections.IViewCursor;
	
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	
	/**
	 * Sets of observations made over time.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class TimeseriesKey extends Key {
		
		/*==============================Fields================================*/
		
		private var _timePeriods:TimePeriodsCollection;
		
		private var _valueFor:KeyDescriptor;
		
		private var _cachedKey:String;
		
		private var _cachedGroupKey:String;
		
		/*===========================Constructor==============================*/
		
		public function TimeseriesKey(keyDescriptor:KeyDescriptor) 
		{
			super();
			_timePeriods = new TimePeriodsCollection();
			valueFor = keyDescriptor;
		}
		
		/*============================Accessors===============================*/
		
		/**
	 	 * @private
	 	 */
		public function set valueFor(keyDescriptor:KeyDescriptor):void 
		{
			if (null == keyDescriptor) {
				throw new ArgumentError("The key descriptor cannot be null");
			}
			_valueFor = keyDescriptor;
			_cachedKey = null;
			_cachedGroupKey = null;
		}
		
		/**
		 * Associates the key descriptor defined in the key family.
		 */ 
		public function get valueFor():KeyDescriptor 
		{
			return _valueFor;
		}

		/**
	 	 * @private
	 	 */
		public function set timePeriods(timePeriods:TimePeriodsCollection):void
		{
			_timePeriods = timePeriods;
		}
		
		/**
		 * The collection of periods belonging to a time series
		 */ 
		public function get timePeriods():TimePeriodsCollection 
		{
			return _timePeriods;
		}
		
		/**
		 * The series key identifying the series 
		 */
		public function get seriesKey():String 
		{
			if (_cachedKey == null && null != keyValues) {
				_cachedKey = keyValues.seriesKey;
			}
			return _cachedKey;
		}
		
		/**
		 * The key of the sibling group to which this series belongs. This 
		 * method makes the assumption that the frequency dimension is in first
		 * position in the series key. 
		 */
		public function get siblingGroupKey():String
		{
			if (_cachedGroupKey == null && null != keyValues) {
				_cachedGroupKey = seriesKey.substr(2);
			}
			return _cachedGroupKey;
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
			keyValuesCollection:KeyValuesCollection):Boolean 
		{
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
		
		/**
		 * Whether or not the series belong to the group identified by the 
		 * supplied group key. The method was introduced in addition to the 
		 * method belongsToGroup for performance purposes and makes two 
		 * assumptions: 
		 * 1. The key supplied identifies a sibling group (so a group where
		 * the frequency dimension is wildcarded). 
		 * 2. The frequency dimension is in the first position in the series
		 * key.
		 * 
		 * @param groupKey The key identifying the sibling group
		 * 
		 * @return Whether or not the series belong to the group identified by 
		 * the supplied group key
		 */
		public function belongsToSiblingGroup(groupKey:String):Boolean
		{
			return siblingGroupKey == groupKey;
		}
	}
}