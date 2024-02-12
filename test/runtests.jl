using Test

using PlutoPDF

testfile = download(
    "https://raw.githubusercontent.com/fonsp/Pluto.jl/main/sample/Tower%20of%20Hanoi.jl",
)

testfile2 = download("https://raw.githubusercontent.com/JuliaPluto/PlutoSliderServer.jl/08dafcca4073551cb4192d442dc3e8c33123b952/test/dir1/a.jl")


is_CI = get(ENV, "CI", "no") == "no"

outfile = tempname(; cleanup=false) * ".pdf"
outdir = tempname(; cleanup=false)

@info "Files" outfile outdir testfile testfile2

result = pluto_to_pdf(testfile, outfile, outdir; open=is_CI, options=(format="A5",))

@test result == outfile

@test isfile(outfile)
@test dirname(outfile) == dirname(testfile)
@test endswith(outfile, ".pdf")

@test isdir(outdir)
filez = readdir(outdir)
@test length(filez) == 28
@test all(endswith.(filez, ".png"))
@test length(joinpath(outdir, read(filez[1]))) > 1000



outfile2 = pluto_to_pdf(testfile2; open=is_CI, options=(format="A5",))
@info "Result" outfile2
@test isfile(outfile2)
@test dirname(outfile2) == dirname(testfile2)
@test endswith(outfile2, ".pdf")

output_dir = get(ENV, "TEST_OUTPUT_DIR", nothing)

if @show(output_dir) isa String
    mkpath(output_dir)
    @assert isdir(output_dir)
    cp(outfile, joinpath(output_dir, "hanoi.pdf"))
end
