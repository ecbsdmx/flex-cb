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
	import eu.ecb.core.util.helper.SeriesColors;
	
	import flash.events.MouseEvent;
	
	import mx.charts.AxisRenderer;
	import mx.charts.LineChart;
	import mx.charts.series.LineSeries;
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.controls.VRule;
	import mx.core.ClassFactory;
	import mx.graphics.Stroke;
	
	import org.sdmx.model.v2.base.LocalisedString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	
	import qs.charts.DashedLineRenderer;
	
	/**
	 * This component displays codes for certain dimension and supports
	 * filtering according to given dimension. It is visually represented as
	 * as check box.
	 *  
	 * @author Rok Povse
	 * @author Steven Bagshaw
	 */
	public class CheckBoxDimensionFilter extends DimensionFilter
	{
		/*==============================Fields================================*/
		
		private var _checkBoxes:ArrayCollection;
		private var _checkBoxesContainers:ArrayCollection;
		private var _columns:ArrayCollection; //SBa - just for cleanup - TODO is this needed???
		private var _coloredCheckboxes:Boolean;
		private var _colorByCode:Boolean; //SBa
		private var _numColumns:Number; //SBa
		private var _greyOutCodes:Boolean; //SBa
		private var _codesInitialised:Boolean; //SBa
		private var _colorCheckboxesDirection:String; //SBa
		
		/*===========================Constructor==============================*/
		
		public function CheckBoxDimensionFilter(direction:String="vertical")
		{
			super(direction);
			_checkBoxes = new ArrayCollection();
			_checkBoxesContainers = new ArrayCollection();
			_columns = new ArrayCollection(); //SBa
			_numColumns = 1; //SBa
			_greyOutCodes = false; //SBa
			_codesInitialised = false; //SBa
			_colorCheckboxesDirection = "horizontal"; //SBa
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function get allowMultipleSelection():Boolean{
			return true;
		}
		
		public function get greyOutCodes():Boolean{
			return _greyOutCodes;
		}
		
		/**
		 * Whether a vertical color bar should be added to the checkbox, 
		 * thereby making it act as a legend.
		 *  
		 * @param value
		 */
		public function set colouredCheckBoxes(value:Boolean):void {
			_coloredCheckboxes = value;
		}	
		
		/**
		 * Whether the colour associated with a particular code should be based
		 * on the code name. If false, then it will just be based on 
		 * the index of the code in the array.
		 * 
		 * @param value
		 */
		public function set colorByCode(value:Boolean):void {
		    _colorByCode = value; //SBa
		}
		
		/**
		 * Set the number of columns the codes should appear in.
		 * 
		 * @param value
		 */
		public function set numColumns(value:Number):void {
		    _numColumns = value; //SBa
		}
		
		public function set greyOutCodes(value:Boolean): void {
		    _greyOutCodes = value;
		}
		
		/**
		 * When checkboxes are coloured, the colour indicator can 
		 * appear on a horizontal or vertical orientation to 
		 * the checkbox.
		 * 
		 * @param value currently "vertical" or "horizontal"
		 */
		public function set colorCheckboxesDirection(value:String): void {
		    _colorCheckboxesDirection = value;
		}
		
		/**
		 * We override the super function, which just displays all codes and
		 * all of them as selected. Here we want to grey out any codes
		 * not specified initially, but otherwise leave the interface intact.
		 * 
		 * This is however an option. By default, the super will be called. 
		 * 
		 * @param codes
		 */
		override public function set displayedCodes(codes:ArrayCollection):void
		{
			if (!_greyOutCodes || !_codesInitialised) {
			    _codesInitialised = true;
			    super.displayedCodes = codes;
			    return;
			}
			
			for each (var checkbox:CheckBox in _checkBoxes) {
			    var active:Boolean = false;
			    
			    for each (var codeID:String in codes) {
			        if (codeID == checkbox.id) {
			            active = true;
			            break;
			        }
			    }
			    
			    checkbox.enabled = active;
			}
		}
		
		/*==========================Protected methods========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function drawComponent(codes:CodeList,
			displayCodes:ArrayCollection):void {				
			addCheckBoxesWithItems(codes,displayCodes);
		}
		
		/**
		 * Cleans the LinkBar or Checkboxes
		 */ 
		override protected function cleanAll():void 
		{
			//clean all checkboxes
			if (_checkBoxes.length > 0) {
					
				for each (var cb:CheckBox in _checkBoxes) {
					cb.removeEventListener(MouseEvent.CLICK,
						checkBoxClickHandler);
				}
				
				for each (var container:Box in _checkBoxesContainers) {
					cb.removeEventListener(MouseEvent.CLICK,
						checkBoxClickHandler);
					container.removeAllChildren();
					//this.removeChild(container); SBa - container is now a child of the column
				}
				
				//start SBa
				for each (var col:VBox in _columns) {
				    col.removeAllChildren();
				    this.removeChild(col);
				}
				//end SBa
				
				_checkBoxes.removeAll();
				_checkBoxesContainers.removeAll();
			}			
		}
		
		/*===========================Private methods==========================*/
		
		/**
		 * Adds checkboxes representing displayedCodes
		 */ 
		private function addCheckBoxesWithItems(codes:CodeList,
		 displayCodes:ArrayCollection = null):void {
			
			var checkBox:CheckBox;
			var index:uint = 0;
			var columns:ArrayCollection = new ArrayCollection();
			
			for (var i:int = 0; i < _numColumns; i++) {
			    columns.addItem(new VBox());
			}
			
			for each (var displayedCode:String in displayCodes) {
				var code:Code = codes.codes.getCode(displayedCode);
				
				if (code != null) {
					var container:Box;
					
					if (_colorCheckboxesDirection == "vertical") {
					    container = new VBox();
					    container.setStyle("verticalAlign", "top");
					}
					else {
					    container = new HBox();	
					    container.setStyle("verticalAlign","middle");
					}
					
					checkBox = new CheckBox();
					checkBox.label = (code.description.
						localisedStrings.getItemAt(0) as LocalisedString).label;
					checkBox.styleName = "textBox";
					checkBox.id = code.id; //added by SBa to ease greying out
					checkBox.addEventListener(MouseEvent.CLICK,
						checkBoxClickHandler,false,0,true);
					
					if (_selectedCodes.contains(displayedCode)) {
						checkBox.selected = true;
					}
					
					if (_coloredCheckboxes) {
						//TODO: coloring should rely on series key rather than
						//indexes in case the series are sorted differently
						//(but... can this be done, as we don't know the series here???)
						
						//start SBa
						//var codeColor:uint = SeriesColors.getColors().getItemAt(index) as uint;
						var codeColor:uint;
						var line:LineSeries = new LineSeries();
						
						if (_colorByCode)
						{
						    codeColor = SeriesColors.getColorForCode(code.id);
						        
						    //make a fake time series to produce a straight line    
						    var zzData:ArrayCollection = new ArrayCollection([
                                {val:0},
                                {val:0}
                            ]);

						    var lineChart:LineChart = new LineChart();
						    lineChart.dataProvider = zzData;
						    lineChart.height = 8;
						    lineChart.width = 100;
						    lineChart.setStyle("paddingLeft", -16);
						    //this makes the line come down close to the text
						    lineChart.setStyle("paddingBottom", -14); 
						    
						    checkBox.setStyle("paddingTop", -5);
						    //without this, hanging g q etc letters get cut off
						    checkBox.setStyle("paddingBottom", 3); 
                             
				            //hide axes
            				var horizontalAxisRenderer:AxisRenderer = new AxisRenderer();
            				lineChart.horizontalAxisRenderer = horizontalAxisRenderer;
            				lineChart.horizontalAxisRenderer.visible = false;
            				var verticalAxisRenderer:AxisRenderer = new AxisRenderer();
            				verticalAxisRenderer.placement = "top";
            				verticalAxisRenderer.alpha = 0;
            				lineChart.verticalAxisRenderer = verticalAxisRenderer;
            				lineChart.verticalAxisRenderer.visible = false;
            				
            				//hide grid lines
                            lineChart.backgroundElements = new Array();
				            
				            //hide series line shadow
				            lineChart.seriesFilters = new Array();
				
						    line.yField = "val";
						    line.dataProvider = zzData;

						    var cf:ClassFactory = new ClassFactory(qs.charts.DashedLineRenderer);
                            cf.properties = SeriesColors.getPatternForCode(code.id);
                            line.setStyle("lineSegmentRenderer", cf);
                            line.interpolateValues = true;
                            
                            var arr:Array = new Array();
                            arr.push(line);
                            lineChart.series = arr;
                            
                            var stroke:Stroke = new Stroke();
						    stroke.color = codeColor; 
						    
						    var weight:uint = SeriesColors.getWeightForCode(code.id);
						    stroke.weight = weight == 1 ? 2 : weight;
						    line.setStyle("lineStroke", stroke);
						    
						    container.addChild(lineChart);
						}
						else
						{
						    codeColor = SeriesColors.getColorByIndex(index); 
						    var verticalLine:VRule = new VRule();
    						verticalLine.setStyle("strokeColor", codeColor);
    						verticalLine.setStyle("shadowColor", codeColor);
    						verticalLine.opaqueBackground = codeColor;
    						verticalLine.setStyle("strokeWidth", 4);
    						verticalLine.height=19;
    						
    						container.addChild(verticalLine);
						}
					}
					
					_checkBoxes.addItem(checkBox);
					container.addChild(checkBox);
				    _checkBoxesContainers.addItem(container);
				    this.addChild(container); 
					
					(columns.getItemAt(index % _numColumns) as VBox).addChild(container); //SBa
					
					index++;
				}
				else {
					throw new ArgumentError("Unknown code " + displayedCode);
				}
			}
			
			this.setStyle("verticalAlign","top");
			
			for each (var col:VBox in columns) {
			    this.addChild(col);
			    _columns.addItem(col);
			}
		}
		
		private function checkBoxClickHandler(event:MouseEvent):void {
			event.stopImmediatePropagation();
			
			_selectedCodes = new ArrayCollection();
			
			for (var i:int=0;i<_checkBoxes.length;i++) {
				if ((_checkBoxes.getItemAt(i) as CheckBox).selected) {
					_selectedCodes.addItem(_displayedCodes.getItemAt(i));
				}
			}
			
			if (_selectedCodes.length == 0) {
				_selectedCodes.addItem(_displayedCodes.getItemAt(
					_checkBoxes.getItemIndex(event.currentTarget as CheckBox)));
				(event.currentTarget as CheckBox).selected = true;
			}
			else {
				dispachFilterEvent();
			}
		}
	}
}