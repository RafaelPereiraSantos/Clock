local button = {}

local object = require("classes.object")

function button.new(pos_x, pos_y, width, height, text, normal_color, pressed_color)
  local new_button = object.new(pos_x, pos_y, width, height)

  new_button.text = text
  new_button.normal_color = normal_color
  new_button.pressed_color = pressed_color

  new_button.on_click_down = function()
  end

  new_button.on_click_up = function()
  end

  return new_button
end