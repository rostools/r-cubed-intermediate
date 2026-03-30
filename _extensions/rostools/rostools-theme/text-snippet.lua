local review_note = [[
::: {.callout-note appearance="minimal" collapse="true"}
## :teacher: Teacher note

Before beginning, get them to recall what they remember of the previous
session, either with something like Mentimeter, verbally, or using hands
/ stickies / origami hats. Preferably something that will allow everyone
to participate, not just the ones who are more comfortable being vocal
to the whole group.

Depending on what they write, you may need to briefly go over the previous
session.
:::
]]

local sticky_up = [[
::: {.callout-caution appearance="minimal"}
## Sticky/hat up!

When you're ready to continue, place the sticky/paper hat on your
computer to indicate this to the teacher :womans_hat: :tophat:
:::
]]

local faq_text = [[
Throughout the many times we've taught this and other workshops we
get asked a lot of questions. We have a [Frequently Asked
Questions](https://guides.rostools.org/faq) page for keeping track of
some of these questions. Check out this page, maybe your question has
already been answered!
]]

local wip = [[
::: {.callout-warning appearance="default"}
🚧 This section is being actively worked on. 🚧
:::
]]


function text_snippet(args)
  local snippet_type = pandoc.utils.stringify(args[1])

  if snippet_type == "review_note" then
    return quarto.utils.string_to_blocks(review_note)
  elseif snippet_type == "sticky_up" then
    return quarto.utils.string_to_blocks(sticky_up)
  elseif snippet_type == "wip" then
    return quarto.utils.string_to_blocks(wip)
  elseif snippet_type == "faq_text" then
    return quarto.utils.string_to_blocks(faq_text)
  end
end
