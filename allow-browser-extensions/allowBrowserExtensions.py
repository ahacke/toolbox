#!/usr/bin/python

import xml.etree.ElementTree as ET
from xml.etree import ElementTree
import os
import shutil
import subprocess
from datetime import date
import argparse

parser = argparse.ArgumentParser("file")
parser.add_argument("userid", help="MacOS userid, e.g. typically the name of your home folder.", type=str)
args = parser.parse_args()

def printPrettyXMLTree():
    root = ElementTree.parse(PATH_TO_TARGET).getroot()
    indent(root)
    ElementTree.dump(root)

def indent(elem, level=0):
    i = "\n" + level*"  "
    j = "\n" + (level-1)*"  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for subelem in elem:
            indent(subelem, level+1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = j
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = j
    return elem        


# >> CONFIGURATION
USER_ID = args.userid
# << CONFIGURATION

# SETTING VARIABLES
FILENAME = "com.microsoft.Edge.plist"
TEMP_DIR = "temp"
PATH_TO_TARGET = "./" + TEMP_DIR + "/" + FILENAME
PATH_TO_SOURCE = "/Library/Managed Preferences/"+USER_ID+"/"+FILENAME

# Create temp directory
print("Creating " + TEMP_DIR + " directory")
if not os.path.exists(TEMP_DIR):
    os.mkdir(TEMP_DIR)

# Copy plist file to temp directory
print("Copying plist file: " + FILENAME + " to " + PATH_TO_TARGET)
shutil.copyfile(PATH_TO_SOURCE, PATH_TO_TARGET)

# Create backup
print("Creating backup")
if not os.path.exists("backup"):
   os.mkdir("backup")
dateString = date.today().strftime("%Y%m%d")

shutil.copyfile(PATH_TO_SOURCE, "./backup/"+dateString+"-"+FILENAME)

# CONVERT TO XML
print("Converting file plist file to XML")
bashCommand = "plutil -convert xml1 " + PATH_TO_TARGET
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()

# Edit XML
print("Edit XML and removing ExtensionInstallBlocklist child values")

mytree = ET.parse(PATH_TO_TARGET)
myroot = mytree.getroot()


items = list(mytree.iter())
for i, item in enumerate(items):
    if item.text == "ExtensionInstallBlocklist":
         next_item = items[i + 1]
         for child in next_item:
            child.text = ""

mytree.write(PATH_TO_TARGET)

#printPrettyXMLTree()

# CONVERT TO XML
print("Converting file plist file to BINARY")
bashCommand = "plutil -convert binary1 " + PATH_TO_TARGET
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()

# Copy plist file to source directory
print("Copying plist file: " + FILENAME + " to " + PATH_TO_SOURCE)
shutil.copyfile(PATH_TO_TARGET, PATH_TO_SOURCE)

print("Remove temp directoy")
if os.path.exists(TEMP_DIR):
   shutil.rmtree(TEMP_DIR)