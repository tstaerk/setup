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
alias ll="ls -l"
EOF
cat >>/etc/profile.d/autoexec.sh<<EOF
alias ssh="ssh -Y"
alias ll="ls -l"
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

# make the key showing a screen to trigger the screensaver and the pause key the same
newdatacount=$(($(cat ~/.kde4/share/config/khotkeysrc|grep DataCount |head -n1|sed "s/.*=//")+1))

cat >>~/.kde4/share/config/khotkeysrc<<EOF
[Data_5]
Comment=Comment
Enabled=true
Name=pausespecialkey
Type=SIMPLE_ACTION_DATA

[Data_5Actions]
ActionsCount=1

[Data_5Actions0]
CommandURL=qdbus org.kde.screensaver /ScreenSaver org.freedesktop.ScreenSaver.Lock
Type=COMMAND_URL

[Data_5Conditions]
Comment=
ConditionsCount=0

[Data_5Triggers]
Comment=Simple_action
TriggersCount=1

[Data_5Triggers0]
Key=Browser
Type=SHORTCUT
Uuid={f1cf67f0-0a74-4e11-b813-426fb0de9a62}

[Data_6]
Comment=Comment
Enabled=true
Name=pausespecialkey
Type=SIMPLE_ACTION_DATA

[Data_6Actions]
ActionsCount=1

[Data_6Actions0]
CommandURL=qdbus org.kde.screensaver /ScreenSaver org.freedesktop.ScreenSaver.Lock
Type=COMMAND_URL

[Data_6Conditions]
Comment=
ConditionsCount=0

[Data_6Triggers]
Comment=Simple_action
TriggersCount=1

[Data_6Triggers0]
Key=Browser
Type=SHORTCUT
Uuid={f1cf67f0-0a74-4e11-b813-426fb0de9a62}
EOF

sed -i "s/DataCount=.*/DataCount=$newdatacount/" ~/.kde4/share/config/khotkeysrc
sed -i "s/Data_6/Data_$newdatacount/g" ~/.kde4/share/config/khotkeysrc

# confirm
echo "Default Config additions done"
