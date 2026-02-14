#!/usr/bin/env fish

set --local layouts fr us
set --local current_layout (setxkbmap -query | rg "layout:\s+(.+)" -r '$1')
set --local switch_next false

for lang in $layouts
  if $switch_next
    setxkbmap $lang
    exit 0
  else if test $lang = $current_layout
    set switch_next true
  end
end

setxkbmap $layouts[1]
