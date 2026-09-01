; extends
(call
  function: [
    (attribute attribute: (identifier) @_method)
    (identifier) @_method
  ]
  (#any-of? @_method "sql" "execute")
  arguments: (argument_list
    (string
      (string_content) @injection.content
      (#set! injection.language "sql")
      (#set! injection.combined))))
