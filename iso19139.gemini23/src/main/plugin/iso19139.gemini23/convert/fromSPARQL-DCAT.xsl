<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:gmd="http://www.isotc211.org/2005/gmd"
              xmlns:gco="http://www.isotc211.org/2005/gco"
              xmlns:srv="http://www.isotc211.org/2005/srv"
              xmlns:gmx="http://www.isotc211.org/2005/gmx"
              xmlns:gts="http://www.isotc211.org/2005/gts"
              xmlns:gsr="http://www.isotc211.org/2005/gsr"
              xmlns:gmi="http://www.isotc211.org/2005/gmi"
              xmlns:gss="http://www.isotc211.org/2005/gss"
              xmlns:gml="http://www.opengis.net/gml/3.2"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xmlns:sr="http://www.w3.org/2005/sparql-results#"
              xmlns:xs="http://www.w3.org/2001/XMLSchema"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:spdx="http://spdx.org/rdf/terms#"
              xmlns:skos="http://www.w3.org/2004/02/skos/core#"
              xmlns:adms="http://www.w3.org/ns/adms#"
              xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
              xmlns:dct="http://purl.org/dc/terms/"
              xmlns:dcat="http://www.w3.org/ns/dcat#"
              xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
              xmlns:foaf="http://xmlns.com/foaf/0.1/"
              xmlns:owl="http://www.w3.org/2002/07/owl#"
              xmlns:schema="http://schema.org/"
              xmlns:locn="http://www.w3.org/ns/locn#"
              xmlns:mdcat="http://data.vlaanderen.be/ns/metadata-dcat#"
              xmlns:fn="http://www.w3.org/2005/xpath-functions"
              xmlns:util="java:org.fao.geonet.util.XslUtil"
              xmlns:gn-fn-sparql="http://geonetwork-opensource.org/xsl/functions/sparql"
              version="2.0"
              exclude-result-prefixes="#all">

  <xsl:import href="utility/createiso19139Namespaces.xsl"/>
  <xsl:import href="common/functions-sparql.xsl"/>

  <!-- Converted from https://github.com/geonetwork/core-geonetwork/blob/main/schemas/iso19115-3.2018/src/main/plugin/iso19115-3.2018/convert/fromSPARQL-DCAT.xsl
  to create Gemini 2.3 records -->

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:param name="uuid" as="xs:string?"/>

  <xsl:variable name="root"
                select="/sr:sparql/sr:results"/>

  <xsl:template match="/">
    <xsl:variable name="catalogURIs"
                  select="gn-fn-sparql:getSubject($root,
                    'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
                    'http://www.w3.org/ns/dcat#Catalog')"/>

    <xsl:variable name="recordURIs"
                  select="gn-fn-sparql:getSubject($root,
                    'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
                    'http://www.w3.org/ns/dcat#CatalogRecord')"/>

    <xsl:variable name="datasetURIs"
                  select="gn-fn-sparql:getSubject($root,
                    'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
                    'http://www.w3.org/ns/dcat#Dataset')"/>

    <xsl:variable name="serviceURIs"
                  select="gn-fn-sparql:getSubject($root,
                    'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
                    'http://www.w3.org/ns/dcat#DataService')"/>

    <xsl:for-each select="$recordURIs">

      <!-- We expect only one CatalogRecord containing on Dataset or DataService -->
      <xsl:variable name="resource"
                    select="($datasetURIs|$serviceURIs)"/>

      <xsl:variable name="isService"
                    select="ends-with($resource/binding[@name = 'object']/uri, 'DataService')"
                    as="xs:boolean"/>

      <xsl:variable name="recordUri"
                    select="sr:uri"/>


      <gmd:MD_Metadata>
        <xsl:call-template name="add-iso19139-namespaces"/>

        <xsl:variable name="uuid"
                      select="if ($uuid != '') then $uuid
                              else gn-fn-sparql:getObject($root,
                                'http://purl.org/dc/terms/identifier',
                                $recordUri)/sr:literal"/>

        <gmd:fileIdentifier>
              <gco:CharacterString>
                <xsl:value-of select="$uuid"/>
              </gco:CharacterString>
        </gmd:fileIdentifier>

        <!-- Metadata Language is hard-coded -->
        <gmd:language>
            <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="eng">English</gmd:LanguageCode>
        </gmd:language>

        <gmd:hierarchyLevel>
              <gmd:MD_ScopeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_ScopeCode"
                                codeListValue="{if ($isService)
                                                then 'service'
                                                else 'dataset'}"/>
        </gmd:hierarchyLevel>

        <!-- metadata pointOfContact -->
        <!-- not sure which element this should map to? -->

        <gmd:contact >
            <gmd:CI_ResponsibleParty>
               <gmd:organisationName gco:nilReason="missing">
                  <gco:CharacterString/>
               </gmd:organisationName>
               <gmd:positionName gco:nilReason="missing">
                  <gco:CharacterString/>
               </gmd:positionName>
               <gmd:contactInfo>
                  <gmd:CI_Contact>
                     <gmd:phone>
                        <gmd:CI_Telephone>
                           <gmd:voice gco:nilReason="missing">
                              <gco:CharacterString/>
                           </gmd:voice>
                        </gmd:CI_Telephone>
                     </gmd:phone>
                     <gmd:address>
                        <gmd:CI_Address>
                           <gmd:deliveryPoint gco:nilReason="missing">
                              <gco:CharacterString/>
                           </gmd:deliveryPoint>
                           <gmd:city gco:nilReason="missing">
                              <gco:CharacterString/>
                           </gmd:city>
                           <gmd:postalCode gco:nilReason="missing">
                              <gco:CharacterString/>
                           </gmd:postalCode>
                           <gmd:country gco:nilReason="missing">
                              <gco:CharacterString/>
                           </gmd:country>
                           <gmd:electronicMailAddress gco:nilReason="missing">
                              <gco:CharacterString/>
                           </gmd:electronicMailAddress>
                        </gmd:CI_Address>
                     </gmd:address>
                  </gmd:CI_Contact>
               </gmd:contactInfo>
               <gmd:role>
                  <gmd:CI_RoleCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_RoleCode"
                                   codeListValue="pointOfContact"/>
               </gmd:role>
            </gmd:CI_ResponsibleParty>
        </gmd:contact>

        <!-- Metadata dateStamp is set to current date -->

        <xsl:variable name="dateStamp" select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[h1]:[m01]:[s01]')"/>

        <gmd:dateStamp >
            <gco:DateTime><xsl:value-of select="$dateStamp"/></gco:DateTime>
        </gmd:dateStamp>

        <!-- Metadata Standard Name and Version are hard-coded -->

        <gmd:metadataStandardName >
              <gmx:Anchor xlink:href="http://vocab.nerc.ac.uk/collection/M25/current/GEMINI/">UK GEMINI</gmx:Anchor>
          </gmd:metadataStandardName>
          <gmd:metadataStandardVersion >
              <gco:CharacterString>2.3</gco:CharacterString>
          </gmd:metadataStandardVersion>

        <!-- Reference System Info is hard-coded -->

        <gmd:referenceSystemInfo >
            <gmd:MD_ReferenceSystem>
               <gmd:referenceSystemIdentifier>
                  <gmd:RS_Identifier>
                     <gmd:code>
                        <gmx:Anchor xlink:title="OSGB 1936 / British National Grid (EPSG:27700)"
                                    xlink:href="http://www.opengis.net/def/crs/EPSG/0/27700">EPSG:27700</gmx:Anchor>
                     </gmd:code>
                  </gmd:RS_Identifier>
               </gmd:referenceSystemIdentifier>
            </gmd:MD_ReferenceSystem>
        </gmd:referenceSystemInfo>

        <!-- in Gemini I don't think this exists at this level -->
        <!-- <gmd:metadataLinkage>
          <gmd:CI_OnlineResource>
            <gmd:linkage>
              <gco:CharacterString><xsl:value-of select="$recordUri"/></gco:CharacterString>
            </gmd:linkage>
            <gmd:function>
              <gmd:CI_OnLineFunctionCode
                codeList="http://standards.iso.org/iso/19139/resources/codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                codeListValue="completeMetadata"/>
            </gmd:function>
          </gmd:CI_OnlineResource>
        </gmd:metadataLinkage> -->


        <xsl:for-each select="$resource">
          <xsl:variable name="resourceUri"
                        select="sr:uri"/>

          <gmd:identificationInfo>
            <xsl:choose>
              <xsl:when test="$isService"></xsl:when>
              <xsl:otherwise>
                <gmd:MD_DataIdentification>
                  <gmd:citation>
                    <gmd:CI_Citation>
                      <gmd:title>
                        <gco:CharacterString>
                          <xsl:value-of select="gn-fn-sparql:getObject($root,
                                                  'http://purl.org/dc/terms/title',
                                                  $resourceUri)/sr:literal"/>
                        </gco:CharacterString>
                      </gmd:title>

                      <gmd:alternateTitle>
                        <gco:CharacterString>
                          <xsl:value-of select="gn-fn-sparql:getObject($root,
                                                  'http://purl.org/dc/terms/alternative_name',
                                                  $resourceUri)/sr:literal"/>
                        </gco:CharacterString>
                      </gmd:alternateTitle>

                      <xsl:variable name="dateTypes" as="node()*">
                        <type dcatType="created" isoType="creation"/>
                        <type dcatType="modified" isoType="revision"/>
                        <type dcatType="issued" isoType="publication"/>
                      </xsl:variable>

                      <xsl:for-each select="$dateTypes">
                        <xsl:variable name="dates"
                                      select="gn-fn-sparql:getObject($root,
                                                  concat('http://purl.org/dc/terms/', @dcatType),
                                                  $resourceUri)/sr:literal"/>
                        <xsl:variable name="isoType" select="@isoType"/>
                        <xsl:for-each select="$dates">
                          <xsl:call-template name="build-date">
                            <xsl:with-param name="element" select="'gmd:date'"/>
                            <xsl:with-param name="date" select="."/>
                            <xsl:with-param name="dateType" select="$isoType"/>
                          </xsl:call-template>
                        </xsl:for-each>
                      </xsl:for-each>


                      <xsl:variable name="identifier"
                                    select="gn-fn-sparql:getObject($root,
                                                  'http://purl.org/dc/terms/identifier',
                                                  $resourceUri)/sr:literal"/>
                      <xsl:if test="$identifier != ''">
                        <gmd:identifier>
                          <gmd:MD_Identifier>
                            <gmd:code>
                              <gco:CharacterString>
                                <xsl:value-of select="$identifier"/>
                              </gco:CharacterString>
                            </gmd:code>
                          </gmd:MD_Identifier>
                        </gmd:identifier>
                      </xsl:if>
                    </gmd:CI_Citation>
                  </gmd:citation>
                  <gmd:abstract>
                    <gco:CharacterString>
                      <xsl:value-of select="gn-fn-sparql:getObject($root,
                                                  'http://purl.org/dc/terms/description',
                                                  $resourceUri)/sr:literal"/>
                    </gco:CharacterString>
                  </gmd:abstract>

                  <!-- dataset contact(s) -->

                  <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                  'http://www.w3.org/ns/dcat#contactPoint',
                                                  $resourceUri)/sr:bnode">
                    <xsl:call-template name="build-contact">
                      <xsl:with-param name="contactUri" select="."/>
                    </xsl:call-template>
                  </xsl:for-each>

                  <!-- resource maintenance -->

                  <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                  'http://purl.org/dc/terms/accrualPeriodicity',
                                                  $resourceUri)/sr:uri">

                    <xsl:variable name="euPrefix"
                                  select="'http://publications.europa.eu/resource/authority/frequency/'"/>
                    <xsl:variable name="frequency"
                                  select="if(starts-with(., $euPrefix))
                                          then substring-after(., $euPrefix)
                                          else ."/>
                    <gmd:resourceMaintenance>
                      <gmd:MD_MaintenanceInformation>
                        <gmd:maintenanceAndUpdateFrequency>
                          <gmd:MD_MaintenanceFrequencyCode codeListValue="{$frequency}"
                                                           codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_MaintenanceFrequencyCode"/>
                        </gmd:maintenanceAndUpdateFrequency>
                      </gmd:MD_MaintenanceInformation>
                    </gmd:resourceMaintenance>
                  </xsl:for-each>

                  <!-- descriptive Keywords -->
                  <!-- free text only -->
                  <gmd:descriptiveKeywords>
                    <gmd:MD_Keywords>
                      <xsl:variable name="theme"
                                    select="gn-fn-sparql:getObject($root,
                                                      ('http://www.w3.org/ns/dcat#theme'),
                                                      $resourceUri)/sr:bnode"/>
                      <xsl:choose>
                        <xsl:when test="$theme">
                          <xsl:for-each select="$theme">
                            <xsl:variable name="label"
                                          select="gn-fn-sparql:getObject($root,
                                                      'http://www.w3.org/2004/02/skos/core#prefLabel',
                                                      .)/sr:literal"/>
                            <gmd:keyword>
                              <gco:CharacterString><xsl:value-of select="$label"/></gco:CharacterString>
                            </gmd:keyword>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                      ('http://www.w3.org/ns/dcat#keyword'),
                                                      $resourceUri)/sr:literal">
                              <gmd:keyword>
                                  <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                              </gmd:keyword>
                          </xsl:for-each>
                        </xsl:otherwise>
                      </xsl:choose>
                    </gmd:MD_Keywords>
                  </gmd:descriptiveKeywords>

                  <!-- Resource Constraints -->
                  <!-- hard-coded as there's nowt in the dcat output about it afaict -->

                  <gmd:resourceConstraints>
                    <gmd:MD_LegalConstraints>
                      <gmd:accessConstraints>
                        <gmd:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"
                                                codeListValue="otherRestrictions"/>
                      </gmd:accessConstraints>
                      <gmd:otherConstraints>
                        <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">no limitations</gmx:Anchor>
                      </gmd:otherConstraints>
                    </gmd:MD_LegalConstraints>
                  </gmd:resourceConstraints>
                  <gmd:resourceConstraints>
                    <gmd:MD_LegalConstraints>
                      <gmd:useConstraints>
                        <gmd:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"
                                                codeListValue="otherRestrictions"/>
                      </gmd:useConstraints>

                      <!-- Add license information from DCAT -->
                      <gmd:otherConstraints>
                        <xsl:variable name="license"
                                      select="gn-fn-sparql:getObject($root,
                                                'http://purl.org/dc/terms/license',
                                                $resourceUri)/sr:literal"/>
                        <xsl:variable name="licenseUrl"
                                      select="normalize-space(gn-fn-sparql:getObject($root,
                                                'http://purl.org/dc/terms/license_url',
                                                $resourceUri))"/>
                        <xsl:choose>
                          <xsl:when test="$license">
                            <xsl:choose>
                              <xsl:when test="$licenseUrl">
                                <gmx:Anchor xlink:href="{$licenseUrl}"><xsl:value-of select="$license"/></gmx:Anchor>
                              </xsl:when>
                              <xsl:otherwise>
                                <gco:CharacterString><xsl:value-of select="$license"/></gco:CharacterString>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise>
                            <gmd:otherConstraints>
                              <gmx:Anchor>no conditions apply</gmx:Anchor>
                            </gmd:otherConstraints>
                          </xsl:otherwise>
                        </xsl:choose>
                      </gmd:otherConstraints>
                    </gmd:MD_LegalConstraints>
                  </gmd:resourceConstraints>

                  <!-- Spatial Representation Type -->
                  <!-- hard-coded as there's nowt in the dcat output about it afaict -->

                  <gmd:spatialRepresentationType>
                     <gmd:MD_SpatialRepresentationTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_SpatialRepresentationTypeCode"
                                                           codeListValue="textTable"/>
                  </gmd:spatialRepresentationType>



                  <!--
                  <dcat:spatialResolutionInMeters>25000</dcat:spatialResolutionInMeters>
                  -->
                  <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                  'http://www.w3.org/ns/dcat#spatialResolutionInMeters',
                                                  $resourceUri)/sr:literal">
                    <gmd:spatialResolution>
                      <gmd:MD_Resolution>
                        <gmd:equivalentScale>
                          <gmd:MD_RepresentativeFraction>
                            <gmd:denominator>
                              <gco:Integer><xsl:value-of select="."/></gco:Integer>
                            </gmd:denominator>
                          </gmd:MD_RepresentativeFraction>
                        </gmd:equivalentScale>
                      </gmd:MD_Resolution>
                    </gmd:spatialResolution>
                  </xsl:for-each>

                  <!-- Metadata Language and Character Set -->
                  <!-- hard-coded as there's nowt in the dcat output about it afaict -->

                  <gmd:language>
                     <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="eng">English</gmd:LanguageCode>
                  </gmd:language>
                  <gmd:characterSet>
                     <gmd:MD_CharacterSetCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_CharacterSetCode"
                                              codeListValue="utf8"/>
                  </gmd:characterSet>

                  <!--
                  <gmd:topicCategory>
                    <gmd:MD_TopicCategoryCode>inlandWaters</gmd:MD_TopicCategoryCode>
                  </gmd:topicCategory>
                  -->

                  <!--
                    <dct:spatial>
                        <dct:Location>
                            <locn:geometry>{"coordinates":[[[6.755991,45.788744],[10.541824,45.788744],[10.541824,47.517566],[6.755991,47.517566],[6.755991,45.788744]]],"type":"Polygon"}</locn:geometry>
                        </dct:Location>
                    </dct:spatial>
                   -->
                  <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                  'http://purl.org/dc/terms/spatial',
                                                  $resourceUri)/sr:bnode[. != '']">
                    <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                  'http://www.w3.org/ns/locn#geometry',
                                                  .)/sr:literal">
                      <xsl:variable name="coordByPipe"
                                    select="util:geoJsonGeomToBbox(string(.))"/>
                      <xsl:if test="$coordByPipe != ''">
                        <xsl:variable name="coords"
                                      select="tokenize($coordByPipe, '\|')"/>
                        <gmd:extent>
                          <gmd:EX_Extent>
                            <gmd:geographicElement>
                              <gmd:EX_GeographicBoundingBox>
                                <gmd:westBoundLongitude>
                                  <gco:Decimal><xsl:value-of select="$coords[1]"/></gco:Decimal>
                                </gmd:westBoundLongitude>
                                <gmd:eastBoundLongitude>
                                  <gco:Decimal><xsl:value-of select="$coords[3]"/></gco:Decimal>
                                </gmd:eastBoundLongitude>
                                <gmd:southBoundLatitude>
                                  <gco:Decimal><xsl:value-of select="$coords[2]"/></gco:Decimal>
                                </gmd:southBoundLatitude>
                                <gmd:northBoundLatitude>
                                  <gco:Decimal><xsl:value-of select="$coords[4]"/></gco:Decimal>
                                </gmd:northBoundLatitude>
                              </gmd:EX_GeographicBoundingBox>
                            </gmd:geographicElement>
                            <gmd:temporalElement>
                               <gmd:EX_TemporalExtent>
                                  <gmd:extent>
                                     <gml:TimePeriod gml:id="d36910e289a1053982">
                                        <gml:beginPosition/>
                                        <gml:endPosition/>
                                     </gml:TimePeriod>
                                  </gmd:extent>
                               </gmd:EX_TemporalExtent>
                            </gmd:temporalElement>
                            <gmd:verticalElement gco:nilReason="missing"/>
                          </gmd:EX_Extent>
                        </gmd:extent>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:for-each>
                </gmd:MD_DataIdentification>
              </xsl:otherwise>
            </xsl:choose>
          </gmd:identificationInfo>

          <!-- distribution info -->

          <xsl:variable name="distributions"
                        select="gn-fn-sparql:getObject($root,
                                                  'http://www.w3.org/ns/dcat#distribution',
                                                  $resourceUri)/sr:bnode[. != '']"/>

          <gmd:distributionInfo>
            <gmd:MD_Distribution>

              <!-- distribution format -->
              <!-- hard-coded as there's nowt in the rdf afaict -->
              <gmd:distributionFormat>
                  <gmd:MD_Format>
                    <gmd:name gco:nilReason="missing">
                        <gco:CharacterString/>
                    </gmd:name>
                    <gmd:version gco:nilReason="unknown"/>
                    <gmd:specification gco:nilReason="missing">
                        <gco:CharacterString/>
                    </gmd:specification>
                  </gmd:MD_Format>
              </gmd:distributionFormat>

              <!-- transfer options -->
              <gmd:transferOptions>
                <gmd:MD_DigitalTransferOptions>
                  <xsl:if test="$distributions">

                    <xsl:for-each select="$distributions">
                      <xsl:variable name="accessUrl"
                                    select="gn-fn-sparql:getObject($root,
                                                        'http://www.w3.org/ns/dcat#accessURL',
                                                        .)/sr:uri"/>
                      <gmd:onLine>
                        <gmd:CI_OnlineResource>
                          <gmd:linkage>
                            <gco:CharacterString>
                              <xsl:value-of select="$accessUrl"/>
                            </gco:CharacterString>
                          </gmd:linkage>

                          <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                        'http://www.w3.org/ns/adms#representationTechnique',
                                                        .)/sr:bnode[. != '']">
                            <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                          'http://www.w3.org/2004/02/skos/core#prefLabel',
                                                          .)/sr:literal[. != '']">
                              <gmd:protocol>
                                <gco:CharacterString>
                                  <xsl:value-of select="."/>
                                </gco:CharacterString>
                              </gmd:protocol>
                            </xsl:for-each>
                          </xsl:for-each>

                          <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                        'http://purl.org/dc/terms/title',
                                                        .)/sr:literal">
                            <gmd:name>
                              <gco:CharacterString>
                                <xsl:value-of select="."/>
                              </gco:CharacterString>
                            </gmd:name>
                          </xsl:for-each>

                          <xsl:for-each select="gn-fn-sparql:getObject($root,
                                                        'http://purl.org/dc/terms/description',
                                                        .)/sr:literal">
                            <gmd:description>
                              <gco:CharacterString>
                                <xsl:value-of select="."/>
                              </gco:CharacterString>
                            </gmd:description>
                          </xsl:for-each>
                        </gmd:CI_OnlineResource>
                      </gmd:onLine>
                    </xsl:for-each>
                  </xsl:if>

                  <!-- Link to original CKAN record -->

                  <gmd:onLine>
                    <gmd:CI_OnlineResource>
                      <gmd:linkage>
                        <gmd:URL>
                          <xsl:copy-of select="string($resourceUri)"/>
                        </gmd:URL>
                      </gmd:linkage>
                      <gmd:protocol>
                        <gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
                      </gmd:protocol>
                      <gmd:name>
                        <gco:CharacterString>
                          <xsl:value-of select="gn-fn-sparql:getObject($root,
                                                'http://purl.org/dc/terms/title',
                                                $resourceUri)/sr:literal"/>
                        </gco:CharacterString>
                      </gmd:name>
                      <gmd:description>
                        <gco:CharacterString>A link to the original CKAN metadata record.</gco:CharacterString>
                      </gmd:description>
                      <gmd:function>
                        <gmd:CI_OnLineFunctionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_OnLineFunctionCode" codeListValue="download"/>
                      </gmd:function>
                    </gmd:CI_OnlineResource>
                  </gmd:onLine>
                </gmd:MD_DigitalTransferOptions>
              </gmd:transferOptions>
            </gmd:MD_Distribution>
          </gmd:distributionInfo>

          <!-- Data Quality -->
          <!-- scope and conformity are hard-coded as there's nothing in the rdf -->
          <gmd:dataQualityInfo >
            <gmd:DQ_DataQuality>
              <gmd:scope>
                <gmd:DQ_Scope>
                    <gmd:level>
                      <gmd:MD_ScopeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_ScopeCode"
                                        codeListValue="dataset"/>
                    </gmd:level>
                </gmd:DQ_Scope>
              </gmd:scope>
              <gmd:report>
                <gmd:DQ_DomainConsistency>
                  <gmd:result>
                    <gmd:DQ_ConformanceResult>
                      <gmd:specification>
                        <gmd:CI_Citation>
                          <gmd:title>
                            <gmx:Anchor xlink:href="http://data.europa.eu/eli/reg/2010/1089">Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services</gmx:Anchor>
                          </gmd:title>
                          <gmd:date>
                            <gmd:CI_Date>
                              <gmd:date>
                                <gco:Date>2010-12-08</gco:Date>
                              </gmd:date>
                              <gmd:dateType>
                                <gmd:CI_DateTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_DateTypeCode"
                                                      codeListValue="publication"/>
                              </gmd:dateType>
                            </gmd:CI_Date>
                          </gmd:date>
                        </gmd:CI_Citation>
                      </gmd:specification>
                      <gmd:explanation gco:nilReason="inapplicable"/>
                      <gmd:pass gco:nilReason="unknown"/>
                    </gmd:DQ_ConformanceResult>
                  </gmd:result>
                </gmd:DQ_DomainConsistency>
              </gmd:report>
              <xsl:variable name="lineage"
                            select="gn-fn-sparql:getObject($root,
                                                'http://purl.org/dc/terms/lineage',
                                                $resourceUri)/sr:literal"/>

              <xsl:if test="$lineage != ''">
                <gmd:lineage>
                  <gmd:LI_Lineage>
                    <gmd:statement>
                      <gco:CharacterString><xsl:value-of select="$lineage"/></gco:CharacterString>
                    </gmd:statement>
                  </gmd:LI_Lineage>
                </gmd:lineage>
              </xsl:if>
            </gmd:DQ_DataQuality>
          </gmd:dataQualityInfo>
        </xsl:for-each>
      </gmd:MD_Metadata>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="build-date">
    <xsl:param name="element" as="xs:string"/>
    <xsl:param name="date" as="xs:string"/>
    <xsl:param name="dateType" as="xs:string"/>

    <xsl:element name="{$element}">
      <gmd:CI_Date>
        <gmd:date>
          <gco:DateTime><xsl:value-of select="$date"/></gco:DateTime>
        </gmd:date>
        <gmd:dateType>
          <gmd:CI_DateTypeCode codeList="https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_DateTypeCode"
                               codeListValue="{$dateType}"></gmd:CI_DateTypeCode>
        </gmd:dateType>
      </gmd:CI_Date>
    </xsl:element>
  </xsl:template>


    <!--
  <dcat:contactPoint>
      <vcard:Kind>
          <vcard:title>Bundesamt für Raumentwicklung</vcard:title>
          <vcard:role>pointOfContact</vcard:role>
          <vcard:hasEmail>rolf.giezendanner@are.admin.ch</vcard:hasEmail>
      </vcard:Kind>
  </dcat:contactPoint>
  -->
  <xsl:template name="build-contact">
    <xsl:param name="element" as="xs:string?" select="'gmd:pointOfContact'"/>
    <xsl:param name="contactUri" as="xs:string"/>

    <xsl:variable name="role"
                  select="gn-fn-sparql:getObject($root,
                                    'http://www.w3.org/2006/vcard/ns#role',
                                    $contactUri)/sr:literal"/>
    <xsl:variable name="title"
                  select="gn-fn-sparql:getObject($root,
                                    'http://www.w3.org/2006/vcard/ns#title',
                                    $contactUri)/sr:literal"/>
    <xsl:variable name="email"
                  select="gn-fn-sparql:getObject($root,
                                    'http://www.w3.org/2006/vcard/ns#hasEmail',
                                    $contactUri)/sr:literal"/>


    <xsl:element name="{$element}">
      <gmd:CI_ResponsibleParty>
        <xsl:choose>
          <xsl:when test="$title != ''">
            <gmd:organisationName>
              <gco:CharacterString>
                <xsl:value-of select="$title"/>
              </gco:CharacterString>
            </gmd:organisationName>
          </xsl:when>
          <xsl:otherwise>
            <gmd:organisationName gco:nilReason="missing">
              <gco:CharacterString />
            </gmd:organisationName>
          </xsl:otherwise>
        </xsl:choose>
        <gmd:contactInfo>
          <gmd:CI_Contact>
            <gmd:onlineResource>
              <gmd:CI_OnlineResource>
                <xsl:choose>
                  <xsl:when test="$email != ''">
                    <gmd:electronicMailAddress>
                      <gco:CharacterString><xsl:value-of select="$email"/></gco:CharacterString>
                    </gmd:electronicMailAddress>
                  </xsl:when>
                  <xsl:otherwise>
                    <gmd:electronicMailAddress gco:nilReason="missing">
                      <gco:CharacterString />
                    </gmd:electronicMailAddress>
                  </xsl:otherwise>
                </xsl:choose>
              </gmd:CI_OnlineResource>
            </gmd:onlineResource>
          </gmd:CI_Contact>
        </gmd:contactInfo>
        <gmd:role>
          <gmd:CI_RoleCode codeList="https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_RoleCode"
                           codeListValue="{$role}"></gmd:CI_RoleCode>
        </gmd:role>
      </gmd:CI_ResponsibleParty>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>