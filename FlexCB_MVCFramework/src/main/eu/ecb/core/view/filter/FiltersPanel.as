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
package eu.ecb.core.view.filter
{
	import eu.ecb.core.view.BaseSDMXView;
	
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.containers.FormItemDirection;
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.events.ListEvent;
	
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
	import org.sdmx.model.v2.structure.code.Code;

	/**
	 * Event triggered when the selected series key has been updated.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.DataReaderAdapter.DATASET_EVENT
	 */
	[Event(name="seriesKeyChanged", type="org.sdmx.event.DataEvent")]
	
	/**
	 * This component displays a panel containing a form. The form allows to
	 * change the selected data by changing the values of the dimensions
	 * displayed. The form will not allow combination of dimension values which 
	 * would lead to no results.
	 * 
	 * Upon initialisation, the component needs to receive:
	 * 1. A collection containing all series available in the dataset.
	 * 2. The series being currently selected.
	 * 
	 * When the user presses the submit button, the component will dispatch
	 * a Flex data event ("seriesKeyChanged"), containing the series key of the 
	 * desired series.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	[ResourceBundle("flex_cb_mvc_lang")]
	public class FiltersPanel extends BaseSDMXView 
	{
		
		/*=============================Constants==============================*/
		
		/**
		 * The DataReaderAdapter.SERIES_KEY_CHANGED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>seriesKeyChanged</code> event.
		 * 
		 * @eventType seriesKeyChanged
		 */
		 public static const SERIES_KEY_CHANGED:String = "seriesKeyChanged";
		
		/*==============================Fields================================*/
		
		private var _form:Form;
		
		/**
		 * The collection of all cube regions available for the supplied 
		 * dataset. The variable contains all possible values and is
		 * recalculated when a new dataset is supplied to the panel.
		 */ 
		private var _initialCubeRegions:Object;
		
		/**
		 * The collection of cube regions displayed in the filters. This will 
		 * be the same, when the application starts up but will then be
		 * updated and reflect selections made by users. 
		 */
		private var _cubeRegions:Object;
		
		/**
		 * The filters selected by the user. 
		 */
		private var _selectedFilters:Object;
		
		private var _isInitialization:Boolean;
		
		private var _panel:Panel;
		
		private var _submitButton:Button;
		
		/*===========================Constructor==============================*/

		public function FiltersPanel(direction:String = "horizontal") {
			super(direction);
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * inheritDoc
		 */
		override protected function resourcesChanged():void 
		{
			if (!initialized) return;
			super.resourcesChanged();
			_panel.title = resourceManager.getString("flex_cb_mvc_lang", 
				"FiltersPanel_filter_options");
			_submitButton.label = resourceManager.getString("flex_cb_mvc_lang", 
				"FiltersPanel_submit");	
		}
		
		/**
		 * inheritDoc
		 */
		override protected function commitProperties():void
		{
			if (_fullDataSetChanged) {
				_fullDataSetChanged = false;
				_isInitialization = true;
			}
			
			if (_referenceSeriesChanged) {
				_referenceSeriesChanged = false;
				if (_isInitialization && null != _fullDataSet && 
					null != _fullDataSet.timeseriesKeys && 
					0 < _fullDataSet.timeseriesKeys.length) {
					populateFilters();
					if (populateCubeRegions(_fullDataSet.timeseriesKeys)) {
						createFilterPanel();
					}
					_isInitialization = false;
				}	
			}
			
			super.commitProperties();
		}
		
		/*=========================Private methods============================*/
		
		//Populate methods
		/**
		 * Method called at start up, that builds the set of cube regions. 
		 * It goes over all dimensions and finds all codes available in the list 
		 * of series for all dimensions.
		 * 
		 * At start up the _initialCubeRegions and the _cubeRegions variables
		 * contain the same data.
		 */ 
		private function populateCubeRegions(
			matchingSeries:TimeseriesKeysCollection):Boolean 
		{
			var hasFilters:Boolean = false;
			_initialCubeRegions = new Object();			
			_cubeRegions = new Object();
			if (matchingSeries != null) {
				for each (var series:TimeseriesKey in matchingSeries) {
					for each (var keyValue:KeyValue in series.keyValues) {
						if (!(_cubeRegions.hasOwnProperty(keyValue.valueFor.
							conceptIdentity.id))) {
							_cubeRegions[keyValue.valueFor.
								conceptIdentity.id] = 
								new ArrayCollection([keyValue.value]);
						} else {
						 	if (!((_cubeRegions[keyValue.valueFor.
						 		conceptIdentity.id] as ArrayCollection).
						 		contains(keyValue.value))) {
						 		(_cubeRegions[keyValue.valueFor.
						 			conceptIdentity.id] as ArrayCollection).
						 			addItem(keyValue.value);
						 		hasFilters = true;
						 	}
						}	
					}
				}	
				for (var dim:String in _cubeRegions) {
					_initialCubeRegions[dim] = new ArrayCollection(
						(_cubeRegions[dim] as ArrayCollection).toArray());
				}
			}
			return hasFilters;
		}	
		
		/**
		 * Method that builds the initial set of filters. The method is called
		 * at startup. It will build an object with all possible dimensions are
		 * set to the default value of null.
		 */ 
		private function populateFilters():void 
		{
			_selectedFilters = new Object();
			for each (var keyValue:KeyValue in _referenceSeries.keyValues) {
				_selectedFilters[keyValue.valueFor.conceptIdentity.id] = null;
			}
		}
		
		//Display methods
		/**
		 * Method that builds the panel containing the filters. The method is
		 * called at startup, only if we have more than one possible code for 
		 * at least one cube region. 
		 */ 
		private function createFilterPanel():void 
		{
			var form:Form = new Form();
			
			//We loop over the dimensions. For each of the dimensions, if we 
			//have more than one code in the list of available cube regions,
			//we display a combo box with the list of available values.
			var dimensionNumber:uint = 0;
			for each (var keyValue:KeyValue in _referenceSeries.keyValues) {
				if ((_cubeRegions[keyValue.valueFor.conceptIdentity.id] as 
					ArrayCollection).length > 1) {
					form.addChild(createFormItem(keyValue, dimensionNumber));
				}
				dimensionNumber++;
			}

			//We add a submit button to the last form item			
			var lastFormItem:FormItem = 
				form.getChildAt(form.getChildren().length - 1) as FormItem;
			lastFormItem.direction = FormItemDirection.HORIZONTAL;	
			lastFormItem.addChild(createSubmitButton());

			//We add the form to the panel and we store it in memory
			_form = form;
			removeAllChildren();
			addChild(createPanel(_form));
		}
		
		private function createFormItem(keyValue:KeyValue, 
			dimensionNumber:uint):FormItem 
		{
			var formItem:FormItem = new FormItem();
			formItem.label = keyValue.valueFor.conceptIdentity.name.
				localisedStrings.getDescriptionByLocale("en") + ":";
			var dataProvider:ArrayCollection = new ArrayCollection();
			var codeNumber:uint = 0;
			var selectedCodeIndex:uint = 0;
			for each(var code:Code in _cubeRegions[keyValue.valueFor.
				conceptIdentity.id] as ArrayCollection) {
				var item:Object = new Object();
				item["label"] = code.description.localisedStrings.
					getDescriptionByLocale("en");
				item["id"] = code.id;
				if ((_referenceSeries.keyValues.getItemAt(dimensionNumber) as 
					KeyValue).value.id == code.id) {
					selectedCodeIndex = codeNumber;
				} 
				dataProvider.addItem(item);		
				codeNumber++;
			}
			var filterBox:ComboBox = new ComboBox();
			filterBox.id = keyValue.valueFor.conceptIdentity.id as String;
			filterBox.rowCount = 10;
			filterBox.dataProvider = dataProvider;
			filterBox.width = 460;
			filterBox.selectedIndex = selectedCodeIndex;
			filterBox.addEventListener("change", filterChanged);
			formItem.addChild(filterBox);
			return formItem;
		}
		
		private function createSubmitButton():Button 
		{
			var submitButton:Button = new Button();
			//submitButton.width = 100;
			submitButton.label = resourceManager.getString("flex_cb_mvc_lang", 
				"FiltersPanel_submit");
			submitButton.addEventListener(MouseEvent.CLICK, submitChanges);
			_submitButton = submitButton;
			return _submitButton;
		}
		
		private function createPanel(form:Form):Panel 
		{
			var panel:Panel = new Panel();
			panel.title = resourceManager.getString("flex_cb_mvc_lang", 
				"FiltersPanel_filter_options");
			panel.layout = "vertical";
			panel.styleName = "filters";
			panel.width = width;
			panel.addChild(form);
			_panel = panel
			return _panel;
		}
		
		//Event methods
		/**
		 * This method builds the series key and dispatchs an event with the
		 * key. It is called when the submit button is pressed.
		 */ 
		private function submitChanges(event:MouseEvent):void 
		{
			var query:String = "";
			var formItemNumber:uint = 0;
			for each (var keyValue:KeyValue in _referenceSeries.keyValues) {
				if ((formItemNumber < _form.getChildren().length) && 
					(((_form.getChildAt(formItemNumber) as FormItem).
						getChildAt(0) as ComboBox).id == keyValue.valueFor.
						conceptIdentity.id)) {
					query = query + "." + 
						((_form.getChildAt(formItemNumber) as FormItem).
						getChildAt(0) as ComboBox).selectedItem.id;
					formItemNumber++;
				} else {
					query = query + "." + ((_cubeRegions[keyValue.valueFor.
						conceptIdentity.id] as ArrayCollection).getItemAt(0) as 
						Code).id;
				}
			}
			query = query.substr(1, query.length);
			dispatchEvent(new DataEvent(SERIES_KEY_CHANGED, false, false, 
				query));
		}
		
		/**
		 * This method is called each time a choice is made in one of the 
		 * combo boxes. It rebuilds the list of filters based on the new 
		 * choices so that combinations of code leading to no data cannot be
		 * made.
		 */ 
		private function filterChanged(event:ListEvent):void 
		{
			//We add the filter selected by the user to the list of selected 
			//filters
			_selectedFilters[event.target.id] = event.target.selectedItem;

			//We need to get the list of matching series, based on the updated
			//filters and then update the cube regions. We first reset the 
			//values in cube regions to the list of all possible values.
			for (var dim:String in _cubeRegions) {
				_cubeRegions[dim] = new ArrayCollection(
					(_initialCubeRegions[dim] as ArrayCollection).toArray());
			}
			findMatchingSeries();
			
			var formItemCount:uint = 0;
			for each (var keyValue:KeyValue in _referenceSeries.keyValues) {
				if (formItemCount < _form.getChildren().length) {
					var formItem:ComboBox = (_form.getChildAt(formItemCount) as 
						FormItem).getChildAt(0) as ComboBox;
					if (formItem.id == keyValue.valueFor.conceptIdentity.id) {
						var dataProvider:ArrayCollection = 
							new ArrayCollection();
						var codeNumber:uint = 0;
						var selectedCodeIndex:uint = 0;
						for each(var code:Code in _cubeRegions[keyValue.
							valueFor.conceptIdentity.id] as ArrayCollection) {
							var item:Object = new Object();
							item["label"] = code.description.localisedStrings.
								getDescriptionByLocale("en");
							item["id"] = code.id;
							if (formItem.selectedItem.id == code.id) {
								selectedCodeIndex = codeNumber;
							} 
							dataProvider.addItem(item);		
							codeNumber++;
						}
						formItem.dataProvider = dataProvider;
						formItem.selectedIndex = selectedCodeIndex;
						formItem.enabled = dataProvider.length > 1;
						formItemCount++;
					}	
				}
			}
		}
		
		/**
		 * For all the filters that have been selected, we need to find the 
		 * collection of matching series. Important note: Filters are applied
		 * individually and not combined (so we have ONE collection of matching
		 * series PER filter selected, instead of ONE collection of series 
		 * matching the combination of filters).
		 */
		private function findMatchingSeries():void {
			for (var filter:String in _selectedFilters) {	
				if (null != _selectedFilters[filter]) {
					var matchingSeries:TimeseriesKeysCollection = 
						new TimeseriesKeysCollection();
					for each (var series:TimeseriesKey in 
						_fullDataSet.timeseriesKeys) {
						var added:Boolean = true;
						for each (var keyValue:KeyValue in series.keyValues) {
							if (filter == keyValue.valueFor.
								conceptIdentity.id	&& keyValue.value.id != 
								_selectedFilters[filter].id) {
								added = false;
								break;
							}
						}
						if (added) {
							matchingSeries.addItem(series);			
						}
					}
					applyFilter(matchingSeries, filter);
				}
			}	
		}
		
		/**
		 * For all the dimensions other than the filtered dimension, we build
		 * a collection of values available in the collection of matching 
		 * series. By doing so, we guarantee that only filters that lead to
		 * data can be selected. 
		 */
		private function applyFilter(matchingSeries:ArrayCollection, 
			filter:String):void
		{
			var filters:Object = new Object();
			for each (var series:TimeseriesKey in matchingSeries) {
				for each (var keyValue:KeyValue in series.keyValues) {
					if (keyValue.valueFor.conceptIdentity.id != filter) {
						if (!(filters.hasOwnProperty(keyValue.valueFor.
							conceptIdentity.id))) {
							filters[keyValue.valueFor.
								conceptIdentity.id] = 
								new ArrayCollection([keyValue.value]);
						} else {
						 	if (!((filters[keyValue.valueFor.
						 		conceptIdentity.id] as ArrayCollection).
						 		contains(keyValue.value))) {
						 		(filters[keyValue.valueFor.
						 			conceptIdentity.id] as ArrayCollection).
						 			addItem(keyValue.value);
						 	}
						}	
					}
				}
			}
			
			// Once all possible values are known, we update the collection
			// of filters used in the GUI.
			for (var slice:String in _cubeRegions) {
				var collection:ArrayCollection = new ArrayCollection(
					(_cubeRegions[slice] as ArrayCollection).toArray());
				for each (var item:Object in collection) {
					if (null != filters[slice] &&
						!((filters[slice] as ArrayCollection).contains(item))) {
						(_cubeRegions[slice] as ArrayCollection).removeItemAt(
							(_cubeRegions[slice] as ArrayCollection).
							getItemIndex(item));
					}
				}
			}
		}
	}
}