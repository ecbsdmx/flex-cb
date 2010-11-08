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
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import org.sdmx.model.v2.base.SDMXArtefact;

	/**
	 * Collection of concepts and concept schemes. It extends the AS3 
	 * ArrayCollection and simply restrict the items type to Concept and
	 * ConceptSchemes.
	 * 
	 * <p>Concepts should normally belong to concept schemes. However, for
	 * reason of backward compatibility, it is possible for concepts to live
	 * outside of any concept scheme. As such, this collection is able to
	 * accept both concepts and concept schemes.</p>
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see Concept
	 * @see ConceptScheme
	 * 
	 * @todo  
	 * 	- Search to include agencyId and conceptSchemeAgency
	 * 	- Check that we don't allow the insertion of duplicates
	 */ 
	public class Concepts extends ArrayCollection implements SDMXArtefact {
		
		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only concepts and concept " + 
				"schemes are allowed in a this collection. Got: ";
		
		private var _id:String;
		
		private var _cursor:IViewCursor;
		
		/*===========================Constructor==============================*/
		
		public function Concepts(id:String = "Concepts", source:Array = null) {
			super(source);
			_id = id;
			var sortByID:Sort = new Sort();
			sortByID.fields=[new SortField("id")];
    		sort = sortByID;
			refresh();
			_cursor = createCursor();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The identifier for the collection
		 * 
		 * @default Concepts 
		 */
		public function get id():String {
			return _id;
		}
		
		/**
		 * @private 
		 */
		public function set id(id:String):void {
			_id = id;
		}		
		
		/*==========================Public methods============================*/
		
		/**
		 * @private 
		 */
		public override function addItemAt(item:Object, index:int):void {
			if (!(item is Concept) && !(item is ConceptScheme)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			}
			super.addItemAt(item, index);
		}
		
		/**
		 * @private 
		 */
		public override function setItemAt(item:Object, index:int):Object {
			if (!(item is Concept) && !(item is ConceptScheme)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			}
			return super.setItemAt(item, index);
		}
		
		/**
		 * Returns the concept matching the supplied data 
		 * 
		 * @param conceptRef The ID of the concept
		 * @param conceptScheme The concept scheme to which the concept belongs 
		 * @return The concept matching the supplied data, if any 
		 */
		public function getConcept(conceptRef:String, 
			conceptSchemeName:String = null):Concept {
				
			if (null == conceptRef || 0 == conceptRef.length) {
				throw new ArgumentError("The concept ref cannot be null or" + 
						" empty");
			}
            var targetConceptScheme:Boolean = 
            	(conceptSchemeName != null && conceptSchemeName.length > 0) ? 
            		true : false;
            var concept:Concept = null;				
            if (targetConceptScheme) {
            	if (_cursor.findAny({id:conceptSchemeName})) {
            		var conceptScheme:ConceptScheme = 
            			_cursor.current as ConceptScheme;
            		concept = conceptScheme.concepts.getConcept(conceptRef);
            	} else {
            		concept = null;
            	}
            } else {
            	if (_cursor.findAny({id:conceptRef})) {
					concept = _cursor.current as Concept; 
            	} else {
            		concept = null;
            	}
            }		
			return concept;
		}
	}
}