module PlutoExport

import NodeJS
export pdf

# Stolen from https://discourse.julialang.org/t/collecting-all-output-from-shell-commands/15592
"Run a Cmd object, returning the stdout & stderr contents plus the exit code"
function execute(cmd::Cmd)
  out = Pipe()
  err = Pipe()

  process = run(pipeline(ignorestatus(cmd), stdout=out, stderr=err))
  close(out.in)
  close(err.in)

  (
    stdout = String(read(out)), 
    stderr = String(read(err)),  
    code = process.exitcode
  )
end

function pdf(notebook_path::AbstractString, output_path::Union{AbstractString, Nothing}=nothing; console_output=true)
    bin_script = normpath(joinpath(@__DIR__, "../node/bin.js"))

    if isnothing(output_path)
        output_path_split = splitpath(notebook_path)
        output_path_split[end] = join([split(output_path_split[end], ".")[1:end-1]..., "pdf"], ".")
        output_path = joinpath(output_path_split...)
        @info "No output path provided. Defaulting to $output_path"
    end

    notebook_path_abs = abspath(joinpath(pwd(), notebook_path))
    output_path_abs = abspath(joinpath(pwd(), output_path))

    cmd = `node $bin_script $notebook_path_abs $output_path_abs`
    if console_output
        run(cmd)
    else
        stdout, stderr, code = execute(cmd)
        if code != 0
            error(stderr)
        end
    end

    nothing
end

end