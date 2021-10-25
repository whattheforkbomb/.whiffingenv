function update_display() {
    NEW_X_DISPLAY_ADDRESS="$1"
    if [ -z "$(grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:0" <<< "$NEW_X_DISPLAY_ADDRESS")" ] ; then
        echo "Provided address '$NEW_X_DISPLAY_ADDRESS' is invalid..."
        return 1
    fi

    export DISPLAY=$NEW_X_DISPLAY_ADDRESS
    unset NEW_X_DISPLAY_ADDRESS
    echo "X-Forwarding Display set to: $DISPLAY..."
    return 0
}

function get_or_set_display() {
    if [ -z "$DISPLAY" ] ; then
        update_display "$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0"
    fi
    echo "$DISPLAY"
}

get_or_set_display > /dev/null

if [ "$DISPLAY" = ":0" ] ; then
    echo "Unable to determine display for X-Forwarding..."
else
    export LIBGL_ALWAYS_INDIRECT=1
    echo "X-Forwarding Display set to: $DISPLAY..."
fi
