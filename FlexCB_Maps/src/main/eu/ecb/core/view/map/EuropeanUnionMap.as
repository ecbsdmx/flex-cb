// Copyright (C) 2010 European Central Bank. All rights reserved.
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
package eu.ecb.core.view.map
{
	import eu.ecb.core.event.XSMeasureSelectionEvent;
	import eu.ecb.core.util.helper.EUCountries;
	
	import flash.display.DisplayObject;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ilog.maps.MapEvent;
	import ilog.maps.MapFeature;
	
	import mx.collections.ArrayCollection;
	import mx.core.IToolTip;
	import mx.core.UIComponent;
	import mx.effects.Effect;
	import mx.effects.Fade;
	import mx.effects.Zoom;
	import mx.managers.ToolTipManager;
	
	import org.sdmx.model.v2.reporting.dataset.CodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.UncodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.reporting.dataset.XSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSObservationsCollection;
	import org.sdmx.model.v2.structure.keyfamily.XSMeasure;

	/**
 	 * Event triggered when a country of the european union has been selected 
 	 * on the map.
 	 * 
 	 * @eventType eu.ecb.core.view.dashboard.DashboardEvents.PANEL_MEASURE_SELECTED
 	 */
	[Event(name="panelMeasureSelected", type="flash.events.DataEvent")]
	
	/**
	 * The map for ECB visualisation tools that display country data on a map
	 * of the European Union.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class EuropeanUnionMap extends BaseMapComponent implements IMap
	{
		/*==============================Fields================================*/
		
		private var _map:EuropeMap;
		private var _mapLegend:IMapComponent;
		private var _euCountries:EUCountries;
		private var _dsCountries:ArrayCollection;
		private var _showDataTip:Boolean;
		private var _toolTip:IToolTip;
		private var _euroAreaCode:String;
		private var _splitEuroArea:Boolean;
		private var _observations:XSObservationsCollection;
		private var _effects:Object;
		private var _minimized:Object;
		private var _euroAreaOnly:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function EuropeanUnionMap(direction:String="horizontal")
		{
			super(direction);
			percentHeight = 100;
			percentWidth  = 100;
			_euCountries = new EUCountries();	
			_showDataTip = true;	
			_euroAreaCode = "U2";	
			_splitEuroArea = true;
			addEventListener(MouseEvent.ROLL_OUT, handleMouseOut);
			setStyle("horizontalGap", -4);
			_effects = new Object();
			_minimized = new Object();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Whether data tip should be displayed.
		 */ 
		public function set showDataTip(flag:Boolean):void
		{
			_showDataTip = flag;
		}
		
		/**
		 * The code used for the euro area (U2, I5, etc).
		 * 
		 * @param code 
		 */
		public function set euroAreaCode(code:String):void
		{
			_euroAreaCode = code;
		}
		
		/**
		 * Whether the data for the euro area should be displayed as a whole or 
		 * if it should be spli into its constituent countries. 
		 */ 
		public function set splitEuroArea(flag:Boolean):void
		{
			_splitEuroArea = flag;
			populateMap();
		}
		
		/**
		 * @private
		 */ 
		public function set mapLegend(legend:IMapComponent):void
		{
			_mapLegend = legend;
			if (getChildren().length == 2) {
				removeChildAt(0);
			}
			addChildAt(_mapLegend as DisplayObject, 0);
		}
		
		/**
		 * Returns the legend used by the map.
		 */ 
		public function get mapLegend():IMapComponent
		{
			return _mapLegend;	
		}
		
		/**
		 * Whether the map should display euro area countries only.
		 */ 
		public function set euroAreaOnly(flag:Boolean):void
		{
			_euroAreaOnly = flag;
			if (null != _map) {
				populateMap();
			}
		}
		
		/**
		 * Whether the fixed euro area composition should be used.
		 */ 
		public function set useFixedEuroAreaComposition(flag:Boolean):void
		{
			_euCountries.useFixedEuroAreaComposition = flag;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Handles the event that specifies whether the data for the euro area
		 * should be displayed as a whole or if it should be split into its
		 * constituent countries. 
		 * 
		 * @param event 
		 */
		public function handleGroupEuroAreaChanged(event:DataEvent):void
		{
			var flag:Boolean = (event.data == "true") ? true : false;
			if (_splitEuroArea != flag) { 
				_splitEuroArea = flag;
				populateMap();
			}
		}
		
		/**
		 * Handles the event that specifies whether only the euro area countries
		 * should be displayed. 
		 * 
		 * @param event 
		 */
		public function handleEuroAreaOnlyUpdated(event:DataEvent):void
		{
			var flag:Boolean = (event.data == "true") ? true : false;
			_euroAreaOnly = flag;
			if (null != _map) {
				populateMap();
			}
			if (_mapLegend is ECBMapLegend) {
				(_mapLegend as ECBMapLegend).handleEuroAreaOnlyUpdated(event);
			}
		}
		
		/*==========================Protected methods=========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (null == _map) {
				_map = new EuropeMap();
				_map.addEventListener(MapEvent.ITEM_ROLL_OVER, handleMouseOver);
				_map.addEventListener(MapEvent.ITEM_ROLL_OUT, handleMouseOut);
				_map.addEventListener(MouseEvent.CLICK, handleMapClicked);
				_map.styleName = "ecbMap";
				_map.allowMultipleSelection = true;
				_map.percentHeight = 100;
				_map.percentWidth  = 100;
				_map.setStyle("paddingTop", -10);
				addChild(_map);
				
				if (parent is UIComponent) {
					(parent as UIComponent).setStyle("paddingRight", -5);
					(parent as UIComponent).setStyle("paddingTop", 2);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitProperties():void
		{
			if (_dataSetChanged) {
				_dataSetChanged = false;
				_dsCountries = new ArrayCollection();
				if ((_dataSet as XSDataSet).groups.length > 1) {
					throw new ArgumentError("This cross-sectional view cannot" + 
						" handle more than one period at a time");
				} else if ((_dataSet as XSDataSet).groups.length == 0) {
					throw new ArgumentError("No data to be displayed");
				} else if (((_dataSet as XSDataSet).groups.getItemAt(0) as 
					XSGroup).sections.length > 1) {
					throw new ArgumentError("This cross-sectional view cannot" + 
						" handle more than one indicator at a time");
				} else if (((_dataSet as XSDataSet).groups.getItemAt(0) as 
					XSGroup).sections.length == 0) {
					throw new ArgumentError("No data to be displayed");	
				} else if ((((_dataSet as XSDataSet).groups.getItemAt(0) as 
					XSGroup).sections.getItemAt(0) as Section).observations.
					length == 0) {
					throw new ArgumentError("No data to be displayed");
				}
				_observations = (((_dataSet as 
					XSDataSet).groups.getItemAt(0) as XSGroup).sections.
					getItemAt(0) as Section).observations;
				populateMap();
				
				if (null != _mapLegend) {
					_mapLegend.dataSet = _dataSet;
				}
			}
			
			if (_isPercentageChanged) {
				_isPercentageChanged = false;
				if (null != _mapLegend) {
					_mapLegend.isPercentage = _isPercentage;
				}
			}
			
			if (_selectedDataSetChanged) {
				_selectedDataSetChanged = false;
				if (null != _selectedDataSet && 
					!(_selectedDataSet is XSDataSet)) {
					throw new ArgumentError("Should be a cross-sectional" + 
						" dataset");					
				}
				_highlightedDataSet = null;
				drawMap();
			}
			
			if (_selectedDateChanged) {
				_selectedDateChanged = false;
				_mapLegend.selectedDate = _selectedDate;
			}
			
			if (_highlightedDataSetChanged) {
				_highlightedDataSetChanged = false;
				if (null != _highlightedDataSet && 
					!(_highlightedDataSet is XSDataSet)) {
					throw new ArgumentError("Should be a cross-sectional" + 
						" dataset");					
				}
				drawMap();
			}
			
			super.commitProperties();
		}		
		
		/*==========================Private methods===========================*/
		
		private function populateMap():void
		{
			var euc:ArrayCollection = new ArrayCollection(
				_euCountries.euMembers.toArray().concat());	
			var euroAreaObs:XSObservation = 
				_observations.getObsByCode(_euroAreaCode);	
			var euValue:String = (euroAreaObs is UncodedXSObservation) ? 
				(euroAreaObs as UncodedXSObservation).value : 
				(euroAreaObs as CodedXSObservation).value.id;
			var minValue:Number;
			var maxValue:Number;			
			for each (var obs:XSObservation in _observations) {
				var countryCode:String;
				if (obs is UncodedXSObservation) {
					countryCode = 
						(obs as UncodedXSObservation).measure.code.id; 
				} else if (obs is CodedXSObservation) {
					countryCode = 
						(obs as CodedXSObservation).measure.code.id;
				}
				if (null == countryCode) {
					throw new ArgumentError("Reference area code not" + 
						" found");
				}
				if (!_euroAreaOnly || (_euroAreaOnly && _euCountries.
					belongsToEuroArea(countryCode, _selectedDate))) {
					_dsCountries.addItem(countryCode);
					var mapFeature:MapFeature = _map.getFeature(_euCountries.
						translateTwoLettersCode(countryCode));
					if (null != mapFeature) {
						if (null == _helper) {
							throw new ArgumentError("Helper cannot be null");
						}
						var value:Number = (obs is UncodedXSObservation) ? 
							Number((obs as UncodedXSObservation).value) :
							Number((obs as CodedXSObservation).value.id);	
						mapFeature.styleName = (_euCountries.belongsToEuroArea(
							mapFeature.key, _selectedDate) && !_splitEuroArea && 
							null != euValue) ?
							_helper.getStyleName(Number(euValue)) :  
							_helper.getStyleName(value); 
						if (mapFeature.key == "MLT") {
							mapFeature.setStyle("stroke", 
								uint(mapFeature.getStyle("fill")));
							mapFeature.setStyle("highlightStroke", 
								uint(mapFeature.getStyle("fill")));	
						}
						
						euc.removeItemAt(euc.getItemIndex(countryCode));
					}
				}
			}	
			for each (var missingCountry:String in euc) {
				var missingFeature:MapFeature = _map.getFeature(
					_euCountries.translateTwoLettersCode(missingCountry));
				if (null != missingFeature) {
					missingFeature.styleName = "disabledCountries";						
				}
			}
		}
		
		private function handleMouseOver(event:MapEvent):void
		{
			event.stopImmediatePropagation();
			if (_showDataTip && null != _dataSet) {
				var f:MapFeature = event.mapFeature;
				if ((_euroAreaOnly && _euCountries.
						belongsToEuroArea(f.key, _selectedDate)) || 
					(!_euroAreaOnly && _euCountries.belongsToEuropeanUnion(
					 _euCountries.translateThreeLettersCode(f.key)))) {
					f.highlighted = true;
					playEffect(f, "zoom", false);
					makeToolTip(f);	
				}
			}
			event = null;
		}
		
		private function handleMouseOut(event:Event):void
		{
			event.stopImmediatePropagation();
			if (event is MapEvent) {
				var f:MapFeature = (event as MapEvent).mapFeature;
				if (_euCountries.belongsToEuropeanUnion(_euCountries.
					translateThreeLettersCode(f.key))) {
					f.highlighted = false;
					playEffect(f, "zoom", true);	
				}
			}
			event = null;
			if (null != _toolTip) {
				ToolTipManager.destroyToolTip(_toolTip);
				_toolTip = null;
			}
		}
		
		private function handleMapClicked(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			if (null != _observations) {
				var feature:MapFeature = 
					_map.getFeatureAt(event.stageX, event.stageY);
				if (null != feature) {	
					if (!_euroAreaOnly || (_euroAreaOnly && _euCountries.
						belongsToEuroArea(feature.key, _selectedDate))) {
						var obs:XSObservation = _observations.getObsByCode(
							_euCountries.translateThreeLettersCode(
							feature.key));
						if (null != obs) {
							var measure:XSMeasure = 
								(obs is UncodedXSObservation) ? 
									(obs as UncodedXSObservation).measure : 
									(obs as CodedXSObservation).measure;
							dispatchEvent(new XSMeasureSelectionEvent(measure, 
								event.ctrlKey, "measureSelected"));
						}
					}
				} else {
					dispatchEvent(new XSMeasureSelectionEvent(null, false,
						"measureSelected"));
				}
			}
			event = null;
		}
		
		private function makeToolTip(country:MapFeature):void
		{
			var p:Point = country.barycenter;
			p = _map.latLongToCanvas(p);
			p = _map.drawingCanvas.localToGlobal(p);
			
			if (null != _observations) {
				var countryObs:XSObservation = _observations.getObsByCode(
					_euCountries.translateThreeLettersCode(country.key));
				if (null != countryObs) {
					var toolTipText:String;
					
					var countryText:String = 
						(countryObs is UncodedXSObservation) ? 
							(countryObs as UncodedXSObservation).measure.code.
								description.localisedStrings.
								getDescriptionByLocale("en") + ": " + 
								(countryObs as UncodedXSObservation).value : 
							(countryObs as CodedXSObservation).measure.code.
								description.localisedStrings.
								getDescriptionByLocale("en") + ": " + 
								(countryObs as CodedXSObservation).value.id;
					countryText = countryText + (_isPercentage ? "%" : " ");		
					
					if (_euCountries.belongsToEuroArea(country.key, 
						_selectedDate)) {
						var euObs:XSObservation = 
							_observations.getObsByCode(_euroAreaCode);
						var euText:String;	
						if (null != euObs) {
							euText = (euObs is UncodedXSObservation)? 
								(euObs as UncodedXSObservation).measure.code.
									description.localisedStrings.
									getDescriptionByLocale("en") + ": " + 
									(euObs as UncodedXSObservation).value : 
								(euObs as CodedXSObservation).measure.code.
									description.localisedStrings.
									getDescriptionByLocale("en") + ": " + 
									(euObs as CodedXSObservation).value.id;
							euText = euText + (_isPercentage ? "%" : " ");						
						}		
						toolTipText = (_splitEuroArea) ? 
							countryText + " (" + euText + ")" :
							euText + " (" + countryText +	")";
					} else {
						toolTipText = countryText;
					}
					
					_toolTip = 
						ToolTipManager.createToolTip(toolTipText, p.x, p.y);
				} else if (_euCountries.belongsToEuropeanUnion(country.key)){
					_toolTip = ToolTipManager.createToolTip(
						"Data not available", p.x, p.y);
				}	
			}
		}
		
		private function drawMap():void
		{
			// We first need to know which are the countries available in the 
			// selected and highlighted datasets
			var selCountries:ArrayCollection = new ArrayCollection();
			getSelectedCountries(_selectedDataSet as XSDataSet, selCountries);
			getSelectedCountries(_highlightedDataSet as	XSDataSet, selCountries) 
			
			//If the list contains the code for the euro area, we remove it
			if (selCountries.contains(_euroAreaCode)) {
				selCountries.removeItemAt(
					selCountries.getItemIndex(_euroAreaCode));
			}
			
			// Then we need to loop over all observations and decide whether the
			// country should be highlighted or not
			for each (var obs:XSObservation in _observations) {
				var countryCode:String;
				if (obs is UncodedXSObservation) {
					countryCode = 
						(obs as UncodedXSObservation).measure.code.id; 
				} else if (obs is CodedXSObservation) {
					countryCode = 
						(obs as CodedXSObservation).measure.code.id;
				}
				if (null == countryCode) {
					throw new ArgumentError("Reference area code not" + 
						" found");
				}
				var feature:MapFeature = _map.getFeature(_euCountries.
					translateTwoLettersCode(countryCode));			
				if (null != feature) {
					if (selCountries.length > 0 &&
						!(selCountries.contains(countryCode))) {
						if (!(_minimized.hasOwnProperty(countryCode)) || 
							!_minimized[countryCode]) {	
							playEffect(feature, "fade", false);
							_minimized[countryCode] = true;
						}
					} else if (selCountries.length > 0) {
						if (_minimized.hasOwnProperty(countryCode) 
							&& _minimized[countryCode]) {
							playEffect(feature, "fade", true);
							_minimized[countryCode] = false;
						}
					} else {
						if (_minimized.hasOwnProperty(countryCode) && 
							_minimized[countryCode]) {
							playEffect(feature, "fade", true);
							_minimized[countryCode] = false;
						}
					}
				}
			}
		}
		
		private function createEffect(type:String):Effect 
		{
			var effect:Effect;
			if (type == "fade") {
		    	effect = new Fade();
		    	(effect as Fade).alphaFrom = 1;
		    	(effect as Fade).alphaTo   = 0.3; 
		 	} else if (type == "zoom") {
			 	effect = new Zoom();
	      		(effect as Zoom).zoomWidthFrom = 1;
				(effect as Zoom).zoomWidthTo = 1.2; 
				(effect as Zoom).zoomHeightFrom = 1;
				(effect as Zoom).zoomHeightTo = 1.2; 
		 	} else {
		 		throw new ArgumentError("Unsupported effect type: " + type);
		 	}	
	    	effect.duration  = 600;
	    	return effect;
	    } 
	    
	    private function playEffect(target:MapFeature, type:String, 
	    	reverse:Boolean):void 
	    {   
	    	var effect:Effect;
	    	if (!(_effects.hasOwnProperty(type)) || 
	    		!(_effects[type].hasOwnProperty(target))) {
	        	effect = createEffect(type);
	        	if (!(_effects.hasOwnProperty(type))) {
	        		_effects[type] = new Object();
	        	}         
	        	_effects[type][target] = effect;
	      	} else {
	      		effect = _effects[type][target];
	      	}
	      	if (effect.isPlaying) {
		        effect.reverse();
		    } else {
	    	    effect.play([target], reverse);
			}
	    }
	    
	    private function getSelectedCountries(ds:XSDataSet, 
	    	countries:ArrayCollection):void
	    {
	       	if (null != ds) {
	    		var obsColl:XSObservationsCollection = ((ds.groups.getItemAt(0) 
	    			as XSGroup).sections.getItemAt(0) as Section).observations;
				for each (var obs:XSObservation in obsColl) {
					var cc:String = (obs is UncodedXSObservation) ? 
						(obs as UncodedXSObservation).measure.code.id :  
						(obs as CodedXSObservation).measure.code.id;
					if (null == cc) {
						throw new ArgumentError("Reference area code not" + 
							" found");
					}
					if (cc != "U2" || cc != "I5") {
						countries.addItem(cc);
					}
				}
	       	}
	    }
	}
}