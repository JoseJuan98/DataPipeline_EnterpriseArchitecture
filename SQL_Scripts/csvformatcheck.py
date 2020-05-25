# -*- coding: utf-8 -*-

import re

f = open("ele_test.csv", "r", encoding="utf-8")
fileElement = f.read()
f.close()

f = open("pro_test.csv", "r", encoding="utf-8")
fileProperty = f.read()
f.close()

f = open("rel_test.csv", "r", encoding="utf-8")
fileRelation = f.read()
f.close()

def makeRegex(header):
    num = header.count(',')
    patternSimple = "([^\n\",]|(\"([^\"]|(\"\"))*\"))*,"
    patternEnd = "([^\n\",]|(\"([^\"]|(\"\"))*\"))*"
    patternLine = "(" + patternSimple + "){" + str(num) + "}(" + patternEnd + ")?"
    patternFull = header + "(\n(" + patternLine + "\n)*(" + patternLine + ")?)?"
    return patternFull


patternElement = makeRegex("ID,Type,Name,Documentation")
patternProperty = makeRegex("ID,Key,Value")
patternRelation = makeRegex("ID,Type,Name,Documentation,Source,Target")

if(re.fullmatch(patternElement, fileElement)):
    print("Elements are formatted correctly")
if(re.fullmatch(patternProperty, fileProperty)):
    print("Properties are formatted correctly")
if(re.fullmatch(patternRelation, fileRelation)):
    print("Relations are formatted correctly")
    
