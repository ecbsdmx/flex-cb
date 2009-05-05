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
	 * The list of valid concept roles.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public final class ConceptRole {
		
		/*============================Constants===============================*/
		
		/**
	     * Identifies the {@link Concept} that plays the role of the frequency.
	     */
	    public static const FREQUENCY:String = "frequency";
	    /**
	     * Identifies the {@link Concept} that plays the role of an identifier 
	     * where the identifier is taken from a known system of counts.
	     */
	    public static const COUNT:String = "count";
	    
	    /**
	     * Identifies the {@link Concept} that plays the role of identifying a 
	     * type of measure.
	     */
	    public static const MEASURE_TYPE:String = "measureType";
	    
	    /**
	     * Identifies the {@link Concept} that plays the role of a day/time
	     * identifier in the {@link KeyFamily} which is not related to the time 
	     * of the observation.
	     */
	    public static const NON_OBS_TIME:String = "nonObsTime";
	    
	    /**
	     * Identifies the {@link Concept} that plays the role of an identifier 
	     * which is taken from a known scheme of identifiers.
	     */
	    public static const IDENTITY:String = "identity";
	    
	    /**
	     * Identifies the {@link Concept} that specifies the time of the 
	     * observation of the {@link primaryMeasure}.
	     */
	    public static const TIME:String = "time";
	    
	    /**
	     * Identifies the {@link Concept} that plays the role of the observation 
	     * in a time series.
	     */
	    public static const PRIMARY_MEASURE:String = "primaryMeasure";
	    
	    /**
	     * Identifies the {@link Concept} that plays the role of the subject to 
	     * whom the data refers (e.g.: the reporting agent for primary 
	     * reporting).
	     */
	    public static const ENTITY:String = "entity";
	    
	    /**
	     * Identifies the {@link Concept} that plays the role of the subject to 
	     * whom the data refers (e.g.: the reporting agent for primary 
	     * reporting).
	     */
	    public static const TIME_FORMAT:String = "timeFormat";
	    
	    /*==========================Public methods============================*/
	    
	    /**
	     * Whether the supplied conceptRole is in the list of valid SDMX concept 
	     * roles.
	     * 
	     * @return true if the supplied conceptRole is in the list of valid SDMX 
	     * concept roles, false otherwise.
	     */ 
	    public static function contains(conceptRole:String):Boolean {
	    	return createConceptRoleList().contains(conceptRole);
	    }
	    
	    /*=========================Private methods============================*/
	    
	    private static function createConceptRoleList():ArrayCollection {
	    	var conceptRole:ArrayCollection = new ArrayCollection();
	    	conceptRole.addItem(FREQUENCY);
		    conceptRole.addItem(COUNT);
		    conceptRole.addItem(MEASURE_TYPE);
		    conceptRole.addItem(NON_OBS_TIME);
		    conceptRole.addItem(IDENTITY);
		    conceptRole.addItem(TIME);
		    conceptRole.addItem(PRIMARY_MEASURE);		    		    		    		    
		    conceptRole.addItem(ENTITY);
		    conceptRole.addItem(TIME_FORMAT);
		    return conceptRole;
	    }
	}
}