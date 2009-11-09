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
package eu.ecb.core.util.formatter.series
{
	import org.sdmx.model.v2.base.type.AttachmentLevel;
	import org.sdmx.model.v2.reporting.dataset.AttachableArtefact;
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.UncodedAttributeValue;

	/**
     * Uses the description (in English) of an attribute as series title. 
     * 
     * @author Xavier Sosnovsky 
     */
	public class AttributesSeriesTitleFormatter implements ISeriesTitleFormatter
	{
		/*==============================Fields================================*/
		
		private var _attribute:String;
		
		private var _attachmentLevel:String;
		
		private var _titleSupplier:AttachableArtefact;
		
		/*===========================Constructor==============================*/
		
		public function AttributesSeriesTitleFormatter()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The id of the attribute (e.g.: TITLE, etc) to be used for
		 * the series title.
		 */
		public function set attribute(attr:String):void
		{
			_attribute = attr;
		}
		
		/**
		 * @private
		 */ 
		public function set attachmentLevel(level:String):void
		{
			if (!(AttachmentLevel.contains(level))) {
				throw new ArgumentError("Unknown level: " + level);
			}	
			_attachmentLevel = level;
		}
		
		/** 
		 * The attachment level of the attribute (e.g.: TITLE, etc) to be used 
		 * for the series title.
		 */ 
		public function get attachmentLevel():String
		{
			return _attachmentLevel;
		}
		
		/** 
		 * The object to which the attribute to be used as series title is 
		 * attached.
		 */ 
		public function set titleSupplier(supplier:AttachableArtefact):void
		{
			_titleSupplier = supplier;	
		}
		
		/*==========================Public methods============================*/

		/**
		 * @inheritDoc
		 */ 
		public function getSeriesTitle(series:TimeseriesKey):String
		{
			if (null == _attribute) {
				throw new ArgumentError("Attribute from which the title must" + 
					" be fetched has not been set");
			}
			
			if (null == _attachmentLevel) {
				throw new ArgumentError("Attachment level of title attribute" + 
					" has not been set");
			}

									
			if (_attachmentLevel == AttachmentLevel.SERIES) {
				_titleSupplier = series;	
			}
			if (null == _titleSupplier) {
				throw new ArgumentError("Series title supplier is null");
			}
			var title:String;
			for each (var attr:AttributeValue in 
				_titleSupplier.attributeValues){
				if (attr is CodedAttributeValue && 
					(attr as CodedAttributeValue).
					valueFor.conceptIdentity.id == _attribute) {
					title = (attr as CodedAttributeValue).value.
						description.localisedStrings.
						getDescriptionByLocale("en");
					break;		
				} else if (attr is UncodedAttributeValue && 
					(attr as UncodedAttributeValue).valueFor.
					conceptIdentity.id == _attribute) {
					title = (attr as UncodedAttributeValue).value;
					break;
				}	
			}
			if (null == title) {
				throw new ArgumentError("Title could not be found");
			}
			return title;
		}
	}
}