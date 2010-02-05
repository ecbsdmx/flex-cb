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
package org.sdmx.stores.xml.v2.structure.hierarchy
{
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.hierarchy.CodeAssociation;
	import org.sdmx.model.v2.structure.hierarchy.CodeAssociationsCollection;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;

	/**
	 * Extracts CodeAssociations out of SDMX-ML structure files.
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	public class CodeAssociationExtractor implements ISDMXExtractor
	{
		/*==============================Fields================================*/
		
		private namespace structure = 
			"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure";		
		use namespace structure;
		
		private var _codeListRef:Object;
		
		/*===========================Constructor==============================*/
		
		public function CodeAssociationExtractor(codeListRef:Object)
		{
			super();
			_codeListRef = codeListRef;
		}
		
		/*==========================Public methods============================*/

		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact
		{
			if (items.child(new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"CodelistAliasRef")).length() == 0) {
				throw new ArgumentError("No referenced code list: " + items);
			}
			
			if (items.child(new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"CodeID")).length() == 0) {
				throw new ArgumentError("Code id not found: " + items);
			}
			
			var codelistAliasRef:String = String(items.CodelistAliasRef);
			if (!(_codeListRef.hasOwnProperty(codelistAliasRef))) {
				throw new ArgumentError("Could not find code list with alias: " 
					+ codelistAliasRef);
			}
			
			var codeList:CodeList = _codeListRef[codelistAliasRef] as CodeList;
			
			var codeID:String = String(items.CodeID);
			var code:Code = codeList.codes.getCode(codeID);
			if (null == code) {
				throw new ArgumentError("Could not find code with id " + 
					codeID + " in list with alias: " + codelistAliasRef);
			}
			
			var codeAssociation:CodeAssociation = 
				new CodeAssociation(code, codeList);
			if (items.child(new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure", 
				"NodeAliasID")).length() > 0) {
				codeAssociation.id = String(items.NodeAliasID);
			}
			
			var codeAssociations:CodeAssociationsCollection = 
				new CodeAssociationsCollection();
			var caExtractor:CodeAssociationExtractor = 
				new CodeAssociationExtractor(_codeListRef);
			for each (var codeRefXML:XML in items.CodeRef) {
				codeAssociations.addItem(caExtractor.extract(codeRefXML));
			}
			codeAssociation.children = codeAssociations;
			return codeAssociation;
		}
	}
}