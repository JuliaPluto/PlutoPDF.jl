using Test

using PlutoPDF

testfile = download(
    "https://raw.githubusercontent.com/fonsp/Pluto.jl/main/sample/Tower%20of%20Hanoi.jl",
)

testfile2 = download("https://raw.githubusercontent.com/JuliaPluto/PlutoSliderServer.jl/08dafcca4073551cb4192d442dc3e8c33123b952/test/dir1/a.jl")


is_CI = get(ENV, "CI", "no") == "no"

outfile_local = tempname(; cleanup=false) * ".pdf"
outfile_url = tempname(; cleanup=false) * ".pdf"
outdir_local = tempname(; cleanup=false)
outdir_url = tempname(; cleanup=false)

@info "Files" outfile_local outdir_local outfile_url outdir_url testfile testfile2

result_local = pluto_to_pdf(testfile, outfile_local, outdir_local; open=is_CI, options=(format="A5",), screenshot_options=(scale=4,))
@test result_local == outfile_local
@test dirname(outfile_local) == dirname(testfile)

result_url = html_to_pdf("https://featured.plutojl.org/puzzles-games/tower%20of%20hanoi", outfile_url, outdir_url; open=is_CI, options=(format="A4",), screenshot_options=(scale=3,))
@test result_url == outfile_url

@testset "Main $(type)" for type in (:local, :url)
    outfile = getproperty(@__MODULE__, Symbol(:outfile_, type))
    outdir = getproperty(@__MODULE__, Symbol(:outdir_, type))
    
    @test isfile(outfile)
    @test endswith(outfile, ".pdf")

    @test isdir(outdir)
    filez = readdir(outdir)
    @test length(filez) == 28
    @test all(endswith.(filez, ".png"))
    @test length(read(joinpath(outdir, filez[1]))) > 1000
end

outfile_small = pluto_to_pdf(testfile2; open=is_CI, options=(format="A5",))
@info "Result" outfile_small
@test isfile(outfile_small)
@test dirname(outfile_small) == dirname(testfile2)
@test endswith(outfile_small, ".pdf")

test_output_dir = get(ENV, "TEST_OUTPUT_DIR", nothing)

if @show(test_output_dir) isa String
    mkpath(test_output_dir)
    @assert isdir(test_output_dir)
    
    
    
    cp(outfile_local, joinpath(test_output_dir, "hanoi.pdf"))
    cp(outfile_small, joinpath(test_output_dir, "small.pdf"))
    cp(outdir_local, joinpath(test_output_dir, "hanoi_screenshots"))
end
