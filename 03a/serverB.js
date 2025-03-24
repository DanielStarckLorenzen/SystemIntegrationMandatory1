const express = require("express");
const fs = require("fs");
const csv = require("csv-parser");
const path = require("path");
const xml2js = require("xml2js");
const yaml = require("js-yaml");
const axios = require("axios");

const app = express();
const PORT = 9000; // Different from FastAPI (which is 8000)

// File paths
const BASE_DIR = path.join(__dirname, "..");
const DATA_FILES = {
    json: path.join(BASE_DIR, "assets", "data.json"),
    csv: path.join(BASE_DIR, "assets", "data.csv"),
    xml: path.join(BASE_DIR, "assets", "data.xml"),
    yaml: path.join(BASE_DIR, "assets", "data.yaml"),
    txt: path.join(BASE_DIR, "assets", "data.txt"),
};

// Parsing functions
const parseJSON = () => JSON.parse(fs.readFileSync(DATA_FILES.json, "utf8"));

const parseCSV = () => {
    return new Promise((resolve) => {
        let results = [];
        fs.createReadStream(DATA_FILES.csv)
            .pipe(csv())
            .on("data", (data) => results.push(data))
            .on("end", () => resolve(results));
    });
};

const parseXML = () => {
    return new Promise((resolve, reject) => {
        fs.readFile(DATA_FILES.xml, "utf8", (err, data) => {
            if (err) reject(err);
            xml2js.parseString(data, (err, result) => {
                if (err) reject(err);
                resolve(result);
            });
        });
    });
};

const parseYAML = () => yaml.load(fs.readFileSync(DATA_FILES.yaml, "utf8"));
const parseTXT = () => fs.readFileSync(DATA_FILES.txt, "utf8");

// API Endpoints
app.get("/json", (req, res) => res.json(parseJSON()));
app.get("/txt", (req, res) => res.json({ content: parseTXT() }));
app.get("/yaml", (req, res) => res.json(parseYAML()));

app.get("/csv", async (req, res) => res.json(await parseCSV()));
app.get("/xml", async (req, res) => res.json(await parseXML()));

// Communicating with Server A (FastAPI)
const SERVER_A_URL = "http://127.0.0.1:8000";

app.get("/proxy/json", async (req, res) => {
    const response = await axios.get(`${SERVER_A_URL}/json`);
    res.json(response.data);
});

app.get("/proxy/csv", async (req, res) => {
    const response = await axios.get(`${SERVER_A_URL}/csv`);
    res.json(response.data);
});

app.get("/proxy/xml", async (req, res) => {
    const response = await axios.get(`${SERVER_A_URL}/xml`);
    res.json(response.data);
});

app.get("/proxy/yaml", async (req, res) => {
    const response = await axios.get(`${SERVER_A_URL}/yaml`);
    res.json(response.data);
});

app.get("/proxy/txt", async (req, res) => {
    const response = await axios.get(`${SERVER_A_URL}/txt`);
    res.json(response.data);
});

// Start Server B
app.listen(PORT, () => console.log(`Server B running on http://127.0.0.1:${PORT}`));
