# NOTE: We can't use a shebang yet.
#!/usr/bin/env bash

# PRE: create_links.sh has run successfully.

set -e
S=$(basename $0)

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

echo "$S: WIN: You've created users in /etc/passwd."

