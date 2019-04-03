local container = {}
local widget = require("classes.widget")

function container.new(widget_to_hold)
  local new_container = widget.new(widget_to_hold.pos_x,
                                   widget_to_hold.pos_y,
                                   widget_to_hold.width,
                                   widget_to_hold.height)

  new_container.widget_held = widget_to_hold or nil
  new_container.debugger_mode = false

  new_container.update = function(self, dt)
    if self:is_holding_something() then
      self.widget_held:update(dt)
    end
  end

  new_container.draw = function(self, gc)
    if self:is_holding_something() then
      self.object_held:draw(gc)
    end

    if new_container.debugger_mode then
      gc.setColor(color.YELLOW)
      gc.rectangle("line", self.pos_x, self.pos_y, (self.pos_x + self.width), (self.pos_y +  self.height))
    end
  end

  new_container.center_position = function(self)
    local pos_x_center = self.pos_x + self.width / 2
    local pos_y_center = self.pos_y + self.height / 2

    return { x = pos_x_center, y = pos_y_center}
  end

  new_container.update_widget_held_position = function(self)
    local new_x_pos = self.pos_x + (self.width / 2)
    local new_y_pos = self.pos_y + (self.height / 2)

    if self:is_holding_something() then
      self.widget_held:change_position(new_x_pos, new_y_pos)
    end
  end

  new_container.change_position_center_based = function(self, new_x_pos, new_y_pos)
    local pos_x = new_x_pos - (self.width / 2)
    local pos_y = new_y_pos - (self.height / 2)
    self:change_position(pos_x, pos_y)
    self:after_change_position()
  end

  new_container.change_position_click_based = function(self, new_x_pos, new_y_pos)
    local pos_x = new_x_pos - (self.width / 2)
    local pos_y = new_y_pos - (self.height / 2)
    self:change_position(pos_x, pos_y)
    self:after_change_position()
  end

  new_container.after_change_position = function(self)
    new_container:update_widget_held_position()
  end

  new_container.is_holding_something = function(self)
    return self.widget_held ~= nil
  end

  new_container.clicked_on = function(self, click_x_pos, click_y_pos)

  local w_start_x_pos = object.pos_x
  local w_start_y_pos = object.pos_y
  local w_end_x_pos = w_start_x_pos + object.width
  local w_end_y_pos = w_start_y_pos + object.height

  local over_horizontal_area = w_start_x_pos <= click_x_pos and click_x_pos <= w_end_x_pos
  local over_vertical_area = w_start_y_pos <= click_y_pos and click_y_pos <= w_end_y_pos

  return over_horizontal_area and over_vertical_area
end

  new_container:update_widget_held_position()

  return new_container
end

return container