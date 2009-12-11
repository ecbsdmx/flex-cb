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
package org.sdmx.model.v2.base.type
{
	import mx.collections.ArrayCollection;
	
	/**
	 * The list of valid attachment levels for cross-sectional components.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class XSAttachmentLevel
	{
		/*==============================Fields================================*/
		
		private static var _instance:XSAttachmentLevel;
		
		private static var _attachmentLevels:ArrayCollection;
		
		/*============================Constants===============================*/
		
		/**
	     * Data set level.
	     */
	    public static const XSDATASET:String = "XSDataSet";
	    
	    /**
	     * Group level.
	     */
	    public static const GROUP:String = "Group";
	    
	    /**
	     * Series level.
	     */
	    public static const SECTION:String = "Section";
	    
	    /**
	     * Observation level.
	     */
	    public static const XSOBSERVATION:String = "XSObservation";
	    
	    /*===========================Constructor==============================*/
	    
		public function XSAttachmentLevel(enforcer:SingletonEnforcer)
		{
			super();
		}
		
		/*==========================Public methods============================*/
	    
	    /**
	     * Whether the supplied cross-sectional attachment level is in the list 3
	     * of valid SDMX attachment levels.
	     * 
	     * @return true if the supplied cross-sectional attachmentLevel is in 
	     * the list of valid SDMX attachment levels, false otherwise.
	     */ 
	    public static function contains(attachmentLevel:String):Boolean {
	    	return createAttachmentLevelList().contains(attachmentLevel);
	    }
	    
	    /*=========================Private methods============================*/
	    
	    private static function createAttachmentLevelList():ArrayCollection {
	    	if (null == _instance) {
	    		_instance = new XSAttachmentLevel(new SingletonEnforcer());
	    		_attachmentLevels = new ArrayCollection();
		    	_attachmentLevels.addItem(XSDATASET);
		    	_attachmentLevels.addItem(GROUP);
			    _attachmentLevels.addItem(SECTION);
		    	_attachmentLevels.addItem(XSOBSERVATION);
	    	}
		    return _attachmentLevels;
	    }
	}
}

class SingletonEnforcer {
}