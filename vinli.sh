export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin
export VINLI_STACK=.stage.ald.vinli.eu

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/shawn/google-cloud-sdk/path.bash.inc' ]; then . '/Users/shawn/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/shawn/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/shawn/google-cloud-sdk/completion.bash.inc'; fi
