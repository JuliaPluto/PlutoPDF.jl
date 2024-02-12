using Test

using PlutoPDF

testfile = download(
    "https://raw.githubusercontent.com/fonsp/Pluto.jl/main/sample/Tower%20of%20Hanoi.jl",
)


is_CI = get(ENV, "CI", "no") == "no"

outfile = pluto_to_pdf(testfile; open=is_CI, options=(format="A5",))


@test isfile(outfile)
@test dirname(outfile) == dirname(testfile)
@test endswith(outfile, ".pdf")

output_dir = get(ENV, "TEST_OUTPUT_DIR", nothing)

if @show(output_dir) isa String
    mkpath(output_dir)
    @assert isdir(output_dir)
    cp(outfile, joinpath(output_dir, "hanoi.pdf"))
end
