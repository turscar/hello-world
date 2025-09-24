package main

import (
	_ "embed"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"runtime"
	"runtime/debug"
	"sort"
)

//go:embed "page.html.tpl"
var templateFile string

//go:embed "VERSION"
var version string

const port = 8080

type App struct {
	Version     string
	VcsRevision string
	VcsTime     string
	Arch        string
}
type PageData struct {
	Req *http.Request
	Env []string
	App App
}

func main() {
	tpl := template.Must(template.New("page.html.tpl").Parse(templateFile))

	app := &App{
		Version: version,
		Arch:    runtime.GOARCH,
	}
	bi, ok := debug.ReadBuildInfo()
	if ok {
		for _, bs := range bi.Settings {
			switch bs.Key {
			case "vcs.revision":
				app.VcsRevision = bs.Value
			case "vcs.time":
				app.VcsTime = bs.Value
			}
		}
	}

	env := os.Environ()
	sort.Strings(env)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		err := tpl.Execute(w, PageData{
			Req: r,
			Env: env,
			App: *app,
		})
		if err != nil {
			log.Printf("Failed to serve page: %v", err)
		}
	})
	log.Printf("Listening on port %d", port)
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	log.Print(err)
}
