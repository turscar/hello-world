<html>
<head>
    <meta charset="utf-8">
    <title>Hello World</title>
    <style>
        dl {
            display: grid;
            grid-template: auto / auto auto;
            width: fit-content;
            column-gap: 1em;
        }

        dl dt {
            grid-column-start: 1;
        }

        dl dd {
            grid-column-start: 2;
            margin: 0;
        }
    </style>
</head>
<body>
{{/*gotype:go.turscar.ie/hello-world.PageData */}}
<h1>Hello World</h1>
<dl>
    <dt>Method</dt>
    <dd>{{ .Req.Method }}</dd>
    <dt>URL</dt>
    <dd>{{ .Req.URL }}</dd>
    <dt>Proto</dt>
    <dd>{{ .Req.Proto }}</dd>
    <dt>Host</dt>
    <dd>{{ .Req.Host }}</dd>
    <dt>Peer</dt>
    <dd>{{ .Req.RemoteAddr }}</dd>
</dl>
<h2>Headers</h2>
<dl>
    {{ range $k, $v := .Req.Header }}
        {{ range $v }}
            <dt>{{ $k }}</dt>
            <dd>{{ . }}</dd>
        {{ end }}
    {{ end }}
</dl>
<h2>Environment</h2>
<pre>{{ range .Env}}{{ . }}
{{ end }}</pre>
</body>
</html>