<?xml version="1.0" standalone="no"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output 
      doctype-public="-//WAPFORUM//DTD WML 1.1//EN" doctype-system="http://www.wapforum.org/DTD/wml_1.1.xml" 
      indent='yes'/> 

<xsl:template match='/'>
  <html><head><title>Final population, EA experiment</title></head>
    <body><h1>Final population, EA experiment</h1>
    <xsl:apply-templates select='experiment/ea[last()]' />
</body></html>
</xsl:template>

<xsl:template match='ea'>
<ul>
  <xsl:for-each select='pop/indi'>
  <li><em><xsl:apply-templates /></em>: <xsl:value-of select='@fitness' /> </li>
</xsl:for-each>
</ul>
</xsl:template>
</xsl:stylesheet>