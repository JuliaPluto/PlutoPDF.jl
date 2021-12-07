using Test

using PlutoPDF

@show pwd()

testfile = download(
    "https://raw.githubusercontent.com/fonsp/Pluto.jl/main/sample/Tower%20of%20Hanoi.jl",
)


is_CI = get(ENV, "CI", "no") == "no"

outfile = pluto_to_pdf(testfile; open=is_CI)


@test isfile(outfile)
@test endswith(outfile, ".pdf")

output_dir = get(ENV, "TEST_OUTPUT_DIR", nothing)
@info "huh" readdir(pwd()) isdir(output_dir)

if output_dir isa String
    cp(outfile, joinpath(output_dir, "hanoi.pdf"))
end
