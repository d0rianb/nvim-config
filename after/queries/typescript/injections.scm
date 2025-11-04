; CSS dans public_field_definition (static styles = css`...`)
((public_field_definition
  value: (call_expression
    function: (identifier) @_func
    arguments: (template_string) @injection.content))
  (#eq? @_func "css")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "css"))

; CSS dans call_expression simple (const x = css`...`)
((call_expression
  function: (identifier) @_func
  arguments: (template_string) @injection.content)
  (#eq? @_func "css")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "css"))

; HTML (déjà fonctionnel normalement)
((call_expression
  function: (identifier) @_func
  arguments: (template_string) @injection.content)
  (#eq? @_func "html")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "html"))

(
  (comment) @injection.language (#offset! @injection.language 0 3 0 -3)
  (template_string (string_fragment) @injection.content)
)
