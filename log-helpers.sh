# log funcs

# no need to resource if already done so
[ ! -z "$_LOG_HELPERS_SOURCED" ] && [ "$_LOG_HELPERS_SOURCED" != "RELOAD" ] && return 0
export _LOG_HELPERS_SOURCED=TRUE

function log() { # basically alias of echo to stderr
    echo -e "$@" >&2
}

function toggle_debug_logging() {
    [ "$LOG_DEBUG" = "TRUE" ] && export LOG_DEBUG=FALSE || export LOG_DEBUG=TRUE
}

function log_debug() {
    [ "$LOG_DEBUG" = "TRUE" ] && log "[DEBUG] - $@"
}

function log_info() {
    log "[INFO] - $@"
}

function log_warn() {
    log "[WARN] - $@"
}

function log_err() {
    log "[ERROR] - $@"
}
