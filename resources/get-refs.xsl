<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:expath-file="http://expath.org/ns/file"
    xmlns:abv="http://ossetic-studies.org/ns/abaevdict"
    exclude-result-prefixes="xs tei expath-file"
    version="2.0">
    
    <xsl:param name="documentSystemID" as="xs:string"></xsl:param>
    <xsl:param name="contextElementXPathExpression" as="xs:string"></xsl:param>    
    
    <xsl:template name="start">
<!--        <xsl:message><xsl:value-of select="$documentSystemID"/></xsl:message>-->
<!--        <xsl:message><xsl:value-of select="$contextElementXPathExpression"/></xsl:message>-->
        <xsl:variable name="dir">
            <xsl:call-template name="getURL">
                <xsl:with-param name="path" select="$documentSystemID"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="masterPath"><xsl:value-of select="$dir"/><xsl:text>../abaev_biblio.xml</xsl:text></xsl:variable>
        <!--<xsl:variable name="master" select="document($masterPath)"/>
        
        <xsl:variable name="collection" select="collection($dir)"/>-->
<!--        <xsl:message><xsl:value-of select="$documentSystemID"/></xsl:message>-->
        
        <xsl:apply-templates select="doc($documentSystemID)"><xsl:with-param name="collectionDir" select="$dir"/><xsl:with-param name="masterPath" select="$masterPath"/></xsl:apply-templates>
        
<!--        <items action="replace" editable="true">
            <xsl:for-each select="$collection">
                <xsl:for-each select="//*[starts-with(@xml:id,'entry_')]">
                    <xsl:element name="item">
                        <xsl:attribute name="value"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
        </items>   -->     
    </xsl:template>
    

    <xsl:template name="getURL">
        <xsl:param name="path" />
        <xsl:choose>
            <xsl:when test="contains($path,'/')">
                <xsl:value-of select="substring-before($path,'/')" />
                <xsl:text>/</xsl:text>
                <xsl:call-template name="getURL">
                    <xsl:with-param name="path" select="substring-after($path,'/')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
    </xsl:template>    
    
    <xsl:template match="/">
        <xsl:param name="collectionDir"/>
        <xsl:param name="masterPath"/>
        <xsl:variable name="element"
            select="saxon:eval(saxon:expression($contextElementXPathExpression))"/>
<!--        <xsl:message><xsl:value-of select="$masterPath"/></xsl:message>-->
        <items action="replace" editable="true">
            <xsl:if test="$element/@type = 'xr'">
                <xsl:for-each select="expath-file:list($collectionDir)">
                        <xsl:element name="item">
                            <xsl:attribute name="value">
                                <xsl:text>#</xsl:text>
                                <xsl:value-of select="replace(substring-before(.,'.xml'),'abaev_','entry_')"/>
                            </xsl:attribute>
                        </xsl:element>                    
                </xsl:for-each>
<!--                <xsl:variable name="collection" select="collection($collectionDir)"/>
                <xsl:for-each select="$collection">
<!-\-                    <xsl:for-each select="//*[starts-with(@xml:id, 'entry_')]">-\->
<!-\-                    <xsl:for-each select="//entry">-\->
                        <xsl:element name="item">
                            <xsl:attribute name="value">
                                <xsl:text>#</xsl:text>
                                <xsl:value-of select="/tei:TEI/tei:text/tei:body/tei:entry[1]/@xml:id"/>
                            </xsl:attribute>
                        </xsl:element>
                    <!-\-</xsl:for-each>-\->
                </xsl:for-each>-->
            </xsl:if>
            <xsl:if test="$element/@type = 'bibl'">
                <xsl:variable name="master" select="document($masterPath)"/>
                <xsl:for-each select="$master/tei:TEI/tei:text/tei:body/tei:div/tei:listBibl/tei:bibl">
                        <xsl:element name="item">
                            <xsl:attribute name="value">
                                <xsl:text>#</xsl:text>
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                        </xsl:element>                    
                </xsl:for-each>
            </xsl:if>
        </items>
        
    </xsl:template>
</xsl:stylesheet>