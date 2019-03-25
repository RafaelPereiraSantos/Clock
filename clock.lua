local clock = {}

local pointer = require("pointer")
local vector = require("vector")

clock.SECOND = 1
clock.MINUTE = 60 * clock.SECOND
clock.HOUR = 60 * clock.MINUTE
clock.DAY = 12 * clock.HOUR -- 12 to work with analogic clock that doesn't has 24 numbers

clock.minutes_to_seconds = function(minutes)
  return minutes * clock.MINUTE
end

clock.hours_to_seconds = function(hours)
  return hours * clock.HOUR
end

function clock.new(current_hour, current_minute, current_second, pos_x, pos_y)
  local new_clock = {}

  new_clock.pos_x = pos_x
  new_clock.pos_y = pos_y

  local v = vector.new(pos_x, pos_y, 100, 0)
  new_clock.second_pointer = pointer.new(v, clock.MINUTE, current_second, { r=255, g=0, b=0 })

  v = vector.new(pos_x, pos_y, 75, 0)
  new_clock.minute_pointer = pointer.new(v, clock.HOUR, clock.minutes_to_seconds(current_minute), { r=0, g=255, b=0 })

  if current_hour > 12 then
    current_hour =  current_hour % 12
  end

  v = vector.new(pos_x, pos_y, 50, 0)
  new_clock.hour_pointer = pointer.new(v, clock.DAY, clock.hours_to_seconds(current_hour), { r=0, g=0, b=255 })

  new_clock.update = function(self, dt)
    self.second_pointer:update(dt)
    self.minute_pointer:update(dt)
    self.hour_pointer:update(dt)
  end

  new_clock.draw = function(self, g)
    g.setColor(255, 255, 255)
    g.circle("fill", self.pos_x, self.pos_y, 120)

    g.setColor(0, 0, 0)

    local hours = 12
    local radio = vector.ANGLE_MAX_BOUND / hours
    for hour = 1, hours, 1 do
      local point =  vector.vector_end_point(self.pos_x, self.pos_y, 100, (radio * hour))

      local font = g.getFont()
      local text_width = font:getWidth(tostring(hour))
      local text_height = font:getHeight(tostring(hour))

      local x = point.x - (text_width / 2)
      local y = point.y - (text_height / 2)

      g.print(hour, x, y)
    end

    self.second_pointer:draw(g)
    self.minute_pointer:draw(g)
    self.hour_pointer:draw(g)
  end

  return new_clock
end

return clock