# How to export Pluto notebooks to PDF?

You probably don't need the PlutoPDF.jl package! Just **open the notebook in Pluto** and **print out the page** (`⌘ P` or `Ctrl+P`). As printer, choose "Print to PDF". Be sure to enable "background graphics" and disable "headers and footers". Pluto is designed to output high-quality PDF files using the browser print function.

In fact, PlutoPDF.jl works exactly the same: it uses [puppeteer](https://pptr.dev/) and the Chromium browser ("headless") to print the document for you. You can use PlutoPDF.jl when you need to generate PDF files automatically from a script, e.g. when you have many notebooks that you want to archive.

# Unmaintained

Unfortunately, PlutoPDF.jl takes too much work to maintain! So if it works on your computer, yay! Otherwise, sorry! PRs very welcome!

# PlutoPDF.jl

*Don't let your printer miss out on the fun!*

## Installation

From the Julia REPL, PlutoPDF.jl can be installed with the following:

```julia
import Pkg; Pkg.add("PlutoPDF")
```

## Usage

From within Julia:

```julia
import PlutoPDF
PlutoPDF.pluto_to_pdf("notebook.jl")
```

### Screenshots

You can also use PlutoPDF to take screenshots of all notebook cells!


```julia
import PlutoPDF
pdf_path = "notebook.pdf"
screenshots_dir = "notebook_screenshots"

PlutoPDF.pluto_to_pdf("notebook.jl", pdf_path, screenshots_dir)
```

# How it works

PlutoPDF.jl is just a combination of other software:
- Pluto: besides running notebooks, the Pluto editor is designed to look nice when printed. When you use Pluto's export to Static PDF button (top right in the editor), the button just tells the browser to open the Print window. 
- Chromium web browser: Pluto has CSS styling specific for printing. But it is the browser that has the ability to take HTML and CSS and make a PDF from it.
- PlutoSliderServer: this package makes it easy to "convert `.jl` to `.html`." It can open a notebook, run it, and generate the export HTML all from the command line, so you don't need to click buttons in Pluto.
- hmmmm more info coming


# Development

When developing, it's nice to have the `node_modules` folder locally. Navigate to the `node` directory and run `npm install`. 

If you don't have `npm`, then run `julia --project` and then

```julia
import PlutoPDF
PlutoPDF.build_node(joinpath(pwd(), "node"))
```
