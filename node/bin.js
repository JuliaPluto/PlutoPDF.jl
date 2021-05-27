const exp = require('./export');
const path = require('path');
const fileUrl = require("file-url");

const fileInput = process.argv[2];
const fileOutput = process.argv[3];
const options = JSON.parse(process.argv[4]);

if(!fileInput) {
    console.error('ERROR: First program argument must be a Pluto notebook path');
    process.exit(1);
}
if(!fileOutput) {
    console.error('ERROR: Second program argument must be the PDF output path');
    process.exit(1);
}

(async () => {
    const file = path.resolve(fileInput);
    const outputFile = path.resolve(fileOutput);

    const exportUrl = fileUrl(file)

    await exp.pdf(exportUrl, outputFile, options);

    process.exit();
})();
