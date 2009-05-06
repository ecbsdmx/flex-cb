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
		
		/*===========================Constructor==============================*/
		
		public function TimePeriod(period:String, obs:Observation, 
			sdmxDate:SDMXDate = null) {
			super();
			//For saving memory consumption, allow reuse of the sdmx date object
			if (null != sdmxDate) {
				_sdmxDate = sdmxDate;
			} else {
				_sdmxDate = new SDMXDate();
			}
			if (null == period || period.length == 0) {
				throw new ArgumentError("The period cannot be null or empty");
			}
			if (period.indexOf("H") > -1 || period.indexOf("W") > -1) {
				throw new ArgumentError("Not implemented!");
			} else if (period.indexOf("Q") > -1 ) {
				switch (period.charAt(6)) {
					case "1":
						_periodComparator = period.substr(0, 4) + "-01";
						break;
					case "2":
						_periodComparator = period.substr(0, 4) + "-04";
						break;
					case "3":
						_periodComparator = period.substr(0, 4) + "-07";
						break;
					case "4":
						_periodComparator = period.substr(0, 4) + "-10";
						break;
					default:
						throw new ArgumentError("Not yet implemented");				
				}
			} else {
				_periodComparator = period;
			}
			_timeValue = _sdmxDate.getDate(_periodComparator);
			setObservationValue(obs);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The value of a time period.
		 */ 
		public function get timeValue():Date {
			return _timeValue;
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
		
		/*=========================Private methods============================*/
		
		private function setObservationValue(observation:Observation):void {
			if (null == observation) {
				throw new ArgumentError("The observation cannot be null");		
			} else {
				_observation = observation;
				_observationValue = (_observation is UncodedObservation) ? 
					(_observation as UncodedObservation).value : 
					(_observation as CodedObservation).value.id;
			}
		}
	}
}