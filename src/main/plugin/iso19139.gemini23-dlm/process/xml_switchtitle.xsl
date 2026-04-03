<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

    <!-- ================================================================= -->

        <!-- Template for switching title and alt title -->

    <!-- ================================================================= -->


    <!-- Base copy -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>



    <!-- ================================================================= -->

    <xsl:template match="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation">
    <!-- Create variables- use first alternative title if there is one. If no alt title then copy as is-->
    <!-- don't flip if already flipped, eg alternate title starts with "Table " -->
        <xsl:copy>
         <xsl:choose>
             <xsl:when test="(count(.//gmd:alternateTitle) &gt; 0) and (not(starts-with(.//gmd:alternateTitle/*/text(), 'Table ')))">
            <xsl:variable name="title" select=".//gmd:title/gco:CharacterString/text()"/>
            <xsl:variable name="altTitle" select=".//gmd:alternateTitle[1]/gco:CharacterString/text()"/>
            <!--  Switch title and alt title  -->
            <xsl:message>=== Updating Title with <xsl:value-of select="$altTitle"/></xsl:message>
            <gmd:title>
                <gco:CharacterString><xsl:value-of select="$altTitle"/></gco:CharacterString>
            </gmd:title>
            <xsl:message>=== Updating Alternate Title with <xsl:value-of select="$title"/></xsl:message>
            <gmd:alternateTitle>
                <gco:CharacterString><xsl:value-of select="$title"/></gco:CharacterString>
            </gmd:alternateTitle>
             <xsl:copy-of select="gmd:date"/>
             <xsl:copy-of select="gmd:edition"/>
                 <xsl:copy-of select="gmd:identifier"/>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:apply-templates select="@*|node()"/>
             </xsl:otherwise>
         </xsl:choose>
            <!--<xsl:apply-templates select="@*|node()"/>-->
        </xsl:copy>
    </xsl:template>
    <!-- ================================================================= -->

    <!--  Remove geonet:* elements.  -->
    <xsl:template match="geonet:*" priority="10"/>

</xsl:stylesheet>
