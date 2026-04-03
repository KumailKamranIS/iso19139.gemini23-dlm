<?xml version="1.0" encoding="utf-8"?>

<!--
	Force metadata to have Gemini 2.2 Metadata Standard and Version and fix gml namespaces
-->

<xsl:stylesheet xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gml="http://www.opengis.net/gml/3.2"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	version="2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>


    <!-- ========================================================================== -->
    <!-- Metadata Standard Name and Version
    -->
    <!-- ========================================================================== -->
	<!--  Change standard to UK GEMINI  -->
	
	<xsl:template match="gmd:metadataStandardName">
		<xsl:message>==== Updating Metadata Standard Name ====</xsl:message>
		<gmd:metadataStandardName>
      <gmx:Anchor xlink:href="http://vocab.nerc.ac.uk/collection/M25/current/GEMINI/">UK GEMINI</gmx:Anchor>
  </gmd:metadataStandardName>
	</xsl:template>
	
	<xsl:template match="gmd:metadataStandardVersion">
		<xsl:message>==== Updating Metadata Standard Version ====</xsl:message>
		 <gmd:metadataStandardVersion>
      <gco:CharacterString>2.3</gco:CharacterString>
  </gmd:metadataStandardVersion>
	</xsl:template>

	 <!-- ========================================================================== -->
    <!-- Schema Location                                                              -->
    <!-- ========================================================================== -->
	
	<!--  Change schema location to gemini version  -->
	<xsl:template match="gmd:MD_Metadata">
			<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:copy-of select="namespace::*[name()]"/>
			<xsl:apply-templates select="@*"/>
			
			<xsl:apply-templates select="gmd:fileIdentifier" />
			<xsl:apply-templates select="gmd:language" />  
			<xsl:apply-templates select="gmd:characterSet" />
			<xsl:apply-templates select="gmd:parentIdentifier" />
			<xsl:apply-templates select="gmd:hierarchyLevel" />
			<xsl:apply-templates select="gmd:hierarchyLevelName" />
			<xsl:apply-templates select="gmd:contact" /> 
			<xsl:apply-templates select="gmd:dateStamp" />   
			<xsl:apply-templates select="gmd:metadataStandardName" />
			<xsl:if test="not(gmd:metadataStandardName)">
				<xsl:message>==== Adding Metadata Standard Name ====</xsl:message>
				<gmd:metadataStandardName>
      <gmx:Anchor xlink:href="http://vocab.nerc.ac.uk/collection/M25/current/GEMINI/">UK GEMINI</gmx:Anchor>
  </gmd:metadataStandardName>
			</xsl:if>

			<xsl:apply-templates select="gmd:metadataStandardVersion" />
			<xsl:if test="not(gmd:metadataStandardVersion)">
				<xsl:message>==== Adding Metadata Standard Version ====</xsl:message>
				<gmd:metadataStandardVersion>
      <gco:CharacterString>2.3</gco:CharacterString>
  </gmd:metadataStandardVersion>
			</xsl:if>
			
			
			<xsl:apply-templates select="gmd:dataSetURI" /> 
			<xsl:apply-templates select="gmd:locale" />  
			<xsl:apply-templates select="gmd:spatialRepresentationInfo" />    
			<xsl:apply-templates select="gmd:referenceSystemInfo" />    
			<xsl:apply-templates select="gmd:metadataExtensionInfo" />    
			<xsl:apply-templates select="gmd:identificationInfo" />   
			<xsl:apply-templates select="gmd:contentInfo" />    
			<xsl:apply-templates select="gmd:distributionInfo" />    
			<xsl:apply-templates select="gmd:dataQualityInfo" />    
			<xsl:apply-templates select="gmd:portrayalCatalogueInfo" />    
			<xsl:apply-templates select="gmd:metadataConstraints" />    
			<xsl:apply-templates select="gmd:applicationSchemaInfo" />    
			<xsl:apply-templates select="gmd:metadataMaintenance" />    
			<xsl:apply-templates select="gmd:series" />    
			<xsl:apply-templates select="gmd:describes" />    
			<xsl:apply-templates select="gmd:propertyType" />    
			<xsl:apply-templates select="gmd:featureType" />    
			<xsl:apply-templates select="gmd:featureAttribute" /> 
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="gmd:hierarchyLevelName">
		<xsl:variable name="resourceType" select="//gmd:hierarchyLevel/gmd:MD_ScopeCode"/>
		<xsl:message>=== Resource Type is <xsl:value-of select="$resourceType"/></xsl:message>
		<gmd:hierarchyLevelName>
			<gco:CharacterString><xsl:value-of select="$resourceType"/></gco:CharacterString>
		</gmd:hierarchyLevelName>
	</xsl:template>
	
	<!--  Update Namespace  -->
	<!--<xsl:template match="/*">
		<gmd:MD_Metadata xmlns:gml="http://www.opengis.net/gml/3.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</gmd:MD_Metadata>
	</xsl:template>-->
	
	<xsl:template match="gmd:identificationInfo">
		<xsl:variable name="resourceType" select="//gmd:hierarchyLevel/gmd:MD_ScopeCode"/>
		<gmd:identificationInfo>
		<xsl:choose>
		<xsl:when test="$resourceType='dataset'">
			<xsl:message>=== Updating with elements for <xsl:value-of select="$resourceType"/></xsl:message>
			<gmd:MD_DataIdentification>
				<xsl:apply-templates select="//gmd:citation" />
				<xsl:apply-templates select="//gmd:abstract" />
				<xsl:apply-templates select="//gmd:pointOfContact" />
				<xsl:apply-templates select="//gmd:resourceMaintenance" />
				<xsl:apply-templates select="//gmd:descriptiveKeywords" />
				<xsl:apply-templates select="//gmd:resourceConstraints" />
				<xsl:apply-templates select="//gmd:spatialRepresentationType" />
				<xsl:apply-templates select="//gmd:spatialResolution" />
				<xsl:apply-templates select="//gmd:language" />
				<xsl:apply-templates select="//gmd:characterSet" />
				<gmd:extent>
					<gmd:EX_Extent>
						<gmd:geographicElement>
							<xsl:apply-templates select="//*:geographicElement/gmd:EX_GeographicDescription" />
						</gmd:geographicElement>
						<gmd:geographicElement>
							<xsl:apply-templates select="//*:geographicElement/gmd:EX_GeographicBoundingBox" />
						</gmd:geographicElement>
						<gmd:temporalElement>
							<xsl:apply-templates select="//*:temporalElement/child::*" />
						</gmd:temporalElement>
					</gmd:EX_Extent>
					</gmd:extent>
			</gmd:MD_DataIdentification>
		</xsl:when>
			<xsl:when test="$resourceType='service'">
				<xsl:message>=== Updating with elements for <xsl:value-of select="$resourceType"/></xsl:message>
				<srv:SV_ServiceIdentification>
					<xsl:apply-templates select="//gmd:citation" />
					<xsl:apply-templates select="//gmd:abstract" />
					<xsl:apply-templates select="//gmd:pointOfContact" />
					<xsl:apply-templates select="//gmd:resourceMaintenance" />
					<xsl:apply-templates select="//gmd:descriptiveKeywords" />
					<xsl:apply-templates select="//gmd:resourceConstraints" />
					<xsl:apply-templates select="//srv:serviceType" />
					<srv:extent>
						<gmd:EX_Extent>
							<gmd:geographicElement>
								<xsl:apply-templates select="//*:geographicElement/gmd:EX_GeographicDescription" />
							</gmd:geographicElement>
							<gmd:geographicElement>
								<xsl:apply-templates select="//*:geographicElement/gmd:EX_GeographicBoundingBox" />
							</gmd:geographicElement>
							<gmd:temporalElement>
								<xsl:apply-templates select="//*:temporalElement/child::*" />
							</gmd:temporalElement>
						</gmd:EX_Extent>
					</srv:extent>
					<xsl:apply-templates select="//srv:couplingType" />
					<xsl:apply-templates select="//srv:containsOperations" />
					<xsl:apply-templates select="//srv:operatesOn" />
				</srv:SV_ServiceIdentification>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>=== Resource type not found. Defaulting to dataset ===</xsl:message>
				<gmd:MD_DataIdentification>
					<xsl:apply-templates select="//gmd:citation" />
					<xsl:apply-templates select="//gmd:abstract" />
					<xsl:apply-templates select="//gmd:pointOfContact" />
					<xsl:apply-templates select="//gmd:resourceMaintenance" />
					<xsl:apply-templates select="//gmd:descriptiveKeywords" />
					<xsl:apply-templates select="//gmd:resourceConstraints" />
					<xsl:apply-templates select="//gmd:spatialRepresentationType" />
					<xsl:apply-templates select="//gmd:spatialResolution" />
					<xsl:apply-templates select="//gmd:language" />
					<xsl:apply-templates select="//gmd:characterSet" />
					<gmd:extent>
						<gmd:EX_Extent>
							<gmd:geographicElement>
								<xsl:apply-templates select="//*:geographicElement/gmd:EX_GeographicDescription" />
							</gmd:geographicElement>
							<gmd:geographicElement>
								<xsl:apply-templates select="//*:geographicElement/gmd:EX_GeographicBoundingBox" />
							</gmd:geographicElement>
							<gmd:temporalElement>
								<xsl:apply-templates select="//*:temporalElement/child::*" />
							</gmd:temporalElement>
						</gmd:EX_Extent>
					</gmd:extent>
				</gmd:MD_DataIdentification>
			</xsl:otherwise>
		</xsl:choose>
		</gmd:identificationInfo>
	</xsl:template>
	
	
	<xsl:template match="gml:*">
		<xsl:element name="gml:{local-name()}" namespace="http://www.opengis.net/gml/3.2">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:element>
	</xsl:template>
	
	<!--  copy All  -->
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@xsi:schemaLocation" priority="10"/>
	
	<!--  Remove geonet:* elements.  -->
	<xsl:template match="geonet:*" priority="2"/>
</xsl:stylesheet>
