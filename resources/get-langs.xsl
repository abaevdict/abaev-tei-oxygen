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
        <xsl:variable name="element"
            select="saxon:eval(saxon:expression($contextElementXPathExpression, ./*))"/>
        <xsl:choose>
            <xsl:when test="name($element) = 'cit' and $element/@type = 'translation'">
                <items action="replace" editable="onlyAllowedItems">
                    <item value="ru"/>
                    <item value="en"/>
                </items>
            </xsl:when>
            <xsl:when test="name($element) = 'entry' or name($element) = 'form' or name($element) = 'sense'">
                <items action="replace" editable="onlyAllowedItems">
                    <item value="os"/>
                    <item value="os-x-iron"/>
                    <item value="os-x-digor"/>
                    <item value="os-x-south"/>
                </items>                
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>