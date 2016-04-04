#!/usr/bin/env bash

# PRE: create_groups.sh has run successfully.

set -e
S=$(basename $0)

touch /var/log/{btmp,lastlog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664 /var/log/lastlog
chmod -v 600 /var/log/btmp

echo "$S: WIN: You've updated the logs."


