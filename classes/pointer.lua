local vector = require("classes.vector")
local object = require("classes.object")

local pointer = {}

function pointer.new(pos_x, pos_y, size, max_time, start_time, color)
  local new_pointer = object.new(pos_x, pos_y)

  new_pointer.vector = vector.new(size, 0)

  new_pointer.max_time = max_time
  new_pointer.current_time = start_time

  new_pointer.color = color

  new_pointer.update = function(self, dt)
  end

  new_pointer.update_time = function(self, time)
    local new_time = self.current_time + time

    if new_time >= self.max_time then
      self.on_cycle_end()
      new_time = 0
    end

    self.current_time = new_time
  end

  new_pointer.update_vector = function(self)
    local angle = self.current_time * (vector.ANGLE_MAX_BOUND / self.max_time)
    self.vector.angle = angle
  end

  new_pointer.update_start_position = function(self, new_x_pos, new_y_pos)
    self.pos_x = new_x_pos
    self.pos_y = new_y_pos
  end

  new_pointer.draw = function(self, g)
    self.vector:draw(g, self.color, self.pos_x, self.pos_y)
  end

  new_pointer.on_cycle_end = function()
  end

  new_pointer:update_vector()

  return new_pointer
end

return pointer