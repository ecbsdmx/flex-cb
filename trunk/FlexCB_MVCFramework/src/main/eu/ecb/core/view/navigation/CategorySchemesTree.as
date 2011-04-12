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
	import eu.ecb.core.view.BaseSDMXServiceView;
	
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.structure.category.Category;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;

	/**
	 * This class displays an SDMX category scheme (subject-matter domain) as
	 * an hierarchical tree, for browsing purposes.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class CategorySchemesTree extends BaseSDMXServiceView
	{
		/*==============================Fields================================*/
		private var _navigationTree:Tree;
		private var _selectedItemRenderer:ECBCategorySchemeTreeItemRenderer;
		
		[Embed(source="/assets/images/plus.gif")] 
		private var _plusIcon:Class;
		
		[Embed(source="/assets/images/minus.gif")] 
		private var _minusIcon:Class;
		
		/*===========================Constructor==============================*/
		
		public function CategorySchemesTree(direction:String="vertical")
		{
			super(direction);
			setStyle("paddingLeft", 7);
			setStyle("backgroundColor", 0xC3D9E4);
		}
		
		/*==========================Protected methods=========================*/
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if (null == _navigationTree) {
				_navigationTree = new Tree();
				_navigationTree.percentWidth  = 100;
				_navigationTree.percentHeight = 100;
				_navigationTree.labelFunction = getCategoryLabel;
				_navigationTree.styleName = "navigationTree";
				_navigationTree.wordWrap = true;
				_navigationTree.variableRowHeight = true;
				_navigationTree.itemRenderer = 
					new ClassFactory(ECBCategorySchemeTreeItemRenderer);
				_navigationTree.dataDescriptor = 
					new CategorySchemeTreeDescriptor();
				_navigationTree.setStyle("defaultLeafIcon", null);
				_navigationTree.setStyle("folderClosedIcon", null);
				_navigationTree.setStyle("folderOpenIcon", null);
				_navigationTree.setStyle("disclosureClosedIcon", _plusIcon);
				_navigationTree.setStyle("disclosureOpenIcon", _minusIcon);
				_navigationTree.addEventListener(ListEvent.CHANGE, 
					handleSelectedItemChanged);	
				addChild(_navigationTree);
			}
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			if (_categorySchemesChanged) {
				_categorySchemesChanged = false;				
				_navigationTree.dataProvider = _categorySchemes;
				_navigationTree.validateNow();
				if (_categorySchemes.length == 1) {
					_navigationTree.expandItem(
						_categorySchemes.getItemAt(0), true);
				}
			}
			super.commitProperties();
		}
		
		/*===========================Private methods==========================*/

		private function getCategoryLabel(item:Object):String 
		{
			return item.name.localisedStrings.getDescriptionByLocale("en");
		}
		
		private function handleSelectedItemChanged(event:ListEvent):void
		{
			if (((event.currentTarget as Tree).selectedItem as Category).
				categories.length == 0) {
				var selectedCategory:Category = ((event.currentTarget as Tree).
					selectedItem) as Category; 	
				var returnedCategory:Category = 
					new Category(selectedCategory.id);
				returnedCategory.name = selectedCategory.name;
				returnedCategory.description = selectedCategory.description;
				returnedCategory.categories = selectedCategory.categories;
				returnedCategory.uri = selectedCategory.uri;
				returnedCategory.urn = selectedCategory.urn;
				returnedCategory.annotations = selectedCategory.annotations;
				returnedCategory.validFrom = selectedCategory.validFrom;
				returnedCategory.validTo   = selectedCategory.validTo;
				var dataflows:DataflowsCollection = new DataflowsCollection(
					selectedCategory.dataflows.id);
				for each (var dataflow:DataflowDefinition in 
					selectedCategory.dataflows) {
					dataflows.addItem(dataflow);	
				}	
				returnedCategory.dataflows = dataflows;		
				dispatchEvent(new SDMXDataEvent(returnedCategory, 
					"selectedCategory"));
				if (null != _selectedItemRenderer) {
					_selectedItemRenderer.unsetSelected();
				}
				_selectedItemRenderer = 
					event.itemRenderer as ECBCategorySchemeTreeItemRenderer;
				_selectedItemRenderer.setSelected();	
			}
		}
	}
}