#!/bin/bash
# This file sets up a computer as tstaerk likes it. Call it after you have performed the OS installation.
# Or, for example on Google Cloud Platform, just add it to a bucket and add a call to it to the VM's metadata.

# Version 1: confirms that it ran

# add user thorstenstaerk
useradd -m thorstenstaerk -s /bin/bash

# default to ssh -X
sed -i "s/.*ForwardX11[^ ].*/ForwardX11 yes/g" /etc/ssh/ssh_config 2>/dev/null || echo "root's changes could not be done"

# confirm
echo "Default Config additions done"
