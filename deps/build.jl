import NodeJS_18_jll

const npm = if Sys.iswindows()
    NodeJS_18_jll.npm.cmd
else
    NodeJS_18_jll.npm
end

node_root = normpath(joinpath(@__DIR__, "../node"))
run(`$npm --version`)
println(run(`$npm --prefix=$node_root --scripts-prepend-node-path=true install $node_root`))
