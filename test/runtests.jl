using Test

using PlutoPDF


testfile = download("https://raw.githubusercontent.com/fonsp/Pluto.jl/main/sample/Tower%20of%20Hanoi.jl")



outfile = pluto_to_pdf(testfile; open=get(ENV, "CI", "no") == "no")

@test isfile(outfile)
@test endswith(outfile, ".pdf")
