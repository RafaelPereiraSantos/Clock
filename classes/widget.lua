local widget = {}
local object = require("classes.object")
local color = require("utils.color")
local helpers = require("utils.helpers")

widget.all = {}
widget.selected = nil

widget.update = function(dt)
  for _, v in ipairs(widget.all) do
    v:update(dt)
  end
end

widget.draw = function(gc)
  for _, v in ipairs(widget.all) do
    v:draw(gc)
  end
end

widget.click_over = function(mouse)
  if mouse.isDown("l") then

    local pos_x = mouse.getX()
    local pos_y = mouse.getY()

    if widget.selected == nil then
      local remove = nil
      local temp_table = helpers.reverse_table(widget.all)

      -- revese the widgets list in order to click over the widget at the top of the list, respectively the widget
      -- that will be draw in the first plan

      for k, v in ipairs(temp_table) do
        if widget.clicked_on(v, pos_x, pos_y) then
          widget.selected = v
          remove = k
          break
        end
      end
      if remove ~= nil then

        -- reverse it back after click over the correct one to not messy with the order that will be draw

        table.remove(temp_table, remove)
        widget.all = temp_table
        table.insert(widget.all, widget.selected)
      end

    else
      widget.selected:change_position_center_based(pos_x, pos_y)
    end
  else
    widget.selected = nil
  end
end

widget.clicked_on = function(object, click_x_pos, click_y_pos)

  local w_start_x_pos = object.pos_x
  local w_start_y_pos = object.pos_y
  local w_end_x_pos = w_start_x_pos + object.width
  local w_end_y_pos = w_start_y_pos + object.height

  local over_horizontal_area = w_start_x_pos <= click_x_pos and click_x_pos <= w_end_x_pos
  local over_vertical_area = w_start_y_pos <= click_y_pos and click_y_pos <= w_end_y_pos

  return over_horizontal_area and over_vertical_area
end

function widget.new(pos_x, pos_y, width, height, object_to_hold)
  local new_widget = object.new(pos_x, pos_y, width, height)

  new_widget.object_held = object_to_hold
  new_widget.debugger_mode = false

  new_widget.update = function(self, dt)
    self.object_held:update(dt)
  end

  new_widget.draw = function(self, g)
    self.object_held:draw(g)

    if new_widget.debugger_mode then
      g.setColor(color.YELLOW)
      g.rectangle("line",self.pos_x, self.pos_y, self.width, self.height)
    end
  end

  new_widget.center_position = function(self)
    local pos_x_center = self.pos_x + self.width / 2
    local pos_y_center = self.pos_y + self.height / 2

    return { x = pos_x_center, y = pos_y_center}
  end

  new_widget.update_object_held_position = function(self)
    local new_x_pos = self.pos_x + (self.width / 2)
    local new_y_pos = self.pos_y + (self.height / 2)

    self.object_held:change_position(new_x_pos, new_y_pos)
  end

  new_widget.change_position_center_based = function(self, new_x_pos, new_y_pos)
    local pos_x = new_x_pos - (self.width / 2)
    local pos_y = new_y_pos - (self.height / 2)
    self:change_position(pos_x, pos_y)
    self:after_change_position()
  end

  new_widget.change_position_click_based = function(self, new_x_pos, new_y_pos)
    local pos_x = new_x_pos - (self.width / 2)
    local pos_y = new_y_pos - (self.height / 2)
    self:change_position(pos_x, pos_y)
    self:after_change_position()
  end

  new_widget.after_change_position = function(self)
    new_widget:update_object_held_position()
  end

  new_widget:update_object_held_position()

  table.insert(widget.all, new_widget)
  return new_widget
end

return widget