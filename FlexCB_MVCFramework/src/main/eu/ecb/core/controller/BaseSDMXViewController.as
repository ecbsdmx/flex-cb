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
package eu.ecb.core.controller
{
	import eu.ecb.core.event.XSMeasureSelectionEvent;
	import eu.ecb.core.model.ISDMXViewModel;
	
	import flash.events.DataEvent;
	
	import org.sdmx.stores.api.ISDMXDaoFactory;

	/**
	 * Base implementation of the ISDMXViewController interface.
	 * 
	 * It implements methods commonly needed by views, such 
	 * as handling changes of periods, or handling dragging a data chart.
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */
	public class BaseSDMXViewController extends BaseSDMXServiceController 
		implements ISDMXViewController
	{	
		/*===========================Constructor==============================*/
		
		/**
		 * Instantiates a new instance of the Base SDMX view controller.
		 *  
		 * @param model The model that will be populated with data returned by
		 * the SDMX data providers.
		 * @param dataFactory The factory that will manage access to the 
		 * specialized SDMX data providers responsible for fetching SDMX-ML data
		 * @param structureFactory The factory that will manage access to the 
		 * specialized SDMX data providers responsible for fetching SDMX-ML 
		 * structural metadata. 
		 */
		public function BaseSDMXViewController(model:ISDMXViewModel, 
			dataFactory:ISDMXDaoFactory = null, 
			structureFactory:ISDMXDaoFactory = null)
		{
			super(model, dataFactory, structureFactory);	
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function handleSelectedPeriodChanged(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			(model as ISDMXViewModel).handlePeriodChange(event);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleChartDragged(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			(model as ISDMXViewModel).handleChartDragged(event);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleLeftDividerDragged(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			(model as ISDMXViewModel).handleDividerDragged(event, "left");
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleRightDividerDragged(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			(model as ISDMXViewModel).handleDividerDragged(event, "right");
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleLegendItemSelected(event:DataEvent):void
		{
			event.stopImmediatePropagation();
			(model as ISDMXViewModel).handleLegendItemSelected(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function handleLegendMeasureSelected(
			event:XSMeasureSelectionEvent):void
		{
			event.stopImmediatePropagation();
			(model as ISDMXViewModel).handleLegendMeasureSelected(event);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleLegendItemHighlighted(event:DataEvent):void
		{
			event.stopImmediatePropagation();
			(model as ISDMXViewModel).handleLegendItemHighlighted(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function handleLegendMeasureHighlighted(
			event:XSMeasureSelectionEvent):void
		{
			event.stopImmediatePropagation();
			(model as ISDMXViewModel).handleLegendMeasureHighlighted(event);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleSelectedDateChanged(event:DataEvent):void
		{
			event.stopImmediatePropagation();
			(model as ISDMXViewModel).handleSelectedDateChanged(event);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function changeStartDate(date:Date):void
		{
			(model as ISDMXViewModel).startDate = date;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function changeEndDate(date:Date):void
		{
			(model as ISDMXViewModel).endDate = date;
		}
		
		/**
		 * @inheritDoc
		 */
		public function startMovie():void
		{
			(_model as ISDMXViewModel).startMovie();
		}
		
		/**
		 * @inheritDoc
		 */
		public function stopMovie():void
		{
			(_model as ISDMXViewModel).stopMovie();
		}
	}
}