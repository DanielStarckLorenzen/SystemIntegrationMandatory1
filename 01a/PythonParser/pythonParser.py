import json
import csv
import xml.etree.ElementTree as ET
import yaml
import os

script_dir = os.path.dirname(os.path.abspath(__file__))

def parse_json(file_path):
    with open(os.path.join(script_dir, file_path), "r") as f:
        data = json.load(f)
    return data

def parse_csv(file_path):
    with open(os.path.join(script_dir, file_path), "r") as f:
        reader = csv.DictReader(f)
        data = [row for row in reader]
    return data

def parse_xml(file_path):
    tree = ET.parse(os.path.join(script_dir, file_path))
    root = tree.getroot()
    return {child.tag: child.text for child in root}

def parse_yaml(file_path):
    with open(os.path.join(script_dir, file_path), "r") as f:
        data = yaml.safe_load(f)
    return data

def parse_txt(file_path):
    with open(os.path.join(script_dir, file_path), "r") as f:
        data = f.read()
    return data

if __name__ == "__main__":
    print("JSON:", parse_json("../../assets/data.json"))
    print("CSV:", parse_csv("../../assets/data.csv"))
    print("XML:", parse_xml("../../assets/data.xml"))
    print("YAML:", parse_yaml("../../assets/data.yaml"))
    print("TXT:", parse_txt("../../assets/data.txt"))
