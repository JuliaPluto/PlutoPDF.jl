import NodeJS_18_jll
const npm = Sys.iswindows() ? "$(NodeJS_18_jll.npm).cmd" : NodeJS_18_jll.npm

node_root = normpath(joinpath(@__DIR__, "../node"))
run(`$npm --version`)
run(`$npm --prefix=$node_root --scripts-prepend-node-path=true install $node_root`)
