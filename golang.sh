gozer() {
    # update gozer req in current repo
    go mod edit -require github.com/vinli/gozer@$1
    go mod download
    go mod tidy
}
