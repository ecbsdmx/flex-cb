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
package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	
	/**
	 * @private
	 */
	public class GroupKeyTest extends KeyTest
	{

		public function GroupKeyTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(GroupKeyTest);
		}
		
		public function testConstructor():void {
			var descriptor:GroupKeyDescriptor = new GroupKeyDescriptor("sibling");
			var groupKey:GroupKey = new GroupKey(descriptor);
			assertEquals("The valueFor should be equal", descriptor, groupKey.valueFor);
			try {
				groupKey = new GroupKey(null);
				fail("The group key descriptor cannot be null");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValueFor():void {
			var descriptor:GroupKeyDescriptor = new GroupKeyDescriptor("SiblingGroup");
			var groupKey:GroupKey = new GroupKey(descriptor);
			assertEquals("The valueFor should be equal", descriptor, groupKey.valueFor);
			var descriptor2:GroupKeyDescriptor = new GroupKeyDescriptor("CountryGroup");
			groupKey.valueFor = descriptor2;
			assertEquals("The valueFor should be equal", descriptor2, groupKey.valueFor);
			try {
				groupKey.valueFor = null;
				fail("The group key descriptor cannot be set to null");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetTimeseriesKeys():void {
			var keys:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			var keyDescriptor:KeyDescriptor = new KeyDescriptor("test");
			keys.addItem(new TimeseriesKey(keyDescriptor));
			keys.addItem(new TimeseriesKey(keyDescriptor));
			var dataSet:DataSet = new DataSet();
			dataSet.timeseriesKeys = keys;
			assertEquals("Collections should be equal", keys, dataSet.timeseriesKeys);
		}
	}
}