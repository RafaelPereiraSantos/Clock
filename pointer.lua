local vector = require("vector")

local pointer = {}

pointer.SECOND = 1
pointer.MINUTE = 60 * pointer.SECOND
pointer.HOUR = 60 * pointer.MINUTE
pointer.DAY = 24 * pointer.HOUR

function pointer.new(v, max_time_in_seconds, current_time_in_seconds, color)
  local new_pointer = {}

  new_pointer.vector = v
  new_pointer.max_time = max_time
  new_pointer.max_time_in_seconds = max_time_in_seconds
  new_pointer.current_time_in_seconds = current_time_in_seconds
  new_pointer.color = color

  new_pointer.update = function(self, dt)
    local new_time = self.current_time_in_seconds + dt

    if new_time >= self.max_time_in_seconds then
      new_time = 0
    end

    self.current_time_in_seconds = new_time

    local angle = new_time * (vector.ANGLE_MAX_BOUND / self.max_time_in_seconds)
    self.vector.angle = angle
  end

  new_pointer.draw = function(self, g)
    self.vector:draw(g, self.color)
  end

  return new_pointer
end

return pointer