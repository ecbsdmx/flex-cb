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
package org.sdmx.stores.api
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;

	/**
	 * Base implementation of the IDataProvider interface.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class BaseDataProvider extends EventDispatcher 
		implements IDataProvider
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _keyFamilies:KeyFamilies;
		
		/**
		 * @private
		 */
		protected var _params:SDMXQueryParameters;
		
		/**
		 * @private
		 */
		protected var _disableObservationAttribute:Boolean;
		
		/**
		 * @private
		 */
		protected var _disableAllAttributes:Boolean;
		
		/**
		 * @private
		 */
		protected var _disableObservationsCreation:Boolean;
		
		/**
		 * @private
		 */
		protected var _optimisationLevel:uint;
		
		/**
		 * @private
		 */
		protected var _extractGroups:Boolean;
		
		/*============================Constructor=============================*/
		
		public function BaseDataProvider(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */
		public function set disableObservationAttribute(flag:Boolean):void
		{
			_disableObservationAttribute = flag;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set disableAllAttributes(flag:Boolean):void
		{
			_disableAllAttributes = flag;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set disableGroups(flag:Boolean):void
		{
			_extractGroups = flag;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set disableObservationsCreation(flag:Boolean):void
		{
			_disableObservationsCreation = flag;	
		}
		
		/**
		 * @inheritDoc
		 */
		public function set optimisationLevel(level:uint):void
		{
			_optimisationLevel = level;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set keyFamilies(kf:KeyFamilies):void
		{
			_keyFamilies = kf;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function getData(params:SDMXQueryParameters=null):void
		{
			_params = params;
		}
	}
}