# source files that have been listed for sourcing

# check if already loaded
[ ! -z "$_SOURCE_SOURCED" ] && [ "$_SOURCE_SOURCED" != "RELOAD" ] && return 0
_SOURCE_SOURCED=TRUE
_WHIFFINGENV_SOURCE_LIST_PATH=$HOME/.whiffingenv/.source.txt

# load logging helpers
. $HOME/.whiffingenv/log-helpers.sh

function source_files() {
    for FILE_TO_SOURCE in "$@" ; do
        . $FILE_TO_SOURCE
    done
}

function add_files_to_source_list() {
    CURRENT_SOURCE_LIST="$(cat "$_WHIFFINGENV_SOURCE_LIST_PATH" | tr "\n" '|' | sed -r "s/^(.+)[|]$/\1/")"
    log_debug "CURRENT_SOURCE_LIST = $CURRENT_SOURCE_LIST"

    for PARAM in "$@"; do
        if [ -z "$(grep -E "^/" <<< "$PARAM")" ] || [ ! -f "$PARAM" ] ; then # invalid file path (should be absolute)
            FILE_SOURCE_ERRORS="${FILE_SOURCE_ERRORS:+
}$PARAM is invalid path (must be fully qaulified (start from /), and exist"
        else
            # if [ -z "$(grep -vE "$CURRENT_SOURCE_LIST")" ]
            FILES_TO_SOURCE="${FILES_TO_SOURCE:+
}$PARAM"
        fi
    done
    
    log_debug "FILES_TO_SOURCE = $FILES_TO_SOURCE"
    FILES_TO_SOURCE="$(grep -vE "$CURRENT_SOURCE_LIST" <<< "$FILES_TO_SOURCE")"
    log_debug "FILES_TO_SOURCE W/ Duplicates Removed = $FILES_TO_SOURCE"

    if [ ! -z "$FILES_TO_SOURCE" ] ; then
        # append to the source file
        echo "$FILES_TO_SOURCE" >> "$_WHIFFINGENV_SOURCE_LIST_PATH"
        
        # load newly added files
        source_files $(cat <<< "$FILES_TO_SOURCE")

        [ ! -z "$FILE_SOURCE_ERRORS" ] && log_err "$FILE_SOURCE_ERRORS"
    fi

    unset FILES_TO_SOURCE FILE_SOURCE_ERRORS CURRENT_SOURCE_LIST
}

source_files $(cat "$_WHIFFINGENV_SOURCE_LIST_PATH" | sed "s|\$HOME|$HOME|")

## TODO - Add means to add files based on current dir (need to find full path based on current dir & selected files...)
