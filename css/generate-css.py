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
        names_en[row["code"]] = row["en"]
        
#Generate Russian CSS
lines = ['@charset "UTF-8";\n', '@namespace xml "http://www.w3.org/XML/1998/namespace";\n']
for code in names_ru.keys():
    lines.append(':lang(' + code + ') > lang:empty {content: "' + names_ru[code] + '";}\n')
    lines.append('*[extralang~="' + code + '"] > lang:empty {-oxy-append-content: ", ' + names_ru[code] + '";}\n')
with open('ru_langs.css', 'w') as f:
    f.writelines(lines)

# Generate English CSS
lines = ['@charset "UTF-8";\n', '@namespace xml "http://www.w3.org/XML/1998/namespace";\n']
for code in names_en.keys():
    lines.append(':lang(' + code + ') > lang:empty {content: "' + names_en[code] + '";}\n')
    lines.append('*[extralang~="' + code + '"] > lang:empty {-oxy-append-content: ", ' + names_en[code] + '";}\n')
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
