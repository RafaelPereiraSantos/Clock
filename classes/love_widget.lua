local love_widget = {}
local button = require("classes.button")
local container = require("classes.container")
local helpers = require("utils.helpers")

love_widget.buttons = {}


love_widget.update = function(dt)
  for _, v in ipairs(love_widget.buttons) do
    v:update(dt)
  end
end

love_widget.draw = function(gc)
  for _, v in ipairs(love_widget.buttons) do
    v:draw(gc)
  end
end

love_widget.click_over = function(mouse)
  if mouse.isDown("l") then

    local pos_x = mouse.getX()
    local pos_y = mouse.getY()

    if love_widget.selected == nil then
      local remove = nil
      local temp_table = helpers.reverse_table(love_widget.buttons)

      -- revese the widgets list in order to click over the widget at the top of the list, respectively the widget
      -- that will be draw in the first plan

      for k, v in ipairs(temp_table) do
        if v:clicked_on(pos_x, pos_y) then
          love_widget.selected = v
          remove = k
          break
        end
      end
      if remove ~= nil then

        -- reverse it back after click over the correct one to not messy with the order that will be draw

        table.remove(temp_table, remove)
        love_widget.buttons = temp_table
        table.insert(love_widget.all, love_widget.selected)
      end

    else
      love_widget.selected:change_position_center_based(pos_x, pos_y)
    end
  else
    love_widget.selected = nil
  end
end

love_widget.new_button = function(pos_x, pos_y, width, height, text, normal_color, pressed_color)
  local new_button = button.new(pos_x, pos_y, width, height, text, normal_color, pressed_color)

  table.insert(love_widget.buttons, new_button) 

  return new_button
end

return love_widget