This sample application shows how to use an XML configuration file (see 
data/configuration.xml) to drive a Flex-CB visualisation tool.

In order for this to work you need to add the following to the list of compiler
arguments: -include-libraries=[flexcb-sdmx-lib],[flexcb-mvc-lib];

[flexcb-sdmx-lib] should be replaced with the path to the Flex-CB SDMX Framework
library and [flexcb-mvc-lib] should be replaced with the path to the Flex-CB MVC 
Framework library.