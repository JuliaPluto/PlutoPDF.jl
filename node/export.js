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
        deviceScaleFactor: screenshot_options.scale,
    })

    await waitForPlutoBusy(page, false, { timeout: 30 * 1000 })

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
async function screenshot_cells(page, screenshot_dir, { outputOnly, scale }) {
    const cells = /** @type {String[]} */ (await page.evaluate(`Array.from(document.querySelectorAll('pluto-cell')).map(x => x.id)`))

    for (let cell_id of cells) {
        const cell = await page.$(`[id="${cell_id}"]${outputOnly ? " > pluto-output" : ""}`)
        if (cell) {
            await cell.scrollIntoView()
            const rect = await cell.boundingBox()
            if (rect == null) {
                throw new Error(`Cell ${cell_id} is not visible`)
            }
            const imgpath = path.join(screenshot_dir, `${cell_id}.png`)

            await cell.screenshot({ path: imgpath, clip: { ...rect, scale }, omitBackground: false })
            console.log(`Screenshot ${cell_id} saved to ${imgpath}`)
        }
    }
}

const timeout = (delay) =>
    new Promise((r) => {
        setTimeout(r, delay)
    })

const waitForPlutoBusy = async (page, iWantBusiness, options) => {
    await timeout(1000)
    await page.waitForFunction(
        (iWantBusiness) => {
            let quiet = //@ts-ignore
                (document?.body?._update_is_ongoing ?? false) === false &&
                //@ts-ignore
                (document?.body?._js_init_set?.size ?? 0) === 0 &&
                document?.body?.classList?.contains("loading") === false &&
                document?.querySelector(`pluto-cell.running, pluto-cell.queued, pluto-cell.internal_test_queued`) == null

            return iWantBusiness ? !quiet : quiet
        },
        options,
        iWantBusiness
    )
    await timeout(1000)
}
