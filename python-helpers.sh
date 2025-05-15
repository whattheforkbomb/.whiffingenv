# python helper funcs / aliases

## conda wrappers
function get_active_conda_env() {
    if [ ! -z "$CONDA_PREFIX" ] ; then 
        CURRENT_CONDA_ENV="$(sed -rn "s/^.*\/envs\/(.+)$/\1/p" <<< "$CONDA_PREFIX")"
        echo "${CURRENT_CONDA_ENV:-base}"
        unset CURRENT_CONDA_ENV
    fi
}

## python wrappers
function get_active_python_version() {
    python --version 2>&1 | sed -rn "s/^Python ([0-9]+(\.[0-9]+)*).*$/\1/p"
}

function activate_conda_env() {
    conda activate $@
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/"
}

function deactivate_conda_env() {
    export LD_LIBRARY_PATH="$(sed -e "s;:$(sed -e "s;/;\\\\/;g" <<< "$CONDA_PREFIX")/lib/;;g" <<< "$LD_LIBRARY_PATH")"
    conda deactivate
}

alias con-a="activate_conda_env"
alias con-d="deactivate_conda_env"
alias con-e=get_active_conda_env
alias jl=jupyter-lab
alias jl-colab="jl --NotebookApp.allow_origin='https://colab.research.google.com' --port=8888 --NotebookApp.port_retries=0"

VENV_PATH="${HOME}/bin/python/venv"

# venv helpers
function activate_venv() {
    if [ -d "${VENV_PATH}/$@" ] ; then
        source "$VENV_PATH/$@/bin/activate"
    else
        echo "Unable to locate venv '$@' in: '${VENV_PATH}'."
        return 1
    fi
}
alias venv=activate_venv