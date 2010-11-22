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
	import eu.ecb.core.controller.ISDMXServiceController;
	import eu.ecb.core.model.ISDMXServiceModel;
	
	/**
	 * Basic implementation of the ISDMXMediator interface.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class BaseSDMXMediator extends BaseSDMXViewComposite
		implements ISDMXMediator
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _controller:ISDMXServiceController;
		
		/**
		 * @private
		 */
		protected var _model:ISDMXServiceModel;
		
		/*===========================Constructor==============================*/
		
		public function BaseSDMXMediator(model:ISDMXServiceModel, 
			controller:ISDMXServiceController, direction:String="vertical")
		{
			super(direction);
			this.model = model;
			this.controller = controller;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function set controller(controller:ISDMXServiceController):void
		{
			_controller = controller;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get controller():ISDMXServiceController
		{
			return _controller;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set model(model:ISDMXServiceModel):void
		{
			_model = model;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get model():ISDMXServiceModel
		{
			return _model;
		}
	}
}