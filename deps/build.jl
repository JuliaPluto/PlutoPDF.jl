import NodeJS_18_jll: npm

@assert isfile(npm)


if Sys.iswindows()
    @warn "Windows might not be supported because of https://github.com/JuliaPackaging/Yggdrasil/issues/8095"
end

node_root = normpath(joinpath(@__DIR__, "../node"))
run(`$npm --version`)
println(run(`$npm --prefix=$node_root --scripts-prepend-node-path=true install $node_root`))
