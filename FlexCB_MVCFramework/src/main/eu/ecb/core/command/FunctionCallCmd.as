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
package eu.ecb.core.command
{
	import eu.ecb.core.util.string.ECBStringUtil;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * This command executes a function of the receiver. The function name can 
	 * either be supplied to the command via the appropriate accessor, or it 
	 * will be derived from the event type, following agreed naming conventions.
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	public class FunctionCallCmd extends BaseCommand
	{
		/*==============================Fields================================*/
		
		private var _methodName:String;
		
		/*===========================Constructor==============================*/
		
		public function FunctionCallCmd()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Sets the name of the method of the receiver(s) to be executed by the 
		 * command. If no value is supplied, the name of the method will be
		 * derived from the event type. For example, if the event type is 
		 * "dataSetChanged", the derived method name will be 
		 * "handleDataSetChanged".
		 *  
		 * @param value 
		 */
		public function set methodName(value:String):void {
			_methodName = value;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function execute():void
		{
			if (_methodName!=null && _receiver.hasOwnProperty(_methodName)) {
				_receiver[_methodName]();
			} else {
				var fnName:String = "handle" + ECBStringUtil.ucfirst(_event.type);
				if (!(_receiver.hasOwnProperty(fnName))) {
					throw new ArgumentError(getQualifiedClassName(_receiver) + 
						" does not contain method " + fnName);
				}
				_receiver[fnName](_event);
			}
		}
	}
}