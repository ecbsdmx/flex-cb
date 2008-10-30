package
{
	import flexunit.framework.TestSuite;
	import eu.ecb.core.model.ModelTests;
	import eu.ecb.core.controller.ControllerTests;
	import eu.ecb.core.command.CommandTests;
	import eu.ecb.core.util.UtilTests;
	import eu.ecb.core.event.EventTests;
	import eu.ecb.core.view.ViewTests;
	
	/**
	 * @private
	 */ 
	public class ECBFrameworkTests
	{
		public static function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(CommandTests.suite());
			suite.addTest(ControllerTests.suite());
			suite.addTest(EventTests.suite());
			suite.addTest(ModelTests.suite());
 			suite.addTest(UtilTests.suite());
 			suite.addTest(ViewTests.suite());
 			return suite;
		}
	}
}