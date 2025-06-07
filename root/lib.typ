

#let default-code-highlight-theme = "forest"
#import "util.typ": *


// Anchor & Goto
#let anchor(id) = {
  if target() == "html" {
    box[#html.elem("anchordef", attrs: (id: str(id)))[ ]]
  } else { }
}

#let goto(id, content) = {
  if target() == "html" {
    link_local_style[#html.elem("anchorgoto", attrs: (id: str(id)), content)]
  } else {
    content
  }
}


#let footnote_def(name, content) = {
  if target() == "html" {
    box[#html.elem("rewrite", attrs: (id: "footnote-def", name: name), content)]
  } else {
    content
  }
}

#let footnote_ref(name) = context {
  if target() == "html" {
    box[#html.elem("rewrite", attrs: (id: "footnote-ref", name: name))]
  } else { }
}


#let schema(name, body) = context {
  if target() != "html" {
    return body
  }
  html.elem("html")[
    #html.elem("head")[
      #html.elem("schema", attrs: (name: str(name)))[ ]
    ]
    #html.elem(
      "body",
      [
        #show emph: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          html.elem("em", it.body)
        }
        #show raw: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          let text = it.text
          let block = it.block
          let lang = it.lang
          if lang == none {
            lang = "text"
          } else {
            lang = to-string(lang)
          }
          let theme = default-code-highlight-theme
          let split = lang.split("--")
          if split.len() > 1 {
            lang = split.at(0)
            theme = split.at(1)
          }
          if block {
            codeblock(text, lang: lang, theme: theme)
          } else {
            codeinline(text, lang: lang, theme: theme)
          }
        }

        #show math.equation: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          inline_math(it, block: it.block)
        }


        #show link: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          let dest = it.dest
          let dest_type = type(dest)
          if dest_type == str {
            if dest.starts-with("mailto:") or dest.starts-with("http") {
              link_external(dest, it.body)
            } else {
              link_local(dest, it.body)
            }
          } else if dest_type == label {
            anchor(str(dest))
          } else {
            [A link with dest type of #str(dest_type) is not supportted in HTML export yet]
          }
        }
        #show super: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          html.elem("sup")[#it.body]
        }
        #show sub: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          html.elem("sub")[#it.body]
        }
        #show overline: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          text-decoration("overline", it.body)
        }
        #show underline: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          text-decoration("underline", it.body)
        }
        #show highlight: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          mark(it.fill, it.body)
        }
        #let footnotes = query(footnote).map(it => it.at("label", default: none)).filter(it => it != none)
        #show ref: it => {
          context {
            if inline-content.get() {
              return it.supplement
            }
          }
          let target = it.target
          if footnotes.contains(target) {
            footnote_ref(str(target))
          } else {
            goto(target)[#it.supplement]
          }
        }
        #show footnote: it => {
          context {
            if inline-content.get() {
              return it
            }
          }
          if type(it.body) == label {
            return footnote_ref(str(it.body))
          }
          if not it.has("label") {
            return footnote_def("!numbering", it.body)
          }
          let name = str(it.label)
          footnote_def(name, it.body)
        }

        #show selector.or(
          heading, // 
          par, // 
          text, // 
          strong, // 
          list, // 
          emph, // ✅
          overline, // ✅
          underline, // ✅
          super, // ✅
          sub, // ✅
          raw, // ✅
          link, // ✅ (without location dest)
          //label, // ✅
          ref, // ✅
          // footnote, // ✅
          math.equation, // ✅
          highlight, // ✅
          align, //
          strike, //
          // footnote.entry //
          // table, //
          terms, //
          figure, //
        ): it => {
          context {
            let label = it.at("label", default: none)
            if label == none {
              return it
            }
            if it.func() == heading {
              return heading(
                bookmarked: it.bookmarked,
                depth: it.depth,
                hanging-indent: it.hanging-indent,
                level: it.level,
                numbering: it.numbering,
                offset: it.offset,
                outlined: it.outlined,
                supplement: it.supplement,
              )[#it.body #anchor(str(label))]
            }

            [#it #anchor(str(label))]
          }
        }
        #body
      ],
    )
  ]
}


// Embed
// sidebar: only_title | full | none
// heading_level: child | peer | exact heading level(1-6)
#let embed(slug, open: true, sidebar: "full", heading_level: "child") = {
  context {
    if target() != "html" {
      return pdf.embed(slug)
    }
    let headings = query(selector(heading).before(here()))
    let headings_len = headings.len()
    let last_heading_level = type => {
      if headings_len > 0 {
        let level = headings.at(headings_len - 1).level
        if type == "child" {
          level + 1
        } else if type == "peer" {
          level
        } else {
          level
        }
      } else { 0 }
    }
    let heading_level = last_heading_level(heading_level)
    html.elem(
      "embed",
      attrs: (
        slug: str(slug),
        open: bool_to_str(open),
        sidebar: sidebar,
        heading_level: str(heading_level),
      ),
    )[ ]
  }
}


#let cite-title(slug) = context {
  if target() == "html" {
    box[
      #html.elem("rewrite", attrs: (id: "cite-with-title", slug: str(slug)))[]
    ]
  } else {
    []
  }
}

#let cite(slug, anchor: "", content) = context {
  if target() == "html" {
    box[
      #html.elem("rewrite", attrs: (id: "cite", slug: str(slug), anchor: anchor), content)
    ]
  } else {
    content
  }
}

// MetaContent

#let title(content) = context {
  if target() == "html" {
    html.elem("metacontent", attrs: ("set": "title"), content)
  } else {
    content
  }
}

#let page_title(content) = context {
  if target() == "html" {
    html.elem("metacontent", attrs: ("set": "page-title"), content)
  } else {
    content
  }
}

#let taxon(content) = context {
  if target() == "html" {
    html.elem("metacontent", attrs: ("set": "taxon"), content)
  } else {
    content
  }
}

#let date(content) = context {
  if target() == "html" {
    html.elem("metacontent", attrs: ("set": "date"), content)
  } else {
    content
  }
}

#let author(content) = context {
  if target() == "html" {
    html.elem("metacontent", attrs: ("set": "author"), content)
  } else {
    content
  }
}

#let set_metacontent(meta_key, content) = context {
  if target() == "html" {
    html.elem("metacontent", attrs: ("set": meta_key), content)
  } else {
    content
  }
}

#let metacontent(meta_key, from: "$self") = context {
  if target() == "html" {
    box[#html.elem("metacontent", attrs: ("get": meta_key, from: from))]
  } else {
    content
  }
}

// MetaOptions

// type: none | bullet | roman | alphabet
#let heading_numbering(type) = context {
  if target() == "html" {
    html.elem("metaoptions", attrs: (key: "heading_numbering", value: type))[ ]
  } else {
    content
  }
}

//type: "full" | "only_embed"
#let sidebar(type) = context {
  if target() == "html" {
    html.elem("metaoptions", attrs: (key: "sidebar", value: type))[ ]
  } else {
    content
  }
}

// MetaGraph


#let parent(slug) = context {
  if target() == "html" {
    html.elem("metagraph", attrs: (key: "parent", slug: slug))[ ]
  } else {
    content
  }
}
