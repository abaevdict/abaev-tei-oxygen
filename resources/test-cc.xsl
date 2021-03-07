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
        <xsl:apply-templates select="doc($documentSystemID)"/>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:variable name="propertyElement" 
            select="saxon:eval(saxon:expression($contextElementXPathExpression, ./*))"/>
        <xsl:message><xsl:value-of select="$contextElementXPathExpression"/></xsl:message>
        <xsl:message><xsl:value-of select="name($propertyElement)"/></xsl:message>
        <items>
            <xsl:if test="$propertyElement/@name = 'color'">
                <item value='red'/>
                <item value='blue'/>  
            </xsl:if>
            <xsl:if test="$propertyElement/@name = 'shape'">
                <item value='rectangle'/>
                <item value='square'/>  
            </xsl:if>
        </items>
    </xsl:template>
</xsl:stylesheet>