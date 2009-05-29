package org.sdmx.stores.api
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class BaseSDMXDaoFactoryTest extends TestCase
	{
		public function BaseSDMXDaoFactoryTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(BaseSDMXDaoFactoryTest);
		}
		
		public function testSetDefaultDAO():void
		{
			var factory:BaseSDMXDaoFactory = new BaseSDMXDaoFactory();
			assertNull("No CS", factory.getCategorySchemeDAO());
			assertNull("No CS", factory.getCodeListDAO());
			assertNull("No CS", factory.getCompactDataDAO());
			assertNull("No CS", factory.getConceptSchemeDAO());
			assertNull("No CS", factory.getDataDAO());
			assertNull("No CS", factory.getDataflowDAO());
			assertNull("No CS", factory.getGenericDataDAO());
			assertNull("No CS", factory.getKeyFamilyDAO());
			assertNull("No CS", factory.getOrganisationSchemeDAO());
			assertNull("No CS", factory.getUtilityDataDAO());
		}
	}
}