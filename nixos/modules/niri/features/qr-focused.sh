set -eu

img=/tmp/qrcode.png
title=QRFloatingWindow
monitor_pid=

log() {
    echo "[$(date '+%F %T')] $*"
}

cleanup() {
    log "cleanup monitor_pid=${monitor_pid:-}"
    [ -n "${monitor_pid}" ] && kill "${monitor_pid}" 2>/dev/null || true
}

trap cleanup EXIT HUP INT TERM

log "start"
wl-paste | qrencode -o "${img}" -s 8

imv -W 500 -H 500 -w "${title}" -c 'bind <Escape> quit' "${img}" &
pid=$!
log "imv pid=${pid}"
wid=

while [ -z "${wid}" ]; do
    if ! kill -0 "${pid}" 2>/dev/null; then
        log "imv exited before wid"
        exit 1
    fi

    wid=$(
        niri msg --json windows |
            jq -r '.[] | select(.app_id=="imv" and .title=="QRFloatingWindow") | .id' |
            tail -n 1
    )
    log "imv wid=${wid}"

    [ "${wid}" = "null" ] && wid=
    [ -n "${wid}" ] && log "wid=${wid}"
    [ -n "${wid}" ] || sleep 0.05
done

focused=$(
    niri msg --json focused-window |
        jq -r 'if . == null then "null" else (.id | tostring) end'
)
log "initial focused=${focused} wid=${wid}"

if [ "${focused}" != "${wid}" ]; then
    log "closing because initial focus differs"
    imv-msg "${pid}" quit >/dev/null 2>&1 || true
    wait "${pid}" 2>/dev/null || true
    exit 0
fi

(
    log "event-stream monitor started"
    niri msg --json event-stream |
        jq --unbuffered -c 'select(.WindowFocusChanged?)' |
        while IFS= read -r event; do
            log "event=${event}"
            focused=$(printf '%s\n' "${event}" | jq -r '.WindowFocusChanged.id | tostring')
            log "focus changed focused=${focused} wid=${wid}"
            [ "${focused}" = "${wid}" ] && continue
            log "closing because focus moved away"
            imv-msg "${pid}" quit >/dev/null 2>&1 || true
            break
        done
) &
monitor_pid=$!
log "monitor pid=${monitor_pid}"

wait "${pid}"
status=$?
log "imv wait status=${status}"
