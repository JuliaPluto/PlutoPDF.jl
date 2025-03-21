module PlutoPDF

import Pluto
import NodeJS_20_jll: node
import JSON
import DefaultApplication

include("./setup_build.jl")

export html_to_pdf, pluto_to_pdf

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
        code = process.exitcode,
    )
end

const default_options = (
    format ="A4",
    margin=(
        top="30mm",
        right="15mm",
        bottom="30mm",
        left="10mm",
    ),
    printBackground=true,
    displayHeaderFooter=false,
)

const screenshot_default_options = (
    outputOnly=false,
    scale=2,
)

const generate_html_default_options = (
    binder_url_js="undefined",
)

"""
The same as `pluto_to_pdf`, but the first argument is a path to an HTML file or a URL (to a Pluto notebook hosted online).
"""
function html_to_pdf(
    html_path::AbstractString,
    output_path::Union{AbstractString,Nothing}=nothing,
    screenshot_dir_path::Union{AbstractString,Nothing}=nothing;
    options=default_options,
    screenshot_options=screenshot_default_options,
    open=true,
    console_output=true
)
    is_url = startswith(html_path, "http://") || startswith(html_path, "https://")
    is_url && @assert output_path !== nothing "You need to specify an output path when the input is a URL"

    output_path = tamepath(something(output_path, Pluto.numbered_until_new(splitext(html_path)[1]; suffix=".pdf", create_file=false)))

    screenshot_dir_path = if screenshot_dir_path === nothing
        nothing
    else
        mkpath(tamepath(screenshot_dir_path))
    end

    @info "Generating pdf..."
    bin_script = joinpath(get_build_dir(), "bin.js")
    cmd = `$(node()) $bin_script $(is_url ? html_path : tamepath(html_path)) $(output_path) $(JSON.json(
        (; default_options..., options...)
    )) $(something(screenshot_dir_path, "")) $(JSON.json((; screenshot_default_options..., screenshot_options...)))`
    if console_output
        run(cmd)
    else
        stdout, stderr, code = execute(cmd)
        if code != 0
            error(stderr)
        end
    end

    open && DefaultApplication.open(output_path)

    output_path
end

"""
```julia
pluto_to_pdf(notebook_path::String[, output_pdf_path::String, screenshot_dir_path::String];
    options=default_options,
    screenshot_options=screenshot_default_options,
    open::Bool=true,
    console_output::Bool=true,
)
```

Run a notebook, generate an Export HTML and then print it to a PDF file! If a `screenshot_dir_path` is provided, then PlutoPDF will also take a screenshot of each cell and save it to the directory.

# Options
The `options` keyword argument can be a named tuple to configure the PDF export. The possible options can be seen in the [docs for `puppeteer.PDFOptions`](https://pptr.dev/api/puppeteer.pdfoptions). You don't need to specify all options, for example: `options=(format="A5",)` will work.

The `screenshot_options` keyword argument can be a named tuple to configure the generation of cell screenshots. Available options:
- `outputOnly::Bool`: only screenshot the cell ouput, not the full cell including code and logs
- `scale::Float64`: the device pixel ratio. 1 means 96dpi. Default is 2.

"""
function pluto_to_pdf(
    notebook_path::AbstractString,
    output_path::Union{AbstractString,Nothing}=nothing,
    screenshot_dir_path::Union{AbstractString,Nothing}=nothing;
    generate_html_options=generate_html_default_options,
    kwargs...
)
    c = Pluto.Configuration.from_flat_kwargs(;
        disable_writing_notebook_files = true,
        lazy_workspace_creation = true,
    )
    session = Pluto.ServerSession(;options=c)
    @info "Running notebook..."
    notebook = Pluto.SessionActions.open(session, notebook_path; run_async=false)
    html_contents = Pluto.generate_html(notebook; generate_html_options...)
    Pluto.SessionActions.shutdown(session, notebook)

    filename = tempname() * ".html"
    write(filename, html_contents)

    output_path = something(output_path, Pluto.numbered_until_new(Pluto.without_pluto_file_extension(notebook_path); suffix=".pdf", create_file=false))

    html_to_pdf(filename, output_path, screenshot_dir_path; kwargs...)
end

function tryexpanduser(path)
	try
		expanduser(path)
	catch ex
		path
	end
end

const tamepath = abspath ∘ tryexpanduser

end
