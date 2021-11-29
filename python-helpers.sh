# python helper funcs / aliases

## conda wrappers
function get_active_conda_env() {
    if [ ! -z "$CONDA_PREFIX" ] ; then 
        CURRENT_CONDA_ENV="$(sed -rn "s/^.*\/envs\/(.+)$/\1/p" <<< "$CONDA_PREFIX")"
        echo "${CURRENT_CONDA_ENV:-base}"
        unset CURRENT_CONDA_ENV
    fi
}

## pyhton wrappers
function get_active_python_version() {
    python --version 2>&1 | sed -rn "s/^Python ([0-9]+(\.[0-9]+)*).*$/\1/p"
}

alias con-a="conda activate"
alias con-d="conda deactivate"
alias con-e=get_active_conda_env
alias jl=jupyter-lab
