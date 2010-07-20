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
	import flash.utils.getQualifiedClassName;
	
	/**
	 * This command updates a field of the receiver. The field name is derived 
	 * from the event type, following agreed naming conventions. For example,
	 * if the event type is "dataSetUpdated", the command will update the 
	 * dataSet field of the receiver, with the value of the corresponding field
	 * in the model.
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	public class UpdateMutatorCmd extends BaseCommand
	{
		/*===========================Constructor==============================*/
		
		public function UpdateMutatorCmd()
		{
			super();
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function execute():void
		{
			if (null == _event) {
				throw new ArgumentError("Event must be set so that the " + 
					"appropriate mutator can be guessed from the event type");
			}
			if (null == _receiver) {
				throw new ArgumentError("No receiver has been set");
			}
			if (null == _model) {
				throw new ArgumentError("No model has been set");
			}
			var field:String = _event.type.replace("Updated" , "");
			if (!(_receiver.hasOwnProperty(field))) {
				throw new ArgumentError("No " + field + " field found in " +
					getQualifiedClassName(_receiver));
			}
			_receiver[field] = _model[field];
		}
	}
}