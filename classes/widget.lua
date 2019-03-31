local widget = {}
local color = require("utils.color")
local object = require("classes.object")

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

  return new_widget
end

return widget