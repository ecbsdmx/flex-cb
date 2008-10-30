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
	import mx.formatters.DateFormatter;
	
	import org.sdmx.util.date.SDMXDate;
		
	/**
	 * A specific time period in a known system of time periods.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class TimePeriod {
		
		/*==============================Fields================================*/
		
		private var _timeValue:Date;
		
		private var _observation:Observation;
		
		private var _sdmxDate:SDMXDate;
		
		private var _periodComparator:String;
		
		private var _observationValue:String;
		
		private var _dateFormatter:DateFormatter;
		
		/*===========================Constructor==============================*/
		
		public function TimePeriod(period:String, observation:Observation, 
			sdmxDate:SDMXDate = null) {
			super();
			//For saving memory consumption, allow reuse of the sdmx date object
			if (null != sdmxDate) {
				_sdmxDate = sdmxDate;
			} else {
				_sdmxDate = new SDMXDate();
			}
			_periodComparator = period;
			_timeValue = _sdmxDate.getDate(_periodComparator);
			this.observation = observation;
		}
		
		/*============================Accessors===============================*/
		
		/**
	 	 * @private
	 	 */
		public function set timeValue(period:Date):void {
			if (null == period) {
				throw new ArgumentError("The period cannot be null");	
			} else {
				_timeValue = period;
				if (null == _dateFormatter) {
					_dateFormatter = new DateFormatter();
					_dateFormatter.formatString = "YYYY-MM-DD";
				}
				_periodComparator = _dateFormatter.format(_timeValue)
			}
		}
		
		/**
		 * The value of a time period.
		 */ 
		public function get timeValue():Date {
			return _timeValue;
		}
		
		/**
	 	 * @private
	 	 */
		public function set observation(observation:Observation):void {
			if (null == observation) {
				throw new ArgumentError("The observation cannot be null");		
			} else {
				_observation = observation;
				_observationValue = (_observation is UncodedObservation) ? 
					(_observation as UncodedObservation).value : 
					(_observation as CodedObservation).value.id;
			}
		}
		
		/**
		 * The observation for the defined period.
		 */ 
		public function get observation():Observation {
			return _observation;
		}
		
		/**
		 * The observation value. This is the same value as the one defined
		 * in the observation object, but it is added at this level to 
		 * simplify the work on the level of certains views (e.g.: Line charts). 
		 */ 
		public function get observationValue():String {
			return _observationValue;
		}
		
		/**
		 * String representation, added at this level to simplify the work on 
		 * the level of certains views (e.g.: Line charts). 
		 */
		public function get periodComparator():String {
        	return _periodComparator;
		}
	}
}