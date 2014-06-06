SUBLIME_TEXT_2="/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
SUBLIME_TEXT_3="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"

SUBLIME_PATH=/usr/local/bin
SUBLIME_LINK="$SUBLIME_PATH/subl"

if ! [[ -e "$SUBLIME_PATH" ]]; then
	echo "Creating the $SUBLIME_PATH directory, please enter password:"
	sudo mkdir -p "$SUBLIME_PATH"
	sudo chmod -R 775 "$SUBLIME_PATH"
fi

if [[ -f "$SUBLIME_TEXT_2" ]]; then
		[[ -e "$SUBLIME_LINK" ]] && rm $SUBLIME_LINK
		ln -s "$SUBLIME_TEXT_2" "$SUBLIME_LINK"
fi

if [[ -e "$SUBLIME_TEXT_3" ]]; then
		[[ -e "$SUBLIME_LINK" ]] && rm $SUBLIME_LINK
		ln -s "$SUBLIME_TEXT_3" "$SUBLIME_LINK"
fi

# todo:
# only create 2 if 3 doesn't exist
# only create 3 if it doesn't exist
# might have link for subl2, subl3 and a master for subl -> subl3 to help

export GIT_EDITOR=subl
