// Copyright (C) 2011 European Central Bank. All rights reserved.
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
package eu.ecb.core.view.panel
{
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.sdmx.model.v2.base.structure.Component;
	import org.sdmx.model.v2.base.structure.LengthRange;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.keyfamily.DataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.UncodedDataAttribute;

	/**
	 * This component displays dataflow information, as well as the constraints
	 * attached to a dataflow.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class DataStructureWindow extends TitleWindow
	{
		/*==============================Fields================================*/
		
		private var _keyFamily:KeyFamily;
		private var _keyFamilyChanged:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function DataStructureWindow()
		{
			super();
			width = 1000;
			height = 700;
			setStyle("paddingRight", 20);
			showCloseButton = true;
			styleName = "KFPanel";
			addEventListener(CloseEvent.CLOSE, handleWindowClose);
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @param kf The data structure to be displayed
		 */
		public function set keyFamily(kf:KeyFamily):void
		{
			_keyFamily = kf;
			_keyFamilyChanged = true;
			invalidateProperties();	
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitProperties():void
		{
			if (_keyFamilyChanged) {
				_keyFamilyChanged = false;
				titleTextField.text = "Data structure definition: " + 
				_keyFamily.name.localisedStrings.getDescriptionByLocale("en");
				
				displayComponentListHeader("Dimensions");
				for each (var dimension:Dimension in _keyFamily.keyDescriptor) {
					displayComponent(dimension);		
				}
				
				displayComponentListHeader("Attributes");
				for each (var attribute:DataAttribute in 
					_keyFamily.attributeDescriptor) {
					displayComponent(attribute);
				}
			}
		}
		
		/*=========================Private methods============================*/
		
		private function displayComponentListHeader(listName:String):void {
			var dimensions:Label = new Label();
			dimensions.percentWidth = 100;
			dimensions.text = listName;
			dimensions.setStyle("fontWeight", "bold");
			dimensions.setStyle("fontSize", "15");
			addChild(dimensions);
			displayComponentsHeaders((listName == "Attributes" ? true : false));
		}
		
		private function displayComponentsHeaders(isAttributes:Boolean):void {
			var headers:HBox = new HBox();
			headers.percentWidth = 100;
			addChild(headers);
			
			var header1:Label = new Label();
			header1.text = "ID";
			header1.setStyle("fontWeight", "bold");
			header1.width = 150;
			headers.addChild(header1);
			
			var header2:Text = new Text();
			header2.text = "Concept";
			header2.setStyle("fontWeight", "bold");
			header2.width = 250;
			headers.addChild(header2);
			
			if (isAttributes) {
				var levelHeader:Label = new Label();
				levelHeader.text = "Attachment Level";
				levelHeader.width = 150;
				levelHeader.setStyle("fontWeight", "bold");
				headers.addChild(levelHeader);
			}
			
			var header3:Label = new Label();
			header3.text = "Allowed values";
			header3.setStyle("fontWeight", "bold");
			headers.addChild(header3);
		}
		
		private function displayComponent(component:Component):void {
			var box:HBox = new HBox();
			box.percentWidth = 100;
			addChild(box);		
			
			var compCode:Label = new Label();
			compCode.text = component.id;
			compCode.width = 150;
			box.addChild(compCode);
			
			var concept:Text = new Text();
			concept.width = 250;
			concept.text = component.conceptIdentity.name.
				localisedStrings.getDescriptionByLocale("en");
			box.addChild(concept);
			
			if (component is DataAttribute) {					
				var level:Label = new Label();
				level.width = 150;
				level.text  = (component as DataAttribute).attachmentLevel;
				box.addChild(level);
			}
			
			var desiredWidth:uint = (component is DataAttribute ? 370 : 530);
			if (component.conceptRole != ConceptRole.TIME) {			
				if (component is UncodedDataAttribute) {
					var value:Label = new Label();
					var range:LengthRange = (component.localRepresentation 
						as LengthRange);
					value.text = (range.minLength == range.maxLength) ? 
						String(range.maxLength) : "Up to " + String(
						range.maxLength);
					box.addChild(value);
				} else {
					var values:ComboBox = new ComboBox();
					values.id = 
						(component.localRepresentation as CodeList).id;
					values.dropdownWidth = desiredWidth;
					values.width = desiredWidth;
					var dataProvider:ArrayCollection = new ArrayCollection();
					for each(var code:Code in (component.localRepresentation 
						as CodeList).codes) {
						var item:Object = new Object();
						item["label"] = code.description.localisedStrings.
							getDescriptionByLocale("en");
						item["id"] = code.id;
						dataProvider.addItem(item);	
					}
					values.dataProvider = dataProvider;
					box.addChild(values);
				}
			}
		}
		
		private function handleWindowClose(event:CloseEvent):void 
		{
			PopUpManager.removePopUp(this);
		} 
	}
}