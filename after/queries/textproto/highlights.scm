;; extends

; Message block names (e.g. `cases {` or `config: {`)
(message_field
  (field_name) @type.definition)

; Scalar field names (e.g. `id: "foo"`)
(scalar_field
  (field_name) @property)

; Escape sequences inside strings (\n, \', \", etc.)
(string_escape) @string.escape

; Enum identifiers (override default @number capture from upstream query)
(scalar_value
  (identifier) @constant)

; Booleans
((scalar_value
  (identifier) @boolean)
  (#any-of? @boolean "true" "false" "True" "False" "TRUE" "FALSE"))

; Float special literals
((scalar_value
  [
    (identifier)
    (signed_identifier)
  ] @constant.builtin)
  (#any-of? @constant.builtin "inf" "-inf" "infinity" "-infinity" "nan" "inff" "-inff"))

; Schema header directives (# proto-file:, # proto-message:)
((comment) @keyword.directive
  (#lua-match? @keyword.directive "^#%s*proto%-"))

; Delimiters
[
  ":"
  ","
  ";"
] @punctuation.delimiter
