import NodeJS
npm = NodeJS.npm_cmd()
node_root = normpath(joinpath(@__DIR__, "../node"))
println(run(`$npm --prefix=$node_root --scripts-prepend-node-path=true install $node_root`))
