<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="documentSystemID" as="xs:string"></xsl:param>
    <xsl:param name="contextElementXPathExpression" as="xs:string"></xsl:param>    
    
    <xsl:template name="start">
<!--        <xsl:message><xsl:value-of select="doc($documentSystemID)"/></xsl:message>-->
        <xsl:apply-templates select="doc($documentSystemID)"/>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:variable name="citElement" select="saxon:eval(saxon:expression($contextElementXPathExpression, ./*))"/>
        <xsl:if test="$citElement/@type = 'translation'">
            <items action="replace">
                <item value="ru"/>
                <item value="en"/>
            </items>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>