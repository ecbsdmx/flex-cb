As with all Flash-based applications, performance ultimately depends on the technical specifications of the client computer. Nevertheless, the Flex-CB code has also been optimized to quickly process large SDMX-ML data files and also offers settings to further improve data extraction time.

By default, the SDMX-ML readers extract all available information out of the SDMX-ML files. However, all of this information is not always used in the visualization tools. To address this, there are settings to instruct the SDMX-ML readers to not extract certain types of information and these settings are described on this page. The settings are defined at the level of the org.sdmx.stores.api.ISDMXDaoFactory interface.

```
var daoFactory:ISDMXDaoFactory = new SDMXMLDaoFactory();
```

# SDMX attributes #
SDMX distinguishes between statistical concepts that identify and describe statistical data (the so-called _dimensions_) and statistical concepts that do not contribute to identifying statistical data but add useful information (the so-called _attributes_). An example of attributes is the observation confidentiality: it does not allow uniquely identifying an observation but it does add some useful information.

In SDMX, attributes can be attached at various levels, such as the dataset, the group, the series and the observation levels.

# Handling of groups #
In SDMX, _groups_ exist for the sole purpose of attaching attributes.

If the attributes attached to the group, as defined in the data structure definition, are not important for the visualization tool, extraction of groups (and therefore of attributes attached to the groups) can be turned off using the following setting:
```
daoFactory.disableGroups = true;
```

# Handling of observations #
As with groups, if the attributes attached at the observation level are not important for the visualization tool, extraction of the observation-level attributes can be turned off using the following setting:

```
daoFactory.disableObservationAttribute = true;	
```

The SDMX information model specifies that time series contain a collection of time periods. Each time period is made up of a time value and an observation. Each observation contains a value, a reference to the measure and the attributes attached to the observation. In concrete terms, this means that for each data point to be displayed, there are 2 objects in memory, the observation and the time period containing the observation. As there is already a getter for the observation value in the time period object, it is not necessary to embed the observation object in the time period, except if observation level attributes are important. In case attributes are not needed, we may as well turn off the creation of the embedded observation objects completely by using the setting below:

```
daoFactory.disableObservationsCreation = true;
```

When turning on these performance related settings, information available in the SDMX-ML data files will not be extracted (for example, observation-level attributes, etc), but if your application does not need these, turning these performance related settings on will significantly improve the data extraction time.