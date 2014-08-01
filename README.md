#Using dotfiles

This contains my favorite aliases and command prompt settings to show your git repository branch for any directory you're in.

##To install:

- Download this repository into your user's root folder
  
	    git clone git@github.com:shawnkc/dotfiles

- Create/edit your ~/.bash_profile file and just copy/paste the contents of the `BASH_PROFILE_EXAMPLE` file.

#Sublime Text Setup

###Themes

- Atom was nice visually, but far too slow with the paint/input response.  Here is a good theme to get you almost there visually:  https://github.com/shawnkc/sublimetext-defaultplus-theme

###Misc Packages

- Package Manager
	- [https://sublime.wbond.net/installation][https://sublime.wbond.net/installation]
	- The simplest method of installation is through the Sublime Text console. The console is accessed via the ctrl+` shortcut or the View > Show Console menu. Once open, paste the appropriate Python code for your version of Sublime Text into the console:
	  
	      import urllib.request,os,hashlib; h = '7183a2d3e96f11eeadd761d777e62404' + 'e330c659d4bb41d3bdf022e94cab3cd0'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)

- HTML/CCS/JS prettify:
	- [https://sublime.wbond.net/packages/HTML-CSS-JS%20Prettify](https://sublime.wbond.net/packages/HTML-CSS-JS%20Prettify)

###Javascript

- Code completion:
	- [http://ternjs.net](http://ternjs.net) (forked to shawnkc/tern_for_sublime so it's not lost)
	- Installation (copied from tern depo):
		- Check out the code in this repository into a subdirectory of your Sublime Text's `Packages` directory.
		
			  cd /path/to/sublime-text-N/Packages
			  git clone git://github.com/marijnh/tern_for_sublime.git
		
		- Next, make sure [node.js](http://nodejs.org) and [npm](https://npmjs.org/) are installed (Tern is a JavaScript program), and install the depedencies of the package.
		
			  cd tern_for_sublime
			  npm install
		
		- You should be all set now.
		
# iTerm2
### Misc tips:

- http://teohm.com/blog/2012/03/22/working-effectively-with-iterm2/
- http://thunderboltlabs.com/blog/2013/11/19/efficiency-with-sublime-text-and-ruby/

- Hide 'Last login':
  
  - Tired of this: 'Last login: Thu Nov 25 09:07:55 on ttys004', simply do this:

      ````$ touch ~/.hushlogin````

### Favorite Settings

#### Move forward/back by a word, delete next work

Map `^ left/right/D` to `Esc + B/F/D`.

![keyboard_pref1](./_readme_images/iterm_keyboard_mapping.png =700x)

#### Control Key on Right Side of Keyboard

- Under **Keys** (not **Profile->Keys**), remap the `Right ⌥` to `^`, I hardly ever use the right option but it's so hard to get me to hit `^a` normally.

#### Open Tab/Pane in Current Working Directory

- Under **Profile->General**, select "Reuse previous session's directory"

#### Switch pane with mouse cursor

- Under **Pointer**, in Miscellaneous Settings section, enable “Focus follows mouse”.

#### Misc Window Settings

- Under **General->Window**, disable "Adjust window when changing font size"
- Under **Appearance->Dimming**, enable "Dim background windows" and "Animate Dimming"
- Under **Appearance->Tabs**, disable "Hide tab number and tab close button"
- Under **Pointer->Miscellaneous Settings**, enable "Focus follows mouse"

### Shortcuts I commonly use

Category | Shortcut | Description
:------- | :------- | :----------
Tabs ||
 |⌘ t  	| Create new tab
 |⌘ ⇧ ]	| Next tab
 |⌘ ⇧ [	| Previous tab
Panes ||
 |⌘ d  	| Split horizontal
 |⌘ ⇧ d  | Split vertical
 |⌘ ]	| Next pane
 |⌘ [	| Previous pane
Misc ||
 |⌘ +	| Larger font
 |⌘ -	| Smaller font
 |⌘ k	| Clears screen (works in almost all OSX apps)
 |⌘ ⌥ =	| Toggle maximize window





















