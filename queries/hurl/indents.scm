; indents.scm
[
  (object)
  (array)
] @indent

[
  "}"
  "]"
] @branch

[
  (json_object)
  (json_array)
] @indent

[
  "}"
  "]"
] @branch

(xml_tag (xml_open_tag)) @indent
(xml_tag (xml_close_tag) @branch)
