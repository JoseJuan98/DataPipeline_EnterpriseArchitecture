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

patternElement = "ID,Type,Name,Documentation\n((.*,){3}(.*\n))*((.*,){3}(.*))?"
patternProperty = "ID,Key,Value\n((.*,){2}(.*\n))*((.*,){2}(.*))?"
patternRelation = "ID,Type,Name,Documentation,Source,Target\n((.*,){5}(.*\n))*((.*,){5}(.*))?"

if(re.fullmatch(patternElement, fileElement)):
    print("Ok1")
if(re.fullmatch(patternProperty, fileProperty)):
    print("Ok2")
if(re.fullmatch(patternRelation, fileRelation)):
    print("Ok3")
