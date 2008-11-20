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
package org.sdmx.model.v2.structure.concept
{
	import org.sdmx.model.v2.base.item.Item;
	import org.sdmx.model.v2.base.type.DataType;
	import org.sdmx.model.v2.base.structure.Representation;

	/**
	 * Concepts are associated to statistical data and allow to make sense of 
	 * it (for example, the concept of frequency).
	 * 
	 * <p>A Concept can have both a Type and a Representation specified. If 
	 * specified the core representation that the Concept will inherit when used 
	 * in a structure the Concept such as a Key Family, or Metadata Structure 
	 * Definition, if not by a local representation specified specifically for 
	 * its use in that structure. Representations are:</p>
	 * <ul>
	 * <li>A CodeList, Category Scheme, Concept Scheme, Organisation Scheme, 
	 * Type Scheme</li>
	 * <li>Date Range</li>
	 * <li>Numeric Range</li>
	 * <li>Pattern</li>
	 * <li>Sequence</li>
	 * </ul>
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo
	 * 		- Add possibility to add children.
	 * 		- Add support for the other representations (DateRange, 
	 * 		  NumericRange, Pattern and Sequence).
	 * 		- Implement restriction so that a child item can only have one
	 * 		  parent item.
	 * 		- Make sure that the coreType and coreRepresentation are inherited
	 * 		  by the children, except if they are overridden.
	 */
	public class Concept extends Item {
		
		/*==============================Fields================================*/
		
		private var _coreRepresentation:Representation;
		
		private var _coreType:String;
		
		/*===========================Constructor==============================*/
		
		public function Concept(id:String) {
			super(id);
		}	
		
		/*============================Accessors===============================*/	
		
		/**
	     * @private 
	     */
		public function set coreRepresentation(
			coreRepresentation:Representation):void {
			_coreRepresentation = coreRepresentation;
		}
		
		/**
	     * The representation (value domain) associated with the concept. Such
	     * a representation could be for example, a code list, from which the
	     * concept would draw its values.
	     */
		public function get coreRepresentation():Representation {
			return _coreRepresentation;
		}
		
		/**
	     * @private 
	     */
		public function set coreType(coreType:String):void {
			if (!DataType.contains(coreType)) {
				throw new TypeError(coreType + " is not a valid SDMX data " + 
						"type");
			} else {
				_coreType = coreType;
			}
		}
		
		/**
	     * The data type (format) associated with the concept. It should
	     * be taken from the list of SDMX data types.
	     * 
	     * @param type The data type associated with the concept.
	     * 
	     * @throws TypeError <code>TypeError</code>: If the supplied core type 
	     * is not a	valid SDMX data type.
	     * 
	     * @see org.sdmx.model.v2.base.type.DataType 
	     */
		public function get coreType():String {
			return _coreType;
		}
	}
}