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
