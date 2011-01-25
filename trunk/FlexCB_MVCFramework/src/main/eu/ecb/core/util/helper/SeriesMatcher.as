// Copyright (C) 2010 European Central Bank. All rights reserved.
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
package eu.ecb.core.util.helper
{
	import eu.ecb.core.model.ISDMXServiceModel;
	import eu.ecb.core.view.filter.IDimensionFilter;
	
	import mx.collections.ArrayCollection;
	
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/** 
	 * Event dispatched when the matching series keys have been updated.
	 * 
	 * @eventType eu.ecb.core.util.helper.SeriesMatcher.MATCHING_SERIES_UPDATED
	 */
	[Event(name="matchingSeriesUpdated", type="flash.events.Event")]
	
	/**
	 * Base implementation of the ISeriesMatcher interface.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class SeriesMatcher extends EventDispatcher implements ISeriesMatcher
	{
		/*=============================Constants==============================*/
		
		/**
		 * The SeriesMatcher.MATCHING_SERIES_UPDATED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>matchingSeriesUpdated</code> event.
		 * 
		 * @eventType matchingSeriesUpdated
		 */
		public static const MATCHING_SERIES_UPDATED:String = 
			"matchingSeriesUpdated";
			
		/*==============================Fields================================*/
		
		private var _model:ISDMXServiceModel;
		private var _matchingSeries:ArrayCollection;
		private var _dimensionFilters:ArrayCollection;
		
		/*===========================Constructor==============================*/
		
		public function SeriesMatcher()
		{
			super();
		}
		
		/*============================Accessors===============================*/

		/**
		 * @inheritDoc 
		 */
		public function set model(model:ISDMXServiceModel):void
		{
			_model = model;
		}
		
		/**
		 * @inheritDoc  
		 */
		public function get matchingSeries():ArrayCollection 
		{
			return _matchingSeries;
		}
		
		/**
		 * @inheritDoc   
		 */
		public function set dimensionFilters(filters:ArrayCollection):void
		{
			_dimensionFilters = filters;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function handleDimensionFilterUpdated(event:Event):void
		{
			updateDimensionFilters(event.currentTarget as IDimensionFilter);
			
			updateMatchingSeries();
		}
		
		/**
		 * @inheritDoc
		 */
		public function handleAllDataSetsUpdated(event:Event):void
		{
			updateMatchingSeries();
		}
		
		/*==========================Private methods===========================*/
		
		private function updateMatchingSeries():void
		{
			_matchingSeries = identifySeriesKeysPool();
			
			for each (var filter:IDimensionFilter in _dimensionFilters) {
				computeSeries(filter);
			}
			
			dispatchEvent(new Event(MATCHING_SERIES_UPDATED));
		}
		
		private function identifySeriesKeysPool():ArrayCollection {
			var targetKeys:ArrayCollection = new ArrayCollection();
			for each (var series:TimeseriesKey in 
				_model.dataSet.timeseriesKeys) {
				targetKeys.addItem(series.seriesKey);	
			}
			return targetKeys;
		}
		
		private function computeSeries(filter:IDimensionFilter):void
		{
			_matchingSeries = identifyMatchingSubset(filter, 
				_matchingSeries,filter.dimensionId,filter.selectedCodes);
		}
		
		private function identifyDimensionPosition(dimensionId:String):uint
		{
			var kf:KeyFamily = _model.allKeyFamilies.getItemAt(0) as KeyFamily;
			return kf.keyDescriptor.getItemIndex(
				kf.keyDescriptor.getDimension(dimensionId));
		}
		
		private function updateDimensionFilters(filter:IDimensionFilter):void
		{
			var targetKeys:ArrayCollection = identifySeriesKeysPool();
			var matchingSubset:ArrayCollection = identifyMatchingSubset(filter, 
				targetKeys,filter.dimensionId,filter.selectedCodes);
			for each (var targetFilter:IDimensionFilter in _dimensionFilters) {
				if (targetFilter != filter) {
					updateFilter(targetFilter, matchingSubset);
				}
			}
		}
		
		private function identifyMatchingSubset(filter:IDimensionFilter, 
			targetKeys:ArrayCollection, dimensionId:String,
			codes:ArrayCollection):ArrayCollection
		{
			var dimPos:uint = identifyDimensionPosition(dimensionId);
			var selectedCodes:ArrayCollection = codes;	
			var matchingSubset:ArrayCollection = new ArrayCollection(); 
			for each (var key:String in targetKeys) {
				var value:String = key.split(".")[dimPos];
				if (selectedCodes.contains(value)) {
					matchingSubset.addItem(key);
				}
			}
			return matchingSubset;
		}
		
		private function updateFilter(filter:IDimensionFilter, 
			validKeys:ArrayCollection):void
		{
			var dimPos:uint = identifyDimensionPosition(filter.dimensionId);
			var validCodes:ArrayCollection = new ArrayCollection();
			var vaildSeriesKeys:ArrayCollection = new ArrayCollection();
			for each (var key:String in validKeys) {
				var value:String = key.split(".")[dimPos];
				if (!(validCodes.contains(value))) {
					validCodes.addItem(value);
					vaildSeriesKeys.addItem(key);
				}
			}
			if (!equalsCodelists(validCodes, filter.displayedCodes)) {
				filter.displayedCodes = validCodes;
			}
		}
		
		private function equalsCodelists(sourceList:ArrayCollection, 
			targetList:ArrayCollection):Boolean
		{
			var equalLists:Boolean = true;
			for each (var item:String in targetList) {
				if (!(sourceList.contains(item))) {
					equalLists = false;
					break;
				}
			}
			return equalLists;
		}
	}
}