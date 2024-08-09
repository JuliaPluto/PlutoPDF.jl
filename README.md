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


# Development

When developing, it's nice to have the `node_modules` folder locally. Navigate to the `node` directory and run `npm install`. 

If you don't have `npm`, then run `julia --project` and then

```julia
import PlutoPDF
PlutoPDF.build_node(joinpath(pwd(), "node"))
```
