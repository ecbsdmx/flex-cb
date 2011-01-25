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
package eu.ecb.core.view.filter
{
	import eu.ecb.core.view.ISDMXView;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * This interface should be implemented by visual components that allow to
	 * filter data based on dimension values. 
	 *  
	 * @author Xavier Sosnovsky
	 * @author Rok Povse
	 */
	public interface IDimensionFilter extends ISDMXView
	{
		/**
		 * @private 
		 */
		function set dimensionId(id:String):void;
		
		/**
		 * The id of the dimension to be used by the dimension filter. 
		 */
		function get dimensionId():String;
		
		/**
		 * @private
		 */
		function set displayedCodes(codes:ArrayCollection):void;
		
		/**
		 * The list of codes to be displayed by the component. This is an 
		 * optional parameter to be used only for cases where not all the codes 
		 * available in the code list should be displayed by the component. 
		 */
		function get displayedCodes():ArrayCollection;
		
		/**
		 * @private
		 */
		function set selectedCodes(codes:ArrayCollection):void;
		
		/**
		 * The list of codes to be marked as selected by the component (for 
		 * example, if the desired representation is a check box). This is an 
		 * optional parameter to be used only for cases where not all the codes 
		 * displayed should be marked as selected. 
		 */
		function get selectedCodes():ArrayCollection;
		
		/**
		 * Whether this component allows multiple selections (for example, 
		 * check lists) or not (for example, radio buttons). 
		 */
		function get allowMultipleSelection():Boolean;
		
		/**
		 * Text shown before the checkboxes or linkbar
		 */ 
		function set labelText(value:String):void;
		
		/**
		 * 
		 */ 
		function set updateDisplayCodes(value:Boolean):void;
	}
}