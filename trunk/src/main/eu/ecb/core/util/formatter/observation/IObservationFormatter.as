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
package eu.ecb.core.util.formatter.observation
{
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	
	/**
	 * Contract to be implemented by classes supporting custom formatting of 
	 * observation values.
	 * 
	 * Xavier Sosnovsky 
	 */
	public interface IObservationFormatter
	{
		/**
		 * @private
		 */ 
		function set series(series:TimeseriesKey):void;
		
		/**
		 * The series containing the observations to be formatted. This is
		 * needed in order to get the attributes attached at the series level
		 * which might be relevant for formatting observations.
		 */ 
		function get series():TimeseriesKey;
		
		/**
		 * @private
		 */
		function set group(group:GroupKey):void;
		
		/**
		 * The series containing the observations to be formatted. This is
		 * needed in order to get the attributes attached at the series level
		 * which might be relevant for formatting observations.
		 */
		function get group():GroupKey;
		
		/**
		 * Formats the supplied object and returns a formatted string
		 * @param value The object to be formatted
		 * @return The formatted string
		 */
		function format(value:Object):String;
	}
}