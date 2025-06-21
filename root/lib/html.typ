#import "@local/typsite:0.1.0": html-bindings as _html, to-str
#import _html: *

/// Creates a text decoration element.
///
/// - decoration (str): overline | underline | line-through | "$decoration $decoration"
///     The text decoration to apply, i.e. "overline", "overline underline"
/// - content (content):
///     The content to be decorated.
/// -> HTML with text-decoration style
#let text-decoration(decoration, content) = {
  if target() != "html" {
    let frame(content) = content
    if decoration.contains("overline") {
      frame = content => overline(frame(content))
    }
    if decoration.contains("underline") {
      frame = content => underline(frame(content))
    }
    frame(content)
  }
  span(style: "text-decoration: " + str(decoration) + ";", content)
}

/// Creates a highlight element with a background color.
///
/// - color (color):
///     The background color to apply to the text.
/// - attrs (..):
///     Additional attributes to apply to the HTML element.
/// - content (content):
///     The content to be highlighted.
/// -> HTML with background color style
#let mark(color, ..attrs, content) = context {
  if target() != "html" {
    return std.highlight(fill: color, content)
  }
  tag("mark", style: "background: " + color.to-hex() + ";", ..attrs, content)
}

/// Creates a text element with font styles applied.
///
/// - font (str):
///     The font family to use for the text.
/// - style (str): "normal", "italic", "oblique"
///     The font style to apply
/// - weight (str):  "regular", "bold", "bolder", "lighter"
///     The font weight to apply
/// - size (ratio | length):
///     The font size to apply, as a ratio of the default size (e.g., 100% for default size).
/// - fill (color):
///     The text color to apply, as a color value.
/// - tracking (length):
///     The letter spacing to apply, as a length value (e.g., 0pt for no tracking).
/// - spacing (length):
///     The word spacing to apply, as a length value (e.g., 0pt for no spacing).
/// - content (content):
///    The content to be styled with the specified font properties.
/// -> HTML with font styles applied
#let text(
  font: none,
  style: "normal",
  weight: "regular",
  size: 100%,
  fill: none,
  tracking: 0pt,
  spacing: 0pt + 100%,
  content,
) = context {
  let text-size = if type(size) == ratio {
    11pt * size
  } else if type(size) == length {
    size * 0.75
  } else {
    panic("Invalid type " + type(size) + " for size: " + to-str([#size]))
  }
  let content = std.text(
    style: style,
    weight: weight,
    size: text-size,
    tracking: tracking,
    spacing: spacing,
    content,
  )
  if target() != "html" {
    return content
  }
  let styles = ()
  styles.push("vertical-align: baseline;")
  if font != none {
    styles.push("font: " + font + ";")
  }
  if style != "normal" {
    styles.push("font-style: " + to-str([#style]) + ";")
  }
  if weight != "regular" {
    styles.push("font-weight: " + to-str([#weight]) + ";")
  }
  if size != 100% {
    styles.push("font-size: " + to-str([#size]) + ";")
  }
  if fill != none {
    styles.push("color: " + fill.to-hex() + ";")
  }
  if tracking != 0pt {
    styles.push("letter-spacing: " + to-str([#tracking]) + ";")
  }
  if spacing != 100% + 0pt {
    styles.push("word-spacing: " + to-str([#spacing]) + ";")
  }
  span(style: styles.join(" "), content)
}

/// Creates an HTML element with text alignment applied.
///
/// - alignment (horizontal-aligment): "left" | "center" | "right" | none
///     The horizontal alignment of the content. if none then returns the content as is.
/// - content (content):
///     The content to be aligned.
/// -> HTML with text alignment applied
#let align(alignment, content) = context {
  if target() != "html" {
    return std.align(alignment, content)
  }
  if alignment == none {
    return content
  }
  let horizontally = if alignment == none { "left" } else if alignment == center { "center" } else if (
    alignment == left
  ) { "left" } else if alignment == right { "right" } else if alignment.x == center { "center" } else if (
    alignment.x == right
  ) { "right" } else { "left" }
  div(style: "text-align: " + horizontally + ";", content)
}
