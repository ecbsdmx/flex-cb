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
	 * The list of valid SDMX data types. Most of them are compatible with those
	 * found in XML Schema and have equivalents in most current implementation
	 * platforms.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public final class DataType {
		
		/*==============================Fields================================*/
		
		private static var _instance:DataType;
		
		private static var _dataTypes:ArrayCollection;
		
		/*============================Constants===============================*/
		
		/**
	     * Represents character strings.
	     */
	    public static const STRING:String = "string";
	    
	    /**
	     * Immutable arbitrary-precision integers.
	     */
	    public static const BIG_INTEGER:String = "bigInteger";
	    
	    /**
	     * 32-bit two's complement.
	     */
	    public static const INTEGER:String = "integer";
	    
	    /**
	     * 64-bit two's complement.
	     */
	    public static const LONG:String = "long";
	    
	    /**
	     * 16-bit two's complement.
	     */
	    public static const SHORT:String = "short";
	    
	    /**
	     * Immutable, arbitrary-precision signed decimal numbers.
	     */
	    public static const DECIMAL:String = "decimal";
	    
	    /**
	     * 32-bit IEEE 754.
	     */
	    public static const FLOAT:String = "float";
	    
	    /**
	     * 64-bit IEEE 754.
	     */
	    public static const DOUBLE:String = "double";
	    
	    /**
	     * true or false.
	     */
	    public static const BOOLEAN:String = "boolean";
	    
	    /**
	     * Objects with integer-valued year, month, day, hour and minute 
	     * properties, a decimal-valued second property, and a boolean timezoned 
	     * property.
	     */
	    public static const DATE_TIME:String = "dateTime";
	    
	    /**
	     * An instant of time that recurs every day.
	     */
	    public static const TIME:String = "time";
	    
	    /**
	     * Top-open intervals of exactly one day in length on the timelines of
	     * dateTime, beginning on the beginning moment of each day (in each
	     * timezone), i.e. '00:00:00', up to but not including '24:00:00' (which 
	     * is identical with '00:00:00' of the next day). For nontimezoned 
	     * values, the top-open intervals disjointly cover the nontimezoned 
	     * timeline, one per day. For timezoned values, the intervals begin at 
	     * every minute and therefore overlap.
	     */
	    public static const DATE:String = "date";
	    
	    /**
	     * A gregorian calendar year.
	     */
	    public static const YEAR:String = "year";
	    
	    /**
	     * Gregorian month that recurs every year.
	     */
	    public static const MONTH:String = "month";
	    
	    /**
	     * Gregorian day that recurs, specifically a day of the month such as 
	     * the 5th of the month.
	     */
	    public static const DAY:String = "day";
	    
	    /**
	     * Gregorian date that recurs, specifically a day of the year such as 
	     * the third of May.
	     */
	    public static const MONTH_DAY:String = "monthDay";
	    
	    /**
	     * A specific gregorian month in a specific gregorian year.
	     */
	    public static const YEAR_MONTH:String = "yearMonth";
	    
	    /**
	     * Immutable representation of a time span as defined in the W3C XML 
	     * Schema 1.0 specification. A Duration object represents a period of 
	     * Gregorian time, which consists of six fields (years, months, days, 
	     * hours, minutes, and seconds) plus a sign (+/-) field.
	     */
	    public static const DURATION:String = "duration";
	    
	    /**
	     * Start DataType.Date_Time + DataType.Duration.
	     */
	    public static const TIME_SPAN:String = "timeSpan";
	    
	    /**
	     * Represents a Uniform Resource Identifier (URI) reference. Aside from 
	     * some minor deviations noted below, an instance of this class 
	     * represents a URI reference as defined by RFC 2396: Uniform Resource 
	     * Identifiers (URI): Generic Syntax, amended by RFC 2732: Format for 
	     * Literal IPv6 Addresses in URLs.
	     */
	    public static const URI:String = "uri";
	    
	    /**
	     * Value taken from a known system of counts.
	     */
	    public static const COUNT:String = "count";
	    
	    /**
	     * Inclusive range of values.
	     */
	    public static const INCLUSIVE_VALUE_RANGE:String = 
	    	"inclusiveValueRange";
	    
	    /**
	     * Exclusive range of values.
	     */
	    public static const EXCLUSIVE_VALUE_RANGE:String = 
	    	"exclusiveValueRange";
	    
	    /**
	     * Value taken from an incremental sequence of integer values.
	     */
	    public static const INCREMENT:String = "increment";
	    
	    /**
	     * A union type of DataType.Date, DataType.Time, DataType.Date_Time, and 
	     * a set of codes for common periods.
	     */
	    public static const OBSERVATIONAL_TIME_PERIOD:String = 
	    	"observationalTimePeriod";
	    
	    /**
	     * 1 signed byte (two's complement). Covers values from -128 to 127.
	     */
	    public static const BASE64_BINARY:String = "base64Binary";
	    
	    /*===========================Constructor==============================*/
		
		public function DataType(enforcer:SingletonEnforcer) {
			super();
		}
	    
	    /*==========================Public methods============================*/
	    
	    /**
	     * Whether the supplied dataType is in the list of valid SDMX data 
	     * types.
	     * 
	     * @return true if the supplied dataType is in the list of valid SDMX 
	     * data types, false otherwise.
	     */ 
	    public static function contains(dataType:String):Boolean {
	    	return createDataTypesList().contains(dataType);
	    }
	    
	    /*=========================Private methods============================*/
	    
	    private static function createDataTypesList():ArrayCollection {
	    	if (null == _instance) {
	    		_instance = new DataType(new SingletonEnforcer());
		    	_dataTypes = new ArrayCollection();
		    	_dataTypes.addItem(STRING);
			    _dataTypes.addItem(BIG_INTEGER);
			    _dataTypes.addItem(INTEGER);
			    _dataTypes.addItem(LONG);
			    _dataTypes.addItem(SHORT);
			    _dataTypes.addItem(DECIMAL);
			    _dataTypes.addItem(FLOAT);
			    _dataTypes.addItem(DOUBLE);
			    _dataTypes.addItem(BOOLEAN);
			    _dataTypes.addItem(DATE_TIME);
			    _dataTypes.addItem(TIME);
			    _dataTypes.addItem(DATE);
			    _dataTypes.addItem(YEAR);
			    _dataTypes.addItem(MONTH);
			    _dataTypes.addItem(DAY);
			    _dataTypes.addItem(MONTH_DAY);
			    _dataTypes.addItem(YEAR_MONTH);
			    _dataTypes.addItem(DURATION);
			    _dataTypes.addItem(TIME_SPAN);
			    _dataTypes.addItem(URI);
			    _dataTypes.addItem(COUNT);
			    _dataTypes.addItem(INCLUSIVE_VALUE_RANGE);
			    _dataTypes.addItem(EXCLUSIVE_VALUE_RANGE);
			    _dataTypes.addItem(INCREMENT);
			    _dataTypes.addItem(OBSERVATIONAL_TIME_PERIOD);
		   		_dataTypes.addItem(BASE64_BINARY);
		    }
		    return _dataTypes;
	    }
	}
}

class SingletonEnforcer {
}