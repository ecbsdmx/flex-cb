# Introduction #

This page described how to get started with the FlexCB project and how to set up your development environment. To follow this tutorial, you will need:
  * A working installation of Adobe Flex Builder 3 Professional Edition
  * A working installation of a Subversion plugin for Adobe Flex Builder 3
  * A working copy of FlexUnit

The source code for the FlexCB project is organized into various logical components. We recommend you set up independent projects for each of these components, mainly to save compilation time when making changes.

# SDMX and the dynamic visualization of statistical data #

The FlexCB visualization framework is based on the SDMX standard for various reasons:
  * It is an ISO technical specification (ISO/TS 17369), sponsored by 7 international institutions.
  * The SDMX information model describes all the components needed to represent the statistical data and metadata being displayed.
  * The SDMX information model can be represented in various XML formats (SDMX-ML), and XML is ideal for feeding data to the visualization tools.

For additional information regarding SDMX, please see http://www.sdmx.org. A description of the SDMX information model used in the FlexCB visualization framework is available in the Section 02 of the SDMX Documentation package (http://www.sdmx.org/index.php?page_id=16#package).

# The FlexCB source code in a nutshell #

The code is organized into the following components:

## 1. The data access layer ##
The data access layer contains readers that extract statistical data and metadata out of an SDMX data source (currently SDMX-ML files). The readers will parse SDMX data structure definitions and extract code lists, concept schemes, organization schemes, data flows and key families. They will also parse SDMX data files and extract data sets, groups, series and observations. They will use the information available in the data structure definition (the dimensions, the attributes, the measures, etc) to interpret the statistical data. The readers will then translate the extracted data into objects of the SDMX information model (see next section).
## 2. The SDMX Information Model layer ##
The SDMX Information Model layer represents the classes defined in the SDMX information model (code lists, concepts, dimensions, data sets, series, observations, etc) as objects that can be stored in memory. These are the objects that can then be visualized, using the views defined in the third package (see below).
## 3. The MVC layer ##
The MVC layer provides views displaying the objects of the SDMX information model in various ways (charts, tables, metadata panels, etc). It also supports the possibility to combine various views on a screen.
It follows the Model-View-Controller pattern and implements a few other design patterns (Command, Abstract Factory, Singleton, Observer, etc.).

# Download of the source code #
As mentioned in the introduction, we will organize the source code into various libraries and projects.

## 1. The SDMX library ##
This library will contain the data access layer as well as the SDMX information model layer.
  1. Open Flex Builder and create a new project (File > New > Other > SVN > New project from SVN).
  1. On the next screen, select the flex-cb repository on Google code.
  1. On the next screen, browse the repository, select the `trunk/FlexCB_SDMXFramework` folder and click on Finish.
  1. On the next screen, select "Check out as a project configured using the New Project Wizard".
  1. On the next screen, select Flex Builder > Flex Library Project. We named it `FlexCB_SDMXFramework`.
  1. On the next screen, add the `FlexUnit` swc file to the Library path.
  1. Add src/main and src/test to the Source path of the library project (Project > Properties > Flex Library Build Path > Source path > Add folder).
  1. Add all the classes to the library project classes (Project > Properties > Flex Library Build Path > Classes) and make sure that the "Main source folder" field is empty.

We should now have a working copy of the SDMX library.

## 2. The FlexCB MVC library ##
This library will contain the FlexCB MVC package.
  1. Open Flex Builder and create a new project (File > New > Other > SVN > New project from SVN).
  1. On the next screen, select the flex-cb repository on Google code.
  1. On the next screen, browse the repository, select the `trunk/FlexCB_MVCFramework` folder and click on Finish.
  1. On the next screen, select "Check out as a project configured using the New Project Wizard".
  1. On the next screen, select Flex Builder > Flex Library Project. We named it `FlexCB_MVCFramework`.
  1. On the next screen, add the `FlexUnit` swc file, the `FlexLib` swc file, and the `FlexCB_SDMXFramework` library to the Library path.
  1. Add src/main, src/test and locale/{locale} to the Source path of the library project (Project > Properties > Flex Library Build Path > Source path > Add folder).
  1. Add all the classes, except the asset directory (below src/main/eu/ecb/assets), to the library project classes (Project > Properties > Flex Library Build Path > Classes) and make sure that the "Main source folder" field is empty.
  1. Add the asset directory to the library assets (Project > Properties > Flex Library Build Path > Assets).

We should now have a working copy of the FlexCB MVC library.

## 3. The sample applications ##

Three sample applications are provided with the FlexCB project. We will now set up one of them.
  1. Open Flex Builder and create a new project (File > New > Other > SVN > New project from SVN).
  1. On the next screen, select the flex-cb repository on Google code.
  1. On the next screen, browse the repository, select the `trunk/FlexCB_SampleApp1` folder and click on Finish.
  1. On the next screen, select "Check out as a project configured using the New Project Wizard".
  1. On the next screen, select Flex Builder > Flex Project. We named it `FlexCB_SampleApp1`.
  1. On the next screen, add the `FlexCB_MVCFramework` library to the Library path.
  1. Run the application from Flex Builder.

The `FlexCB_SampleApp1` application will by default display price inflation in the euro area. You can change this without recompiling the application by adding the following line in the index.template.html file below the html-template of the Flex project:

```
"flashVars", "dataFile=data/inflation.xml.zlib&dsdFile=data/ecb_icp1.xml"
```

This line should be added in the following block of code:

```
} else if (hasRequestedVersion) {
    // if we've detected an acceptable version
    // embed the Flash Content SWF when all tests are passed
    AC_FL_RunContent(
        "src", "${swf}",
        "width", "${width}",
        "height", "${height}",
        "align", "middle",
        "id", "${application}",
        "quality", "high",
        "bgcolor", "${bgcolor}",
        "name", "${application}",
        "allowScriptAccess","sameDomain",
        "type", "application/x-shockwave-flash",
        "flashVars", "dataFile=data/inflation.xml.zlib&dsdFile=data/ecb_icp1.xml",
        "pluginspage", "http://www.adobe.com/go/getflashplayer"
    );
}
```

The dataFile variable should point to an SDMX-ML data file, in one of the 3 supported SDMX-ML Data formats (SDMX-ML Compact Data, SDMX-ML Generic Data and SDMX-ML Utility Data), and the dsdFile variable should point to a data structure definition, expressed in version 2 of the SDMX-ML Structure format.