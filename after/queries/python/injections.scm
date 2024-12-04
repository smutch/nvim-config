; extends
(call
    (attribute
		attribute: (identifier) @_attribute (#eq? @_attribute "sql"))
	(argument_list (string (string_content) @injection.content (#set! injection.language "sql"))))
