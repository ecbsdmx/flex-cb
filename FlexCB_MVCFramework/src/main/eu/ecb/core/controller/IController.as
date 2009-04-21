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
package eu.ecb.core.controller
{
	import eu.ecb.core.model.IModel;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * Minimum contract to be implemented by controllers.
	 * 
	 * <p>Controller objects execute actions, as requested by users of the
	 * application via views. Most of the time, the model will be modified to 
	 * reflect those actions. It should look almost like a dictionary of all 
	 * the features of an application, because it is effectively a list of 
	 * things that views need to have done for them.</p>
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public interface IController extends IEventDispatcher
	{			
		/**
		 * The model used by this controller. 
		 * 
		 * <p>Results of actions performed by the controller will often affect
		 * the model.</p>
		 * 
		 * @return The eu.ecb.core.model.IModel class used by the controller
		 * 
		 * @see eu.ecb.core.model.IModel
		 */
		function get model():IModel;	

		/**
		 * @private
		 */
		function set model(model:IModel):void;
	}
}