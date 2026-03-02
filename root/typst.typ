
#import "/lib/lib.typ": *

#show : schema.with("page")


#title[Typst 简介]
#date[2025-04-27 18:39]
#author[Glomzzz]
#parent("index.typ")

Typst 是一种现代化的排版系统，类似于 LaTeX，但设计更为简洁、易学，它主要用于创建学术论文、书籍、报告等需要精美排版的文档。

你可以在这里查看其官方英文文档：#link("https://typst.app/docs/")[Typst Document];  \
对于Typst的中文教程，我强烈推荐：#link("https://typst-doc-cn.github.io/tutorial/introduction.html")[Typst 蓝书]
#note[\[天呐，这位编者非常清楚地知道自己是在阐述一套*本体论*!\]].

\
#html.align(center)[

  #html.text(size: 52pt, weight: "bold", fill: rgb("#22D3EE"))[Typst]
  \
  \
  #html.text(size: 38pt, fill: rgb("#22D3EE"))[🔥*已经崛起了!*🔥]
  \
  \
  \
  \
  \

  #html.text(size: 22pt, style: "italic", fill: red)[🚀这TeX人没收到通知吗？🚀]
  \
  \
]

\


此节的剩余部分将会介绍 *Typst & HTML -> Typsite*

== Typst 的 HTML 导出功能

Typst 于 `0.13` 增加了 #link("https://typst.app/docs/reference/html/")[HTML 导出功能]，包括 *html-export* 模式以及两个核心函数：#link("https://typst.app/docs/reference/html/elem/")[`html.elem`] 和 #link("https://typst.app/docs/reference/html/frame/")[`html.frame`] —— 我们可以利用这些函数来基于 Typst 编写以HTML+CSS为目标内容。

== Typsite：基于 Typst 的静态站点生成器

受此启发，我用 *Rust* 开发了名为 #link("https://github.com/Glomzzz/typsite")[Typsite] 的静态站点生成器.

目前，Typst 的 HTML 导出:
- 对简单富文本已有良好支持
- 复杂样式需要用户通过 `html.elem` 函数手动编写
- 无法自动将所有 Typst 生态内容转换为 HTML
- 对于包含复杂 Typst 样式的内容，可以使用 `html.frame` 将其转为 SVG 并嵌入 HTML
- 对于每一次 compile, 只支持单文件 HTML 输出

对于详细的已支持内容与计划可以追踪这个issue: #link("https://github.com/typst/typst/issues/5512")[HTML export \#5512]

虽然官方有计划支持*自动 typst style -> HTML+CSS*，但这并不会与 Typsite 产生任何冲突。
_*恰恰相反*_，Typst 的发展将使 Typsite 更加实用，因为 *Typsite 主要职能是协调文章间的交互，并最终构建一套功能完善的静态网站*。
