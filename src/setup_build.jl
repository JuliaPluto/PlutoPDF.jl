import NodeJS_20_jll
using Scratch
using RelocatableFolders

const node_root_files = (
    @path(joinpath(dirname(@__DIR__), "node", "bin.js")),
    @path(joinpath(dirname(@__DIR__), "node", "export.js")),
    @path(joinpath(dirname(@__DIR__), "node", "package-lock.json")),
    @path(joinpath(dirname(@__DIR__), "node", "package.json")),
)


function npm_cmd()
    npm = !Sys.iswindows() ? NodeJS_20_jll.npm : let
        new = "$(NodeJS_20_jll.npm).cmd"
        isfile(new) ? new : NodeJS_20_jll.npm
    end
    
    # Add NodeJS PATH to the existing PATH environment variable 
    path_sep = Sys.iswindows() ? ';' : ':'
    path_list = prepend!(split(get(ENV, "PATH", ""), path_sep), NodeJS_20_jll.PATH_list)
    path = join(path_list, path_sep)
    addenv(`$(npm)`, "PATH" => path)
end

function get_build_dir()
    build_node(@get_scratch!("build_dir4"))
end

const node_build_lock = ReentrantLock()

function build_node(dir)
    lock(node_build_lock) do
        @info "PlutoPDF: Running npm install in scratch space..."
        
        if dir !== dirname(node_root_files[1])
            for f in node_root_files
                readwrite(f, joinpath(dir, basename(f)))
            end
        end
        
        npm_cache_dir = @get_scratch!("npm_cache")
        
        cmd = addenv(npm_cmd(), "NPM_CONFIG_CACHE" => npm_cache_dir)
        
        @info "huh" cmd
        
        cd(dir) do
            run(`$(cmd) --version`)
            run(`$(cmd) install --audit-level=none --no-fund --no-audit`)
        end
        
        dir
    end
end

"Like `cp` except we create the file manually (to fix permission issues). (It's not plagiarism if you use this function to copy homework.)"
function readwrite(from::AbstractString, to::AbstractString)
    write(to, read(from))
end

