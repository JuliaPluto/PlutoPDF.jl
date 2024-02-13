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

# Development

Navigate to this directory, then `pkg> activate .` and `pkg> build`.
