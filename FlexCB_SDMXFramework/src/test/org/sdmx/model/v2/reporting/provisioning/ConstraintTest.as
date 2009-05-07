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
package org.sdmx.model.v2.reporting.provisioning
{
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.IdentifiableArtefactAdapterTest;
	import org.sdmx.model.v2.base.IdentifiableArtefact;

	/**
	 * @private
	 */ 
	public class ConstraintTest extends IdentifiableArtefactAdapterTest {
		
		protected var _constraint:Constraint;
		
		public function ConstraintTest(methodName:String=null) {
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
			_constraint = createConstraint();
			assertNotNull("Problem creating versionable artefact", _constraint);
		}
		
		public override function createIdentifiableArtefact():IdentifiableArtefact {
			return createConstraint();
		}
		
		public static function suite():TestSuite {
			return new TestSuite(ConstraintTest);
		}
		
		public function createConstraint():Constraint {
			return new Constraint(_id);
		}
		
		public function testSetAndGetCalendar():void {
			assertNull("By default, there should be no calendar", _constraint.calendar);
			var calendar:ReleaseCalendar = new ReleaseCalendar();
			_constraint.calendar = calendar;
			assertEquals("The calendars should be equal", calendar, _constraint.calendar);
		}
		
		public function testSetAndGetAvailableDates():void {
			assertNull("By default, there should be no reference period", _constraint.availableDates);
			var dates:ReferencePeriod = new ReferencePeriod();
			_constraint.availableDates = dates;
			assertEquals("The dates should be equal", dates, _constraint.availableDates);
		}
		
		public function testSetAndGetPermittedContentKeys():void {
			assertNull("By default, there should be no permitted content keys", _constraint.permittedContentKeys);
			var keys:KeySet = new KeySet();
			_constraint.permittedContentKeys = keys;
			assertEquals("The keys should be equal", keys, _constraint.permittedContentKeys);
		}
		
		public function testSetAndGetPermittedContentRegion():void {
			assertEquals("By default there should be no permitted content region", 0, _constraint.permittedContentRegion.length);
			var regions:CubeRegionsCollection = new CubeRegionsCollection();
			_constraint.permittedContentRegion = regions;
			assertEquals("The permitted content regions should be the same", regions, _constraint.permittedContentRegion);
		}
	}
}