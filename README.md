# Handlebar

Handlebar is a template rendering library for V similar to Go's text/template.

## Syntax

- `{{color "red" "this is a string"}}`
- `{{color "red" "this is a string" | Bold}}`
- `{{color "red" (printf "%3.02f" valueName)}}%`
- `{{((float valueNameA) / (float valueNameB)) * 100.0}}`
- `{{if valueNameA < 10 valueNameA else valueNameB}}`
- `{{valueName || "default value"}}`
- `{{identifier}}`
