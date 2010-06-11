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
package eu.ecb.core.view.filter{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.List;
	
	import mx.events.ListEvent;
	
	import mx.managers.PopUpManager;
	
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.code.Code;

	/**
	 * Used by FiltersPanel to display and select the options for the 
	 * via list boxes. A PopUpManager is used to display this descendant of 
	 * TitleWindow. The List property toList is used by the FiltersPanel 
	 * instance to get the chosen list of ids.
	 * 
	 * @author Huzaifa Zoomkawala
	 *
	 */
	public class InclusiveOptionsWindow extends TitleWindow{
		/*==============================Fields================================*/
		private var _fromList:List, _toList: List;		
		private var _fromListCopy:List, _toListCopy: List;
		private var _filtersPanel: FiltersPanel;
		
		private var addButton:Button, removeButton: Button;
		private var _addButtonEnabled:Boolean, _removeButtonEnabled: Boolean;
		
		/*===========================Constructor==============================*/
		public function InclusiveOptionsWindow(filtersPanel: FiltersPanel, 
			cubeRegions: Object, referenceSeries: TimeseriesKey, keyValue: 
			KeyValue, dimensionNumber:uint){
				
			super();
			_filtersPanel = filtersPanel;
			
			_fromListCopy = new List();
			_fromListCopy.dataProvider = new ArrayCollection();
			_toListCopy = new List();
			_toListCopy.dataProvider = new ArrayCollection();
			
			title = keyValue.valueFor.conceptIdentity
				.name.localisedStrings.getDescriptionByLocale("en");
			
			var componentBox:HBox = new HBox();							
			var fromBox: VBox = new VBox();
			
			_fromList = new List();
			_fromList.width = 150;
			var dataProviderFrom:ArrayCollection = new ArrayCollection();
			var dataProviderTo:ArrayCollection = new ArrayCollection();
			for each(var code:Code in cubeRegions[keyValue.
			    valueFor.conceptIdentity.id] as ArrayCollection) {
				var item:Object = new Object();
				var description:String = code.description.localisedStrings.
					getDescriptionByLocale("en");
				item["label"] = description;
				item["id"] = code.id;
				if ((referenceSeries.keyValues.
				    getItemAt(dimensionNumber) as KeyValue).value.id == code.id)				
					dataProviderTo.addItem(item);
				else                    
					dataProviderFrom.addItem(item);					    					
			}
	
			_fromList.dataProvider = dataProviderFrom;
			_fromList.allowMultipleSelection = true;
			_fromList.addEventListener("change", _fromListSelectionChanged);
			var label: Label = new Label();
			label.htmlText="<b>Available</b>";
			fromBox.addChild(label);
			fromBox.addChild(_fromList);
			componentBox.addChild(fromBox);
			
			var addRemoveBox: VBox = new VBox();
			// add empty label to align the top of the buttons with the top of 
			// the list boxes                  
			label = new Label();
			label.text = "";
			addRemoveBox.addChild(label);
			
			addButton = new Button();
			//addButton.width = 40;
			addButton.label = ">";
			addButton.enabled = false;
			addButton.addEventListener("click", addButtonClicked);
			addRemoveBox.addChild(addButton);
			removeButton = new Button();
			//removeButton.width = 40;
			removeButton.label = "<";
			removeButton.enabled = false;
			removeButton.addEventListener("click", removeButtonClicked);
			addRemoveBox.addChild(removeButton);
			
			componentBox.addChild(addRemoveBox);                               
	
			_toList = new List();
			_toList.width = 150;
			_toList.dataProvider = dataProviderTo;
			_toList.allowMultipleSelection = true;
			_toList.addEventListener("change", _toListSelectionChanged);
			_toList.id = 'to_list';
			var toBox:VBox = new VBox();
			label= new Label();
			label.htmlText="<b>Selected</b>";
			toBox.addChild(label);
			toBox.addChild(_toList);
			componentBox.addChild(toBox);
			
			addChild(componentBox);
				
			showCloseButton = false;
			
			var buttonsBox:HBox = new HBox();
			
			setStyle("horizontalAlign","center");
			var okButton:Button = new Button();			
			okButton.label = "Ok";
			okButton.addEventListener("click", windowClose);
			buttonsBox.addChild(okButton);
			var cancelButton:Button = new Button();
			cancelButton.label = "Cancel";
			cancelButton.addEventListener("click", windowCancel);
			buttonsBox.addChild(cancelButton);
			addChild(buttonsBox);			
		}

		/*======================== Accessors================================= */
		/**
		 * Used by the caller to access the selected list of options.
		 */
		public function get toList(): List{
			return _toList;
		}
		
		/*=========================Public methods=-===========================*/
		/**
		 * Used to save the existing state of the lists and the enabled status
		 * of buttons. This behaviour should ideally be private to the class, 
		 * but as 'activate' or 'show' events could not be detected when the
		 * window becomes visible through PopUpManager.addPopup, a public method
		 * is used prior to making the object visible to copy the state.
		 */
		public function saveWindowState(): void{
			cloneList(_fromList, _fromListCopy);
			cloneList(_toList, _toListCopy);
			_addButtonEnabled = addButton.enabled;
			_removeButtonEnabled = removeButton.enabled;
		}
		
		/*=========================Private methods============================*/
		/**
		 * If the user presses cancel, the state of the list boxes and buttons
		 * saved by saveWindowState.
		 */
		private function resetWindowState(): void{
			cloneList(_fromListCopy, _fromList);
			cloneList(_toListCopy, _toList);
			addButton.enabled = _addButtonEnabled;
			removeButton.enabled = _removeButtonEnabled;
		}
		
		/**
		 * Copy the dataProvider from the source to dest Lists, and set the
		 * dest's selectedIndex property to the corresponding source value.
		 */
		private function cloneList(source:List, dest: List): void{
			dest.dataProvider.removeAll();
			dest.dataProvider.addAll(source.dataProvider);
			dest.selectedIndex = source.selectedIndex;
		}
		
		/**
		 * Move the selected items from the Available list (fromList) to the 
		 * Selected list (toList)
		 */
		private function addButtonClicked(event: MouseEvent):void {
			for each (var index: int in _fromList.selectedIndices){
				var item:Object = _fromList.dataProvider.getItemAt(index);
				_fromList.dataProvider.removeItemAt(index);
				_toList.dataProvider.addItem(item);
			}
			addButton.enabled = false;			
		}	
		
		/**
		 * Move the selected items from the Selected list (toList) to the 
		 * Available list (fromList)
		 */
		private function removeButtonClicked(event: MouseEvent):void {
			for each (var index: int in _toList.selectedIndices){
				var item:Object = _toList.dataProvider.getItemAt(index);
				_toList.dataProvider.removeItemAt(index);
				_fromList.dataProvider.addItem(item);
			}
			removeButton.enabled = false;			
		}	

		/**
		 * Set the enabled status of addButton based on whether any item in 
		 * fromList has been selected
		 */
		private function _fromListSelectionChanged(event: ListEvent):void {
			addButton.enabled = (event.target as List).selectedItem != null;		
		}	
		
		/**
		 * Set the enabled status of removeButton based on whether any item in 
		 * toList has been selected
		 */
		private function _toListSelectionChanged(event: ListEvent):void {
			removeButton.enabled = (event.target as List).selectedItem != null;		
		}	

		/**
		 * Close the window by using PopUpManager.removePopUp method, but only
		 * if there is at least one item in toList
		 */
		private function windowClose(event: MouseEvent):void {
			if (_toList.dataProvider.length > 0){
				PopUpManager.removePopUp(this);
				_filtersPanel.filterChanged(null);
			}else
			    Alert.show("Selected list should have at least one item");
		}	

		/**
		 * Close the window, resetting the state of list boxes and buttons
		 */
		private function windowCancel(event: MouseEvent):void {
			resetWindowState();
			PopUpManager.removePopUp(this);
		}	
		
	}
}
