#import "/lib/lib.typ": *

#show: schema.with("page")


#title[Introduction to Typst]
#date[2025-04-27 18:39]
#author[Glomzzz]
#parent("/en/index.typ")

Typst is a modern typesetting system, similar to LaTeX, but designed to be more concise and easier to learn. It is primarily used to create beautifully typeset documents such as academic papers, books, and reports.

You can find the official English documentation here: #link("https://typst.app/docs/")[Typst Document]; \
For a Chinese tutorial on Typst, I highly recommend: #link("https://typst-doc-cn.github.io/tutorial/introduction.html")[The Typst Blue Book] \
(_Oh my, the author is *clearly aware* that they're explaining an *ontology*!_).

\
#html.align(center)[

  #html.text(size: 52pt, weight: "bold", fill: rgb("#22D3EE"))[Typst]
  \
  \
  #html.text(size: 38pt, fill: rgb("#22D3EE"))[🔥*has risen!*🔥]
  \
  \
  \
  \
  \

  #html.text(size: 22pt, style: "italic", fill: red)[🚀Did the TeX folks miss the memo?🚀]
  \
  \
]

\

The rest of this section will introduce *Typst & HTML → Typsite*

== Typst’s HTML Export Feature

In version `0.13`, Typst added #link("https://typst.app/docs/reference/html/")[HTML export capabilities], including an *html-export* mode and two core functions: #link("https://typst.app/docs/reference/html/elem/")[`html.elem`] and #link("https://typst.app/docs/reference/html/frame/")[`html.frame`] — using these, we can write Typst documents targeting HTML+CSS output.

== Typsite: A Static Site Generator Based on Typst

Inspired by this, I developed a static site generator in *Rust* called #link("https://github.com/Glomzzz/typsite")[Typsite].

Currently, Typst’s HTML export:
- Has good support for basic rich text
- Requires users to manually write complex styles using the `html.elem` function
- Cannot automatically convert all Typst ecosystem content into HTML
- For content with complex Typst styles, `html.frame` can be used to convert them into SVG and embed them into HTML
- Only supports single-file HTML output per compilation

For details on supported features and the roadmap, follow this issue: #link("https://github.com/typst/typst/issues/5512")[HTML export \#5512]

Although the official team plans to support *automatic typst style → HTML+CSS* in the future, this won’t conflict with Typsite.
_*On the contrary*_, Typst’s development will make Typsite even more useful, because *Typsite’s main role is to coordinate interaction between articles and ultimately build a fully functional static website*.

