import p from "puppeteer"
import chalk from "chalk"
import path from "path"

function sleep(time) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve(null)
        }, time)
    })
}

export async function pdf(url, pdf_path, options, screenshot_dir, screenshot_options, { beforeClose = async () => {} } = {}) {
    const browser = await p.launch()
    console.log("Initiated headless browser")
    const page = await browser.newPage()
    // await page.emulateMediaType('screen');
    await page.goto(url, {
        waitUntil: "networkidle2",
    })
    console.log("Loaded notebook file")

    await page.setViewport({
        width: 1000,
        height: 1000,
    })

    while (true) {
        const queued = await page.evaluate(`Array.from(document.getElementsByClassName('queued')).map(x => x.id)`)
        const running = await page.evaluate(`Array.from(document.getElementsByClassName('running')).map(x => x.id)`)
        const cells = await page.evaluate(`Array.from(document.getElementsByTagName('pluto-cell')).map(x => x.id)`)
        const bodyClasses = await page.evaluate(`document.body.getAttribute('class')`)

        if (running.length > 0) {
            process.stdout.write(`\rRunning cell ${chalk.yellow(`${cells.length - queued.length}/${cells.length}`)} ${chalk.cyan(`[${running[0]}]`)}`)
        }

        if (!(bodyClasses.includes("loading") || queued.length > 0 || running.length > 0)) {
            process.stdout.write(`\rRunning cell ${chalk.yellow(`${cells.length}/${cells.length}`)}`)
            console.log()
            break
        }

        await sleep(250)
    }

    console.log("Exporting as pdf...")
    await page.pdf({
        path: pdf_path,
        ...options,
    })
    if (screenshot_dir != null) {
        await screenshot_cells(page, screenshot_dir, screenshot_options)
    }

    console.log(chalk.green("Exported ✓") + " ... cleaning up")

    await beforeClose()
    await browser.close()
}

/**
 * @param {p.Page} page
 * @param {string} screenshot_dir
 */
async function screenshot_cells(page, screenshot_dir, { outputOnly, dpi }) {
    const cells = /** @type {String[]} */ (await page.evaluate(`Array.from(document.querySelectorAll('pluto-cell')).map(x => x.id)`))

    for (let cell_id of cells) {
        const cell = await page.$(`#${cell_id}`)
        if (cell) {
            await cell.scrollIntoView()
            const rect = await cell.boundingBox()
            const imgpath = path.join(screenshot_dir, `${cell_id}.png`)

            await cell.screenshot({ path: imgpath, clip: rect, omitBackground: false })
            console.log(`Screenshot ${cell_id} saved to ${imgpath}`)
        }
    }
}
