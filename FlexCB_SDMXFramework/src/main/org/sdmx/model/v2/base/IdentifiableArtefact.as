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
package org.sdmx.model.v2.base
{
	/**
	 * Provides identity to all derived classes. Identifiable artefacts can have
	 * both a multi-lingual name and a multi-lingual description. It also 
	 * provides annotations to derived classes, as it extends the 
	 * AnnotableArtefact interface.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public interface IdentifiableArtefact extends AnnotableArtefact
	{
	     /**
	     * The unique identifier of the SDMX artefact
	     * 
		 * @throws ArgumentError <code>ArgumentError</code> If the supplied id 
		 * is null or empty
	     */
		function get id():String;
	
		/**
	     * @private
	     */	
		function set id(id:String):void;
		
		/**
	     * The Universal Resource Identifier of the SDMX artefact
	     */
		function get uri():String;
		
		/**
	     * @private
	     */
		function set uri(uri:String):void;
		
		/**
	     * The Universal Resource Name of the SDMX artefact
	     */
		function get urn():String;
		
		/**
	     * @private
	     */
		function set urn(urn:String):void;
		
		/**
	     * The multilingual name of the SDMX artefact
	     */
		function get name():InternationalString;
		
		/**
	     * @private
	     */
		function set name(name:InternationalString):void;
		
		/**
	     * The multilingual description of the SDMX artefact
	     */
		function get description():InternationalString;

		/**
	     * @private
	     */		
		function set description(description:InternationalString):void
	}
}