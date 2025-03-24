from fastapi import FastAPI
import json
import csv
import xml.etree.ElementTree as ET
import yaml
import os
import requests

app = FastAPI()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_FILES = {
    "json": os.path.join(BASE_DIR, "../assets/data.json"),
    "csv": os.path.join(BASE_DIR, "../assets/data.csv"),
    "xml": os.path.join(BASE_DIR, "../assets/data.xml"),
    "yaml": os.path.join(BASE_DIR, "../assets/data.yaml"),
    "txt": os.path.join(BASE_DIR, "../assets/data.txt"),
}

def parse_json():
    with open(DATA_FILES["json"], "r") as f:
        return json.load(f)

def parse_csv():
    with open(DATA_FILES["csv"], "r") as f:
        reader = csv.DictReader(f)
        return [row for row in reader]

def parse_xml():
    tree = ET.parse(DATA_FILES["xml"])
    root = tree.getroot()
    return {child.tag: child.text for child in root}

def parse_yaml():
    with open(DATA_FILES["yaml"], "r") as f:
        return yaml.safe_load(f)

def parse_txt():
    with open(DATA_FILES["txt"], "r") as f:
        return {"content": f.read()}

@app.get("/json")
def get_json():
    return parse_json()

@app.get("/csv")
def get_csv():
    return parse_csv()

@app.get("/xml")
def get_xml():
    return parse_xml()

@app.get("/yaml")
def get_yaml():
    return parse_yaml()

@app.get("/txt")
def get_txt():
    return parse_txt()

SERVER_B_URL = "http://127.0.0.1:9000"

@app.get("/proxy/json")
def proxy_json():
    response = requests.get(f"{SERVER_B_URL}/json")
    return response.json()

@app.get("/proxy/csv")
def proxy_csv():
    response = requests.get(f"{SERVER_B_URL}/csv")
    return response.json()

@app.get("/proxy/xml")
def proxy_xml():
    response = requests.get(f"{SERVER_B_URL}/xml")
    return response.json()

@app.get("/proxy/yaml")
def proxy_yaml():
    response = requests.get(f"{SERVER_B_URL}/yaml")
    return response.json()

@app.get("/proxy/txt")
def proxy_txt():
    response = requests.get(f"{SERVER_B_URL}/txt")
    return response.json()