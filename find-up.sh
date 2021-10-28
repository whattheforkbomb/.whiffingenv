[ ! -z "$_FIND_UP_SOURCED" ] && [ "$_FIND_UP_SOURCED" != "RELOAD" ] && return 0
_FIND_UP_SOURCED=TRUE

function nested_path_dirs() {
    PATH_TO_SPLIT="$1"
    if [ -z "$PATH_TO_SPLIT" ] ; then 
        log_err "A path to split was not provided" 
        return 1
    fi

    PATH_DIRS="$(sed -r "s/^\///" <<< "$PATH_TO_SPLIT" | tr "/" "\n")"

    for DIR_IN_PATH in $PATH_DIRS ; do
        CURRENT_NESTED_PATH_DIRS="${CURRENT_NESTED_PATH_DIRS}/$DIR_IN_PATH" # Will not include root
        NESTED_PATH_DIRS="${CURRENT_NESTED_PATH_DIRS}${NESTED_PATH_DIRS:+
$NESTED_PATH_DIRS}"
    done

    echo "$NESTED_PATH_DIRS"
    unset PATH_TO_SPLIT PATH_DIRS DIR_IN_PATH CURRENT_NESTED_PATH_DIRS NESTED_PATH_DIRS
}

function find_up() {
    FILE_TO_FIND="$1"
    PATHS_TO_EXCLUDE="$2"
    if [ -z "$FILE_TO_FIND" ] ; then 
        log_err "A file to find was not provided" 
        return 1
    fi

    DIRS_IN_PWD="$(nested_path_dirs "$(pwd)")"
    
    if [ ! -z "$PATHS_TO_EXCLUDE" ] ; then
        PATH_FILTER_REGEX="$(nested_path_dirs "$PATHS_TO_EXCLUDE" | sed -r "s/(.+)/^\1$/" | tr "\n" "|" | sed -r "s/\|$//")"
        DIRS_IN_PWD="$(grep -E -v "$PATH_FILTER_REGEX" <<< "$DIRS_IN_PWD")"
        unset PATH_FILTER_REGEX
    fi
    
    if [ ! -z "$DIRS_IN_PWD" ] ; then
        DIRS_IN_PWD="$(tr "\n" " " <<< "$DIRS_IN_PWD")"
        find $DIRS_IN_PWD -maxdepth 1 -mount -type f -name "$FILE_TO_FIND" -print
    fi
    unset DIRS_IN_PWD FILE_TO_FIND PATHS_TO_EXCLUDE
}
