import NodeJS_18_jll
using Scratch
using RelocatableFolders

const node_root_files = (
    @path(joinpath(dirname(@__DIR__), "node", "bin.js")),
    @path(joinpath(dirname(@__DIR__), "node", "export.js")),
    @path(joinpath(dirname(@__DIR__), "node", "package-lock.json")),
    @path(joinpath(dirname(@__DIR__), "node", "package.json")),
)

const npm = !Sys.iswindows() ? NodeJS_18_jll.npm : let
    new = "$(NodeJS_18_jll.npm).cmd"
    isfile(new) ? new : NodeJS_18_jll.npm
end

function get_build_dir()
    build_node(@get_scratch!("build_dir"))
end


function build_node(dir)
    @info "PlutoPDF: Running npm install in scratch space..."
    
    if dir !== dirname(node_root_files[1])
        for f in node_root_files
            cp(f, joinpath(dir, basename(f)); force=true)
        end
    end
    
    cd(dir) do
        run(`$npm --version`)
        run(`$npm install`)
    end
    
    dir
end

