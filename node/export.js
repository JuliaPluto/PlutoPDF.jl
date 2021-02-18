const p = require('puppeteer');
const chalk = require('chalk');

function sleep(time) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve();
        }, time);
    });
}

async function pdf(url, output, beforeClose=async ()=>{}) {
    const browser = await p.launch();
    console.log('Initiated headless browser');
    const page = await browser.newPage();
    await page.goto(url, {
        waitUntil: 'networkidle2'
    });
    console.log('Loaded notebook file')

    while(true) {
        const queued = await page.evaluate(`Array.from(document.getElementsByClassName('queued')).map(x => x.id)`);
        const running = await page.evaluate(`Array.from(document.getElementsByClassName('running')).map(x => x.id)`);
        const cells = await page.evaluate(`Array.from(document.getElementsByTagName('pluto-cell')).map(x => x.id)`)
        const bodyClasses = await page.evaluate(`document.body.getAttribute('class')`);

        if(running.length > 0) {
            process.stdout.write(`\rRunning cell ${chalk.yellow(`${cells.length-queued.length}/${cells.length}`)} ${chalk.cyan(`[${running[0]}]`)}`);
        }
        
        if(!(bodyClasses.includes('loading') || queued.length > 0 || running.length > 0)) {
            process.stdout.write(`\rRunning cell ${chalk.yellow(`${cells.length}/${cells.length}`)}`);
            console.log();
            break;
        }
        
        await sleep(250);
    }

    console.log('Exporting as pdf...');
    await page.pdf({
        path: output,
        format: 'A4',
        margin: {
            top: "50px",
            right: "0px",
            bottom: "50px",
            left: "0px"
        },
        headerTemplate: '<p></p>',
        footerTemplate: '<p></p>',
        displayHeaderFooter: true
    });

    console.log(chalk.green('Exported ✓') + ' ... cleaning up');

    await beforeClose();

    await browser.close();
}

module.exports = {pdf};
