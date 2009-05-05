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
	 * The list of valid attachment levels.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class AttachmentLevel {
		
		/*==============================Fields================================*/
		
		private static var _instance:AttachmentLevel;
		
		private static var _attachmentLevels:ArrayCollection;
		
		/*============================Constants===============================*/
		
		/**
	     * Data set level.
	     */
	    public static const DATASET:String = "DataSet";
	    
	    /**
	     * Group level.
	     */
	    public static const GROUP:String = "Group";
	    
	    /**
	     * Series level.
	     */
	    public static const SERIES:String = "Series";
	    
	    /**
	     * Observation level.
	     */
	    public static const OBSERVATION:String = "Observation";
	    
	    /*===========================Constructor==============================*/
		
		public function AttachmentLevel(enforcer:SingletonEnforcer) {
			super();
		}
	    
	    /*==========================Public methods============================*/
	    
	    /**
	     * Whether the supplied attachment level is in the list of valid SDMX 
	     * attachment levels.
	     * 
	     * @return true if the supplied attchmentLevel is in the list of valid 
	     * SDMX attachment levels, false otherwise.
	     */ 
	    public static function contains(attachmentLevel:String):Boolean {
	    	return createAttachmentLevelList().contains(attachmentLevel);
	    }
	    
	    /*=========================Private methods============================*/
	    
	    private static function createAttachmentLevelList():ArrayCollection {
	    	if (null == _instance) {
	    		_instance = new AttachmentLevel(new SingletonEnforcer());
	    		_attachmentLevels = new ArrayCollection();
		    	_attachmentLevels.addItem(DATASET);
		    	_attachmentLevels.addItem(GROUP);
			    _attachmentLevels.addItem(SERIES);
		    	_attachmentLevels.addItem(OBSERVATION);
	    	}
		    return _attachmentLevels;
	    }
	}
}

class SingletonEnforcer {
}