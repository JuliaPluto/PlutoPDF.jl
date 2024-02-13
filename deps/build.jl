import NodeJS_18_jll
const npm = Sys.iswindows() ? "$(NodeJS_18_jll.npm).cmd" : NodeJS_18_jll.npm

node_root = joinpath(dirname(@__DIR__), "node")
cd(node_root) do
    run(`$npm --version`)
    run(`$npm install`)
end
