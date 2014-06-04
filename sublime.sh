SUBLIME_TEXT_2="/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
SUBLIME_TEXT_3="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"

mkdir -p /usr/local/bin

if [[ -f "$SUBLIME_TEXT_2" ]]; then
       rm /usr/local/bin/subl
       ln -s "$SUBLIME_TEXT_2" /usr/local/bin/subl
fi

if [[ -e "$SUBLIME_TEXT_3" ]]; then
       rm /usr/local/bin/subl
       ln -s "$SUBLIME_TEXT_3" /usr/local/bin/subl
fi

export GIT_EDITOR=subl
