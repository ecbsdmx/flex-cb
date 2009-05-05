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
package org.sdmx.model.v2.base.type
{
	import mx.collections.ArrayCollection;
	
	/**
	 * Lists the possible formats that an attribute value can take when it is 
	 * assigned as a data type for the attribute. The semantic 
	 * meaning of the data types in the enumeration are defined with the 
	 * structure in which they are used (e.g. Concept Scheme).
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class FacetType {
		
		/*============================Constants===============================*/
		
	    /**
	     * If true, the Representation is an incremental sequence of integer 
	     * values (value range) or date/time values (time range). The facets 
	     * startValue, and interval or timeInterval must also be specified for a 
	     * sequence.
	     */
		public static const IS_SEQUENCE:String = "isSequence";
		
		/**
	     * If true, valid values for the Representation lie within the given
	     * value/time range, otherwise outside the value/time range.
	     */
		public static const IS_INCLUSIVE:String = "isInclusive";
		
		/**
	     * Specifies the minimum number of characters for a value.
	     */
		public static const MIN_LENGTH:String = "minLength";
		
		/**
	     * Specifies the maximum number of characters for a value.
	     */
		public static const MAX_LENGTH:String = "maxLength";
		
		/**
	     * Specifies the minimum numeric value.
	     */
		public static const MIN_VALUE:String = "minValue";
		
		/**
	     * Specifies the maximum numeric value.
	     */
		public static const MAX_VALUE:String = "maxValue";
		
		/**
	     * Specifies the starting value for a sequence (time or value range).
	     */
		public static const START_VALUE:String = "startValue";
		
		/**
	     * Specifies the end value for a sequence (time or value range).
	     */
		public static const END_VALUE:String = "endValue";
		
		/**
	     * Used to specify the incremental steps of a value range. Starting from
	     * startValue, and incrementing by increment until endValue is reached. 
	     * The sequence then begins again from startValue. If no endValue is 
	     * specified, the sequence continues indefinitely.
	     */
		public static const INCREMENT:String = "increment";
		
		/**
	     * Used to specify the incremental steps (periods) of a time range. 
	     * Starting from startValue, and incrementing by timeInterval until 
	     * endValue is reached. The sequence then begins again from startValue. 
	     * If no endValue is specified, the sequence continues indefinitely.
	     */
		public static const TIME_INTERVAL:String = "timeInterval";
		
		/**
	     * The Representation has a specified number of decimals.
	     */
		public static const DECIMALS:String = "decimals";
		
		/**
	     * The Representation is a regular expression (see XSD spec) which is
	     * expressed as a string.
	     */
		public static const PATTERN:String = "pattern";
		
		/**
	     * The Representation is an enumeration of Items in specific scheme of
	     * Items, such as an identified {@link CodeList}.
	     */
		public static const ENUMERATION:String = "enumeration";
		
		/*==========================Public methods============================*/
		
		/**
		 * Whether the supplied facet type is in the list of valid facet types. 
		 * 
		 * @param facetType The supplied facet type.
		 * 
		 * @return true if the supplied facet type is in the list of valid SDMX 
	     * facet types, false otherwise.
		 */
		public static function contains(facetType:String):Boolean {
	    	return createFacetTypesList().contains(facetType);
	    }
	    
	    /*=========================Private methods============================*/
	    
	    private static function createFacetTypesList():ArrayCollection {
	    	var facetTypes:ArrayCollection = new ArrayCollection();
	    	facetTypes.addItem(IS_SEQUENCE);	    	
	    	facetTypes.addItem(IS_INCLUSIVE);
	    	facetTypes.addItem(MIN_LENGTH);
	    	facetTypes.addItem(MAX_LENGTH);
	    	facetTypes.addItem(MAX_VALUE);
	    	facetTypes.addItem(MAX_VALUE);
	    	facetTypes.addItem(START_VALUE);
	    	facetTypes.addItem(END_VALUE);
	    	facetTypes.addItem(INCREMENT);
	    	facetTypes.addItem(TIME_INTERVAL);
	    	facetTypes.addItem(DECIMALS);
	    	facetTypes.addItem(PATTERN);
	    	facetTypes.addItem(ENUMERATION);
		    return facetTypes;
	    }
	}
}