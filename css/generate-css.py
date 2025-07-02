import csv

names_ru = {}
names_en = {}

with open('langnames.csv') as csv_file:
    csv_reader = csv.DictReader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            line_count += 1
        names_ru[row["code"]] = row["ru"]
        names_en[row["code"]] = row["en_abbr"]
        
#Generate Russian CSS
lines = ['@charset "UTF-8";\n',
         '@namespace xml "http://www.w3.org/XML/1998/namespace";\n',
         '@namespace tei "http://www.tei-c.org/ns/1.0";\n',
         '@namespace abv "http://ossetic-studies.org/ns/abaevdict";\n']
for code in names_ru.keys():
    lines.append(':lang(' + code + ') > tei|lang:empty {content: "' + names_ru[code] + '";}\n')
    lines.append('tei|lang[xml|lang="' + code + '"]:empty {content: "' + names_ru[code] + '";}\n')
    lines.append('*[extralang~="' + code + '"] > tei|lang:empty {-oxy-append-content: ", ' + names_ru[code] + '";}\n')
with open('ru_langs.css', 'w') as f:
    f.writelines(lines)

# Generate English CSS
lines = ['@charset "UTF-8";\n',
         '@namespace xml "http://www.w3.org/XML/1998/namespace";\n',
         '@namespace tei "http://www.tei-c.org/ns/1.0";\n',
         '@namespace abv "http://ossetic-studies.org/ns/abaevdict";\n']
for code in names_en.keys():
    lines.append(':lang(' + code + ') > tei|lang:empty {content: "' + names_en[code] + '";}\n')
    lines.append('tei|lang[xml|lang="' + code + '"]:empty {content: "' + names_en[code] + '";}\n')
    lines.append('*[extralang~="' + code + '"] > tei|lang:empty {-oxy-append-content: ", ' + names_en[code] + '";}\n')
with open('en_langs.css', 'w') as f:
    f.writelines(lines)

# Generate code fragment to insert into .xpr
lines = ['                                <field name="allowedValues">\n',
         '                                    <profileConditionValue-array>\n']
for code in names_ru.keys():
    lines.append('                                        <profileConditionValue>\n')
    lines.append('                                            <field name="value">\n')
    lines.append('                                                <String>' + code + '</String>\n')
    lines.append('                                            </field>\n')
    lines.append('                                            <field name="description">\n')
    lines.append('                                                <String>' + names_en[code] + '</String>\n')
    lines.append('                                            </field>\n')
    lines.append('                                            <field name="level">\n')
    lines.append('                                                <Integer>0</Integer>\n')
    lines.append('                                            </field>\n')
    lines.append('                                            <field name="renderName">\n')
    lines.append('                                                <String>' + names_ru[code] + '</String>\n')
    lines.append('                                            </field>\n')
    lines.append('                                        </profileConditionValue>\n')
lines.append('                                    </profileConditionValue-array>\n')
lines.append('                                </field>\n')

with open('profiling-text.xml', 'w') as f:
    f.writelines(lines)

# Generate XSL template
lines = [   '<?xml version="1.0" encoding="UTF-8"?>\n',
            '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\n',
            '    xmlns:xs="http://www.w3.org/2001/XMLSchema"\n',
            '    exclude-result-prefixes="xs"\n',
            '    version="2.0">\n',
            '    <xsl:template name="lang-text">\n',
            '        <xsl:param name="lang-code"/>\n',
            '        <xsl:param name="name-lang"/>\n',
            '        <xsl:choose>\n']
for code in names_ru.keys():
    lines.append('            <xsl:when test="$lang-code = \'' + code + '\'">\n')
    lines.append('                <xsl:choose>\n')
    lines.append('                    <xsl:when test="$name-lang = \'ru\'"><xsl:text>' + names_ru[code] + '</xsl:text></xsl:when>\n')
    lines.append('                    <xsl:when test="$name-lang = \'en\'"><xsl:text>' + names_en[code] + '</xsl:text></xsl:when>\n')
    lines.append('                </xsl:choose>\n')
    lines.append('            </xsl:when>\n')
lines.append('        </xsl:choose>\n')
lines.append('    </xsl:template>\n')
lines.append('</xsl:stylesheet>\n')

with open('lang-names.xsl', 'w') as f:
    f.writelines(lines)
