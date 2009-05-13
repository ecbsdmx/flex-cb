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
package org.sdmx.model.v2.structure.keyfamily
{
	import mx.collections.ArrayCollection;
	import flash.utils.getQualifiedClassName;
	import org.sdmx.model.v2.base.SDMXArtefact;
	import mx.collections.IViewCursor;

	/**
	 * A collection of dataflows. It extends the AS3 ArrayCollection
	 * and simply restrict the items type to DataflowDefinition.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see DataflowDefinition
	 * 
	 * @todo 
	 * 		- Guarantee uniqueness constraints for each of the dataflow
	 */ 
	public class DataflowsCollection extends ArrayCollection 
		implements SDMXArtefact {
		
		/*==============================Fields================================*/
		
		private static const ERROR_MSG:String = "Only dataflows " + 
				"are allowed in an collection of dataflows. Got: ";
		
		private var _id:String;
		
		/*===========================Constructor==============================*/
		
		public function DataflowsCollection(id:String = "Dataflows", 
			source:Array=null) {
			super();
			_id = id;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The identifier for the data flows collection
		 * 
		 * @default Dataflows
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
			if (!(item is DataflowDefinition)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				super.addItemAt(item, index);
			}
		}
		
		/**
		 * @private
		 */
		public override function setItemAt(item:Object, index:int):Object {
			if (!(item is DataflowDefinition)) {
				throw new ArgumentError(ERROR_MSG + 
						getQualifiedClassName(item) + ".");
			} else {
				return super.setItemAt(item, index);
			}
		}
		
		/**
		 * Returns the data flow matching the supplied information
		 *  
		 * @param dataflowId The dataflow identifier
		 * @param dataflowAgency The maintenance agency responsible for the 
		 * 	dataflow definition
		 * @param dataflowVersion The version of the dataflow
		 * @return The data flow matching the supplied information
		 */
		public function getDataflowById(dataflowId:String, 
			dataflowAgency:String, dataflowVersion:String):DataflowDefinition {
			if (null == dataflowId || 0 == dataflowId.length) {
				throw new ArgumentError("The dataflow id is mandatory");
			}
			refresh();	
            var cursor:IViewCursor = createCursor();
            var returnedValue:DataflowDefinition = null;
            while (!cursor.afterLast) {
            	var dataflow:DataflowDefinition = 
            		cursor.current as DataflowDefinition;
            	if (dataflow.id == dataflowId && 
            		(dataflowVersion == null || dataflowVersion.length == 0 || 
            			dataflow.version == dataflowVersion) &&
            		(dataflowAgency == null || dataflowAgency.length == 0 || 
            			dataflow.maintainer.id == dataflowAgency)) {
            		returnedValue = dataflow;
            		break;		
				}
            	cursor.moveNext();
            }
			return returnedValue;	
		}
	}
}