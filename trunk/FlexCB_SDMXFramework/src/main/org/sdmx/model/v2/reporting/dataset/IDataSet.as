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
package org.sdmx.model.v2.reporting.dataset
{
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	
	/**
	 * Contract to be implemented by DataSets
	 *  
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */ 
	public interface IDataSet extends AttachableArtefact
	{
		/**
		 * @private
		 */ 
		function set reportingBeginDate(beginDate:Date):void;
		
		/**
		 * A specific time period that identifies the beginning period of a 
		 * report.
		 */ 
		function get reportingBeginDate():Date;
		
		/**
		 * @private
		 */
		function set reportingEndDate(endDate:Date):void;
		
		/**
		 * A specific time period that identifies the end period of a 
		 * report.
		 */ 
		function get reportingEndDate():Date;
		
		/**
		 * @private
		 */
		function set dataExtractionDate(extractionDate:Date):void;
		
		/**
		 * A specific time period that identifies the date and time that the 
		 * data are extracted from a data source.
		 */ 
		function get dataExtractionDate():Date;
		
		/**
		 * @private
		 */
		function set describedBy(describedBy:DataflowDefinition):void;
		
		/**
		 * Associates a data flow definition and thereby a Key Family to the 
		 * data set.
		 */ 
		function get describedBy():DataflowDefinition;
	}
}