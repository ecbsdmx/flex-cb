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
package eu.ecb.core.event
{
	import flash.events.Event;
	
	import org.sdmx.model.v2.structure.hierarchy.CodeAssociation;

	/**
	 * This event is dispatched when a node item (code association) has been 
	 * selected in an hierarchical code list.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class HierarchicalItemSelectedEvent extends Event
	{
		/*==============================Fields================================*/
        
		private var _codeAssociation:CodeAssociation;
		
		/*============================Constructor=============================*/
		
		public function HierarchicalItemSelectedEvent(type:String, 
			item:CodeAssociation, bubbles:Boolean=false, 
			cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_codeAssociation = item;
		}
		
		 /*==========================Public methods============================*/
        
        /**
		 * @inheritDoc
		 */ 
        override public function clone():Event {
            return new HierarchicalItemSelectedEvent(type, _codeAssociation, 
            	bubbles, cancelable);
        }
        
        /**
         * The code association selected in the hierarchy 
         */ 
        public function get codeAssocation():CodeAssociation {
            return _codeAssociation;
        }
	}
}