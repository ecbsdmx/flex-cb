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
package org.sdmx.model.v2.structure.hierarchy
{
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;

	/**
	 * Provides for a reference to a code that is referenced within the 
	 * hierarchy.
	 * 
	 * WARNING: This is based on the draft version of SDMX 2.1. Until the
	 * proposal has been endorsed, the information model is still subject to
	 * changes.
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo
	 * 		- Add support for versioning (version, validFrom and validTo 
	 * 		  attributes)
	 * 		- Add support for levels (level attribute)
	 */
	public class CodeAssociation implements SDMXArtefact
	{
		/*==============================Fields================================*/
		
		private var _code:Code;
		
		private var _codeList:CodeList;
		
		private var _id:String;
		
		private var _children:CodeAssociationsCollection;
		
		/*===========================Constructor==============================*/
		
		public function CodeAssociation(code:Code, codeList:CodeList)
		{
			super();
			_code = code;
			_codeList = codeList;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The code that is used at that specific point in the hierarchy
		 */ 
		public function get code():Code
		{
			return _code;
		}
		
		/**
		 * The code list the referenced code lives in
		 */ 
		public function get codeList():CodeList
		{
			return _codeList;
		}

		/**
		 * @private
		 */ 
		public function set id(id:String):void
		{
			_id = id;
		}
		
		/**
		 * Unique identity within the hierarchy for the code
		 */ 
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * @private
		 */ 
		public function set children(codes:CodeAssociationsCollection):void
		{
			_children = codes;
		}
		
		/**
		 * Collection of codes that, in the hierarchy, are children of the 
		 * current code.
		 */ 
		public function get children():CodeAssociationsCollection
		{
			return _children;
		}
	}
}