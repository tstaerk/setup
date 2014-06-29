#!/bin/bash
# This file sets up a computer as tstaerk likes it. Call it after you have performed the OS installation.

# Version 1: confirms that it ran

# set default browser for KDE to firefox
#   for SUSE Linux, where we have to look in .kde4 instead of .kde
# The key for default browser is BrowserApplication.
cd
mkdir -p .kde4/share/apps/konsole
mkdir -p .kde4/share/config
cd .kde4/share/config 
# first delete all the old entries for BrowserApplication 
sed -i 's/BrowserApplication\[\$e\]=.*//g' kdeglobals
# add BrowserApplication to the General section if a General section exists
sed -i 's/\[General\]/\[General\]\nBrowserApplication\[\$e\]=!firefox/g' kdeglobals 
# add a General section and the key BrowerserApplication if no General section exists
grep "\[General\]" kdeglobals || echo -e "\n[General]\nBrowserApplication[\$e]=!firefox" >> kdeglobals

# allow root logins
test -f /usr/local/share/config/kdm/kdmrc && sed -i "s/AllowRootLogin=false//" /usr/local/share/config/kdm/kdmrc

# default to ssh -X
sed -i "s/.*ForwardX11[^ ].*/ForwardX11 yes/g" /etc/ssh/ssh_config 2>/dev/null || echo "root's changes could not be done"

# set an alias for ssh to work with graphical transmission
cat >>/etc/bash.bashrc<<EOF
alias ssh="ssh -Y"
EOF
cat >>/etc/profile.d/autoexec.sh<<EOF
alias ssh="ssh -Y"
EOF

# set compose key
cd
cat >>.Xmodmap<<EOF
keycode 134 = Multi_key
EOF

# set scrolling to unlimited in konsole
cd
cd .kde4/share/apps/konsole
cat >Shell.profile<<EOF
[General]
ShowNewAndCloseTabButtons=true

[Scrolling]
HistoryMode=2

[Appearance]
Font=DejaVu Sans Mono,13,-1,2,50,0,0,0,0,0
EOF
# same thing for Ubuntu
cd
mkdir -p .kde/share/apps/konsole
cd .kde/share/apps/konsole
cat >Shell.profile<<EOF
[General]
ShowNewAndCloseTabButtons=true

[Scrolling]
HistoryMode=2

[Appearance]
Font=DejaVu Sans Mono,13,-1,2,50,0,0,0,0,0
EOF

# set close buttons to the left in case of Ubuntu´s MetaCity settings        
gconftool-2 --unset /apps/metacity/general/button_layout 

# confirm
echo "Default Config additions done"
