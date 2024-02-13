# PlutoPDF.jl

Export Pluto notebooks to PDF automatically!

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

Navigate to this directory, then `pkg> activate .` and `pkg> build`.
