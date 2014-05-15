#Sublime Text Setup

##Javascript

- Code completion:
	- http://ternjs.net/ (forked to shawnkc/tern_for_sublime so it's not lost)
	- Installation (copied from tern depo):
		- Check out the code in this repository into a subdirectory of your Sublime Text's `Packages` directory.
		
			    cd /path/to/sublime-text-N/Packages
			    git clone git://github.com/marijnh/tern_for_sublime.git
		
		- Next, make sure [node.js][node] and [npm][npm] are installed (Tern is a JavaScript program), and install the depedencies of the package.
		
[node]: http://nodejs.org
[npm]: https://npmjs.org/
		
			    cd tern_for_sublime
			    npm install
		
		- You should be all set now.
		
# iTerm2
## Misc tips:

- http://teohm.com/blog/2012/03/22/working-effectively-with-iterm2/
- http://thunderboltlabs.com/blog/2013/11/19/efficiency-with-sublime-text-and-ruby/

## Favorite Settings

### Control Key on Right Side of Keyboard

Under **Keys** (not **Profile->Keys**), remap the `Right ⌥` to `^`, I hardly ever use the right option but it's so hard to get me to hit `^a` normally.

### Open Tab/Pane in Current Working Directory

Under **Profile->General**, select "Reuse previous session's directory"

### Switch pane with mouse cursor

Under **Pointer**, in Miscellaneous Settings section, enable “Focus follows mouse”.

### Misc Window Settings

Under **General->Window**, disable "Adjust window when changing font size"

Under **Appearance->Dimming**, enable "Dim background windows" and "Animate Dimming"

Under **Appearance->Tabs**, disable "Hide tab number and tab close button"

Under **Pointer->Miscellaneous Settings**, enable "Focus follows mouse"

## Shortcuts I commonly use

Category | Shortcut | Description
:------- | :------- | :----------
Tabs |
|⌘ t  	| Create new tab
|⌘ ⇧ ]	| Next tab
|⌘ ⇧ [	| Previous tab
Panes |
|⌘ d  	| Split horizontal
|⌘ ⇧ d  | Split vertical
|⌘ ]	| Next pane
|⌘ [	| Previous pane
Misc |
|⌘ +	| Larger font
|⌘ -	| Smaller font
|⌘ k	| Clears screen (works in almost all OSX apps)
|⌘ ⌥ =	| Toggle maximize window





















