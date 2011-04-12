// Copyright (C) 2011 European Central Bank. All rights reserved.
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
package eu.ecb.core.view.navigation
{
	import mx.controls.Tree;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	
	import org.sdmx.model.v2.structure.category.CategoryScheme;

/**
	 * This class provides the ECB-specific visual aspects of the tree 
	 * displaying a category scheme.
	 * 
	 * @author Xavier Sosnovsky
	 */
	internal class ECBCategorySchemeTreeItemRenderer extends TreeItemRenderer
	{
		/*===========================Constructor==============================*/
		
		public function ECBCategorySchemeTreeItemRenderer()
		{
			super();
		}
		
		/*============================Public methods==========================*/
		
		/**
		 * Indicates that a navigation item is selected.
		 */ 
		public function setSelected():void 
		{
            setStyle("fontWeight", "bold");
		}
		
		/**
		 * Removes the indication that a navigation item is selected.
		 */
		public function unsetSelected():void
		{
			setStyle("color", 0x000000);
            setStyle("fontWeight", "normal");
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set data(value:Object):void {
            super.data = value;
            if (super.data is CategoryScheme || (
            	super.listData as TreeListData).open == true) {
            	setStyle("color", 0x000000);
                setStyle("fontWeight", "bold");
            } else if (value != (owner as Tree).selectedItem) {
            	setStyle("fontWeight", "normal");
            }
        }		
	}
}