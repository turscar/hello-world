package main

import (
	_ "embed"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"sort"
)

//go:embed "page.html.tpl"
var templateFile string

const port = 8080

type PageData struct {
	Req *http.Request
	Env []string
}

func main() {
	tpl := template.Must(template.New("page.html.tpl").Parse(templateFile))

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		env := os.Environ()
		sort.Strings(env)
		err := tpl.Execute(w, PageData{
			Req: r,
			Env: env,
		})
		if err != nil {
			log.Printf("Failed to serve page: %v", err)
		}
	})
	log.Printf("Listening on port %d", port)
	_ = http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
}
