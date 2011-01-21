This sample application shows how Flex-CB visualisation tools can be localized.

In order for this to work you need to:

1. Recompile the FlexCB_MVCFramework library, to add support for the locale 
fr_CA. This is typically done by adding the following -locale=en_US,fr_CA to the
list of compiler arguments.

2. You also need to compile this application (FlexCB_SampleApp2), passing the 
same parameters (-locale=en_US,fr_CA) to the list of compiler arguments.

Once this has been done, you can use the language button at the top, to switch 
between English and French. However, the SDMX structural metadata (defined in 
the file data/ecb_exr1.xml) being only in English, the filter options box will
not be affected by the language settings.