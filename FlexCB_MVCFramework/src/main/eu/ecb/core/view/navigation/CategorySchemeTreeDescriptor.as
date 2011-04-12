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
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.controls.treeClasses.DefaultDataDescriptor;
	
	import org.sdmx.model.v2.structure.category.Category;
	import org.sdmx.model.v2.structure.category.CategoryScheme;

	/**
	 * This class implements a data descriptor for a category scheme.
	 * 
	 * @author Xavier Sosnovsky
	 */
	internal class CategorySchemeTreeDescriptor extends DefaultDataDescriptor
	{
		
		/*===========================Constructor==============================*/
		
		public function CategorySchemeTreeDescriptor()
		{
			super();
		}
		
		/*============================Public methods==========================*/
		
		/**
		 * @inheritDoc
		 */
		public override function hasChildren(node:Object, 
			model:Object=null):Boolean {
			var returnValue:Boolean = false; 
			if (node == null) {
				returnValue = false;
			} else if (node is ArrayCollection && (node as 
				ArrayCollection).length > 0) {
				returnValue = true;
			} else if (node is CategoryScheme && (node as 
				CategoryScheme).categories.length > 0) {
				returnValue = true;
			} else if (node is Category && 
				(node as Category).categories.length > 0) {
				returnValue = true;
			}
			return returnValue;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function isBranch(node:Object, 
			model:Object=null):Boolean {
			var returnValue:Boolean = false; 
			if (node == null) {
				returnValue = false;
			} else if (node is ArrayCollection) {
				returnValue = true;
			} else if (node is CategoryScheme) {
				returnValue = true;
			} else if (node is Category && 
				(node as Category).categories.length > 0) {
				returnValue = true;
			}
			return returnValue;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function getChildren(node:Object, 
			model:Object=null):ICollectionView {
			var collection:ArrayCollection = new ArrayCollection();
			if (hasChildren(node, model)) {
				var cursor:IViewCursor;
				if (node is ArrayCollection) {
					cursor = (node as ArrayCollection).createCursor();
				} else if (node is CategoryScheme) {
					cursor = (node as CategoryScheme).categories.createCursor();
				} else if (node is Category && 
					(node as Category).categories.length > 0) {
					cursor = (node as Category).categories.createCursor();
				} else {
					throw new Error("Unsupported class: " + 
						getQualifiedClassName(node));
				}
				while (!cursor.afterLast) {
					collection.addItem(cursor.current);
					cursor.moveNext();
				}
			}
			return collection;
		}
	}
}