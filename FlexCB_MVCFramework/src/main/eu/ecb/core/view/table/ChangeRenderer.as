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
package eu.ecb.core.view.table
{
    import mx.controls.Label;
    import mx.controls.listClasses.*;

	/**
	 * Renderer for a column containing changes. If the observation value is 
	 * higher than the previous one, the cell content will be green. If the 
	 * observation value is lower, the cell content will be red.
	 *  
	 * @author Xavier Sosnovsky
	 */
    public class ChangeRenderer extends Label {
    	
    	/*==============================Fields================================*/

        private const POSITIVE_COLOR:uint = 0x009933; // Green
        private const NEGATIVE_COLOR:uint = 0xCC0000; // Red 
        
        /*========================Protected methods===========================*/

        override protected function updateDisplayList(unscaledWidth:Number, 
        	unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (null != data && null != data.value_change) {
				var color:uint;
				var value:String = String(data.value_change);
				if (null != value && value.charAt(0) == "+") {
					color = POSITIVE_COLOR;
				} else if (null != value && value.charAt(0) == "-") {
					color = NEGATIVE_COLOR;
				}
				setStyle("color", color);
			}
        }
    }
}
