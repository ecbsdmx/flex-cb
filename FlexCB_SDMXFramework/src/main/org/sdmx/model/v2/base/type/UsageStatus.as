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
package org.sdmx.model.v2.base.type
{
	import mx.collections.ArrayCollection;
	
	/**
	 * The list of valid usage status.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public final class UsageStatus {
		
		/*==============================Fields================================*/
		
		private static var _instance:UsageStatus;
		
		private static var _usageStatus:ArrayCollection;
		
		/*============================Constants===============================*/
		
		/**
	     * The usage is mandatory.
	     */
	    public static const MANDATORY:String = "Mandatory";
	    
	    /**
	     * The usage is mandatory when certain conditions are satisfied.
	     */
	    public static const CONDITIONAL:String = "Conditional";
	    
	    /*===========================Constructor==============================*/
		
		public function UsageStatus(enforcer:SingletonEnforcer) {
			super();
		}
	    
	    /*==========================Public methods============================*/
	    
	    /**
	     * Whether the supplied usageStatus is in the list of valid SDMX usage 
	     * status.
	     * 
	     * @return true if the supplied usageStatus is in the list of valid SDMX 
	     * usage status, false otherwise.
	     */ 
	    public static function contains(usageStatus:String):Boolean {
	    	return createUsageStatusList().contains(usageStatus);
	    }
	    
	    /*=========================Private methods============================*/
	    
	    private static function createUsageStatusList():ArrayCollection {
	    	if (null == _instance) {
	    		_instance = new UsageStatus(new SingletonEnforcer());
	    		_usageStatus = new ArrayCollection();
	    		_usageStatus.addItem(MANDATORY);
		    	_usageStatus.addItem(CONDITIONAL);
		    }
		    return _usageStatus;
	    }
	}
}

class SingletonEnforcer {
}