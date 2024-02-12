import { pdf } from "./export.js"

import path from "path"
import fileUrl from "file-url"

const html_path_arg = process.argv[2]
const pdf_path_arg = process.argv[3]
const options = JSON.parse(process.argv[4])
const screenshot_path_arg = process.argv[5]
const screenshot_options = JSON.parse(process.argv[6])

const input_url = html_path_arg.startsWith("http://") || html_path_arg.startsWith("https://") ? html_path_arg : fileUrl(path.resolve(html_path_arg))
const pdf_path = path.resolve(pdf_path_arg)
const screenshot_path = path.resolve(screenshot_path_arg)

await pdf(input_url, pdf_path, options, screenshot_path, screenshot_options)

process.exit()
