const fs = require('fs');
const csv = require('csv-parser');
const xml2js = require('xml2js');
const yaml = require('js-yaml');

function parseJSON(filePath) {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function parseCSV(filePath) {
    return new Promise((resolve) => {
        let results = [];
        fs.createReadStream(filePath)
            .pipe(csv())
            .on('data', (data) => results.push(data))
            .on('end', () => resolve(results));
    });
}

function parseXML(filePath) {
    return new Promise((resolve, reject) => {
        fs.readFile(filePath, 'utf8', (err, data) => {
            if (err) reject(err);
            xml2js.parseString(data, (err, result) => {
                if (err) reject(err);
                resolve(result);
            });
        });
    });
}

function parseYAML(filePath) {
    return yaml.load(fs.readFileSync(filePath, 'utf8'));
}

function parseTXT(filePath) {
    return fs.readFileSync(filePath, 'utf8');
}

async function main() {
    console.log("JSON:", parseJSON("../../assets/data.json"));
    console.log("TXT:", parseTXT("../../assets/data.txt"));
    console.log("YAML:", parseYAML("../../assets/data.yaml"));
    console.log("CSV:", await parseCSV("../../assets/data.csv"));
    console.log("XML:", await parseXML("../../assets/data.xml"));
}

main();
