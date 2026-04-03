<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gml32="http://www.opengis.net/gml/3.2"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gss="http://www.isotc211.org/2005/gss"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gsr="http://www.isotc211.org/2005/gsr"
                xmlns:geonet="http://www.fao.org/geonetwork"
                exclude-result-prefixes="#all"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is
      the preferred method for meta-stylesheets to use where possible.
    -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <xsl:include xmlns:svrl="http://purl.oclc.org/dsdl/svrl" href="../../../xsl/utils-fn.xsl"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="lang"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="thesaurusDir"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="rule"/>
   <xsl:variable xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="loc"
                 select="document(concat('../loc/', $lang, '/', $rule, '.xml'))"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1"
                          select="1+       count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+     count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@
              <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans
      (Top-level element has index)
    -->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH-->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2-->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="UK GEMINI Standard Draft Version 2.3"
                              schemaVersion="1.2">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>
         
        <xsl:value-of select="$archiveNameParameter"/>
         
        <xsl:value-of select="$fileNameParameter"/>
         
        <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:text>This Schematron schema is designed to test the constraints introduced in the GEMINI2 discovery metadata standard.</svrl:text>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmd" prefix="gmd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gco" prefix="gco"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmx" prefix="gmx"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/srv" prefix="srv"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml/3.2" prefix="gml32"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/cat/csw/2.0.2" prefix="csw"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gss" prefix="gss"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gts" prefix="gts"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gsr" prefix="gsr"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.fao.org/geonetwork" prefix="geonet"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Title</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi1-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi1-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Alternative Title</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi2-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi2-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Dataset Language</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi3-Language</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi3-Language</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Abstract</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi4-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi4-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Abstract free-text element check</xsl:attribute>
            <svrl:text>A human readable, non-empty description of the dataset, dataset series or service shall
      be provided</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Abstract length check</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Abstract is not the same as Title...</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Topic Category</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Keyword</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi6-Keyword-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi6-Keyword-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi6-Thesaurus-Title-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi6-Thesaurus-Title-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi6-Thesaurus-DateType-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi6-Thesaurus-DateType-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Temporal extent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Dataset reference date</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi8-ReferenceDate-DateType-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi8-ReferenceDate-DateType-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Lineage</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi10-Statement-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi10-Statement-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">West and East longitude, North and South latitude</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi11-BoundingBox</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi11-BoundingBox</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi11-West-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi11-West-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi11-East-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi11-East-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi11-South-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi11-South-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mill-North-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mill-North-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Extent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi15-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi15-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Vertical extent information</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi16-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi16-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Spatial reference system</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi17-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi17-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>The coordinate reference system(s) used in the described dataset or dataset series shall
      be given using element
      gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier
      INSPIRE Requirements metadata/2.0/req/sds-interoperable/crs and metadata/2.0/req/isdss/crs </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>If the coordinate reference system is listed in the table Default Coordinate Reference
      System Identifiers in Annex D.4, ... The gmd:codeSpace element shall not be used in this
      case.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Spatial Resolution</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi18-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi18-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Resource locator</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi19-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi19-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Data Format</xsl:attribute>
            <svrl:text>The encoding and the storage or transmission format of the provided datasets or dataset
      series shall be given using the gmd:distributionFormat/gmd:MD_Format element. The multiplicity
      of this element is 1..*. </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>If the version of the encoding is unknown or if the encoding is not versioned, the
      gmd:version shall be left empty and the nil reason attribute shall be provided with either
      value "unknown" or "inapplicable" correspondingly</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi21-Name-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi21-Name-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi21-Version-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi21-Version-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Responsible organisation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi23-ResponsibleParty</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi23-ResponsibleParty</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M74"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi23-OrganisationName-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi23-OrganisationName-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M75"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi23-Role-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi23-Role-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M76"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Frequency of update</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M77"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi24-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi24-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M78"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">LimitationsOnPublicAccess codelist</xsl:attribute>
            <svrl:text>We need metadata to have a gmx:Anchor linking to one of the LimitationsOnPublicAccess codelist values from: http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M79"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi25-OtherConstraints-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi25-OtherConstraints-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M80"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi25-AccessConstraints-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi25-AccessConstraints-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M81"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi26-UseConstraints-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi26-UseConstraints-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M82"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Additional information source</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M83"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi27-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi27-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M84"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata date</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M85"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi30-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi30-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M86"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata language</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M87"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi33-Language</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi33-Language</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M88"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata point of contact</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M89"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi35-ResponsibleParty</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi35-ResponsibleParty</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M90"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi35-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi35-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M91"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">(Unique) Resource Identifier</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M92"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi36-Code-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi36-Code-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M93"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi36-CodeSpace-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi36-CodeSpace-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M94"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Spatial data service type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M95"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi37-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi37-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M96"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Coupled resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M97"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Resource type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M98"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi39-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi39-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M99"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Conformity</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M100"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M101"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M102"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>This test allows for the title to start with `COMMISSION REGULATION` but ss. it should be
      'Commission Regulation'</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M103"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M104"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M105"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M106"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi41-Explanation-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi41-Explanation-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M107"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Specification</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M108"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi42-Title-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi42-Title-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M109"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi42-Date-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi42-Date-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M110"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi42-DateType-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi42-DateType-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M111"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Equivalent scale</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M112"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi43-Nillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi43-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M113"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Hierarchy level name</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M114"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>Hierarchy level name is mandatory for dataset series and services, not required for
      datasets</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M115"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>TG Requirement 3.1: metadata/2.0/req/sds/resource-type Additionally the name of the
      hierarchy level shall be given using element gmd:hierarchyLevelName element with a Non-empty
      Free Text Element containing the term "service" in the language of the metadata.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M116"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Quality Scope</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M117"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>TG Requirement 1.9: metadata/2.0/req/datasets-and-series/one-data-quality-element</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M118"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>TG Requirement 1.9: metadata/2.0/req/datasets-and-series/one-data-quality-element</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M119"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>TG Requirement 3.8: metadata/2.0/req/sds/only-one-dq-element</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M120"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>The level shall be named using element
      gmd:scope/gmd:DQ_Scope/gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other element with a
      Non-empty Free Text Element containing the term "service" in the language of the metadata.
      (metadata/2.0/req/sds/only-one-dq-element)</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M121"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Spatial Representation Type</xsl:attribute>
            <svrl:text>Dataset and dataset series must have a MD_SpatialRepresentationTypeCode</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M122"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>MD_SpatialRepresentationTypeCode, ... must be one of 'vector', 'grid', 'tin', or
      'textTable'</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M123"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Spatial Representation Type is not nillable for dataset/series</xsl:attribute>
            <svrl:text>Dataset and dataset series must have a MD_SpatialRepresentationTypeCode</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M124"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi50-SRType-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi50-SRType-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M125"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Character encoding</xsl:attribute>
            <svrl:text>The character encoding(s) shall be given for datasets and datasets series which use
      encodings not based on UTF-8 by using element gmd:characterSet/gmd:MD_CharacterSetCode
      referring to one of the values of ISO 19139 code list MD_CharacterSetCode.</svrl:text>
            <svrl:text>The multiplicity of this element is 0..n. If more than one character encoding is used
      within the described dataset or datasets series, all used character encodings, including UTF-8
      (code list value "utf8"), shall be given using this element</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M126"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-mi51-CharSet-CodeList</xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi51-CharSet-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M127"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>When we have a DQ_QuantitativeResult for a gmd:DQ_TopologicalConsistency report, the
      result type shall be declared using the xsi:type attribute of the gco:Record element </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M128"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Topological consistency</xsl:attribute>
            <svrl:text>In the event that a Topological consistency report is required for a Generic Network
      Model dataset, check that the correct date/datetype and boolean values are given. Test relies
      on the citation having the required title...</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M129"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Data identification citation</xsl:attribute>
            <svrl:text>The identification information citation cannot be null.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M130"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata resource type test</xsl:attribute>
            <svrl:text>Test to ensure that metadata about datasets include the gmd:MD_DataIdentification element
      and metadata about services include the srv:SV_ServiceIdentification element</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M131"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata file identifier</xsl:attribute>
            <svrl:text>A file identifier is required</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M132"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Gemini2-at3-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Gemini2-at3-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M133"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Constraints</xsl:attribute>
            <svrl:text>Constraints (Limitations on public access and use constraints) are required.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M134"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Creation date type</xsl:attribute>
            <svrl:text>Constrain citation date type = creation to one occurrence.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M135"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Non-empty free text content</xsl:attribute>
            <svrl:text>Don't allow empty Free text gco:CharacterString or gmx:Anchor</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M136"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Revision date type</xsl:attribute>
            <svrl:text>Constrain citation date type = revision to one occurrence.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M137"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Legal Constraints</xsl:attribute>
            <svrl:text>To satisfy INSPIRE TG Requirement C.18, there must be at least two gmd:resourceConstraints : md:MD_LegalConstraints element blocks
      One for "Limitations on public access" and the other for "Conditions for access and use".  Applies to all metadata</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M138"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">UK GEMINI Standard Draft Version 2.3</svrl:text>
   <xsl:param name="hierarchyLevelCLValue"
              select="//gmd:MD_Metadata/gmd:hierarchyLevel[1]/gmd:MD_ScopeCode[1]/@codeListValue"/>
   <xsl:param name="inspire1089"
              select="'Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services'"/>
   <xsl:param name="inspire1089x"
              select="'COMMISSION REGULATION (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services'"/>
   <xsl:param name="inspire976"
              select="'Commission Regulation (EC) No 976/2009 of 19 October 2009 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards the Network Services'"/>
   <xsl:param name="defaultCRScodes"
              select="document('https://raw.githubusercontent.com/agiorguk/gemini-schematron/main/resources/d4.xml')"/>
   <xsl:param name="charSetCodes"
              select="document('https://raw.githubusercontent.com/agiorguk/gemini-schematron/main/resources/MD_CharacterSetCode.xml')"/>
   <xsl:param name="LPreportsupplement"
              select="'This test may be called by the following Metadata Items: 3 - Dataset Language and 33 - Metadata Language'"/>
   <xsl:param name="RPreportsupplement"
              select="'This test may be called by the following Metadata Items: 23 - Responsible Organisation and 35 - Metadata Point of Contact'"/>
   <xsl:param name="GBreportsupplement" select="'Issue in Metadata item 44: Bounding box'"/>

   <!--PATTERN
        Title-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Title</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi1-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:title"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:title"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN
        Alternative Title-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Alternative Title</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi2-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:alternateTitle"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:alternateTitle"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN
        Dataset Language-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Dataset Language</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi3-Language-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:language"
                 priority="1001"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:language"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:LanguageCode) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:LanguageCode) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-4a: Language shall be implemented with
        gmd:LanguageCode. <xsl:text/>
                  <xsl:copy-of select="$LPreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:language/gmd:LanguageCode"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:language/gmd:LanguageCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-4b: The language code list value
        is absent. When a dataset has no natural language use code zxx. <xsl:text/>
                  <xsl:copy-of select="$LPreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="string-length(@codeListValue) != 3">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="string-length(@codeListValue) != 3">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> AP-4c: The language code should be
        three characters. <xsl:text/>
               <xsl:copy-of select="$LPreportsupplement"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

   <!--PATTERN
        Abstract-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Abstract</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi4-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:abstract"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:abstract"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>

   <!--PATTERN
        Abstract free-text element check-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Abstract free-text element check</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:abstract" priority="1000" mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:abstract"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="normalize-space(.) and *"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="normalize-space(.) and *">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-4a (Abstract): A human readable, non-empty description of
        the dataset, dataset series, or service shall be provided </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>

   <!--PATTERN
        Abstract length check-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Abstract length check</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:abstract/*[1]" priority="1000" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:abstract/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length() &gt; 99"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length() &gt; 99">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-4b (Abstract): Abstract is too short. GEMINI 2.3 requires
        an abstract of at least 100 characters, but abstract "<xsl:text/>
                  <xsl:copy-of select="normalize-space(.)"/>
                  <xsl:text/>" has only <xsl:text/>
                  <xsl:copy-of select="string-length(.)"/>
                  <xsl:text/>
        characters </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

   <!--PATTERN
        Abstract is not the same as Title...-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Abstract is not the same as Title...</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:abstract/*[1]" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:abstract/*[1]"/>
      <xsl:variable name="resourceTitle"
                    select="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:title/*[1][normalize-space()]"/>
      <xsl:variable name="resourceAbstract" select="normalize-space(.)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$resourceAbstract != $resourceTitle"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$resourceAbstract != $resourceTitle">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-4c (Abstract): Abstract "<xsl:text/>
                  <xsl:copy-of select="$resourceAbstract"/>
                  <xsl:text/>" must not be the same text as the title "<xsl:text/>
                  <xsl:copy-of select="$resourceTitle"/>
                  <xsl:text/>")). </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>

   <!--PATTERN
        Topic Category-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Topic Category</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]" priority="1001"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           ((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or           ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and           count(gmd:topicCategory) &gt;= 1) or           (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and           ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or           count(../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(gmd:topicCategory) &gt;= 1) or (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>MI-5a (Topic Category): Topic category is mandatory for datasets and series. One or more shall be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:topicCategory"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:topicCategory"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           ((../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or           ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and           count(@gco:nilReason) = 0) or           (../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and           ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or           count(../../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(@gco:nilReason) = 0) or (../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>MI-5b (Topic Category): Topic Category shall not be null. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>

   <!--PATTERN
        Keyword-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Keyword</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]" priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:descriptiveKeywords) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:descriptiveKeywords) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-6 (Keyword): Descriptive keywords are
        mandatory. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi6-Keyword-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:keyword"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:keyword"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi6-Thesaurus-Title-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:title"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:title"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi6-Thesaurus-DateType-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"
                 priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>

   <!--PATTERN
        Temporal extent-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Temporal extent</svrl:text>

  <!--RULE
      -->
<xsl:template match="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent"
                 priority="1000"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gml:TimePeriod) = 1 or count(gml:TimeInstant) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gml:TimePeriod) = 1 or count(gml:TimeInstant) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-7a (Temporal Extent): Temporal
        extent shall be implemented using gml:TimePeriod or gml:TimeInstant. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:endPosition"
                 priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:endPosition"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not((@indeterminatePosition = 'unknown' or @indeterminatePosition = 'now') and normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not((@indeterminatePosition = 'unknown' or @indeterminatePosition = 'now') and normalize-space(.))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-7b (Temporal Extent): When indeterminatePosition='unknown' or indeterminatePosition='now' are specified
        endPosition should be empty </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:endPosition"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:endPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:endPosition"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) = 0 or string-length(normalize-space(.)) = 4 or string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 10 or string-length(normalize-space(.)) = 19"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) = 0 or string-length(normalize-space(.)) = 4 or string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 10 or string-length(normalize-space(.)) = 19">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-7c (Temporal Extent): End Position date string doesn't have correct length, check it conforms to Gregorian calendar
        and UTC as per ISO 8601 </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:beginPosition"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:beginPosition"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not(@indeterminatePosition = 'unknown' and normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not(@indeterminatePosition = 'unknown' and normalize-space(.))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-7d (Temporal Extent): When
        indeterminatePosition='unknown' is specified beginPosition should be empty </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:beginPosition"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod//gml:beginPosition |         //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType = 'gmd:EX_TemporalExtent'][1]/gmd:extent/gml:TimePeriod//gml:beginPosition"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) = 0 or string-length(normalize-space(.)) = 4 or string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 10 or string-length(normalize-space(.)) = 19"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) = 0 or string-length(normalize-space(.)) = 4 or string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 10 or string-length(normalize-space(.)) = 19">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-7e (Temporal Extent): Begin Position date string doesn't have correct length, check it conforms to Gregorian calendar
        and UTC as per ISO 8601 </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>

   <!--PATTERN
        Dataset reference date-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Dataset reference date</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi8-ReferenceDate-DateType-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>

   <!--PATTERN
        Lineage-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Lineage</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1000" mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           ((gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or           gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and           count(gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement) = 1) or           (gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and           gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or           count(gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement) = 1) or (gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-10a (Lineage): Lineage is mandatory for datasets and series. One shall be provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi10-Statement-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement"
                 priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo[1]/gmd:DQ_DataQuality[1]/gmd:scope[1]/gmd:DQ_Scope[1]/gmd:level[1]/gmd:MD_ScopeCode[1][@codeListValue = 'dataset']"
                 priority="1001"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo[1]/gmd:DQ_DataQuality[1]/gmd:scope[1]/gmd:DQ_Scope[1]/gmd:level[1]/gmd:MD_ScopeCode[1][@codeListValue = 'dataset']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:lineage) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:lineage) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-10b (Lineage): The gmd:dataQualityInfo scoped to dataset must have a lineage section
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo[1]/gmd:DQ_DataQuality[1]/gmd:scope[1]/gmd:DQ_Scope[1]/gmd:level[1]/gmd:MD_ScopeCode[1][@codeListValue = 'series']"
                 priority="1000"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo[1]/gmd:DQ_DataQuality[1]/gmd:scope[1]/gmd:DQ_Scope[1]/gmd:level[1]/gmd:MD_ScopeCode[1][@codeListValue = 'series']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:lineage) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:lineage) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-10c (Lineage): The gmd:dataQualityInfo scoped to series must have a lineage section </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>

   <!--PATTERN
        West and East longitude, North and South latitude-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">West and East longitude, North and South latitude</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]" priority="1000"
                 mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           ((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or           ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and           (count(gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox) &gt;= 1) or           count(gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType = 'gmd:EX_GeographicBoundingBox'][1]) &gt;= 1) or           (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and           ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or           count(../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and (count(gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox) &gt;= 1) or count(gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType = 'gmd:EX_GeographicBoundingBox'][1]) &gt;= 1) or (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-(11,12,13,13  Geographic Bounding Box): Geographic bounding box is mandatory for datasets and series. One or
        more shall be provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi11-BoundingBox-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'] [1]|       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'][1]"
                 priority="1000"
                 mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'] [1]|       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'][1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(gmd:westBoundLongitude) = 0 or (gmd:westBoundLongitude &gt;= -180.0 and gmd:westBoundLongitude &lt;= 180.0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmd:westBoundLongitude) = 0 or (gmd:westBoundLongitude &gt;= -180.0 and gmd:westBoundLongitude &lt;= 180.0)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-6a: West bound longitude has a value of <xsl:text/>
                  <xsl:copy-of select="gmd:westBoundLongitude"/>
                  <xsl:text/>
        which is outside bounds. <xsl:text/>
                  <xsl:copy-of select="$GBreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(gmd:eastBoundLongitude) = 0 or (gmd:eastBoundLongitude &gt;= -180.0 and gmd:eastBoundLongitude &lt;= 180.0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmd:eastBoundLongitude) = 0 or (gmd:eastBoundLongitude &gt;= -180.0 and gmd:eastBoundLongitude &lt;= 180.0)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>AP-6b: East bound longitude has a value of <xsl:text/>
                  <xsl:copy-of select="gmd:eastBoundLongitude"/>
                  <xsl:text/>
        which is outside bounds. <xsl:text/>
                  <xsl:copy-of select="$GBreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(gmd:southBoundLatitude) = 0 or (gmd:southBoundLatitude &gt;= -90.0 and gmd:southBoundLatitude &lt;= gmd:northBoundLatitude)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmd:southBoundLatitude) = 0 or (gmd:southBoundLatitude &gt;= -90.0 and gmd:southBoundLatitude &lt;= gmd:northBoundLatitude)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>AP-6c: South bound latitude has a value of <xsl:text/>
                  <xsl:copy-of select="gmd:southBoundLatitude"/>
                  <xsl:text/>
        which is outside bounds. <xsl:text/>
                  <xsl:copy-of select="$GBreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(gmd:northBoundLatitude) = 0 or (gmd:northBoundLatitude &lt;= 90.0 and gmd:northBoundLatitude &gt;= gmd:southBoundLatitude)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmd:northBoundLatitude) = 0 or (gmd:northBoundLatitude &lt;= 90.0 and gmd:northBoundLatitude &gt;= gmd:southBoundLatitude)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>AP-6d: North bound latitude has a value of <xsl:text/>
                  <xsl:copy-of select="gmd:northBoundLatitude"/>
                  <xsl:text/>
        which is outside bounds. <xsl:text/>
                  <xsl:copy-of select="$GBreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi11-West-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude"
                 priority="1000"
                 mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi11-East-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi11-South-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude"
                 priority="1000"
                 mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mill-North-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude"
                 priority="1000"
                 mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>

   <!--PATTERN
        Extent-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Extent</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi15-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code"
                 priority="1000"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>

   <!--PATTERN
        Vertical extent information-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Vertical extent information</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi16-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:minimumValue |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:maximumValue"
                 priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:minimumValue |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:maximumValue"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>

   <!--PATTERN
        Spatial reference system-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Spatial reference system</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi17-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]/gmd:code"
                 priority="1000"
                 mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]/gmd:code"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1000" mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(//gmd:MD_Metadata[1]/child::gmd:referenceSystemInfo/descendant::gmd:RS_Identifier) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(//gmd:MD_Metadata[1]/child::gmd:referenceSystemInfo/descendant::gmd:RS_Identifier) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-17a (Spatial Reference System): At least one coordinate reference system used in the described dataset, dataset
        series, or service shall be given using
        gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/gmd:RS_Identifier[1]/gmd:code/gco:CharacterString"
                 priority="1001"
                 mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/gmd:RS_Identifier[1]/gmd:code/gco:CharacterString"/>

      <!--REPORT
      -->
<xsl:if test="           $defaultCRScodes//crs/text()[normalize-space(.) = normalize-space(current()/.)] and           count(parent::gmd:code/parent::gmd:RS_Identifier/child::gmd:codeSpace) &gt; 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$defaultCRScodes//crs/text()[normalize-space(.) = normalize-space(current()/.)] and count(parent::gmd:code/parent::gmd:RS_Identifier/child::gmd:codeSpace) &gt; 0">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> MI-17c (Spatial Reference System): The coordinate reference system <xsl:text/>
               <xsl:copy-of select="normalize-space(current()/.)"/>
               <xsl:text/> is listed in Default Coordinate Reference System
        Identifiers in Annex D.4. Such identifiers SHALL NOT use gmd:codeSpace </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/gmd:RS_Identifier[1]/gmd:code/gmx:Anchor"
                 priority="1000"
                 mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/gmd:RS_Identifier[1]/gmd:code/gmx:Anchor"/>

      <!--REPORT
      -->
<xsl:if test="           $defaultCRScodes//crs/text()[normalize-space(.) = normalize-space(current()/@xlink:href)] and           count(parent::gmd:code/parent::gmd:RS_Identifier/child::gmd:codeSpace) &gt; 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$defaultCRScodes//crs/text()[normalize-space(.) = normalize-space(current()/@xlink:href)] and count(parent::gmd:code/parent::gmd:RS_Identifier/child::gmd:codeSpace) &gt; 0">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> MI-17b (Spatial Reference System): The coordinate reference system <xsl:text/>
               <xsl:copy-of select="normalize-space(current()/@xlink:href)"/>
               <xsl:text/> is listed in Default Coordinate Reference System
        Identifiers in Annex D.4. Such identifiers SHALL NOT use gmd:codeSpace </svrl:text>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="           $defaultCRScodes//crs/text()[normalize-space(.) = normalize-space(current()/.)] and           count(parent::gmd:code/parent::gmd:RS_Identifier/child::gmd:codeSpace) &gt; 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$defaultCRScodes//crs/text()[normalize-space(.) = normalize-space(current()/.)] and count(parent::gmd:code/parent::gmd:RS_Identifier/child::gmd:codeSpace) &gt; 0">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> MI-17d (Spatial Reference System): The coordinate reference system <xsl:text/>
               <xsl:copy-of select="normalize-space(current()/.)"/>
               <xsl:text/> is listed in Default Coordinate Reference System
        Identifiers in Annex D.4. Such identifiers SHALL NOT use gmd:codeSpace </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>

   <!--PATTERN
        Spatial Resolution-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Spatial Resolution</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi18-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:distance"
                 priority="1000"
                 mode="M66">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:distance"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>

   <!--PATTERN
        Resource locator-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Resource locator</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]"
                 priority="1000"
                 mode="M67">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           count(gmd:linkage) = 0 or           (starts-with(normalize-space(gmd:linkage/*[1]), 'http://') or           starts-with(normalize-space(gmd:linkage/*[1]), 'https://') or           starts-with(normalize-space(gmd:linkage/*[1]), 'ftp://'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:linkage) = 0 or (starts-with(normalize-space(gmd:linkage/*[1]), 'http://') or starts-with(normalize-space(gmd:linkage/*[1]), 'https://') or starts-with(normalize-space(gmd:linkage/*[1]), 'ftp://'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-19 (Resource Locator): The value of resource locator does not appear to be a valid URL. It has a value of
          '<xsl:text/>
                  <xsl:copy-of select="gmd:linkage/*[1]"/>
                  <xsl:text/>'. The URL must start with either http://,
        https:// or ftp://. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi19-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]/gmd:linkage"
                 priority="1000"
                 mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]/gmd:linkage"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>

   <!--PATTERN
        Data Format-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Data Format</svrl:text>
   <xsl:variable name="MDFs"
                 select="count(//gmd:MD_Metadata[1]/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format)"/>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:distributionInfo/gmd:MD_Distribution"
                 priority="1000"
                 mode="M69">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:distributionInfo/gmd:MD_Distribution"/>

      <!--REPORT
      -->
<xsl:if test="($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and ($MDFs &lt; 1)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and ($MDFs &lt; 1)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> MI-21a (Data Format): Datasets or dataset series must have at least one
        gmd:distributionFormat/gmd:MD_Format We have <xsl:text/>
               <xsl:copy-of select="$MDFs"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:version/*[1]"
                 priority="1000"
                 mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:version/*[1]"/>

      <!--REPORT
      -->
<xsl:if test="           ($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and           (normalize-space(.) = 'NotApplicable' or normalize-space(.) = 'Not Applicable' or           normalize-space(.) = 'Not entered' or normalize-space(.) = 'Not Entered' or           normalize-space(.) = 'Missing' or normalize-space(.) = 'missing' or           normalize-space(.) = 'Unknown' or normalize-space(.) = 'unknown')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and (normalize-space(.) = 'NotApplicable' or normalize-space(.) = 'Not Applicable' or normalize-space(.) = 'Not entered' or normalize-space(.) = 'Not Entered' or normalize-space(.) = 'Missing' or normalize-space(.) = 'missing' or normalize-space(.) = 'Unknown' or normalize-space(.) = 'unknown')">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> MI-21b (Data Format): A value of <xsl:text/>
               <xsl:copy-of select="normalize-space(.)"/>
               <xsl:text/> is not expected here. If
        the version of the encoding is not known, then use nilReason='unknown', otherwise if the
        encoding is not versioned use nilReason='inapplicable', like: &lt;gmd:version
        nilReason='unknown' /&gt; </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi21-Name-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:name"
                 priority="1000"
                 mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:name"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi21-Version-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:version"
                 priority="1000"
                 mode="M72">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:version"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'unknown')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'unknown')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1b: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value OR a nil reason of either 'inapplicable'
        or 'unknown'. This test may be called by the following Metadata Items: 21 - Data Format</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>

   <!--PATTERN
        Responsible organisation-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Responsible organisation</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]" priority="1001"
                 mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:pointOfContact) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:pointOfContact) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-23a (Responsible Organisation): Responsible organisation is
        mandatory. At least one shall be provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact"
                 priority="1000"
                 mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-23b (Responsible Organisation): The value of responsible organisation
        shall not be null. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi23-ResponsibleParty-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact"
                 priority="1000"
                 mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:organisationName) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:organisationName) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-5a: One organisation name shall be
        provided. <xsl:text/>
                  <xsl:copy-of select="$RPreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-5b:
        One email address shall be provided. <xsl:text/>
                  <xsl:copy-of select="$RPreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi23-OrganisationName-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:organisationName |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress"
                 priority="1000"
                 mode="M75">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:organisationName |       //gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi23-Role-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:role/*[1]"
                 priority="1000"
                 mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:role/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>

   <!--PATTERN
        Frequency of update-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Frequency of update</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi24-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceMaintenance/*[1]/gmd:maintenanceAndUpdateFrequency/*[1]"
                 priority="1000"
                 mode="M78">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceMaintenance/*[1]/gmd:maintenanceAndUpdateFrequency/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>

   <!--PATTERN
        LimitationsOnPublicAccess codelist-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">LimitationsOnPublicAccess codelist</svrl:text>
   <xsl:variable name="LoPAurl"
                 select="'http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/'"/>
   <xsl:variable name="LoPAurlNum"
                 select="count(//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gmx:Anchor/@xlink:href[contains(.,$LoPAurl)])"/>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]" priority="1000"
                 mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]"/>

      <!--REPORT
      -->
<xsl:if test="$LoPAurlNum != 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$LoPAurlNum != 1">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
        MI-25c (Limitations on Public Access): There must be one (and only one) LimitationsOnPublicAccess code list value specified using a gmx:Anchor in gmd:otherConstraints.
        We have <xsl:text/>
               <xsl:copy-of select="$LoPAurlNum"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi25-OtherConstraints-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:otherConstraints"
                 priority="1000"
                 mode="M80">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:otherConstraints"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi25-AccessConstraints-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:accessConstraints/*[1]"
                 priority="1000"
                 mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:accessConstraints/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi26-UseConstraints-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:useConstraints/*[1]"
                 priority="1000"
                 mode="M82">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:useConstraints/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M82"/>
   <xsl:template match="@*|node()" priority="-2" mode="M82">
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>

   <!--PATTERN
        Additional information source-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Additional information source</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M83"/>
   <xsl:template match="@*|node()" priority="-2" mode="M83">
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi27-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:supplementalInformation"
                 priority="1000"
                 mode="M84">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:supplementalInformation"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M84"/>
   <xsl:template match="@*|node()" priority="-2" mode="M84">
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>

   <!--PATTERN
        Metadata date-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata date</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi30-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dateStamp/gco:Date" priority="1000" mode="M86">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dateStamp/gco:Date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>

   <!--PATTERN
        Metadata language-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata language</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1000" mode="M87">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:language) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:language) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-33 (Metadata Language): Metadata language is mandatory. One shall
        be provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi33-Language-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:language" priority="1001" mode="M88">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:language"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:LanguageCode) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:LanguageCode) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-4a: Language shall be implemented with
        gmd:LanguageCode. <xsl:text/>
                  <xsl:copy-of select="$LPreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:language/gmd:LanguageCode" priority="1000"
                 mode="M88">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:language/gmd:LanguageCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-4b: The language code list value
        is absent. When a dataset has no natural language use code zxx. <xsl:text/>
                  <xsl:copy-of select="$LPreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="string-length(@codeListValue) != 3">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="string-length(@codeListValue) != 3">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> AP-4c: The language code should be
        three characters. <xsl:text/>
               <xsl:copy-of select="$LPreportsupplement"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>

   <!--PATTERN
        Metadata point of contact-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata point of contact</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:contact" priority="1000" mode="M89">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:contact"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-35a (Metadata Point of Contact): The value of metadata point of contact
        shall not be null. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(parent::node()[gmd:contact/*[1]/gmd:role/*[1]/@codeListValue = 'pointOfContact']) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(parent::node()[gmd:contact/*[1]/gmd:role/*[1]/@codeListValue = 'pointOfContact']) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-35b (Metadata Point of Contact): At least one metadata point of contact shall have the role 'pointOfContact'.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M89"/>
   <xsl:template match="@*|node()" priority="-2" mode="M89">
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi35-ResponsibleParty-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:contact" priority="1000" mode="M90">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:contact"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:organisationName) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:organisationName) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-5a: One organisation name shall be
        provided. <xsl:text/>
                  <xsl:copy-of select="$RPreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-5b:
        One email address shall be provided. <xsl:text/>
                  <xsl:copy-of select="$RPreportsupplement"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M90"/>
   <xsl:template match="@*|node()" priority="-2" mode="M90">
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi35-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:contact/*[1]/gmd:organisationName | //gmd:MD_Metadata[1]/gmd:contact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress"
                 priority="1000"
                 mode="M91">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:contact/*[1]/gmd:organisationName | //gmd:MD_Metadata[1]/gmd:contact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M91"/>
   <xsl:template match="@*|node()" priority="-2" mode="M91">
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>

   <!--PATTERN
        (Unique) Resource Identifier-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">(Unique) Resource Identifier</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]"
                 priority="1000"
                 mode="M92">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           ((../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or           ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and           count(gmd:identifier) &gt;= 1) or           (../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and           ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or           count(../../../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(gmd:identifier) &gt;= 1) or (../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-36 (Unique) Resource Identifier: (Unique) Resource Identifier is mandatory for datasets and series. One or more
        shall be provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M92"/>
   <xsl:template match="@*|node()" priority="-2" mode="M92">
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi36-Code-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:code"
                 priority="1000"
                 mode="M93">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:code"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M93"/>
   <xsl:template match="@*|node()" priority="-2" mode="M93">
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi36-CodeSpace-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:codeSpace"
                 priority="1000"
                 mode="M94">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:codeSpace"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M94"/>
   <xsl:template match="@*|node()" priority="-2" mode="M94">
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>

   <!--PATTERN
        Spatial data service type-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Spatial data service type</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/srv:SV_ServiceIdentification | /*[1]/gmd:identificationInfo[1]/*[@gco:isoType = 'srv:SV_ServiceIdentification'][1]"
                 priority="1000"
                 mode="M95">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/srv:SV_ServiceIdentification | /*[1]/gmd:identificationInfo[1]/*[@gco:isoType = 'srv:SV_ServiceIdentification'][1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (../../gmd:hierarchyLevel/*[1]/@codeListValue = 'service' and           count(srv:serviceType) = 1) or           ../../gmd:hierarchyLevel/*[1]/@codeListValue != 'service'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(../../gmd:hierarchyLevel/*[1]/@codeListValue = 'service' and count(srv:serviceType) = 1) or ../../gmd:hierarchyLevel/*[1]/@codeListValue != 'service'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-37a (Spatial Data Service Type): If the resource type is service, one spatial data service type shall be provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           srv:serviceType/*[1] = 'discovery' or           srv:serviceType/*[1] = 'view' or           srv:serviceType/*[1] = 'download' or           srv:serviceType/*[1] = 'transformation' or           srv:serviceType/*[1] = 'invoke' or           srv:serviceType/*[1] = 'other'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="srv:serviceType/*[1] = 'discovery' or srv:serviceType/*[1] = 'view' or srv:serviceType/*[1] = 'download' or srv:serviceType/*[1] = 'transformation' or srv:serviceType/*[1] = 'invoke' or srv:serviceType/*[1] = 'other'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-37b (Spatial Data Service Type): Service type shall be one of 'discovery', 'view', 'download', 'transformation',
        'invoke' or 'other' following INSPIRE generic names. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M95"/>
   <xsl:template match="@*|node()" priority="-2" mode="M95">
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi37-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:serviceType"
                 priority="1000"
                 mode="M96">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:serviceType"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M96"/>
   <xsl:template match="@*|node()" priority="-2" mode="M96">
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>

   <!--PATTERN
        Coupled resource-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Coupled resource</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:operatesOn"
                 priority="1000"
                 mode="M97">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:operatesOn"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(@xlink:href) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@xlink:href) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-38 (Coupled Resource): Coupled resource shall be implemented by
        reference using the xlink:href attribute. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M97"/>
   <xsl:template match="@*|node()" priority="-2" mode="M97">
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>

   <!--PATTERN
        Resource type-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Resource type</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1000" mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:hierarchyLevel) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:hierarchyLevel) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-39a (Resource Type): Resource type is mandatory. One
        shall be provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or           gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series' or           gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'service'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series' or gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'service'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-39b (Resource Type): Value of resource type shall be 'dataset', 'series' or 'service'. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M98"/>
   <xsl:template match="@*|node()" priority="-2" mode="M98">
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi39-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:hierarchyLevel/*[1]" priority="1000" mode="M99">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:hierarchyLevel/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M99"/>
   <xsl:template match="@*|node()" priority="-2" mode="M99">
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>

   <!--PATTERN
        Conformity-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Conformity</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M100"/>
   <xsl:template match="@*|node()" priority="-2" mode="M100">
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1000" mode="M101">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-41a (Conformity): There must be at least one gmd:DQ_ConformanceResult </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M101"/>
   <xsl:template match="@*|node()" priority="-2" mode="M101">
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = 'Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services']"
                 priority="1000"
                 mode="M102">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = 'Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services']"/>
      <xsl:variable name="localPassPath"
                    select="parent::gmd:title/parent::gmd:CI_Citation/parent::gmd:specification/following-sibling::gmd:pass"/>
      <xsl:variable name="localDatePath"
                    select="parent::gmd:title/following-sibling::gmd:date/gmd:CI_Date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localPassPath/gco:Boolean or $localPassPath/@gco:nilReason = 'unknown'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localPassPath/gco:Boolean or $localPassPath/@gco:nilReason = 'unknown'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MI-41b (Conformity): The pass value shall be true, false, or have a nil reason of 'unknown', in a
        conformance statement for <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MI-41c (Conformity): The date reported shall be 2010-12-08 (date of publication), in a conformance
        statement for <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MI-41d (Conformity): The dateTypeCode reported shall be publication, in a conformance statement for
          <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M102"/>
   <xsl:template match="@*|node()" priority="-2" mode="M102">
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = 'COMMISSION REGULATION (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services']"
                 priority="1000"
                 mode="M103">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = 'COMMISSION REGULATION (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services']"/>
      <xsl:variable name="localPassPath"
                    select="parent::gmd:title/parent::gmd:CI_Citation/parent::gmd:specification/following-sibling::gmd:pass"/>
      <xsl:variable name="localDatePath"
                    select="parent::gmd:title/following-sibling::gmd:date/gmd:CI_Date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localPassPath/gco:Boolean or $localPassPath/@gco:nilReason = 'unknown'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localPassPath/gco:Boolean or $localPassPath/@gco:nilReason = 'unknown'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MI-41e (Conformity): The pass value shall be true, false, or have a nil reason of 'unknown', in a
        conformance statement for <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MI-41f (Conformity): The date reported shall be 2010-12-08 (date of publication), in a conformance
        statement for <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MI-41g (Conformity): The DateTypeCode reported shall be publication, in a conformance statement for
          <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M103"/>
   <xsl:template match="@*|node()" priority="-2" mode="M103">
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = 'Commission Regulation (EC) No 976/2009 of 19 October 2009 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards the Network Services']"
                 priority="1000"
                 mode="M104">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = 'Commission Regulation (EC) No 976/2009 of 19 October 2009 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards the Network Services']"/>
      <xsl:variable name="localPassPath"
                    select="parent::gmd:title/parent::gmd:CI_Citation/parent::gmd:specification/following-sibling::gmd:pass"/>
      <xsl:variable name="localDatePath"
                    select="parent::gmd:title/following-sibling::gmd:date/gmd:CI_Date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localPassPath/gco:Boolean or $localPassPath/@gco:nilReason = 'unknown'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localPassPath/gco:Boolean or $localPassPath/@gco:nilReason = 'unknown'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MI-41h (Conformity): The pass value shall be true, false, or have a nil reason of 'unknown', in a
        conformance statement for <xsl:text/>
                  <xsl:copy-of select="$inspire976"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MI-41i (Conformity): The date reported shall be 2010-12-08 (date of publication), in a conformance
        statement for <xsl:text/>
                  <xsl:copy-of select="$inspire976"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MI-41j (Conformity): The dateTypeCode reported shall be publication, in a conformance statement for
          <xsl:text/>
                  <xsl:copy-of select="$inspire976"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M104"/>
   <xsl:template match="@*|node()" priority="-2" mode="M104">
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'service']"
                 priority="1000"
                 mode="M105">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'service']"/>
      <xsl:variable name="count1089"
                    select="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089])"/>
      <xsl:variable name="count1089x"
                    select="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089x])"/>
      <xsl:variable name="count976"
                    select="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire976])"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$count1089 &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$count1089 &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> M1-41k (Conformity): A service record should have no more than one
        Conformance report to [1089/2010] (counted <xsl:text/>
                  <xsl:copy-of select="$count1089"/>
                  <xsl:text/>) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$count1089x &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$count1089x &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> M1-41l (Conformity): A service record should have no more than one
        Conformance report to [1089/2010] (counted <xsl:text/>
                  <xsl:copy-of select="$count1089"/>
                  <xsl:text/>) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$count976 &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$count976 &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> M1-41m (Conformity): A service record should have no more than one
        Conformance report to [976/2009] (counted <xsl:text/>
                  <xsl:copy-of select="$count976"/>
                  <xsl:text/>) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="           not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089]) and           not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089x]) and           not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire976])">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089]) and not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089x]) and not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire976])">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> M1-41n (Conformity): A service record should have a Conformance report to [976/2009] or [1089/2010]
      </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M105"/>
   <xsl:template match="@*|node()" priority="-2" mode="M105">
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="         //gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'dataset'] |         //gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'series']"
                 priority="1000"
                 mode="M106">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="         //gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'dataset'] |         //gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'series']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089]) = 1 or           count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089x]) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089]) = 1 or count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089x]) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-41o (Conformity): Datasets and series must provide a conformance report to [1089/2010]. The INSPIRE
        rule tells us this must be the EXACT title of the regulation, which is: <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M106"/>
   <xsl:template match="@*|node()" priority="-2" mode="M106">
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi41-Explanation-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:explanation"
                 priority="1000"
                 mode="M107">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:explanation"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M107"/>
   <xsl:template match="@*|node()" priority="-2" mode="M107">
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>

   <!--PATTERN
        Specification-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Specification</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M108"/>
   <xsl:template match="@*|node()" priority="-2" mode="M108">
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi42-Title-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:title"
                 priority="1000"
                 mode="M109">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:title"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M109"/>
   <xsl:template match="@*|node()" priority="-2" mode="M109">
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi42-Date-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date"
                 priority="1000"
                 mode="M110">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M110"/>
   <xsl:template match="@*|node()" priority="-2" mode="M110">
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi42-DateType-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"
                 priority="1000"
                 mode="M111">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M111"/>
   <xsl:template match="@*|node()" priority="-2" mode="M111">
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>

   <!--PATTERN
        Equivalent scale-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Equivalent scale</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M112"/>
   <xsl:template match="@*|node()" priority="-2" mode="M112">
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi43-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:equivalentScale/*[1]/gmd:denominator"
                 priority="1000"
                 mode="M113">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:equivalentScale/*[1]/gmd:denominator"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           (string-length(normalize-space(.)) &gt; 0) or           (@gco:nilReason = 'inapplicable' or           @gco:nilReason = 'missing' or           @gco:nilReason = 'template' or           @gco:nilReason = 'unknown' or           @gco:nilReason = 'withheld' or           starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-1a: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the
        following Metadata Items: 2 - Alternative Title, 36 - (Unique) Resource Identifier,
        37 - Spatial Data Service Type 41 - Conformity, 42 - Specification, and 43 - Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M113"/>
   <xsl:template match="@*|node()" priority="-2" mode="M113">
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>

   <!--PATTERN
        Hierarchy level name-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Hierarchy level name</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M114"/>
   <xsl:template match="@*|node()" priority="-2" mode="M114">
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1000" mode="M115">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>
      <xsl:variable name="hierLevelNameCount" select="count(gmd:hierarchyLevelName)"/>

      <!--REPORT
      -->
<xsl:if test="$hierLevelNameCount = 0 and ($hierarchyLevelCLValue = 'service' or $hierarchyLevelCLValue = 'series')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$hierLevelNameCount = 0 and ($hierarchyLevelCLValue = 'service' or $hierarchyLevelCLValue = 'series')">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> MI-47a (Hierarchy level name): Need at least one hierarchyLevelName have: <xsl:text/>
               <xsl:copy-of select="$hierLevelNameCount"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M115"/>
   <xsl:template match="@*|node()" priority="-2" mode="M115">
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:hierarchyLevelName/*[not(substring-before(name(), concat(':', local-name())) = 'geonet')][1]"
                 priority="1000"
                 mode="M116">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:hierarchyLevelName/*[not(substring-before(name(), concat(':', local-name())) = 'geonet')][1]"/>
      <xsl:variable name="hierLevelcListVal"
                    select="preceding::gmd:hierarchyLevel/*/@codeListValue"/>
      <xsl:variable name="hierLevelNameText" select="descendant-or-self::text()"/>

      <!--REPORT
      -->
