using Test

using PlutoPDF


testfile = download("https://raw.githubusercontent.com/fonsp/Pluto.jl/main/sample/Tower%20of%20Hanoi.jl")


outfile = @test_nowarn pluto_to_pdf(testfile; open=false)

@test isfile(outfile)
@test endswith(outfile, ".pdf")

