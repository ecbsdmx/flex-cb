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
package org.sdmx.model.v2.base.structure
{
	import org.sdmx.model.v2.base.IdentifiableArtefactAdapter;
	import org.sdmx.model.v2.base.item.Item;
	import org.sdmx.model.v2.base.type.DataType;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * Defines qualitative and quantitative data and metadata items that belong 
	 * to a ComponentList and hence a Structure.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see ComponentList
	 */
	public class Component extends IdentifiableArtefactAdapter {
		
		/*==============================Fields================================*/
		
		private var _conceptIdentity:Concept;
		
		private var _conceptRole:String;
		
		private var _localType:String;
		
		private var _localRepresentation:Representation;
		
		/*===========================Constructor==============================*/
		
		/**
		 * Constructs a component.
		 *  
		 * @param identifier The attribute id
		 * @param conceptIdentity The concept representing a component
		 */
		public function Component(identifier:String, concept:Concept) {
			super(identifier);
			conceptIdentity = concept;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private 
		 */
		public function set conceptIdentity(concept:Concept):void {
			if (null == concept) {
				throw new ArgumentError("The concept identity cannot be null");
			}
			_conceptIdentity = concept;
		}
		
		/**
		 * The concept from which the component takes its semantic. 
		 */
		public function get conceptIdentity():Concept {
			return _conceptIdentity;
		}
		
		/**
		 * @private 
		 */
		public function set conceptRole(conceptRole:String):void {
			if (!ConceptRole.contains(conceptRole)) {
				throw new TypeError(conceptRole + 
					" is not a valid concept role");
			}
			_conceptRole = conceptRole;
		}
		
		/**
		 * The role played by the component in a structure. For example,
		 * the concept "FREQ" plays the role of the frequency dimension in a
		 * certain data structure definition. 
		 */
		public function get conceptRole():String {
			return _conceptRole;
		}
		
		/**
		 * @private 
		 */
		public function set localType(localType:String):void {
			if (!DataType.contains(localType)) {
				throw new TypeError(localType + 
					" is not a valid SDMX data type");
			}
			_localType = localType;
		}
		
		/**
		 * Type taken by a component in a certain structure. If supplied, it
		 * overrides any type specified for the item which contains its concept
		 * identity. 
		 */
		public function get localType():String {
			return _localType;
		}
		
		/**
		 * @private 
		 */
		public function set localRepresentation(localRepresentation:
			Representation):void {
			_localRepresentation = localRepresentation;
		}
		
		/**
		 * Default representation of the concept (for instance a CodeList).
		 */
		public function get localRepresentation():Representation {
			return _localRepresentation;
		}
	}
}