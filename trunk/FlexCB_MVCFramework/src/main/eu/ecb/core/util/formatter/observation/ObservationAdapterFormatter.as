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
	import flash.errors.IllegalOperationError;
	
	import mx.controls.Alert;
	
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;

	public class ObservationAdapterFormatter implements IObservationFormatter
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 
		protected var _series:TimeseriesKey;
		
		/**
		 * @private
		 */
		protected var _group:GroupKey;
		
		/**
		 * @private
		 */
		protected var _unitMult:String;
		
		/*===========================Constructor==============================*/
		
		public function ObservationAdapterFormatter()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function set series(series:TimeseriesKey):void
		{
			_series = series;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get series():TimeseriesKey
		{
			return _series;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set group(group:GroupKey):void
		{
			_group = group;
			/*
			This is ECB-specific and should be refactored. It expects to find 
			the unit multiplier as a group-level attribute, with UNIT_MULT as 
			id.
			*/ 
			if (null != _group && null != _group.attributeValues) {
				for each (var attribute:AttributeValue in 
					_group.attributeValues) {
					if (attribute is CodedAttributeValue && (attribute as 
						CodedAttributeValue).valueFor.conceptIdentity.id == 
						"UNIT_MULT") {
						var unitMultValue:uint = 
							uint((attribute as CodedAttributeValue).value.id);
						_unitMult = "1";							
						for (var i:uint = 1; i <= unitMultValue; i++){
							_unitMult = _unitMult + "0";
						}	
						break;
					}
				}
			}		
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get group():GroupKey
		{
			return _group;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function format(value:Object):String 
		{
			throw new IllegalOperationError("This method must be implemented"
				+ " by subclasses");	
		}
	}
}