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
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	/**
	 * Interface to be implemented by utility class that computes the desired 
	 * series keys out of dimension values, selected via dimension filters.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public interface ISeriesMatcher extends IEventDispatcher
	{
		/*============================Accessors===============================*/

		/**
		 * The model to be used by the series matcher. 
		 */
		function set model(model:ISDMXServiceModel):void;
		
		/**
		 * Returns the list of series keys matching the selection made by a user
		 * in an IDimensionFilter component.  
		 */
		function get matchingSeries():ArrayCollection; 
		
		/**
		 * The dimension filters that the series matcher needs to take into
		 * account when computing the matching series keys. 
		 */
		function set dimensionFilters(filters:ArrayCollection):void;
		
		/**
		 * Handles the event indicating that a dimension value has been selected
		 * in an IDimensionFilter view. The list of matching series keys will be
		 * recomputed.
		 */ 
		function handleDimensionFilterUpdated(event:Event):void;
		
		/**
		 * Handles the reception of the event triggered by the model that 
		 * indicates that the data set has been updated. The series matcher
		 * will then use the information available in the dimension filters to
		 * compute the list of series keys that need to be displayed by the 
		 * views.
		 */
		function handleAllDataSetsUpdated(event:Event):void;
	}
}