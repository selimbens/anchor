package version

import (
	"fmt"
	"runtime"
)

var (
	// Version is the application version
	Version = "dev"
	// GitCommit is the git commit hash
	GitCommit = "unknown"
	// BuildDate is the build timestamp
	BuildDate = "unknown"
	// GoVersion is the Go version used to build
	GoVersion = runtime.Version()
	// Platform is the OS/Architecture pair
	Platform = fmt.Sprintf("%s/%s", runtime.GOOS, runtime.GOARCH)
)

// Info returns version information as a formatted string
func Info() string {
	return fmt.Sprintf("anchor version %s\n", Version)
}

// DetailedInfo returns detailed version information
func DetailedInfo() string {
	return fmt.Sprintf(`anchor version %s
Git Commit: %s
Build Date: %s
Go Version: %s
Platform: %s`, Version, GitCommit, BuildDate, GoVersion, Platform)
}
