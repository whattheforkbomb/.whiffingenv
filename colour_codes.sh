# Colour env vars

[ "$_COLOUR_OPEN_TAG" = "\e[" ] && return 0 # already loaded...

# Black
export _BLACK_FG="30"
export _BLACK_BG="40"
export _DARK_GREY_FG="90"
export _DARK_GREY_BG="100"

# Red
export _RED_FG="31"
export _RED_BG="41"
export _LIGHT_RED_FG="91"
export _LIGHT_RED_BG="101"

# Green
export _GREEN_FG="32"
export _GREEN_BG="42"
export _LIGHT_GREEN_FG="92"
export _LIGHT_GREEN_BG="102"

# Brown/Yellow
export _BROWN_FG="33"
export _BROWN_BG="43"
export _YELLOW_FG="93"
export _YELLOW_BG="103"

# Blue
export _BLUE_FG="34"
export _BLUE_BG="44"
export _LIGHT_BLUE_FG="94"
export _LIGHT_BLUE_BG="104"

# Purple
export _PURPLE_FG="35"
export _PURPLE_BG="45"
export _LIGHT_PURPLE_FG="95"
export _LIGHT_PURPLE_BG="105"

# Cyan
export _CYAN_FG="36"
export _CYAN_BG="46"
export _LIGHT_CYAN_FG="96"
export _LIGHT_CYAN_BG="106"

# Gray/White
export _LIGHT_GRAY_FG="37"
export _LIGHT_GRAY_BG="47"
export _WHITE_FG="97"
export _WHITE_BG="107"

# control
export _COLOUR_OPEN_TAG="\e["
export _COLOUR_CLOSE_TAG="m"
export _COLOUR_SEPARATOR=";"
export _NO_COLOUR="${_COLOUR_OPEN_TAG}0${_COLOUR_CLOSE_TAG}"

export _COLOUR_BOLD="1"

function list_colour_grid() {
    (
        printf " _BLACK_BG _DARK_GREY_BG _RED_BG _LIGHT_RED_BG _GREEN_BG _LIGHT_GREEN_BG _BROWN_BG _YELLOW_BG _BLUE_BG _LIGHT_BLUE_BG _PURPLE_BG _LIGHT_PURPLE_BG _CYAN_BG _LIGHT_CYAN_BG _LIGHT_GRAY_BG _WHITE_BG\n"
        for FG in "_BLACK_FG|$_BLACK_FG" "_DARK_GREY_FG|$_DARK_GREY_FG" "_RED_FG|$_RED_FG" "_LIGHT_RED_FG|$_LIGHT_RED_FG" "_GREEN_FG|$_GREEN_FG" "_LIGHT_GREEN_FG|$_LIGHT_GREEN_FG" "_BROWN_FG|$_BROWN_FG" "_YELLOW_FG|$_YELLOW_FG" "_BLUE_FG|$_BLUE_FG" "_LIGHT_BLUE_FG|$_LIGHT_BLUE_FG" "_PURPLE_FG|$_PURPLE_FG" "_LIGHT_PURPLE_FG|$_LIGHT_PURPLE_FG" "_CYAN_FG|$_CYAN_FG" "_LIGHT_CYAN_FG|$_LIGHT_CYAN_FG" "_LIGHT_GRAY_FG|$_LIGHT_GRAY_FG" "_WHITE_FG|$_WHITE_FG" ; do
            FG_NAME="$(sed -r "s/([^|]+)\|.+/\1/" <<< "$FG")"
            FG_NUM="$(sed -r "s/[^|]+\|(.+)/\1/" <<< "$FG")"
            printf "$FG_NAME"
            for BG in "_BLACK_BG|$_BLACK_BG" "_DARK_GREY_BG|$_DARK_GREY_BG" "_RED_BG|$_RED_BG" "_LIGHT_RED_BG|$_LIGHT_RED_BG" "_GREEN_BG|$_GREEN_BG" "_LIGHT_GREEN_BG|$_LIGHT_GREEN_BG" "_BROWN_BG|$_BROWN_BG" "_YELLOW_BG|$_YELLOW_BG" "_BLUE_BG|$_BLUE_BG" "_LIGHT_BLUE_BG|$_LIGHT_BLUE_BG" "_PURPLE_BG|$_PURPLE_BG" "_LIGHT_PURPLE_BG|$_LIGHT_PURPLE_BG" "_CYAN_BG|$_CYAN_BG" "_LIGHT_CYAN_BG|$_LIGHT_CYAN_BG" "_LIGHT_GRAY_BG|$_LIGHT_GRAY_BG" "_WHITE_BG|$_WHITE_BG" ; do
                BG_NAME="$(sed -r "s/([^|]+)\|.+/\1/" <<< "$BG")"
                BG_NUM="$(sed -r "s/[^|]+\|(.+)/\1/" <<< "$BG")"
                printf " ${_COLOUR_OPEN_TAG}${BG_NUM}${_COLOUR_SEPARATOR}${FG_NUM}${_COLOUR_CLOSE_TAG}abc123"
            done
            printf "${_NO_COLOUR}\n"
        done
    ) | column -tn
}
