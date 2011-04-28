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
package eu.ecb.core.view.filter
{
	import eu.ecb.core.view.BaseSDMXServiceView;
	import eu.ecb.core.view.panel.DataStructureWindow;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.List;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.controls.Spacer;
	import mx.events.ItemClickEvent;
	import mx.managers.PopUpManager;
	
	import org.sdmx.event.SDMXQueryEvent;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.reporting.provisioning.CubeRegion;
	import org.sdmx.model.v2.reporting.provisioning.MemberSelection;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.stores.api.SDMXQueryParameters;
		
	/**
	 * Event dispatched when a selection has been made on the dimensions filters
	 * panel.
	 * 
	 * @eventType eu.ecb.core.view.filter.DataflowsFilters.QUERY_SUBMITTED
	 */
	[Event(name="categorySchemesUpdated", type="org.sdmx.api.SDMXQueryEvent")]

	/**
	 * This component displays dataflow information, as well as the constraints
	 * attached to a dataflow.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class DataflowsFilters extends BaseSDMXServiceView
	{
		
		/*=============================Constants==============================*/
		
		/**
		 * The DataflowsFilters.QUERY_SUBMITTED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>querySubmitted</code> event.
		 * 
		 * @eventType querySubmitted
		 */
		public static const QUERY_SUBMITTED:String = "querySubmitted";
			
		/*==============================Fields================================*/
			
		private var _dataflowsPanel:Panel;
		private var _buttonsGroup:RadioButtonGroup;
		private var _filtersPanel:Panel;
		private var _form:Form;
		private var _status:Label;
		private var _kfWindow:DataStructureWindow;
		
		/*===========================Constructor==============================*/
		
		public function DataflowsFilters(direction:String="vertical")
		{
			super(direction);
			setStyle("paddingTop", 5);
			setStyle("paddingRight", 5);
			percentWidth = 100;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function createChildren():void
		{
			if (null == _dataflowsPanel) {
				_dataflowsPanel = new Panel();
				_dataflowsPanel.styleName = "filters";
				_dataflowsPanel.title = "Available dataflows";
				_dataflowsPanel.percentWidth = 100;
				_dataflowsPanel.visible = false;
				addChild(_dataflowsPanel);
			}
			
			if (null == _filtersPanel) {
				_filtersPanel = new Panel();
				_filtersPanel.styleName = "filters";
				_filtersPanel.title = "Filter options";
				_filtersPanel.percentWidth = 100;
				_filtersPanel.visible = false;
				addChild(_filtersPanel);
			}
			
			if (null == _status) {
				_status = new Label();
				_status.height = 0;
				_status.visible = false;
				_filtersPanel.addChild(_status);
			}
			
			if (null == _form) {
				_form = new Form();
				_form.percentWidth = 100;
				_filtersPanel.addChild(_form);
			}
			
			if (null == _buttonsGroup) {
				_buttonsGroup = new RadioButtonGroup();
				_buttonsGroup.addEventListener(ItemClickEvent.ITEM_CLICK,
					handleDataflowChanged);
			}
						
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			if (_dataflowsChanged) {
				_dataflowsChanged = false;
				_dataflowsPanel.removeAllChildren();
				for (var i:uint = 0; i < _dataflows.length; i++) {
					var row:HBox = new HBox();
					_dataflowsPanel.addChild(row); 
					var dataflow:DataflowDefinition = 
						_dataflows.getItemAt(i) as DataflowDefinition;
					var button:RadioButton = new RadioButton();
					button.group = _buttonsGroup;
					button.label = dataflow.name.localisedStrings.
						getDescriptionByLocale("en");
					button.id = dataflow.id;	
					if (i == 0) {	
						button.selected = true;
					}	
					row.addChild(button);
					var link:LinkButton = new LinkButton();
					link.label = "(View data structure definition)";
					link.addEventListener(MouseEvent.CLICK, 
						handleKFLinkClicked);
					link.data = dataflow;	
					row.addChild(link);	
				}
				_dataflowsPanel.visible = true;
				createFilterPanel(_dataflows.getItemAt(0) 
					as DataflowDefinition);
			}			
		}
		
		/*==========================Private methods===========================*/
		
		private function handleDataflowChanged(event:ItemClickEvent):void
		{
			var dataflow:DataflowDefinition = 
				_dataflows.getDataflowById((event.relatedObject as 
				RadioButton).id, null, null);
			if (null != dataflow) {
				createFilterPanel(dataflow);
			} 	
			_dataSet = null;
		}
		
		private function createFormItem(member:MemberSelection, 
			keyFamily:KeyFamily):FormItem 
		{
			var formItem:FormItem = new FormItem();
			formItem.percentWidth = 100;
			var dimension:Dimension = keyFamily.keyDescriptor.getDimension(
				member.structureComponent.id) as Dimension;
			formItem.label = dimension.conceptIdentity.name.localisedStrings.
				getDescriptionByLocale("en") + " (" + member.values.length + 
				"): ";
			formItem.id = member.structureComponent.id;	
			var dataProvider:ArrayCollection = new ArrayCollection();
			for each(var value:String in member.values) {
				var item:Object = new Object();
				item["label"] = (dimension.localRepresentation as CodeList).
					codes.getCode(value).description.localisedStrings.
					getDescriptionByLocale("en");
				item["id"] = value;
				dataProvider.addItem(item);		
			}
			var filterBox:List = new List();
			filterBox.id = member.structureComponent.id;
			filterBox.dataProvider = dataProvider;
			filterBox.variableRowHeight = true;
			filterBox.wordWrap = true;
			filterBox.rowCount = 2;
			filterBox.percentWidth = 100;
			filterBox.height = 45;
			formItem.addChild(filterBox);
			return formItem;
		}
		
		private function createFilterPanel(dataflow:DataflowDefinition):void
		{
			_form.removeAllChildren();
			_form.id = dataflow.id;
			
			if (_filtersPanel.getChildren().length > 2) {
				_filtersPanel.removeChildAt(2);
			}
			if (null != dataflow.contentConstraint && null != 
				dataflow.contentConstraint.permittedContentRegion) {
				var hasMembers:Boolean;
				for each (var cube:CubeRegion in dataflow.
					contentConstraint.permittedContentRegion) {
					if (null != cube.members && cube.members.length > 0) {	
						for each (var member:MemberSelection in 
							cube.members) {
							if (member.values.length > 1) {
								hasMembers = true;
								_form.addChild(createFormItem(member, 
									dataflow.structure as KeyFamily));
							}
						}
					}	
				}	
				if (hasMembers) {
					var lastRow:HBox = new HBox();
					lastRow.percentWidth = 100;
					_filtersPanel.addChild(lastRow);
					
					var spacer:Spacer = new Spacer();
					spacer.percentWidth = 100;
					lastRow.addChild(spacer);
					
					var submitButton:Button = new Button();
					submitButton.width = 80;
					submitButton.label = "Submit"
					lastRow.addChild(submitButton);
					
					submitButton.addEventListener(MouseEvent.CLICK, 
						submitChanges);
						
					_status.height = 0;
					_status.visible = false;
				} else {
					_status.height = 20;
					_status.visible = true;
					_status.text = "There is no data available for this" 
							+ " dataflow.";	
				}
				_filtersPanel.visible = true;			
			}
		}
		
		private function handleKFLinkClicked(event:MouseEvent):void
		{
			_kfWindow = PopUpManager.createPopUp(this.parent, 
				DataStructureWindow, false) as DataStructureWindow;
			_kfWindow.keyFamily = ((event.currentTarget as LinkButton).data as 
				DataflowDefinition).structure as KeyFamily; 
			PopUpManager.centerPopUp(_kfWindow);
		} 
		
		private function submitChanges(event:MouseEvent):void
		{
			var query:Object = new Object();
			event.stopImmediatePropagation();
			event = null;
			var hasFilters:Boolean;
			
			var params:SDMXQueryParameters = new SDMXQueryParameters();
			
			for each (var dataflow:DataflowDefinition in _dataflows) {
				if (dataflow.id == _form.id) {
					params.dataflow = dataflow;
					break
				}
			}
			 
			var collection:KeyValuesCollection = new KeyValuesCollection(); 
			for each (var formItem:FormItem in _form.getChildren()) {
				var list:List = formItem.getChildAt(0) as List;
				var dimension:Dimension = new Dimension(formItem.id, 
					new Concept(formItem.id));
				
				for each (var item:Object in list.selectedItems) {
					collection.addItem(new KeyValue(new Code(item.id), 
						dimension));
					hasFilters = true;
				}
			}
			params.criteria = collection;
			if (hasFilters) {
				dispatchEvent(new SDMXQueryEvent(params, QUERY_SUBMITTED));
			}
		}
	}
}