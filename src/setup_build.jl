import NodeJS_20_jll
using Scratch
using RelocatableFolders

const node_root_files = (
    @path(joinpath(dirname(@__DIR__), "node", "bin.js")),
    @path(joinpath(dirname(@__DIR__), "node", "export.js")),
    @path(joinpath(dirname(@__DIR__), "node", "package-lock.json")),
    @path(joinpath(dirname(@__DIR__), "node", "package.json")),
)

const npm = !Sys.iswindows() ? NodeJS_20_jll.npm : let
    new = "$(NodeJS_20_jll.npm).cmd"
    isfile(new) ? new : NodeJS_20_jll.npm
end

function get_build_dir()
    build_node(@get_scratch!("build_dir4"))
end

ci() = get(ENV, "CI", "neetjes") != "neetjes"

function build_node(dir)
    @info "PlutoPDF: Running npm install in scratch space..."
    
    if dir !== dirname(node_root_files[1])
        for f in node_root_files
            readwrite(f, joinpath(dir, basename(f)))
        end
    end
    
    cd(dir) do
        run(`$npm --version`)
        run(ci() ? `$npm install --verbose` : `$npm install`)
    end
    
    @info "PlutoPDF: Finished npm install."
    
    dir
end

"Like `cp` except we create the file manually (to fix permission issues). (It's not plagiarism if you use this function to copy homework.)"
function readwrite(from::AbstractString, to::AbstractString)
    write(to, read(from))
end

