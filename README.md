# PlutoExport.jl
Export Pluto notebooks to document formats without the need for an end-user on the application frontend.

## Installation (Eventually)
From the Julia REPL, PlutoExport.jl can be installed with the following:
```
import Pkg; Pkg.add("https://github.com/JuliaPluto/PlutoExport.jl.git")
```

## Usage
From within Julia (eventually):
```
import PlutoExport
PlutoExport.pdf("notebook.jl")
```

Alternatively the `pluto-export` command takes two arguments, the first being the path to the notebook file and the second being the desired exported output path.
```
pluto-export notebook.jl notebook.pdf
```
