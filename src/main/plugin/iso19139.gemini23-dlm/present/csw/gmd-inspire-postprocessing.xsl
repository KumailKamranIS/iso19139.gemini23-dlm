<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv"
    exclude-result-prefixes="srv">
    
    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>


    
    <xsl:strip-space elements="*"/>
    
    <!-- Template for Copy data -->
    <xsl:template name="copyData" match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- example from docs <xsl:template match="*[gmd:CI_OnlineResource
                         and count(gmd:CI_OnlineResource/gmd:linkage/gmd:URL[not(starts-with(text(), 'http'))]) > 0]"
                priority="2"/> -->
    
    <!-- remove PostGIS protocol resources -->
    <xsl:template match="*[gmd:CI_OnlineResource and count(gmd:CI_OnlineResource/gmd:linkage/gmd:URL[(starts-with(text(), 'PG'))]) > 0]" priority="1000">
        <xsl:message>=== Stripping Online Resources where the URL is a PostgreSQL DSN ===</xsl:message>
    </xsl:template>


</xsl:stylesheet>