# PlutoExport.jl
Export Pluto notebooks to document formats without the need for an end-user on the application frontend.

## Installation
From the Julia REPL, PlutoExport.jl can be installed with the following:
```
import Pkg; Pkg.add("https://github.com/JuliaPluto/PlutoExport.jl.git")
```
Also ensure you have Pluto installed globally by running `Pkg.add("Pluto")`.

## Usage
From within Julia:
```
import PlutoExport
PlutoExport.pdf("notebook.jl")
```
