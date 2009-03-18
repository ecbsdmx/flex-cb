// ECB/SIS Public License, version 1.0, document reference SIS/2001/116
//
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
package eu.ecb.core.command
{
	import eu.ecb.core.command.sdmx.LoadSDMXData;
	
	import flash.events.ErrorEvent;
	import flash.net.URLRequest;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.event.SDMXDataEvent;

	/**
	 *	@private 
	 */
	public class LoadSDMXDataTest extends TestCase
	{
		public function LoadSDMXDataTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(LoadSDMXDataTest);
		}
		
		public function testGetData():void {
			var command:LoadSDMXData = new LoadSDMXData();
			command.dataFile = new URLRequest("testData/usd.xml");
			command.structureFile = new URLRequest("testData/ecb_exr1.xml");	
			command.addEventListener(LoadSDMXData.DATA_LOADED, 
				addAsync(handleData, 3000));	
			command.execute();	
		}
		
		public function testNonExistingData():void {
			var command:LoadSDMXData = new LoadSDMXData();
			command.dataFile = new URLRequest("testData/nonExistingFile.xml");
			command.structureFile = new URLRequest("testData/ecb_exr1.xml");
			command.addEventListener(CommandAdapter.COMMAND_ERROR, 
				addAsync(handleError, 3000));	
			command.execute();
		}
		
		public function testWrongStructureFile():void {
			var command:LoadSDMXData = new LoadSDMXData();
			command.dataFile = new URLRequest("testData/rub.xml.zlib");
			command.structureFile = new URLRequest("testData/usd.xml");
			command.addEventListener(CommandAdapter.COMMAND_ERROR, 
				addAsync(handleError, 3000));	
			command.execute();
		}
		
		public function testGetWrongDataFile():void {
			var command:LoadSDMXData = new LoadSDMXData();
			command.dataFile = new URLRequest("testData/ecb_mir1.xml");
			command.structureFile = new URLRequest("testData/ecb_exr1.xml");
			command.addEventListener(CommandAdapter.COMMAND_ERROR, 
				addAsync(handleError, 3000));	
			command.execute();
		}
		
		public function testGetIdenticalFiles():void {
			var command:LoadSDMXData = new LoadSDMXData();
			command.dataFile = new URLRequest("testData/ecb_exr1.xml");
			command.structureFile = new URLRequest("testData/ecb_exr1.xml");
			command.addEventListener(CommandAdapter.COMMAND_ERROR, 
				addAsync(handleError, 3000));	
			command.execute();
		}
		
		private function handleData(event:SDMXDataEvent):void {}
		
		private function handleError(event:ErrorEvent):void {}
	}
}