<xsl:if test="($hierLevelcListVal = 'service' and $hierLevelNameText != 'service')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="($hierLevelcListVal = 'service' and $hierLevelNameText != 'service')">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
        MI-47b (Hierarchy level name): Hierarchy level name for services must have value "service" </svrl:text>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="normalize-space(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="normalize-space(.)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-47c: Hierarchy level name for services must have
        value "service" </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M116"/>
   <xsl:template match="@*|node()" priority="-2" mode="M116">
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>

   <!--PATTERN
        Quality Scope-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Quality Scope</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1000" mode="M117">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:dataQualityInfo) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:dataQualityInfo) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-48a (Quality Scope): There must be at least one
        gmd:dataQualityInfo </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M117"/>
   <xsl:template match="@*|node()" priority="-2" mode="M117">
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:hierarchyLevel/gmd:MD_ScopeCode[@codeListValue = 'series']"
                 priority="1000"
                 mode="M118">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:hierarchyLevel/gmd:MD_ScopeCode[@codeListValue = 'series']"/>
      <xsl:variable name="dssDQ"
                    select="count(//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'series'])"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$dssDQ = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$dssDQ = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-48b (Quality Scope): There shall be exactly one
        gmd:dataQualityInfo/gmd:DQ_DataQuality element scoped to the entire described dataset
        series, but here we have <xsl:text/>
                  <xsl:copy-of select="$dssDQ"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M118"/>
   <xsl:template match="@*|node()" priority="-2" mode="M118">
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:hierarchyLevel/gmd:MD_ScopeCode[@codeListValue = 'dataset']"
                 priority="1000"
                 mode="M119">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:hierarchyLevel/gmd:MD_ScopeCode[@codeListValue = 'dataset']"/>
      <xsl:variable name="dsDQ"
                    select="count(//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'dataset'])"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$dsDQ = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$dsDQ = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-48c (Quality Scope): There shall be exactly one
        gmd:dataQualityInfo/gmd:DQ_DataQuality element scoped to the entire described dataset, but
        here we have <xsl:text/>
                  <xsl:copy-of select="$dsDQ"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M119"/>
   <xsl:template match="@*|node()" priority="-2" mode="M119">
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:hierarchyLevel/gmd:MD_ScopeCode[@codeListValue = 'service']"
                 priority="1000"
                 mode="M120">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:hierarchyLevel/gmd:MD_ScopeCode[@codeListValue = 'service']"/>
      <xsl:variable name="svDQ"
                    select="count(//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'service'])"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$svDQ = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$svDQ = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-48d (Quality Scope): There shall be exactly one
        gmd:dataQualityInfo/gmd:DQ_DataQuality element scoped to the entire described service, but
        here we have <xsl:text/>
                  <xsl:copy-of select="$svDQ"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M120"/>
   <xsl:template match="@*|node()" priority="-2" mode="M120">
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'service']"
                 priority="1000"
                 mode="M121">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'service']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(following::gmd:levelDescription) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(following::gmd:levelDescription) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-48e (Quality Scope): gmd:levelDescription is
        missing ~ the level shall be named using element
        gmd:scope/gmd:DQ_Scope/gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other element with a
        Non-empty Free Text Element containing the term "service" </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="           following::gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other/gco:CharacterString/text() != 'service' or           following::gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other/gmx:Anchor/text() != 'service'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="following::gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other/gco:CharacterString/text() != 'service' or following::gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other/gmx:Anchor/text() != 'service'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> MI-48f (Quality Scope): Value (gmd:MD_ScopeDescription/gmd:other) should be "service" </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M121"/>
   <xsl:template match="@*|node()" priority="-2" mode="M121">
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>

   <!--PATTERN
        Spatial Representation Type-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Spatial Representation Type</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/gmd:MD_DataIdentification[1]"
                 priority="1000"
                 mode="M122">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/gmd:MD_DataIdentification[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and count(gmd:spatialRepresentationType) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and count(gmd:spatialRepresentationType) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-50a (Spatial representation type): Dataset and dataset series metadata must have at least one
        gmd:spatialRepresentationType with gmd:MD_SpatialRepresentationTypeCode. The codeListValue
        must be one of 'vector', 'grid', 'tin', or 'textTable' </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M122"/>
   <xsl:template match="@*|node()" priority="-2" mode="M122">
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/gmd:MD_DataIdentification[1]/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode"
                 priority="1000"
                 mode="M123">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/gmd:MD_DataIdentification[1]/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           ($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and           (@codeListValue = 'vector' or @codeListValue = 'grid' or @codeListValue = 'tin' or @codeListValue = 'textTable')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and (@codeListValue = 'vector' or @codeListValue = 'grid' or @codeListValue = 'tin' or @codeListValue = 'textTable')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-50b (Spatial representation type): codeListValue must be one of 'vector', 'grid', 'tin', or 'textTable' </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M123"/>
   <xsl:template match="@*|node()" priority="-2" mode="M123">
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>

   <!--PATTERN
        Spatial Representation Type is not nillable for dataset/series-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Spatial Representation Type is not nillable for dataset/series</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/gmd:MD_DataIdentification[1]/gmd:spatialRepresentationType"
                 priority="1000"
                 mode="M124">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/gmd:MD_DataIdentification[1]/gmd:spatialRepresentationType"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and count(gmd:MD_SpatialRepresentationTypeCode) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and count(gmd:MD_SpatialRepresentationTypeCode) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-50c (Spatial representation type): Dataset and dataset series metadata must have at least one
        gmd:spatialRepresentationType with gmd:MD_SpatialRepresentationTypeCode. The codeListValue
        must be one of 'vector', 'grid', 'tin', or 'textTable' </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M124"/>
   <xsl:template match="@*|node()" priority="-2" mode="M124">
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi50-SRType-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode"
                 priority="1000"
                 mode="M125">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M125"/>
   <xsl:template match="@*|node()" priority="-2" mode="M125">
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>

   <!--PATTERN
        Character encoding-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Character encoding</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:characterSet/gmd:MD_CharacterSetCode[1]"
                 priority="1000"
                 mode="M126">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:characterSet/gmd:MD_CharacterSetCode[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="           ($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and           $charSetCodes//gml:identifier/text()[normalize-space(.) = normalize-space(current()/@codeListValue)]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="($hierarchyLevelCLValue = 'dataset' or $hierarchyLevelCLValue = 'series') and $charSetCodes//gml:identifier/text()[normalize-space(.) = normalize-space(current()/@codeListValue)]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-51 (Character encoding): "<xsl:text/>
                  <xsl:copy-of select="normalize-space(./@codeListValue)"/>
                  <xsl:text/>" is not one of the values of ISO 19139
        code list MD_CharacterSetCode </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M126"/>
   <xsl:template match="@*|node()" priority="-2" mode="M126">
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-mi51-CharSet-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo[1]/gmd:MD_DataIdentification/gmd:characterSet/gmd:MD_CharacterSetCode"
                 priority="1000"
                 mode="M127">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo[1]/gmd:MD_DataIdentification/gmd:characterSet/gmd:MD_CharacterSetCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-3: The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: 6 - Keyword, 8 -
        Dataset Reference Date, 23 - Responsible Organisation, 24 - Frequency of Update, 25 -
        Limitations on Public Access, 26 - Use Constraints, 39 - Resource Type (aka 46 - Hierarchy Level), 42 -
        Specification, 50 - Spatial representation type, and 51 - Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M127"/>
   <xsl:template match="@*|node()" priority="-2" mode="M127">
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_TopologicalConsistency/gmd:result/gmd:DQ_QuantitativeResult/gmd:value"
                 priority="1000"
                 mode="M128">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_TopologicalConsistency/gmd:result/gmd:DQ_QuantitativeResult/gmd:value"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gco:Record/@xsi:type) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gco:Record/@xsi:type) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-52a (Topological consistency): The result type shall be declared
        using the xsi:type attribute of the gco:Record element </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M128"/>
   <xsl:template match="@*|node()" priority="-2" mode="M128">
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>

   <!--PATTERN
        Topological consistency-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Topological consistency</svrl:text>
   <xsl:variable name="GenericNetworkModelValue"
                 select="'INSPIRE Data Specifications - Base Models - Generic Network Model'"/>
   <xsl:variable name="GenericNetworkModelDate" select="'2013-04-05'"/>

  <!--RULE
      -->
<xsl:template match="//gmd:DQ_TopologicalConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString[normalize-space(text()) = 'INSPIRE Data Specifications - Base Models - Generic Network Model']"
                 priority="1000"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:DQ_TopologicalConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString[normalize-space(text()) = 'INSPIRE Data Specifications - Base Models - Generic Network Model']"/>

      <!--REPORT
      -->
<xsl:if test="following::gmd:date/gmd:CI_Date/gmd:date/gco:Date[text() != '2013-04-05']">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="following::gmd:date/gmd:CI_Date/gmd:date/gco:Date[text() != '2013-04-05']">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
        MI-52b (Topological consistency): When TopologicalConsistency is for <xsl:text/>
               <xsl:copy-of select="$GenericNetworkModelValue"/>
               <xsl:text/>, the date given shall be the date of publication of the Generic Network Model, which is
        2013-04-05 </svrl:text>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="following::gmd:dateType/gmd:CI_DateTypeCode[@codeListValue != 'publication']">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="following::gmd:dateType/gmd:CI_DateTypeCode[@codeListValue != 'publication']">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> MI-52c (Topological consistency):
        When TopologicalConsistency is for <xsl:text/>
               <xsl:copy-of select="$GenericNetworkModelValue"/>
               <xsl:text/>, the
        code list value shall always be publication </svrl:text>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(following::gmd:explanation/@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(following::gmd:explanation/@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-52d (Topological consistency): When
        TopologicalConsistency is for <xsl:text/>
                  <xsl:copy-of select="$GenericNetworkModelValue"/>
                  <xsl:text/>, Some
        statement on topological consistency must be provided in the explanation</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="following::gmd:pass/gco:Boolean = 'false'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="following::gmd:pass/gco:Boolean = 'false'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MI-52e (Topological consistency): When
        TopologicalConsistency is for <xsl:text/>
                  <xsl:copy-of select="$GenericNetworkModelValue"/>
                  <xsl:text/>, The value
        shall always be false to indicate that the data does not assure the centerline topology for
        the network </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M129"/>
   <xsl:template match="@*|node()" priority="-2" mode="M129">
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

   <!--PATTERN
        Data identification citation-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Data identification citation</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation"
                 priority="1000"
                 mode="M130">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AT-1: Identification information citation shall
        not be null. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M130"/>
   <xsl:template match="@*|node()" priority="-2" mode="M130">
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>

   <!--PATTERN
        Metadata resource type test-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata resource type test</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]" priority="1000" mode="M131">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]"/>
      <xsl:variable name="isData"
                    select="../gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue='dataset' or                             ../gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue='series'"/>
      <xsl:variable name="isService"
                    select="../gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue='service'"/>
      <xsl:variable name="dataIdExists"
                    select="count(*[local-name()='MD_DataIdentification'])=1 or                                   count(*[@gco:isoType='gmd:MD_DataIdentification'])=1"/>
      <xsl:variable name="serviceIdExists"
                    select="count(*[local-name()='SV_ServiceIdentification'])=1 or                                   count(*[@gco:isoType='srv:SV_ServiceIdentification'])=1"/>

      <!--REPORT
      -->
<xsl:if test="$isData">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$isData">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Resource type is data</svrl:text>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$isService">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$isService">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Resource type is service</svrl:text>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($isData) or                 ( $isData and $dataIdExists ) or                 count(../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($isData) or ( $isData and $dataIdExists ) or count(../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>AT-2a: The first identification information element shall be of type
    gmd:MD_DataIdentification. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($isService) or                 ( $isService and $serviceIdExists ) or                 count(../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($isService) or ( $isService and $serviceIdExists ) or count(../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>AT-2b: The first identification information element shall be of type
    srv:SV_ServiceIdentification. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M131"/>
   <xsl:template match="@*|node()" priority="-2" mode="M131">
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>

   <!--PATTERN
        Metadata file identifier-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata file identifier</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1000" mode="M132">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:fileIdentifier) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:fileIdentifier) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AT-3a: A metadata file identifier shall be
        provided. Its value shall be a system generated GUID. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="contains(gmd:fileIdentifier, '{') or contains(gmd:fileIdentifier, '}')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="contains(gmd:fileIdentifier, '{') or contains(gmd:fileIdentifier, '}')">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
        AT-3b: File identifier shouldn't contain braces </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M132"/>
   <xsl:template match="@*|node()" priority="-2" mode="M132">
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>

   <!--PATTERN
        Gemini2-at3-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:fileIdentifier" priority="1000" mode="M133">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:fileIdentifier"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AP-2: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following
        Metadata Items: 1 - Title, 4 - Abstract, 6 - Keyword, 11, 12, 13, 14 - Geographic Bounding
        Box, 17 - Spatial Reference System, 23 - Responsible Organisation, 30 - Metadata Date, 35 -
        Metadata Point of Contact, 36 - (Unique) Resource Identifier, 42 - Specification, and in the
        Ancillary test 3 - Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M133"/>
   <xsl:template match="@*|node()" priority="-2" mode="M133">
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>

   <!--PATTERN
        Constraints-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Constraints</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]" priority="1000"
                 mode="M134">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:resourceConstraints) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:resourceConstraints) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AT-4: Limitations on public access
        and use constraints are required. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M134"/>
   <xsl:template match="@*|node()" priority="-2" mode="M134">
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>

   <!--PATTERN
        Creation date type-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Creation date type</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:CI_Citation | //*[@gco:isoType = 'gmd:CI_Citation'][1]"
                 priority="1000"
                 mode="M135">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:CI_Citation | //*[@gco:isoType = 'gmd:CI_Citation'][1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:date/*[1]/gmd:dateType/*[1][@codeListValue = 'creation']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:date/*[1]/gmd:dateType/*[1][@codeListValue = 'creation']) &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AT-5: There shall not be more than one creation date. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M135"/>
   <xsl:template match="@*|node()" priority="-2" mode="M135">
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>

   <!--PATTERN
        Non-empty free text content-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Non-empty free text content</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gco:CharacterString | //gmx:Anchor" priority="1000" mode="M136">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gco:CharacterString | //gmx:Anchor"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="normalize-space(.) or string(../@gco:nilReason)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="normalize-space(.) or string(../@gco:nilReason)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AT-6: Free text elements should not be empty
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M136"/>
   <xsl:template match="@*|node()" priority="-2" mode="M136">
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>

   <!--PATTERN
        Revision date type-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Revision date type</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:CI_Citation | //*[@gco:isoType = 'gmd:CI_Citation'][1]"
                 priority="1000"
                 mode="M137">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:CI_Citation | //*[@gco:isoType = 'gmd:CI_Citation'][1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:date/*[1]/gmd:dateType/*[1][@codeListValue = 'revision']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:date/*[1]/gmd:dateType/*[1][@codeListValue = 'revision']) &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> AT-7: There shall not be more than one revision date. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M137"/>
   <xsl:template match="@*|node()" priority="-2" mode="M137">
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>

   <!--PATTERN
        Legal Constraints-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Legal Constraints</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo" priority="1000" mode="M138">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo"/>
      <xsl:variable name="legalCons"
                    select="count(//gmd:MD_Metadata[1]/gmd:identificationInfo/*[1]/gmd:resourceConstraints/gmd:MD_LegalConstraints)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$legalCons &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$legalCons &gt; 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        AT-8: There must be at least two Legal Constraints sections (gmd:resourceConstraints/gmd:MD_LegalConstraints) in the metadata but we have <xsl:text/>
                  <xsl:copy-of select="$legalCons"/>
                  <xsl:text/>.
        One section shall be provided to describe the "Limitations on public access" and another shall be provided to describe the
        "Conditions for access and use"
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M138"/>
   <xsl:template match="@*|node()" priority="-2" mode="M138">
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>
</xsl:stylesheet>