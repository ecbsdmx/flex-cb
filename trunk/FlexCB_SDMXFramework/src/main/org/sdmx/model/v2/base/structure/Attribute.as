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
	import org.sdmx.model.v2.base.type.UsageStatus;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * An abstract class used to provide qualitative information.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @see org.sdmx.model.v2.base.type.UsageStatus
	 */ 
	public class Attribute extends Component {

		/*==============================Fields================================*/
		
		private var _usageStatus:String;
		
		/*===========================Constructor==============================*/

		/**
		 * Constructs an attribute.
		 *  
		 * @param identifier The attribute id
		 * @param conceptIdentity The concept representing the attribute (for
		 * example, the attribute OBS_CONF represents the concept of an 
		 * observation confidentiality).
		 */
		public function Attribute(identifier:String, conceptIdentity:Concept) {
			super(identifier, conceptIdentity);
		}
		
		/*============================Accessors===============================*/
		
		/**
	 	 * @private 
	 	 */
	 	[Inspectable(enumeration=Mandatory,Conditional)] 
		public function set usageStatus(usageStatus:String):void {
			if (!UsageStatus.contains(usageStatus)) {
				throw new TypeError(usageStatus + 
					" is not a valid SDMX usage status");
			} else {
				_usageStatus = usageStatus;
			}
		}
		
		/**
		 * The usage status (Mandatory or Conditional) of the attribute. 
		 * 
		 * @throws TypeError <code>TypeError</code>: If the supplied usage 
		 * status is not in the list of valid SDMX status.
		 */
		public function get usageStatus():String {
			return _usageStatus;
		}
	}
}