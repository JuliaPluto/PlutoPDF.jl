const pluto = require('./pluto');
const exp = require('./export');
const path = require('path');
const chalk = require('chalk');

const fileInput = process.argv[2];
const fileOutput = process.argv[3];

if(!fileInput) {
    console.error('ERROR: First program argument must be a Pluto notebook path');
    process.exit(1);
}
if(!fileOutput) {
    console.error('ERROR: Second program argument must be the PDF output path');
    process.exit(1);
}

(async () => {
    const plutoServer = await pluto.startPluto();
    console.log('Started Pluto server');

    const url = plutoServer.url;
    const file = path.resolve(fileInput);
    const outputFile = path.resolve(fileOutput);
    const exportUrl = `${url.protocol}//${url.host}/open?path=${encodeURIComponent(file)}&secret=${url.searchParams.get('secret')}`

    await exp.pdf(exportUrl, outputFile, async () => {
        pluto.stopPluto(plutoServer);
    });

    process.exit();
})();
