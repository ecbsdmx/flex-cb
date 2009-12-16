// Copyright (C) 2009 European Central Bank. All rights reserved.
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
package eu.ecb.core.view
{
	import mx.containers.Box;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.IDataSet;
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.structure.category.CategorieSchemesCollection;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	
	/**
	 * Basic implementation of the ISDMXServiceView interface.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class BaseSDMXServiceView extends Box implements ISDMXServiceView
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _categorySchemes:CategorieSchemesCollection;
		
		/**
		 * @private
		 */
		protected var _categorySchemesChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _dataflows:DataflowsCollection;
		
		/**
		 * @private
		 */
		protected var _dataflowsChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _keyFamilies:KeyFamilies;
		
		/**
		 * @private
		 */
		protected var _keyFamiliesChanged:Boolean;
		
		/**
		 * @private
		 */ 	
		protected var _dataSet:IDataSet;
		
		/**
		 * @private
		 */
		protected var _dataSetChanged:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function BaseSDMXServiceView(direction:String = "vertical")
		{
			super();
			this.direction = direction;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function set categorySchemes(cs:CategorieSchemesCollection):void
		{
			if (null != cs) {
				_categorySchemes = cs;
				_categorySchemesChanged = true;
				invalidateProperties(); 
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set dataflowDefinitions(dd:DataflowsCollection):void
		{
			if (null != dd) {
				_dataflows = dd;
				_dataflowsChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set keyFamilies(kf:KeyFamilies):void
		{
			if (null != kf) {
				_keyFamilies = kf;
				_keyFamiliesChanged = true;
				invalidateProperties();
			}
		}

		/**
		 * @inheritDoc
		 */ 
		public function set dataSet(dataSet:IDataSet):void
		{
			if (null != dataSet &&  ((dataSet is DataSet && 
				null != (dataSet as DataSet).timeseriesKeys && 
				(dataSet as DataSet).timeseriesKeys.length > 0) || 
				(dataSet is XSDataSet && null != (dataSet as XSDataSet).groups 
				&& (dataSet as XSDataSet).groups.length > 0 && 
				null != (dataSet as XSDataSet).groups.getItemAt(0) &&
				null != ((dataSet as XSDataSet).groups.getItemAt(0) as XSGroup).
				sections && ((dataSet as XSDataSet).groups.getItemAt(0) as 
				XSGroup).sections.length > 0 && ((dataSet as XSDataSet).groups.
				getItemAt(0) as XSGroup).sections.getItemAt(0) != null && 
				(((dataSet as XSDataSet).groups.getItemAt(0) as XSGroup).
				sections.getItemAt(0) as Section).observations != null && (((
				dataSet as XSDataSet).groups.getItemAt(0) as XSGroup).sections.
				getItemAt(0) as Section).observations.length > 0))) {
				_dataSet = dataSet;
				_dataSetChanged = true;		
				invalidateProperties();
			}
		}
	}
}