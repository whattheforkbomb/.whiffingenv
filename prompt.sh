. /home/whiffingj/.whiffingenv/colour_codes.sh
. /home/whiffingj/.whiffingenv/git-helpers.sh
. /home/whiffingj/.whiffingenv/python-helpers.sh

_PROMPT_SHOW_GIT_STATUS=ALL
_PROMPT_SHOW_PYTHON_STATUS=ALL
_PROMPT_SHOW_EXTRA_INFO=TRUE
_PROMPT_DEFAULT_FG="${_COLOUR_OPEN_TAG}0${_COLOUR_SEPARATOR}${_LIGHT_GRAY_FG}${_COLOUR_CLOSE_TAG}"

function _prompt_get_git_info() {
    GIT_BRANCH_COLOUR="\\${_COLOUR_OPEN_TAG}0${_COLOUR_SEPARATOR}${_LIGHT_BLUE_FG}${_COLOUR_CLOSE_TAG}"
    GIT_INSERTIONS_COLOUR="\\${_COLOUR_OPEN_TAG}0${_COLOUR_SEPARATOR}${_GREEN_FG}${_COLOUR_CLOSE_TAG}"
    GIT_DELETIONS_COLOUR="\\${_COLOUR_OPEN_TAG}0${_COLOUR_SEPARATOR}${_RED_FG}${_COLOUR_CLOSE_TAG}"
    # GIT
    case $_PROMPT_SHOW_GIT_STATUS in
        BRANCH)
            PROMPT_GIT_STATUS="${GIT_BRANCH_COLOUR}$(get_current_branch)${_PROMPT_DEFAULT_FG}"
            ;;
        *)
            PROMPT_GIT_STATUS="$(get_current_branch)"
            [ -z "$PROMPT_GIT_STATUS" ] && PROMPT_GIT_STATUS="" || PROMPT_GIT_STATUS="${GIT_BRANCH_COLOUR}${PROMPT_GIT_STATUS}${_PROMPT_DEFAULT_FG} - $(get_head_git_changes | sed -r "s/([0-9]+)\/([0-9]+)\/([0-9]+)/\1\/${GIT_INSERTIONS_COLOUR}\2\\${_PROMPT_DEFAULT_FG}\/${GIT_DELETIONS_COLOUR}\3\\${_PROMPT_DEFAULT_FG}/")"
            ;;
    esac

    printf "$PROMPT_GIT_STATUS"
    unset PROMPT_GIT_STATUS GIT_BRANCH_COLOUR GIT_INSERTIONS_COLOUR GIT_DELETIONS_COLOUR
}

function _prompt_get_python_info() {
    case $_PROMPT_SHOW_PYTHON_STATUS in
        ENV)
            PROMPT_PYTHON_STATUS="$(get_active_conda_env)"
            ;;
        VERSION)
            PROMPT_PYTHON_STATUS="$(get_active_python_version)"
            ;;
        ALL)
            PROMPT_PYTHON_STATUS="$(get_active_conda_env)"
            [ -z "$PROMPT_PYTHON_STATUS" ] && PROMPT_PYTHON_STATUS="" || PROMPT_PYTHON_STATUS="$PROMPT_PYTHON_STATUS - $(get_active_python_version)"
            ;;
    esac

    printf "$PROMPT_PYTHON_STATUS"
    unset PROMPT_PYTHON_STATUS
}

function _prompt_get_bg_jobs_count() {
    BG_JOBS_COUNT="$(jobs -r | wc -l)"
    [ "$BG_JOBS_COUNT" != 0 ] && printf "BG: $BG_JOBS_COUNT"
    unset BG_JOBS_COUNT
}

function get_prompt() {
    # Previous Command Success
    [ "$?" = "0" ] && LAST_COMMAND_SUCCESS_COLOUR="${_COLOUR_OPEN_TAG}${_GREEN_FG}${_COLOUR_CLOSE_TAG}" || LAST_COMMAND_SUCCESS_COLOUR="${_COLOUR_OPEN_TAG}${_RED_FG}${_COLOUR_CLOSE_TAG}"

    PROMPT_GIT_STATUS="$(_prompt_get_git_info)"
    PROMPT_PYTHON_STATUS="$(_prompt_get_python_info)"
    PROMPT_BG_JOBS_COUNT="$(_prompt_get_bg_jobs_count)"
    
    printf "${_PROMPT_DEFAULT_FG}[${HOSTNAME}] $(pwd)\n" # Location Info (chroot, machine, & current dirtectory)
    [ "${_PROMPT_SHOW_EXTRA_INFO}" = "TRUE" ] && printf "[$(date +"%D %T (%Z)")] ${_PROMPT_DEFAULT_FG}${debian_chroot:+[$debian_chroot] }${PROMPT_BG_JOBS_COUNT:+[$PROMPT_BG_JOBS_COUNT] }${PROMPT_GIT_STATUS:+[$PROMPT_GIT_STATUS] }${PROMPT_PYTHON_STATUS:+[$PROMPT_PYTHON_STATUS]}\n" # Meta info
    printf "${LAST_COMMAND_SUCCESS_COLOUR}${USER} ${_PROMPT_DEFAULT_FG}>${_NO_COLOUR} "
    
    unset PROMPT_GIT_STATUS PROMPT_PYTHON_STATUS LAST_COMMAND_SUCCESS_COLOUR PROMPT_BG_JOBS_COUNT 
}

function prompt_toggle_info() {
    [ "${_PROMPT_SHOW_EXTRA_INFO}" = "TRUE" ] && _PROMPT_SHOW_EXTRA_INFO=FALSE || _PROMPT_SHOW_EXTRA_INFO=TRUE
}

PS1="\$(get_prompt)"
