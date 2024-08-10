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

const npm_cmd = let
    # Add NodeJS PATH to the existing PATH environment variable 
    path_sep = Sys.iswindows() ? ';' : ':'
    path_list = prepend!(split(get(ENV, "PATH", ""), path_sep), NodeJS_20_jll.PATH_list)
    path = join(path_list, path_sep)
    addenv(`$(npm)`, "PATH" => path)
end

function get_build_dir()
    build_node(@get_scratch!("build_dir3"))
end


function build_node(dir)
    @info "PlutoPDF: Running npm install in scratch space..."
    
    if dir !== dirname(node_root_files[1])
        for f in node_root_files
            readwrite(f, joinpath(dir, basename(f)))
        end
    end
    
    cd(dir) do
        run(`$npm_cmd --version`)
        run(`$npm_cmd install`)
    end
    
    dir
end

"Like `cp` except we create the file manually (to fix permission issues). (It's not plagiarism if you use this function to copy homework.)"
function readwrite(from::AbstractString, to::AbstractString)
    write(to, read(from))
end

