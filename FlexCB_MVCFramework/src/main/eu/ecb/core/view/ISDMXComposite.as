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
package eu.ecb.core.view
{
	/**
	 * Interface to be implemented by views which hold other views. This 
	 * approach (the composite pattern) allows us to treat individual views and
	 * composition of views uniformly. 
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public interface ISDMXComposite extends IView
	{
		/**
		 * Adds a view to the collection of views currently held by the object.
		 *  
		 * @param view The view to be added
		 */
		function addView(view:ISDMXServiceView):void;
		
		/**
		 * Gets the view identified by the supplied index in the collection.
		 *  
		 * @param index The index of the view to be returned
		 * 
		 * @return The view identified by the supplied index in the collection.
		 */
		function getView(index:uint):ISDMXServiceView;
		
		/**
		 * Removes the supplied view from the collection of views held by the
		 * object.
		 *  
		 * @param view The view to be removed
		 */
		function removeView(view:ISDMXServiceView):void;
	}
}