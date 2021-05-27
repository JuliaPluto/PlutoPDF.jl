# PlutoPDF.jl

Export Pluto notebooks to PDF automatically!

## Installation

From the Julia REPL, PlutoPDF.jl can be installed with the following:

```julia
import Pkg; Pkg.add(url="https://github.com/JuliaPluto/PlutoPDF.jl")
```

## Usage

From within Julia:

```
import PlutoPDF
PlutoPDF.pluto_to_pdf("notebook.jl")
```
