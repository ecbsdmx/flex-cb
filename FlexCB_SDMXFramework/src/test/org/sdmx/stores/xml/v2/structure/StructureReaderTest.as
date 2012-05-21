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
package org.sdmx.stores.xml.v2.structure
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.base.structure.LengthRange;
	import org.sdmx.model.v2.base.type.AttachmentLevel;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.base.type.UsageStatus;
	import org.sdmx.model.v2.reporting.provisioning.CubeRegion;
	import org.sdmx.model.v2.reporting.provisioning.MemberSelection;
	import org.sdmx.model.v2.structure.category.CategorieSchemesCollection;
	import org.sdmx.model.v2.structure.category.Category;
	import org.sdmx.model.v2.structure.category.CategoryScheme;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.concept.ConceptScheme;
	import org.sdmx.model.v2.structure.concept.Concepts;
	import org.sdmx.model.v2.structure.hierarchy.CodeAssociation;
	import org.sdmx.model.v2.structure.hierarchy.HierarchicalCodeScheme;
	import org.sdmx.model.v2.structure.hierarchy.HierarchicalCodeSchemesCollection;
	import org.sdmx.model.v2.structure.hierarchy.Hierarchy;
	import org.sdmx.model.v2.structure.keyfamily.DataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.Measure;
	import org.sdmx.model.v2.structure.keyfamily.UncodedDataAttribute;
	import org.sdmx.model.v2.structure.organisation.OrganisationScheme;
	import org.sdmx.model.v2.structure.organisation.OrganisationSchemes;

	/**
	 * @private
	 */
	public class StructureReaderTest extends TestCase
	{
		private var _testXML:XML = 
<Structure 
	xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message SDMXMessage.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure SDMXStructure.xsd">
	<Header>
		<ID>IREF000506</ID>
		<Test>false</Test>
		<Name xml:lang="en">ECB structural definitions</Name>
		<Prepared>2006-10-25T14:26:00</Prepared>
		<Sender id="4F0"/>
	</Header>
	<message:CodeLists xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
		<CodeList agencyID="ECB" id="CL_COLLECTION">
			<Name xml:lang="en">Collection indicator code list</Name>
			<Code value="A">
				<Description xml:lang="EN">Average of observations through period</Description>
			</Code>
			<Code value="B">
				<Description xml:lang="en">Beginning of period</Description>
			</Code>
			<Code value="E">
				<Description xml:lang="en">End of period</Description>
			</Code>
			<Code value="H">
				<Description xml:lang="en">Highest in period</Description>
			</Code>
			<Code value="L">
				<Description xml:lang="en">Lowest in period</Description>
			</Code>
			<Code value="M">
				<Description xml:lang="en">Middle of period</Description>
			</Code>
			<Code value="S">
				<Description xml:lang="en">Summed through period</Description>
			</Code>
			<Code value="U">
				<Description xml:lang="en">Unknown</Description>
			</Code>
			<Code value="V">
				<Description xml:lang="en">Other</Description>
			</Code>
			<Code value="Y">
				<Description xml:lang="en">Annualised summed</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_CURRENCY">
			<Name xml:lang="en">Currency code list</Name>
			<Code value="ALL">
				<Description xml:lang="en">Albanian lek</Description>
			</Code>
			<Code value="ARS">
				<Description xml:lang="en">Argentine peso</Description>
			</Code>
			<Code value="ATS">
				<Description xml:lang="en">Austrian schilling</Description>
			</Code>
			<Code value="AUD">
				<Description xml:lang="en">Australian dollar</Description>
			</Code>
			<Code value="BAM">
				<Description xml:lang="en">Bosnia-Hezergovinian convertible mark</Description>
			</Code>
			<Code value="BEF">
				<Description xml:lang="en">Belgian franc</Description>
			</Code>
			<Code value="BEL">
				<Description xml:lang="en">Belgian franc (financial)</Description>
			</Code>
			<Code value="BGN">
				<Description xml:lang="en">Bulgarian lev</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_DECIMALS">
			<Name xml:lang="en">Decimals codelist</Name>
			<Code value="0">
				<Description xml:lang="en">Zero</Description>
			</Code>
			<Code value="1">
				<Description xml:lang="en">One</Description>
			</Code>
			<Code value="2">
				<Description xml:lang="en">Two</Description>
			</Code>
			<Code value="3">
				<Description xml:lang="en">Three</Description>
			</Code>
			<Code value="4">
				<Description xml:lang="en">Four</Description>
			</Code>
			<Code value="5">
				<Description xml:lang="en">Five</Description>
			</Code>
			<Code value="6">
				<Description xml:lang="en">Six</Description>
			</Code>
			<Code value="7">
				<Description xml:lang="en">Seven</Description>
			</Code>
			<Code value="8">
				<Description xml:lang="en">Eight</Description>
			</Code>
			<Code value="9">
				<Description xml:lang="en">Nine</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_EXR_SUFFIX">
			<Name xml:lang="en">Exch. rate series variation code list</Name>
			<Code value="A">
				<Description xml:lang="en">Average or standardised measure for given frequency</Description>
			</Code>
			<Code value="E">
				<Description xml:lang="en">End-of-period</Description>
			</Code>
			<Code value="P">
				<Description>Growth rate to previous period</Description>
            </Code>
            <Code value="R">
                <Description>Annual rate of change</Description>
            </Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_EXR_TYPE">
			<Name xml:lang="en">Exchange rate type code list</Name>
			<Code value="BRC0">
				<Description xml:lang="en">Real bilateral exchange rate, CPI deflated</Description>
			</Code>
			<Code value="CR00">
				<Description xml:lang="en">Central rate</Description>
			</Code>
			<Code value="EN00">
				<Description xml:lang="en">Nominal effective exch. rate</Description>
			</Code>
			<Code value="ERC0">
				<Description xml:lang="en">Real effective exch. rate CPI deflated</Description>
			</Code>
			<Code value="ERC1">
				<Description xml:lang="en">Real effective exch. rate retail prices deflated</Description>
			</Code>
			<Code value="ERD0">
				<Description xml:lang="en">Real effective exch. rate GDP deflators deflated</Description>
			</Code>
			<Code value="ERM0">
				<Description xml:lang="en">Real effective exch. rate import unit values deflated</Description>
			</Code>
			<Code value="ERP0">
				<Description xml:lang="en">Real effective exch. rate producer prices deflated</Description>
			</Code>
			<Code value="ERU0">
				<Description xml:lang="en">Real effective exch. rate ULC manufacturing deflated</Description>
			</Code>
			<Code value="ERU1">
				<Description xml:lang="en">Real effective exch. rate ULC total economy deflated</Description>
			</Code>
			<Code value="ERW0">
				<Description xml:lang="en">Real effective exch. rate wholesale prices deflated</Description>
			</Code>
			<Code value="ERX0">
				<Description xml:lang="en">Real effective exch. rate export unit values deflated</Description>
			</Code>
			<Code value="SP00">
				<Description xml:lang="en">Spot</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_FREQ">
			<Name xml:lang="en">Frequency code list</Name>
			<Code value="A">
				<Description xml:lang="en">Annual</Description>
			</Code>
			<Code value="B">
				<Description xml:lang="en">Business</Description>
			</Code>
			<Code value="D">
				<Description xml:lang="en">Daily</Description>
			</Code>
			<Code value="E">
				<Description xml:lang="en">Event (not supported)</Description>
			</Code>
			<Code value="H">
				<Description xml:lang="en">Half-yearly</Description>
			</Code>
			<Code value="M">
				<Description xml:lang="en">Monthly</Description>
			</Code>
			<Code value="Q">
				<Description xml:lang="en">Quarterly</Description>
			</Code>
			<Code value="W">
				<Description xml:lang="en">Weekly</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_OBS_CONF">
			<Name xml:lang="en">Observation confidentiality code list</Name>
			<Code value="C">
				<Description xml:lang="en">Confidential statistical information</Description>
			</Code>
			<Code value="D">
				<Description xml:lang="en">Secondary confidentiality set by the sender, not for publication</Description>
			</Code>
			<Code value="F">
				<Description xml:lang="en">Free (free for publication)</Description>
			</Code>
			<Code value="N">
				<Description xml:lang="en">Not for publication, restricted for internal use only</Description>
			</Code>
			<Code value="R">
				<Description xml:lang="en">Discontinued from 13 October 2006</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_OBS_STATUS">
			<Name xml:lang="en">Observation status code list</Name>
			<Code value="A">
				<Description xml:lang="en">Normal value</Description>
			</Code>
			<Code value="B">
				<Description xml:lang="en">Break</Description>
			</Code>
			<Code value="E">
				<Description xml:lang="en">Estimated value</Description>
			</Code>
			<Code value="F">
				<Description xml:lang="en">Forecast value</Description>
			</Code>
			<Code value="H">
				<Description xml:lang="en">Missing value; holiday or weekend</Description>
			</Code>
			<Code value="L">
				<Description xml:lang="en">Missing value; data exist but were not collected</Description>
			</Code>
			<Code value="M">
				<Description xml:lang="en">Missing value; data cannot exist</Description>
			</Code>
			<Code value="P">
				<Description xml:lang="en">Provisional value</Description>
			</Code>
			<Code value="Q">
				<Description xml:lang="en">Missing value; suppressed</Description>
			</Code>
			<Code value="S">
				<Description xml:lang="en">Strike</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_UNIT">
			<Name xml:lang="en">Unit code list</Name>
			<Code value="ARS">
				<Description xml:lang="en">Argentine peso</Description>
			</Code>
			<Code value="ATS">
				<Description xml:lang="en">Austrian schilling</Description>
			</Code>
			<Code value="AUD">
				<Description xml:lang="en">Australian dollar</Description>
			</Code>
			<Code value="BEF">
				<Description xml:lang="en">Belgian franc</Description>
			</Code>
			<Code value="BEL">
				<Description xml:lang="en">Belgian franc (financial)</Description>
			</Code>
			<Code value="BGN">
				<Description xml:lang="en">Bulgarian lev</Description>
			</Code>
			<Code value="BRL">
				<Description xml:lang="en">Brazilian real</Description>
			</Code>
			<Code value="CAD">
				<Description xml:lang="en">Canadian dollar</Description>
			</Code>
			<Code value="CHF">
				<Description xml:lang="en">Swiss franc</Description>
			</Code>
			<Code value="ZAR">
				<Description xml:lang="en">South African rand</Description>
			</Code>
		</CodeList>
		<CodeList agencyID="ECB" id="CL_UNIT_MULT">
			<Name xml:lang="en">Unit multiplier code list</Name>
			<Code value="0">
				<Description xml:lang="en">Units</Description>
			</Code>
			<Code value="1">
				<Description xml:lang="en">Tens</Description>
			</Code>
			<Code value="2">
				<Description xml:lang="en">Hundreds</Description>
			</Code>
			<Code value="3">
				<Description xml:lang="en">Thousands</Description>
			</Code>
			<Code value="4">
				<Description xml:lang="en">Tens of thousands</Description>
			</Code>
			<Code value="6">
				<Description xml:lang="en">Millions</Description>
			</Code>
			<Code value="9">
				<Description xml:lang="en">Billions</Description>
			</Code>
		</CodeList>
	</message:CodeLists>
	<message:Concepts xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
		<Concept agencyID="ECB" id="COLLECTION">
			<Name xml:lang="en">Collection indicator</Name>
		</Concept>
		<Concept agencyID="ECB" id="CURRENCY">
			<Name xml:lang="en">Currency</Name>
		</Concept>
		<Concept agencyID="ECB" id="CURRENCY_DENOM">
			<Name xml:lang="en">Currency denominator</Name>
		</Concept>
		<Concept agencyID="ECB" id="DECIMALS">
			<Name xml:lang="en">Decimals</Name>
		</Concept>
		<Concept agencyID="ECB" id="EXR_SUFFIX">
			<Name xml:lang="en">Series variation - EXR context</Name>
		</Concept>
		<Concept agencyID="ECB" id="EXR_TYPE">
			<Name xml:lang="en">Exchange rate type</Name>
		</Concept>
		<Concept agencyID="ECB" id="FREQ">
			<Name xml:lang="en">Frequency</Name>
		</Concept>
		<Concept agencyID="ECB" id="OBS_CONF">
			<Name xml:lang="en">Observation confidentiality</Name>
		</Concept>
		<Concept agencyID="ECB" id="OBS_STATUS">
			<Name xml:lang="en">Observation status</Name>
		</Concept>
		<Concept agencyID="ECB" id="OBS_VALUE">
			<Name xml:lang="en">Observation value</Name>
		</Concept>
		<Concept agencyID="ECB" id="TIME_FORMAT">
			<Name xml:lang="en">Time format code</Name>
		</Concept>
		<Concept agencyID="ECB" id="TIME_PERIOD">
			<Name xml:lang="en">Time period or range</Name>
		</Concept>
		<Concept agencyID="ECB" id="TITLE_COMPL">
			<Name xml:lang="en">Title complement</Name>
		</Concept>
		<Concept agencyID="ECB" id="UNIT">
			<Name xml:lang="en">Unit</Name>
		</Concept>
		<Concept agencyID="ECB" id="UNIT_MULT">
			<Name xml:lang="en">Unit multiplier</Name>
		</Concept>
	</message:Concepts>
	<message:KeyFamilies xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
		<KeyFamily agencyID="ECB" id="ECB_EXR1" uri="http://stats.ecb.europa.eu/stats/dtf_test/ecb_exr1.xml">
			<Name xml:lang="en">Exchange Rates</Name>
			<Components>
				<Dimension conceptRef="FREQ" codelist="CL_FREQ" isFrequencyDimension="true"/>
				<Dimension conceptRef="CURRENCY" codelist="CL_CURRENCY"/>
				<Dimension conceptRef="CURRENCY_DENOM" codelist="CL_CURRENCY"/>
				<Dimension conceptRef="EXR_TYPE" codelist="CL_EXR_TYPE"/>
				<Dimension conceptRef="EXR_SUFFIX" codelist="CL_EXR_SUFFIX"/>
				<TimeDimension conceptRef="TIME_PERIOD"/>
				<Group id="Group">
					<DimensionRef>CURRENCY</DimensionRef>
					<DimensionRef>CURRENCY_DENOM</DimensionRef>
					<DimensionRef>EXR_TYPE</DimensionRef>
					<DimensionRef>EXR_SUFFIX</DimensionRef>
				</Group>
				<PrimaryMeasure conceptRef="OBS_VALUE"/>
				<Attribute conceptRef="TIME_FORMAT" attachmentLevel="Series" assignmentStatus="Mandatory" isTimeFormat="true">
					<TextFormat textType="String" maxLength="3"/>
				</Attribute>
				<Attribute conceptRef="OBS_STATUS" attachmentLevel="Observation" codelist="CL_OBS_STATUS" assignmentStatus="Mandatory"/>
				<Attribute conceptRef="OBS_CONF" attachmentLevel="Observation" codelist="CL_OBS_CONF" assignmentStatus="Conditional"/>
				<Attribute conceptRef="COLLECTION" attachmentLevel="Series" codelist="CL_COLLECTION" assignmentStatus="Mandatory"/>
				<Attribute conceptRef="DECIMALS" attachmentLevel="Group" codelist="CL_DECIMALS" assignmentStatus="Mandatory">
					<AttachmentGroup>Group</AttachmentGroup>
				</Attribute>
				<Attribute conceptRef="TITLE_COMPL" attachmentLevel="Group" assignmentStatus="Mandatory">
					<TextFormat textType="String" maxLength="1050"/>
					<AttachmentGroup>Group</AttachmentGroup>
				</Attribute>
				<Attribute conceptRef="UNIT" attachmentLevel="Group" codelist="CL_UNIT" assignmentStatus="Mandatory">
					<AttachmentGroup>Group</AttachmentGroup>
				</Attribute>
				<Attribute conceptRef="UNIT_MULT" attachmentLevel="Group" codelist="CL_UNIT_MULT" assignmentStatus="Mandatory">
					<AttachmentGroup>Group</AttachmentGroup>
				</Attribute>
			</Components>
		</KeyFamily>
	</message:KeyFamilies>
</Structure>

		private var _testDSD21:XML =
<message:Structure
	xmlns:message="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message"
	xmlns:structure="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure"
	xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message ../../xsd/SDMX/2.1/SDMXMessage.xsd">
	<message:Header>
		<message:ID>IREF000506</message:ID>
		<message:Test>false</message:Test>
		<message:Prepared>2006-10-25T14:26:00</message:Prepared>
		<message:Sender id="4F0" />
		<common:Name xml:lang="en">ECB structural definitions</common:Name>
	</message:Header>
	<message:Structures>
		<structure:Codelists>
			<structure:Codelist agencyID="ECB" id="CL_COLLECTION">
				<common:Name xml:lang="en">
					Collection indicator code list
				</common:Name>
				<structure:Code id="A">
					<common:Name xml:lang="EN">
						Average of observations through period
					</common:Name>
				</structure:Code>
				<structure:Code id="B">
					<common:Name xml:lang="en">Beginning of period</common:Name>
				</structure:Code>
				<structure:Code id="E">
					<common:Name xml:lang="en">End of period</common:Name>
				</structure:Code>
				<structure:Code id="H">
					<common:Name xml:lang="en">Highest in period</common:Name>
				</structure:Code>
				<structure:Code id="L">
					<common:Name xml:lang="en">Lowest in period</common:Name>
				</structure:Code>
				<structure:Code id="M">
					<common:Name xml:lang="en">Middle of period</common:Name>
				</structure:Code>
				<structure:Code id="S">
					<common:Name xml:lang="en">
						Summed through period
					</common:Name>
				</structure:Code>
				<structure:Code id="U">
					<common:Name xml:lang="en">Unknown</common:Name>
				</structure:Code>
				<structure:Code id="V">
					<common:Name xml:lang="en">Other</common:Name>
				</structure:Code>
				<structure:Code id="Y">
					<common:Name xml:lang="en">Annualised summed</common:Name>
				</structure:Code>
			</structure:Codelist>
			<structure:Codelist agencyID="ECB" id="CL_CURRENCY">
				<common:Name xml:lang="en">Currency code list</common:Name>
				<structure:Code id="ALL">
					<common:Name xml:lang="en">Albanian lek</common:Name>
				</structure:Code>
				<structure:Code id="ARS">
					<common:Name xml:lang="en">Argentine peso</common:Name>
				</structure:Code>
				<structure:Code id="ATS">
					<common:Name xml:lang="en">Austrian schilling</common:Name>
				</structure:Code>
				<structure:Code id="AUD">
					<common:Name xml:lang="en">Australian dollar</common:Name>
				</structure:Code>
				<structure:Code id="BAM">
					<common:Name xml:lang="en">
						Bosnia-Hezergovinian convertible mark
					</common:Name>
				</structure:Code>
				<structure:Code id="BEF">
					<common:Name xml:lang="en">Belgian franc</common:Name>
				</structure:Code>
				<structure:Code id="BEL">
					<common:Name xml:lang="en">
						Belgian franc (financial)
					</common:Name>
				</structure:Code>
				<structure:Code id="BGN">
					<common:Name xml:lang="en">Bulgarian lev</common:Name>
				</structure:Code>
			</structure:Codelist>
			<structure:Codelist agencyID="ECB" id="CL_DECIMALS">
				<common:Name xml:lang="en">Decimals codelist</common:Name>
				<structure:Code id="0">
					<common:Name xml:lang="en">Zero</common:Name>
				</structure:Code>
				<structure:Code id="1">
					<common:Name xml:lang="en">One</common:Name>
				</structure:Code>
				<structure:Code id="2">
					<common:Name xml:lang="en">Two</common:Name>
				</structure:Code>
				<structure:Code id="3">
					<common:Name xml:lang="en">Three</common:Name>
				</structure:Code>
				<structure:Code id="4">
					<common:Name xml:lang="en">Four</common:Name>
				</structure:Code>
				<structure:Code id="5">
					<common:Name xml:lang="en">Five</common:Name>
				</structure:Code>
				<structure:Code id="6">
					<common:Name xml:lang="en">Six</common:Name>
				</structure:Code>
				<structure:Code id="7">
					<common:Name xml:lang="en">Seven</common:Name>
				</structure:Code>
				<structure:Code id="8">
					<common:Name xml:lang="en">Eight</common:Name>
				</structure:Code>
				<structure:Code id="9">
					<common:Name xml:lang="en">Nine</common:Name>
				</structure:Code>
			</structure:Codelist>
			<structure:Codelist agencyID="ECB" id="CL_EXR_SUFFIX">
				<common:Name xml:lang="en">
					Exch. rate series variation code list
				</common:Name>
				<structure:Code id="A">
					<common:Name xml:lang="en">
						Average or standardised measure for given frequency
					</common:Name>
				</structure:Code>
				<structure:Code id="E">
					<common:Name xml:lang="en">End-of-period</common:Name>
				</structure:Code>
				<structure:Code id="P">
					<common:Name>Growth rate to previous period</common:Name>
				</structure:Code>
				<structure:Code id="R">
					<common:Name>Annual rate of change</common:Name>
				</structure:Code>
			</structure:Codelist>
			<structure:Codelist agencyID="ECB" id="CL_EXR_TYPE">
				<common:Name xml:lang="en">
					Exchange rate type code list
				</common:Name>
				<structure:Code id="BRC0">
					<common:Name xml:lang="en">
						Real bilateral exchange rate, CPI deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="CR00">
					<common:Name xml:lang="en">Central rate</common:Name>
				</structure:Code>
				<structure:Code id="EN00">
					<common:Name xml:lang="en">
						Nominal effective exch. rate
					</common:Name>
				</structure:Code>
				<structure:Code id="ERC0">
					<common:Name xml:lang="en">
						Real effective exch. rate CPI deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="ERC1">
					<common:Name xml:lang="en">
						Real effective exch. rate retail prices deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="ERD0">
					<common:Name xml:lang="en">
						Real effective exch. rate GDP deflators deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="ERM0">
					<common:Name xml:lang="en">
						Real effective exch. rate import unit values deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="ERP0">
					<common:Name xml:lang="en">
						Real effective exch. rate producer prices deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="ERU0">
					<common:Name xml:lang="en">
						Real effective exch. rate ULC manufacturing deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="ERU1">
					<common:Name xml:lang="en">
						Real effective exch. rate ULC total economy deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="ERW0">
					<common:Name xml:lang="en">
						Real effective exch. rate wholesale prices deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="ERX0">
					<common:Name xml:lang="en">
						Real effective exch. rate export unit values deflated
					</common:Name>
				</structure:Code>
				<structure:Code id="SP00">
					<common:Name xml:lang="en">Spot</common:Name>
				</structure:Code>
			</structure:Codelist>
			<structure:Codelist agencyID="ECB" id="CL_FREQ">
				<common:Name xml:lang="en">Frequency code list</common:Name>
				<structure:Code id="A">
					<common:Name xml:lang="en">Annual</common:Name>
				</structure:Code>
				<structure:Code id="B">
					<common:Name xml:lang="en">Business</common:Name>
				</structure:Code>
				<structure:Code id="D">
					<common:Name xml:lang="en">Daily</common:Name>
				</structure:Code>
				<structure:Code id="E">
					<common:Name xml:lang="en">
						Event (not supported)
					</common:Name>
				</structure:Code>
				<structure:Code id="H">
					<common:Name xml:lang="en">Half-yearly</common:Name>
				</structure:Code>
				<structure:Code id="M">
					<common:Name xml:lang="en">Monthly</common:Name>
				</structure:Code>
				<structure:Code id="Q">
					<common:Name xml:lang="en">Quarterly</common:Name>
				</structure:Code>
				<structure:Code id="W">
					<common:Name xml:lang="en">Weekly</common:Name>
				</structure:Code>
			</structure:Codelist>
			<structure:Codelist agencyID="ECB" id="CL_OBS_CONF">
				<common:Name xml:lang="en">
					Observation confidentiality code list
				</common:Name>
				<structure:Code id="C">
					<common:Name xml:lang="en">
						Confidential statistical information
					</common:Name>
				</structure:Code>
				<structure:Code id="D">
					<common:Name xml:lang="en">
						Secondary confidentiality set by the sender, not for
						publication
					</common:Name>
				</structure:Code>
				<structure:Code id="F">
					<common:Name xml:lang="en">
						Free (free for publication)
					</common:Name>
				</structure:Code>
				<structure:Code id="N">
					<common:Name xml:lang="en">
						Not for publication, restricted for internal use only
					</common:Name>
				</structure:Code>
				<structure:Code id="R">
					<common:Name xml:lang="en">
						Discontinued from 13 October 2006
					</common:Name>
				</structure:Code>
			</structure:Codelist>
			<structure:Codelist agencyID="ECB" id="CL_OBS_STATUS">
				<common:Name xml:lang="en">
					Observation status code list
				</common:Name>
				<structure:Code id="A">
					<common:Name xml:lang="en">Normal value</common:Name>
				</structure:Code>
				<structure:Code id="B">
					<common:Name xml:lang="en">Break</common:Name>
				</structure:Code>
				<structure:Code id="E">
					<common:Name xml:lang="en">Estimated value</common:Name>
				</structure:Code>
				<structure:Code id="F">
					<common:Name xml:lang="en">Forecast value</common:Name>
				</structure:Code>
				<structure:Code id="H">
					<common:Name xml:lang="en">
						Missing value; holiday or weekend
					</common:Name>
				</structure:Code>
				<structure:Code id="L">
					<common:Name xml:lang="en">
						Missing value; data exist but were not collected
					</common:Name>
				</structure:Code>
				<structure:Code id="M">
					<common:Name xml:lang="en">
						Missing value; data cannot exist
					</common:Name>
				</structure:Code>
				<structure:Code id="P">
					<common:Name xml:lang="en">Provisional value</common:Name>
				</structure:Code>
				<structure:Code id="Q">
					<common:Name xml:lang="en">
						Missing value; suppressed
					</common:Name>
				</structure:Code>
				<structure:Code id="S">
					<common:Name xml:lang="en">Strike</common:Name>
				</structure:Code>
			</structure:Codelist>
			<structure:Codelist agencyID="ECB" id="CL_UNIT">
				<common:Name xml:lang="en">Unit code list</common:Name>
				<structure:Code id="ARS">
					<common:Name xml:lang="en">Argentine peso</common:Name>
				</structure:Code>
				<structure:Code id="ATS">
					<common:Name xml:lang="en">Austrian schilling</common:Name>
				</structure:Code>
				<structure:Code id="AUD">
					<common:Name xml:lang="en">Australian dollar</common:Name>
				</structure:Code>
				<structure:Code id="BEF">
					<common:Name xml:lang="en">Belgian franc</common:Name>
				</structure:Code>
				<structure:Code id="BEL">
					<common:Name xml:lang="en">
						Belgian franc (financial)
					</common:Name>
				</structure:Code>
				<structure:Code id="BGN">
					<common:Name xml:lang="en">Bulgarian lev</common:Name>
				</structure:Code>
				<structure:Code id="BRL">
					<common:Name xml:lang="en">Brazilian real</common:Name>
				</structure:Code>
				<structure:Code id="CAD">
					<common:Name xml:lang="en">Canadian dollar</common:Name>
				</structure:Code>
				<structure:Code id="CHF">
					<common:Name xml:lang="en">Swiss franc</common:Name>
				</structure:Code>
				<structure:Code id="ZAR">
					<common:Name xml:lang="en">South African rand</common:Name>
				</structure:Code>
			</structure:Codelist>
			<structure:Codelist agencyID="ECB" id="CL_UNIT_MULT">
				<common:Name xml:lang="en">
					Unit multiplier code list
				</common:Name>
				<structure:Code id="0">
					<common:Name xml:lang="en">Units</common:Name>
				</structure:Code>
				<structure:Code id="1">
					<common:Name xml:lang="en">Tens</common:Name>
				</structure:Code>
				<structure:Code id="2">
					<common:Name xml:lang="en">Hundreds</common:Name>
				</structure:Code>
				<structure:Code id="3">
					<common:Name xml:lang="en">Thousands</common:Name>
				</structure:Code>
				<structure:Code id="4">
					<common:Name xml:lang="en">Tens of thousands</common:Name>
				</structure:Code>
				<structure:Code id="6">
					<common:Name xml:lang="en">Millions</common:Name>
				</structure:Code>
				<structure:Code id="9">
					<common:Name xml:lang="en">Billions</common:Name>
				</structure:Code>
			</structure:Codelist>
		</structure:Codelists>
		<structure:Concepts>
			<structure:ConceptScheme id="CORE_CONCEPTS" agencyID="ECB">
				<common:Name>ECB core concepts</common:Name>
				<structure:Concept id="COLLECTION">
					<common:Name xml:lang="en">
						Collection indicator
					</common:Name>
				</structure:Concept>
				<structure:Concept id="CURRENCY">
					<common:Name xml:lang="en">Currency</common:Name>
				</structure:Concept>
				<structure:Concept id="CURRENCY_DENOM">
					<common:Name xml:lang="en">
						Currency denominator
					</common:Name>
				</structure:Concept>
				<structure:Concept id="DECIMALS">
					<common:Name xml:lang="en">Decimals</common:Name>
				</structure:Concept>
				<structure:Concept id="EXR_SUFFIX">
					<common:Name xml:lang="en">
						Series variation - EXR context
					</common:Name>
				</structure:Concept>
				<structure:Concept id="EXR_TYPE">
					<common:Name xml:lang="en">Exchange rate type</common:Name>
				</structure:Concept>
				<structure:Concept id="FREQ">
					<common:Name xml:lang="en">Frequency</common:Name>
				</structure:Concept>
				<structure:Concept id="OBS_CONF">
					<common:Name xml:lang="en">
						Observation confidentiality
					</common:Name>
				</structure:Concept>
				<structure:Concept id="OBS_STATUS">
					<common:Name xml:lang="en">Observation status</common:Name>
				</structure:Concept>
				<structure:Concept id="OBS_VALUE">
					<common:Name xml:lang="en">Observation value</common:Name>
				</structure:Concept>
				<structure:Concept id="TIME_FORMAT">
					<common:Name xml:lang="en">Time format code</common:Name>
				</structure:Concept>
				<structure:Concept id="TIME_PERIOD">
					<common:Name xml:lang="en">
						Time period or range
					</common:Name>
				</structure:Concept>
				<structure:Concept id="TITLE_COMPL">
					<common:Name xml:lang="en">Title complement</common:Name>
				</structure:Concept>
				<structure:Concept id="UNIT">
					<common:Name xml:lang="en">Unit</common:Name>
				</structure:Concept>
				<structure:Concept id="UNIT_MULT">
					<common:Name xml:lang="en">Unit multiplier</common:Name>
				</structure:Concept>
			</structure:ConceptScheme>
		</structure:Concepts>
		<structure:DataStructures>
			<structure:DataStructure agencyID="ECB" id="ECB_EXR1"
				uri="http://stats.ecb.europa.eu/stats/dtf_test/ecb_exr1.xml">
				<common:Name xml:lang="en">Exchange Rates</common:Name>
				<structure:DataStructureComponents>
					<structure:DimensionList>
						<structure:Dimension>
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="FREQ" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_FREQ" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
							<structure:ConceptRole>
								<Ref agencyID="ECB" maintainableParentID="CORE_CONCEPTS" id="FREQ"/>
							</structure:ConceptRole>
						</structure:Dimension>
						<structure:Dimension>
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="CURRENCY" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_CURRENCY" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
						</structure:Dimension>
						<structure:Dimension>
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="CURRENCY_DENOM" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_CURRENCY" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
						</structure:Dimension>
						<structure:Dimension>
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="EXR_TYPE" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_EXR_TYPE" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
						</structure:Dimension>
						<structure:Dimension>
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="EXR_SUFFIX" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_EXR_SUFFIX" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
						</structure:Dimension>
						<structure:TimeDimension>
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="TIME_PERIOD" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:TextFormat
									textType="ObservationalTimePeriod" />
							</structure:LocalRepresentation>
						</structure:TimeDimension>
					</structure:DimensionList>
					<structure:Group id="Group">
						<structure:GroupDimension><structure:DimensionReference><Ref id="CURRENCY"/></structure:DimensionReference></structure:GroupDimension>
						<structure:GroupDimension><structure:DimensionReference><Ref id="CURRENCY_DENOM"/></structure:DimensionReference></structure:GroupDimension>						
						<structure:GroupDimension><structure:DimensionReference><Ref id="EXR_TYPE"/></structure:DimensionReference></structure:GroupDimension>						
						<structure:GroupDimension><structure:DimensionReference><Ref id="EXR_SUFFIX"/></structure:DimensionReference></structure:GroupDimension>						
					</structure:Group>
					<structure:AttributeList>
						<structure:Attribute assignmentStatus="Mandatory"
							id="DECIMALS">
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="DECIMALS" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_DECIMALS" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
							<structure:AttributeRelationship>
								<structure:Group>
									<Ref id="Group" />
								</structure:Group>
							</structure:AttributeRelationship>
						</structure:Attribute>
						<structure:Attribute assignmentStatus="Mandatory"
							id="TITLE_COMPL">
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="TITLE_COMPL" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:TextFormat maxLength="1050"/>
							</structure:LocalRepresentation>
							<structure:AttributeRelationship>
								<structure:Group>
									<Ref id="Group" />
								</structure:Group>
							</structure:AttributeRelationship>
						</structure:Attribute>
						<structure:Attribute assignmentStatus="Mandatory"
							id="UNIT">
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="UNIT" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_UNIT" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
							<structure:AttributeRelationship>
								<structure:Group>
									<Ref id="Group" />
								</structure:Group>
							</structure:AttributeRelationship>
						</structure:Attribute>
						<structure:Attribute assignmentStatus="Mandatory"
							id="UNIT_MULT">
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="UNIT_MULT" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_UNIT_MULT" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
							<structure:AttributeRelationship>
								<structure:Group>
									<Ref id="Group" />
								</structure:Group>
							</structure:AttributeRelationship>
						</structure:Attribute>
						<structure:Attribute assignmentStatus="Mandatory">
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="TIME_FORMAT" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:TextFormat maxLength="3"/>
							</structure:LocalRepresentation>
							<structure:AttributeRelationship>
								<structure:Dimension><Ref id="FREQ"/></structure:Dimension>
								<structure:Dimension><Ref id="CURRENCY"/></structure:Dimension>
								<structure:Dimension><Ref id="CURRENCY_DENOM"/></structure:Dimension>
								<structure:Dimension><Ref id="EXR_TYPE"/></structure:Dimension>
								<structure:Dimension><Ref id="EXR_SUFFIX"/></structure:Dimension>
							</structure:AttributeRelationship>
						</structure:Attribute>
						<structure:Attribute assignmentStatus="Mandatory">
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="COLLECTION" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_COLLECTION" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
							<structure:AttributeRelationship>
								<structure:Dimension><Ref id="FREQ"/></structure:Dimension>
								<structure:Dimension><Ref id="CURRENCY"/></structure:Dimension>
								<structure:Dimension><Ref id="CURRENCY_DENOM"/></structure:Dimension>
								<structure:Dimension><Ref id="EXR_TYPE"/></structure:Dimension>
								<structure:Dimension><Ref id="EXR_SUFFIX"/></structure:Dimension>
							</structure:AttributeRelationship>
						</structure:Attribute>						
						<structure:Attribute assignmentStatus="Mandatory"
							id="OBS_STATUS">
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="OBS_STATUS" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_OBS_STATUS" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
							<structure:AttributeRelationship>
								<structure:PrimaryMeasure><Ref id="OBS_VALUE"/></structure:PrimaryMeasure>
							</structure:AttributeRelationship>
						</structure:Attribute>
						<structure:Attribute assignmentStatus="Conditional"
							id="OBS_CONF">
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="OBS_CONF" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:Enumeration>
									<Ref agencyID="ECB" id="CL_OBS_CONF" />
								</structure:Enumeration>
							</structure:LocalRepresentation>
							<structure:AttributeRelationship>
								<structure:PrimaryMeasure><Ref id="OBS_VALUE"/></structure:PrimaryMeasure>
							</structure:AttributeRelationship>
						</structure:Attribute>
					</structure:AttributeList>
					<structure:MeasureList>
						<structure:PrimaryMeasure>
							<structure:ConceptIdentity>
								<Ref agencyID="ECB"
									maintainableParentID="CORE_CONCEPTS" maintainableParentVersion="1.0"
									id="OBS_VALUE" />
							</structure:ConceptIdentity>
							<structure:LocalRepresentation>
								<structure:TextFormat textType="Decimal" />
							</structure:LocalRepresentation>
						</structure:PrimaryMeasure>
					</structure:MeasureList>
				</structure:DataStructureComponents>
			</structure:DataStructure>
		</structure:DataStructures>
	</message:Structures>
</message:Structure>		

private var _testCS:XML =
<message:Structure xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message http://ollie:8080/scorpio-external/vocabulary/sdmx/2.0/SDMXMessage.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure http://ollie:8080/scorpio-external/vocabulary/sdmx/2.0/SDMXStructure.xsd" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic" xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact" xmlns:metadatareport="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/metadatareport" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" xmlns:genericmetadata="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/genericmetadata" xmlns:registry="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/registry" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross">
    <message:Header>
        <message:ID>d87f1147-9505-45dd-9d2f-21200d6c2fe6</message:ID>
        <message:Test>false</message:Test>
        <message:Prepared>2009-06-09T14:46:15+02:00</message:Prepared>
        <message:Sender id="ECB">
            <message:Name>European Central Bank</message:Name>
            <message:Contact>
                <message:Email>statistics@ecb.europa.eu</message:Email>
            </message:Contact>
        </message:Sender>
    </message:Header>
    <message:CategorySchemes>
        <structure:CategoryScheme isFinal="true" version="1.0" agencyID="ECB" id="SDW_ECONOMIC_CONCEPTS">
            <structure:Name>SDW economic concepts</structure:Name>
            <structure:Category version="1.0" id="2018800">
                <structure:Name>Monetary operations</structure:Name>
                <structure:Category version="1.0" id="2018801">
                    <structure:Name>Key interest rates</structure:Name>
                    <structure:DataflowRef>
                        <structure:AgencyID>ECB</structure:AgencyID>
                        <structure:DataflowID>2136672</structure:DataflowID>
                        <structure:Version>1.0</structure:Version>
                    </structure:DataflowRef>
                </structure:Category>
                <structure:Category version="1.0" id="2018802">
                    <structure:Name>Minimum reserves and liquidity</structure:Name>
                    <structure:DataflowRef>
                        <structure:AgencyID>ECB</structure:AgencyID>
                        <structure:DataflowID>2136673</structure:DataflowID>
                        <structure:Version>1.0</structure:Version>
                    </structure:DataflowRef>
                    <structure:DataflowRef>
                        <structure:AgencyID>ECB</structure:AgencyID>
                        <structure:DataflowID>2034468</structure:DataflowID>
                        <structure:Version>1.0</structure:Version>
                    </structure:DataflowRef>
                </structure:Category>
            </structure:Category>
		</structure:CategoryScheme>
    </message:CategorySchemes>
</message:Structure>

private var _testCS21:XML =
<message:Structure
	xmlns:message="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message"
	xmlns:structure="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure"
	xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message ../../xsd/SDMX/2.1/SDMXMessage.xsd">
    <message:Header>
        <message:ID>d87f1147-9505-45dd-9d2f-21200d6c2fe6</message:ID>
        <message:Test>false</message:Test>
        <message:Prepared>2009-06-09T14:46:15+02:00</message:Prepared>
        <message:Sender id="ECB"/>
    </message:Header>
    <message:Structures>
	    <structure:CategorySchemes>
	        <structure:CategoryScheme isFinal="true" version="1.0" agencyID="ECB" id="SDW_ECONOMIC_CONCEPTS">
	            <common:Name>SDW economic concepts</common:Name>
	            <structure:Category id="2018800">
	                <common:Name>Monetary operations</common:Name>
	                <structure:Category id="2018801">
	                    <common:Name>Key interest rates</common:Name>
	                </structure:Category>
	                <structure:Category id="2018802">
	                    <common:Name>Minimum reserves and liquidity</common:Name>
	                </structure:Category>
	            </structure:Category>
			</structure:CategoryScheme>
	    </structure:CategorySchemes>
	    <structure:Categorisations>
	    	<structure:Categorisation id="categorisation1" agencyID="ECB">
	    		<common:Name>Tmp Cat</common:Name>
	    		<structure:Source>
	    			<Ref id="2136672" class="Dataflow" package="datastructure" agencyID="ECB" version="1.0"/>
	    		</structure:Source>
	    		<structure:Target>
	    			<Ref agencyID="ECB" maintainableParentID="SDW_ECONOMIC_CONCEPTS" id="2018801"/>
	    		</structure:Target>
	    	</structure:Categorisation>
	    	<structure:Categorisation id="categorisation2" agencyID="ECB">
	    		<common:Name>Tmp Cat 2</common:Name>
	    		<structure:Source>
	    			<Ref id="2136673" class="Dataflow" package="datastructure" agencyID="ECB" version="1.0"/>	    			
	    		</structure:Source>
	    		<structure:Target>
	    			<Ref agencyID="ECB" maintainableParentID="SDW_ECONOMIC_CONCEPTS" id="2018802"/>
	    		</structure:Target>
	    	</structure:Categorisation>
	    	<structure:Categorisation id="categorisation3" agencyID="ECB">
	    		<common:Name>Tmp Cat 3</common:Name>
	    		<structure:Source>
	    			<Ref id="2034468" class="Dataflow" package="datastructure" agencyID="ECB" version="1.0"/>
	    		</structure:Source>
	    		<structure:Target>
	    			<Ref agencyID="ECB" maintainableParentID="SDW_ECONOMIC_CONCEPTS" id="2018802"/>
	    		</structure:Target>
	    	</structure:Categorisation>
	    </structure:Categorisations>
    </message:Structures>
</message:Structure>

		private var _testOS:XML =
<message:Structure xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message http://ollie:8080/scorpio-external/vocabulary/sdmx/2.0/SDMXMessage.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure http://ollie:8080/scorpio-external/vocabulary/sdmx/2.0/SDMXStructure.xsd" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic" xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact" xmlns:metadatareport="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/metadatareport" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" xmlns:genericmetadata="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/genericmetadata" xmlns:registry="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/registry" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross">
    <message:Header>
        <message:ID>d4bf2593-261d-4879-9910-4d29a9e25787</message:ID>
        <message:Test>false</message:Test>
        <message:Prepared>2009-06-09T14:47:16+02:00</message:Prepared>
        <message:Sender id="ECB"/>
    </message:Header>
    <message:OrganisationSchemes>
        <structure:OrganisationScheme isFinal="true" agencyID="ECB" version="1.0" id="ESCB">
            <structure:Name>27 EU National Central Banks plus ECB</structure:Name>
            <structure:Agencies>
                <structure:Agency id="ECB">
                    <structure:Name>European Central Bank</structure:Name>
                    <structure:MaintenanceContact>
                        <structure:Name>Statistics Hotline</structure:Name>
                        <structure:Department>DG - Statistics</structure:Department>
                        <structure:Telephone>+49 69 1344 6688</structure:Telephone>
                        <structure:Email>statistics@ecb.europa.eu</structure:Email>
                    </structure:MaintenanceContact>
                </structure:Agency>
            </structure:Agencies>
            <structure:DataProviders>
                <structure:DataProvider id="COCOA">
                    <structure:Name>Cocoa Island</structure:Name>
                </structure:DataProvider>
                <structure:DataProvider id="ECB">
                    <structure:Name>European Central Bank</structure:Name>
                    <structure:MaintenanceContact>
                        <structure:Name>Statistics Hotline</structure:Name>
                        <structure:Department>DG - Statistics</structure:Department>
                        <structure:Telephone>+49 69 1344 6688</structure:Telephone>
                        <structure:Email>statistics@ecb.europa.eu</structure:Email>
                    </structure:MaintenanceContact>
                </structure:DataProvider>
            </structure:DataProviders>
        </structure:OrganisationScheme>
    </message:OrganisationSchemes>
</message:Structure>
		
		private var _testDF:XML =
<message:Structure xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message http://ollie:8080/scorpio-external/vocabulary/sdmx/2.0/SDMXMessage.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure http://ollie:8080/scorpio-external/vocabulary/sdmx/2.0/SDMXStructure.xsd" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic" xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact" xmlns:metadatareport="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/metadatareport" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" xmlns:genericmetadata="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/genericmetadata" xmlns:registry="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/registry" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross">
    <message:Header>
        <message:ID>43c6984c-ca56-49d2-96ee-1ca226497526</message:ID>
        <message:Test>false</message:Test>
        <message:Prepared>2009-06-09T14:48:36+02:00</message:Prepared>
        <message:Sender id="ECB">
            <message:Name>European Central Bank</message:Name>
            <message:Contact>
                <message:Email>statistics@ecb.europa.eu</message:Email>
            </message:Contact>
        </message:Sender>
    </message:Header>
    <message:Dataflows>
        <structure:Dataflow isFinal="true" agencyID="ECB" version="1.0" id="2034468">
            <structure:Name>Internal Liquidity Management  - Minimum reserves and liquidity</structure:Name>
            <structure:KeyFamilyRef>
                <structure:KeyFamilyID>ECB_ILM1</structure:KeyFamilyID>
                <structure:KeyFamilyAgencyID>ECB</structure:KeyFamilyAgencyID>
                <structure:Version>1.0</structure:Version>
            </structure:KeyFamilyRef>
			<structure:Constraint ConstraintType="Content">
                <common:ConstraintID>ECB_ILM1-CONSTRAINT</common:ConstraintID>
                <common:CubeRegion isIncluded="true">
                    <common:Member isIncluded="true">
                        <common:ComponentRef>FREQ</common:ComponentRef>
                        <common:MemberValue>
                            <common:Value>M</common:Value>
                        </common:MemberValue>
                        <common:MemberValue>
                            <common:Value>W</common:Value>
                        </common:MemberValue>
                    </common:Member>
                    <common:Member isIncluded="false">
                        <common:ComponentRef>REF_AREA</common:ComponentRef>
                        <common:MemberValue>
                            <common:Value>U2</common:Value>
                        </common:MemberValue>
                    </common:Member>
				</common:CubeRegion>
			</structure:Constraint>					
        </structure:Dataflow>
    </message:Dataflows>
</message:Structure>

		private var _testDF21:XML =	
<message:Structure
	xmlns:message="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message"
	xmlns:structure="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure"
	xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message ../../xsd/SDMX/2.1/SDMXMessage.xsd">
    <message:Header>
        <message:ID>43c6984c-ca56-49d2-96ee-1ca226497526</message:ID>
        <message:Test>false</message:Test>
        <message:Prepared>2009-06-09T14:48:36+02:00</message:Prepared>
        <message:Sender id="ECB"/>
    </message:Header>
    <message:Structures>
	    <structure:Dataflows>
	        <structure:Dataflow isFinal="true" agencyID="ECB" version="1.0" id="2034468">
	            <common:Name>Internal Liquidity Management  - Minimum reserves and liquidity</common:Name>
	            <structure:Structure>
		            <Ref agencyID="ECB" id="ECB_ILM1" version="1.0"/>
	            </structure:Structure>
	        </structure:Dataflow>
	    </structure:Dataflows>
	    <structure:Constraints>
	    	<structure:ContentConstraint agencyID="ECB" id="ECB_ILM1-CONSTRAINT">
	    		<common:Name>Constraint for ECB_ILM1</common:Name>
	    		<structure:ConstraintAttachment>
	    			<structure:Dataflow>
	    				<Ref agencyID="ECB" id="2034468"/>
	    			</structure:Dataflow>
	    		</structure:ConstraintAttachment>
                <structure:CubeRegion include="true">
                	<common:KeyValue id="FREQ" include="true">
                		<common:Value>M</common:Value>
                		<common:Value>W</common:Value>                		
                	</common:KeyValue>
                	<common:KeyValue id="REF_AREA" include="false">
                		<common:Value>U2</common:Value>
                	</common:KeyValue>                	
				</structure:CubeRegion>
			</structure:ContentConstraint>
	    </structure:Constraints>
    </message:Structures>
</message:Structure>

		private var _testHCS:XML =
<message:Structure xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message http://ollie:8080/scorpio-external/vocabulary/sdmx/2.0/SDMXMessage.xsd http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure http://ollie:8080/scorpio-external/vocabulary/sdmx/2.0/SDMXStructure.xsd" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic" xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact" xmlns:metadatareport="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/metadatareport" xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" xmlns:query="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query" xmlns:genericmetadata="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/genericmetadata" xmlns:registry="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/registry" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross">
    <message:Header>
        <message:ID>43c6984c-ca56-49d2-96ee-1ca226497526</message:ID>
        <message:Test>false</message:Test>
        <message:Prepared>2009-06-09T14:48:36+02:00</message:Prepared>
        <message:Sender id="ECB">
            <message:Name>European Central Bank</message:Name>
            <message:Contact>
                <message:Email>statistics@ecb.europa.eu</message:Email>
            </message:Contact>
        </message:Sender>
    </message:Header>
    <message:CodeLists>
    	<structure:CodeList isFinal="true" version="1.0" agencyID="ECB" id="CL_ICP_ITEM">
            <structure:Name>Indices of Consumer Prices classification code list</structure:Name>
            <structure:Code value="000000">
                <structure:Description>HICP - Overall index</structure:Description>
            </structure:Code>
            <structure:Code value="010000">
                <structure:Description>HICP - FOOD AND NON-ALCOHOLIC BEVERAGES</structure:Description>
            </structure:Code>
            <structure:Code value="011000">
                <structure:Description>HICP - Food</structure:Description>
            </structure:Code>
		</structure:CodeList>      
	</message:CodeLists>	      
	<message:HierarchicalCodelists>
    	<structure:HierarchicalCodelist version="1.0" agencyID="ECB" 
    		id="ICP_HIERARCHIES">
    		<structure:Name>Hierarchies used for the HICP visualisation tools</structure:Name>
    		<structure:CodelistRef>
    			<structure:AgencyID>ECB</structure:AgencyID>
				<structure:CodelistID>CL_ICP_ITEM</structure:CodelistID>
				<structure:Version>1.0</structure:Version>
				<structure:Alias>ICP_ITEM</structure:Alias>
    		</structure:CodelistRef>
    		<structure:Hierarchy id="H_ICP_ITEM_1">
    			<structure:Name>Breakdown by purpose of consumption</structure:Name>
    			<structure:CodeRef>
    				<structure:CodelistAliasRef>ICP_ITEM</structure:CodelistAliasRef>
    				<structure:CodeID>000000</structure:CodeID>
    				<structure:CodeRef>
	    				<structure:CodelistAliasRef>ICP_ITEM</structure:CodelistAliasRef>
	    				<structure:CodeID>010000</structure:CodeID>
	    				<structure:NodeAliasID>010000</structure:NodeAliasID>
	    			</structure:CodeRef>
	    			<structure:NodeAliasID>000000</structure:NodeAliasID>
	    		</structure:CodeRef>
	    	</structure:Hierarchy>
	    </structure:HierarchicalCodelist>
	 </message:HierarchicalCodelists>   				
</message:Structure>

		private var _testHCS21:XML =
<message:Structure
	xmlns:message="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message"
	xmlns:structure="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure"
	xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message ../../xsd/SDMX/2.1/SDMXMessage.xsd">
	<message:Header>
		<message:ID>43c6984c-ca56-49d2-96ee-1ca226497526</message:ID>
		<message:Test>false</message:Test>
		<message:Prepared>2009-06-09T14:48:36+02:00</message:Prepared>
		<message:Sender id="ECB"/>
	</message:Header>
	<message:Structures>
		<structure:Codelists>
			<structure:Codelist isFinal="true" version="1.0" agencyID="ECB"
				id="CL_ICP_ITEM">
				<common:Name>
					Indices of Consumer Prices classification code list
				</common:Name>
				<structure:Code id="000000">
					<common:Name>HICP - Overall index</common:Name>
				</structure:Code>
				<structure:Code id="010000">
					<common:Name>
						HICP - FOOD AND NON-ALCOHOLIC BEVERAGES
					</common:Name>
				</structure:Code>
				<structure:Code id="011000">
					<common:Name>HICP - Food</common:Name>
				</structure:Code>
			</structure:Codelist>
		</structure:Codelists>
		<structure:HierarchicalCodelists>
			<structure:HierarchicalCodelist version="1.0" agencyID="ECB"
				id="ICP_HIERARCHIES">
				<common:Name>
					Hierarchies used for the HICP visualisation tools
				</common:Name>
				<structure:IncludedCodelist alias="ICP_ITEM">
					<Ref agencyID="ECB" id="CL_ICP_ITEM" version="1.0"/>
				</structure:IncludedCodelist>
				<structure:Hierarchy id="H_ICP_ITEM_1">
					<common:Name>
						Breakdown by purpose of consumption
					</common:Name>
					<structure:HierarchicalCode id="000000">
						<structure:CodelistAliasRef>ICP_ITEM</structure:CodelistAliasRef>
						<structure:CodeID>
							<Ref id="000000"/>
						</structure:CodeID>
						<structure:HierarchicalCode id="010000">
							<structure:CodelistAliasRef>ICP_ITEM</structure:CodelistAliasRef>
							<structure:CodeID>
								<Ref id="010000"/>
							</structure:CodeID>
						</structure:HierarchicalCode>
					</structure:HierarchicalCode>
				</structure:Hierarchy>
			</structure:HierarchicalCodelist>
		</structure:HierarchicalCodelists>
	</message:Structures>
</message:Structure>
		
		public function StructureReaderTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(StructureReaderTest);
		}
		
		public function testExtractCodeLists():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchCodeLists = true;
			reader.addEventListener(StructureReader.CODE_LISTS_EVENT, 
				addAsync(handleCodeLists, 3000));
			reader.read(_testXML);
		}
		
		public function testExtractCodeLists21():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchCodeLists = true;
			reader.addEventListener(StructureReader.CODE_LISTS_EVENT, 
				addAsync(handleCodeLists, 3000));
			reader.read(_testDSD21);
		}
		
		public function testExtractConcepts():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchConcepts = true;
			reader.addEventListener(StructureReader.CONCEPTS_EVENT, 
				addAsync(handleConcepts, 3000));
			reader.read(_testXML);
		}
		
		public function testExtractConcepts21():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchConcepts = true;
			reader.addEventListener(StructureReader.CONCEPTS_EVENT, 
				addAsync(handleConcepts, 3000));
			reader.read(_testDSD21);
		}
		
		public function testExtractKeyFamily():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchKeyFamilies = true;
			reader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleKeyFamilies, 3000));
			reader.read(_testXML);
		}
		
		public function testExtractDSD21():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchKeyFamilies = true;
			reader.addEventListener(StructureReader.KEY_FAMILIES_EVENT,
				addAsync(handleKeyFamilies, 3000));
			reader.read(_testDSD21);
		}
		
		public function testExtractDataflow():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchDataflows = true;
			reader.addEventListener(StructureReader.DATAFLOWS_EVENT,
				addAsync(handleDF, 3000));
			reader.read(_testDF);
		}
		
		public function testExtractDataflow21():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchDataflows = true;
			reader.addEventListener(StructureReader.DATAFLOWS_EVENT,
				addAsync(handleDF, 3000));
			reader.read(_testDF21);
		}
		
		public function testExtractOrganisationScheme():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchOrganisationSchemes = true;
			reader.addEventListener(StructureReader.ORGANISATION_SCHEMES_EVENT,
				addAsync(handleOS, 3000));
			reader.read(_testOS);
		}
		
		public function testExtractHierachicalCodeScheme():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchHierarchicalCodeSchemes = true;
			reader.addEventListener(
				StructureReader.HIERARCHICAL_CODE_SCHEMES_EVENT,
				addAsync(handleHCS, 3000));
			reader.read(_testHCS);
		}
		
		public function testExtractHierachicalCodeScheme21():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchHierarchicalCodeSchemes = true;
			reader.addEventListener(
				StructureReader.HIERARCHICAL_CODE_SCHEMES_EVENT,
				addAsync(handleHCS, 3000));
			reader.read(_testHCS21);
		}
		
		public function testCategoryScheme():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchCategorySchemes = true;
			reader.addEventListener(StructureReader.CATEGORY_SCHEMES_EVENT,
				addAsync(handleCS, 3000));
			reader.read(_testCS);
		}
		
		public function testCategoryScheme21():void
		{
			var reader:StructureReader = new StructureReader();
			reader.dispatchCategorySchemes = true;
			reader.addEventListener(StructureReader.CATEGORY_SCHEMES_EVENT,
				addAsync(handleCS, 3000));
			reader.read(_testCS21);
		}
		
		private function handleCodeLists(event:SDMXDataEvent):void
		{
			assertTrue("There should be some code lists in the event", 
				event.data is CodeLists);
			var codeLists:CodeLists = event.data as CodeLists;
			assertEquals("There must be 10 code lists", 10, codeLists.length);
			var codeList1:CodeList = codeLists.getItemAt(0) as CodeList;
			assertEquals("The 1st code list should be CL_COLLECTION", 
				"CL_COLLECTION", codeList1.id);
			assertEquals("There should be 10 codes in the code list", 10,
				codeList1.codes.length);
			var codeList2:CodeList = codeLists.getItemAt(9) as CodeList;	
			assertEquals("The 1st code list should be CL_UNIT_MULT", 
				"CL_UNIT_MULT", codeList2.id);
			assertEquals("There should be 7 codes in the code list", 7,
				codeList2.codes.length);
		}
		
		private function handleConcepts(event:SDMXDataEvent):void
		{
			var concepts:Concepts = event.data as Concepts;
			assertTrue("There should be at least 1 concept/concept scheme", 
				concepts.length > 0);
			if (concepts.getItemAt(0) is Concept) {	
				assertEquals("There must be 15 concepts", 15, concepts.length);
				var concept1:Concept = concepts.getItemAt(0) as Concept;
				assertEquals("The 1st concept should be 'COLLECTION'", 
					"COLLECTION", concept1.id);
				var concept2:Concept = concepts.getItemAt(14) as Concept;
				assertEquals("The last concept should be 'UNIT_MULT'", 
					"UNIT_MULT", concept2.id);			
			} else if (concepts.getItemAt(0) is ConceptScheme) {
				var scheme:ConceptScheme = 
					concepts.getItemAt(0) as ConceptScheme; 
				assertEquals("There must be 15 concepts", 15, 
					scheme.concepts.length);
				var concept1:Concept = scheme.concepts.getItemAt(0) as Concept;
				assertEquals("The 1st concept should be 'COLLECTION'", 
					"COLLECTION", concept1.id);
				var concept2:Concept = scheme.concepts.getItemAt(14) as Concept;
				assertEquals("The last concept should be 'UNIT_MULT'", 
					"UNIT_MULT", concept2.id);		
			} else {
				fail("Unexpected type");
			}
		}
		
		private function handleKeyFamilies(event:SDMXDataEvent):void
		{
			var keyFamily:KeyFamily = (event.data as KeyFamilies).getItemAt(0) 
				as KeyFamily;
			assertEquals("Key family is ECB_EXR1", "ECB_EXR1", keyFamily.id);
			assertEquals("There should be 6 dimensions in the KF", 6, 
				keyFamily.keyDescriptor.length);
			for each (var dim:Dimension in 	keyFamily.keyDescriptor) {
				if (dim.id == "FREQ") {
					assertEquals(ConceptRole.FREQUENCY, dim.conceptRole);
					assertEquals("CL_FREQ", 
						(dim.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(dim.localRepresentation as CodeList).maintainer.id);	
				} else if (dim.id == "CURRENCY") {
					assertNull(dim.conceptRole);
					assertEquals("CL_CURRENCY", 						
						(dim.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(dim.localRepresentation as CodeList).maintainer.id);
				} else if (dim.id == "CURRENCY_DENOM") {
					assertNull(dim.conceptRole);
					assertEquals("CL_CURRENCY", 
						(dim.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(dim.localRepresentation as CodeList).maintainer.id);
				} else if (dim.id == "EXR_TYPE") {
					assertNull(dim.conceptRole);
					assertEquals("CL_EXR_TYPE", 
						(dim.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(dim.localRepresentation as CodeList).maintainer.id);
				} else if (dim.id == "EXR_SUFFIX") {
					assertNull(dim.conceptRole);
					assertEquals("CL_EXR_SUFFIX", 
						(dim.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(dim.localRepresentation as CodeList).maintainer.id);	
				} else if (dim.id == "TIME_PERIOD") {
					assertEquals(ConceptRole.TIME, dim.conceptRole);
					assertNull(dim.localRepresentation);	
				} else {
					fail("Unexpected dimension: " + dim.id);
				}
			}
			
			assertEquals("There should be 1 measure", 1, 
				keyFamily.measureDescriptor.length);	
			var measure:Measure = 
				keyFamily.measureDescriptor.getItemAt(0) as Measure;
			assertEquals("Measure", measure.id);
			assertEquals("OBS_VALUE", measure.conceptIdentity.id);
			assertEquals(ConceptRole.PRIMARY_MEASURE, measure.conceptRole);	
			assertNull(measure.localRepresentation);
				
			assertEquals("There should be 1 group descriptor", 1, 
				keyFamily.groupDescriptors.length);
			var group:GroupKeyDescriptor = 
				keyFamily.groupDescriptors.getItemAt(0) as GroupKeyDescriptor;
			assertEquals(4, group.length);
			assertEquals("CURRENCY.CURRENCY_DENOM.EXR_TYPE.EXR_SUFFIX", 
				group.groupKey);	
			
			assertEquals("There should be 8 attributes", 8, 
				keyFamily.attributeDescriptor.length);	
			for each (var attr:DataAttribute in keyFamily.attributeDescriptor) {
				if (attr.id == "TIME_FORMAT") {
					assertEquals(ConceptRole.TIME_FORMAT, attr.conceptRole);
					assertEquals(AttachmentLevel.SERIES, attr.attachmentLevel);
					assertEquals(UsageStatus.MANDATORY, attr.usageStatus);
					assertEquals(3, ((attr as UncodedDataAttribute).
						localRepresentation as LengthRange).maxLength);
				} else if (attr.id == "OBS_STATUS") {
					assertNull(attr.conceptRole);
					assertEquals(AttachmentLevel.OBSERVATION, attr.attachmentLevel);
					assertEquals(UsageStatus.MANDATORY, attr.usageStatus);
					assertEquals("CL_OBS_STATUS", 
						(attr.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(attr.localRepresentation as CodeList).maintainer.id);
				} else if (attr.id == "OBS_CONF") {
					assertNull(attr.conceptRole);
					assertEquals(AttachmentLevel.OBSERVATION, attr.attachmentLevel);
					assertEquals(UsageStatus.CONDITIONAL, attr.usageStatus);
					assertEquals("CL_OBS_CONF", 
						(attr.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(attr.localRepresentation as CodeList).maintainer.id);
				} else if (attr.id == "COLLECTION") {
					assertNull(attr.conceptRole);
					assertEquals(AttachmentLevel.SERIES, attr.attachmentLevel);
					assertEquals(UsageStatus.MANDATORY, attr.usageStatus);
					assertEquals("CL_COLLECTION", 
						(attr.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(attr.localRepresentation as CodeList).maintainer.id);
				} else if (attr.id == "DECIMALS") {
					assertNull(attr.conceptRole);
					assertEquals(AttachmentLevel.GROUP, attr.attachmentLevel);
					assertEquals(UsageStatus.MANDATORY, attr.usageStatus);
					assertEquals("CL_DECIMALS", 
						(attr.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(attr.localRepresentation as CodeList).maintainer.id);	
				} else if (attr.id == "TITLE_COMPL") {
					assertNull(attr.conceptRole);
					assertEquals(AttachmentLevel.GROUP, attr.attachmentLevel);
					assertEquals(UsageStatus.MANDATORY, attr.usageStatus);
					assertEquals(1050, ((attr as UncodedDataAttribute).
						localRepresentation as LengthRange).maxLength);
				} else if (attr.id == "UNIT") {
					assertNull(attr.conceptRole);
					assertEquals(AttachmentLevel.GROUP, attr.attachmentLevel);
					assertEquals(UsageStatus.MANDATORY, attr.usageStatus);
					assertEquals("CL_UNIT", 
						(attr.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(attr.localRepresentation as CodeList).maintainer.id);	
				} else if (attr.id == "UNIT_MULT") {
					assertNull(attr.conceptRole);
					assertEquals(AttachmentLevel.GROUP, attr.attachmentLevel);
					assertEquals(UsageStatus.MANDATORY, attr.usageStatus);
					assertEquals("CL_UNIT_MULT", 
						(attr.localRepresentation as CodeList).id);
					assertEquals("ECB", 
						(attr.localRepresentation as CodeList).maintainer.id);
				} else {
					fail("Unexpected attribute: " + attr.id);
				}
			}	
		}
		
		private function handleOS(event:SDMXDataEvent):void
		{        
			assertTrue("There should be an organisation scheme in the event", 
				event.data is OrganisationSchemes);
			var org:OrganisationSchemes = event.data as OrganisationSchemes;	
			assertEquals("There must be 1 os", 1, org.length);
			var os1:OrganisationScheme = org.getItemAt(0) as OrganisationScheme;
			assertEquals("Should be ESCB", "ESCB", os1.id);
			assertEquals("There should be 2 organisations in the os", 2,
				os1.organisations.length);
		}
		
		private function handleCS(event:SDMXDataEvent):void
		{
			assertTrue("There should a list of category schemes in the event", 
				event.data is CategorieSchemesCollection);
			var schemes:CategorieSchemesCollection = 
				event.data as CategorieSchemesCollection;
			assertEquals("There must be 1 category scheme", 1, schemes.length);
			
			var scheme:CategoryScheme = schemes.getItemAt(0) as CategoryScheme;
			assertEquals("The scheme should be", "SDW_ECONOMIC_CONCEPTS", 
				scheme.id);
			assertTrue(scheme.isFinal);	
			assertEquals("1.0", scheme.version);
			assertEquals("ECB", scheme.maintainer.id);
			assertEquals("SDW economic concepts", scheme.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals(1, scheme.categories.length);
			
			var rootCat:Category = scheme.categories.getItemAt(0) as Category;
			assertEquals(2018800, rootCat.id);
			assertEquals("Monetary operations", rootCat.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals(2, rootCat.categories.length);
			assertEquals(0, rootCat.dataflows.length);
			
			var childCat1:Category = rootCat.categories.getItemAt(0) as Category;
			var childCat2:Category = rootCat.categories.getItemAt(1) as Category;
			assertEquals(2018801, childCat1.id);
			assertEquals("Key interest rates", childCat1.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals(0, childCat1.categories.length);
			assertEquals(1, childCat1.dataflows.length);
			var flow1:DataflowDefinition = 
				childCat1.dataflows.getItemAt(0) as DataflowDefinition; 
			assertEquals("2136672", flow1.id);
			assertEquals("ECB", flow1.maintainer.id);
			assertEquals("1.0", flow1.version);
			
			assertEquals(2018802, childCat2.id);
			assertEquals("Minimum reserves and liquidity", childCat2.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals(0, childCat2.categories.length);
			assertEquals(2, childCat2.dataflows.length);
			var flow2:DataflowDefinition = 
				childCat2.dataflows.getItemAt(0) as DataflowDefinition;
			var flow3:DataflowDefinition = 
				childCat2.dataflows.getItemAt(1) as DataflowDefinition;
			assertEquals("2136673", flow2.id);
			assertEquals("ECB", flow2.maintainer.id);
			assertEquals("1.0", flow2.version);
			assertEquals("2034468", flow3.id);
			assertEquals("ECB", flow3.maintainer.id);
			assertEquals("1.0", flow3.version);
		}
		
		private function handleDF(event:SDMXDataEvent):void
		{
			assertTrue("There should be some dataflows in the event", 
				event.data is DataflowsCollection);
			var flows:DataflowsCollection = event.data as DataflowsCollection;
			assertEquals("There must be 1 dataflow", 1, flows.length);
			var df:DataflowDefinition = 
				flows.getItemAt(0) as DataflowDefinition;
			assertEquals("The 1st df should be 2034468", 
				"2034468", df.id);
			assertEquals("ECB", df.maintainer.id);
			assertTrue(df.isFinal);
			assertEquals("Internal Liquidity Management  - Minimum reserves and liquidity", 
				df.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("ECB", df.structure.maintainer.id);
			assertEquals("ECB_ILM1", df.structure.id);
			assertEquals("1.0", df.structure.version);					
			assertNotNull(df.contentConstraint); 				
			assertEquals("ECB_ILM1-CONSTRAINT", df.contentConstraint.id);
			assertEquals(1, df.contentConstraint.permittedContentRegion.length);
			var cube:CubeRegion = 
				df.contentConstraint.permittedContentRegion.getItemAt(0) as
					CubeRegion;
			assertEquals(2, cube.members.length);
			var member1:MemberSelection = 
				cube.members.getItemAt(0) as MemberSelection; 						
			var member2:MemberSelection = 
				cube.members.getItemAt(1) as MemberSelection;
			assertTrue(member1.isIncluded);
            assertEquals("FREQ", member1.structureComponent.id);
			assertEquals(2, member1.values.length);
			assertTrue(member1.values.contains("M"));
			assertTrue(member1.values.contains("W"));
			assertFalse(member2.isIncluded);
			assertEquals("REF_AREA", member2.structureComponent.id);
			assertEquals(1, member2.values.length);
			assertTrue(member2.values.contains("U2"));
		}
		
		private function handleHCS(event:SDMXDataEvent):void
		{
			assertTrue("There should a list of hierarchical code schemes" + 
				" in the event", 
				event.data is HierarchicalCodeSchemesCollection);
			var schemes:HierarchicalCodeSchemesCollection = 
				event.data as HierarchicalCodeSchemesCollection;
			assertEquals("There must be 1 code scheme", 1, schemes.length);
			var scheme:HierarchicalCodeScheme = 
				schemes.getItemAt(0) as HierarchicalCodeScheme;
			assertEquals("The scheme should be", "ICP_HIERARCHIES", 
				scheme.id);
			assertEquals("The maintenance agency should be", "ECB", 
				scheme.maintainer.id);
			assertEquals("There should be 1 hierarchy", 1, 
				scheme.hierarchies.length);	
			var hierarchy:Hierarchy = 
				scheme.hierarchies.getItemAt(0) as Hierarchy;
			assertEquals("H_ICP_ITEM_1", hierarchy.id);
			assertEquals("Breakdown by purpose of consumption", 
				hierarchy.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("There should be 1 child", 1, hierarchy.children.length);
			var ca:CodeAssociation = 
				hierarchy.children.getItemAt(0) as CodeAssociation;
			assertEquals("000000", ca.id);
			assertEquals("000000", ca.code.id);
			assertEquals("CL_ICP_ITEM", ca.codeList.id);
			assertEquals("ECB", ca.codeList.maintainer.id);	
			assertEquals(1, ca.children.length);
			var childCa:CodeAssociation = 
				ca.children.getItemAt(0) as CodeAssociation;
			assertEquals("010000", childCa.id);
			assertEquals("010000", childCa.code.id);
			assertEquals("CL_ICP_ITEM", childCa.codeList.id);
			assertEquals("ECB", childCa.codeList.maintainer.id);	
			assertEquals(0, childCa.children.length);
		}
	}
}