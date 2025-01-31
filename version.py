import json
import sys
import xml.etree.ElementTree as ET

def process_json_file(filename: str):
    try:
        with open(filename, 'r') as json_file:
            json_data = json.load(json_file)

        version = json_data.get('version')
        if version is None:
            raise ValueError(f"The JSON file '{filename}' does not have a 'version' attribute")

        print(version)
    except Exception as e:
        sys.exit(f"Error processing JSON file: {e}")

def process_xml_file(filename: str):
    try:
        tree = ET.parse(filename)
        root = tree.getroot()
        sp = root.tag.split('}')
        version_element = None

        if len(sp) > 1:
            version_element = root.find(sp[0] + '}' + 'version')
        else:
            version_element = root.find('version')

        if version_element is None:
            raise ValueError(f"Version element not found in XML file {filename}")

        print(version_element.text)
    except Exception as e:
        sys.exit(f"Error processing XML file: {e}")

#_________________________START______________________#
if len(sys.argv) < 2: sys.exit("Missing file argument\nExample: version <file.json or file.xml>")
filename = sys.argv[1]
if filename.endswith('.json'): process_json_file(filename) # only show
elif filename.endswith('.xml'): process_xml_file(filename)# only show
else: sys.exit("Unsupported file type!\nSupported types: .json, .xml")
