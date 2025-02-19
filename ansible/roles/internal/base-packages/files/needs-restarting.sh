#!/bin/bash

PATH="/usr/bin:/bin"
export PATH

DATE="$(date '+%Y/%m/%d %H:%M:%S (%Z)')"
HOSTNAME="$(hostname)"

subject="${HOSTNAME} restarts required"
body=""

REBOOT_RESTARTS=$(needs-restarting -r)
if [ "$?" -ne 0 ] ; then
    printf -v msg '\n\nReboot required:\n%s\n' "${REBOOT_RESTARTS}"
    body+="${msg}"
fi

SYSTEMD_RESTARTS=$(needs-restarting -s)
if [ -n "${SYSTEMD_RESTARTS}" ] ; then
    printf -v msg '\n\nThe following systemd services should be restarted:\n%s\n' "${SYSTEMD_RESTARTS}"
    body+="${msg}"
fi


if [ -n "${body}" ] ; then
printf -v body 'This is the "needs-restarting" script on %s run at %s.  The following actions should be taken in the next maintenance window\n%s' "${HOSTNAME}" "${DATE}" "${body}"
cat <<EOF | mailx -s "${subject}" root
${body}
EOF
fi
