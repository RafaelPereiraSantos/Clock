local clock = {}

local pointer = require("classes.pointer")
local vector = require("classes.vector")
local object = require("classes.object")
local color = require("utils.color")

clock.SECOND = 1
clock.MINUTE = 60 * clock.SECOND
clock.HOUR = 60 * clock.MINUTE
clock.DAY = 24 * clock.HOUR

clock.around = function(value)
  leftover = value % 1
  return value - leftover
end

clock.seconds_to_minutes = function(seconds)
  local minutes = seconds / clock.MINUTE
  local leftover = minutes % 1
  minutes = minutes - leftover
  return minutes
end

clock.seconds_to_hours = function(seconds)
  local hours = seconds / clock.HOUR
  local leftover = hours % 1
  hours = hours - leftover
  return hours
end

clock.minutes_to_seconds = function(minutes)
  return minutes * clock.MINUTE
end

clock.hours_to_seconds = function(hours)
  return hours * clock.HOUR
end

clock.format_digital_clock = function(hours, minutes, seconds)
  local formatted_seconds = seconds .. ""

  if string.len(formatted_seconds) < 2 then
    formatted_seconds = "0" .. formatted_seconds
  end

  local formatted_minutes = minutes .. ""

  if string.len(formatted_minutes) < 2 then
    formatted_minutes = "0" .. formatted_minutes
  end

  local formatted_hours = hours .. ""

  if string.len(formatted_hours) < 2 then
    formatted_hours = "0" .. formatted_hours
  end

  return formatted_hours .. ":" .. formatted_minutes .. ":" .. formatted_seconds
end

clock.new = {}

function clock.new.analog_clock(current_hour, current_minute, current_second, pos_x, pos_y)
  local new_clock = object.new(pos_x, pos_y, 0, 0)

  new_clock.digital_version = false

  new_clock.pos_x = pos_x
  new_clock.pos_y = pos_y
  new_clock.radio = 120

  new_clock.time_factor = 1
  new_clock.twenty_four_hours = false

  new_clock.second_pointer = pointer.new(pos_x, pos_y, 100, clock.MINUTE, current_second, color.RED)

  local current_minute_in_seconds = clock.minutes_to_seconds(current_minute)
  new_clock.minute_pointer = pointer.new(pos_x, pos_y, 75, clock.HOUR, current_minute_in_seconds, color.GREEN)

  if current_hour > 12 then
    new_clock.twenty_four_hours = true
    current_hour =  current_hour % 12
  end

  local current_hour_in_seconds = clock.hours_to_seconds(current_hour)
  new_clock.hour_pointer = pointer.new(pos_x, pos_y, 50, clock.DAY / 2, current_hour_in_seconds, color.BLUE)
  new_clock.hour_pointer.on_cycle_end = function()
    new_clock.twenty_four_hours = not new_clock.twenty_four_hours
  end

  new_clock.update = function(self, dt)

    local passed_time = dt * self.time_factor

    self.second_pointer:update_time(passed_time)
    self.second_pointer:update_vector()

    self.minute_pointer:update_time(passed_time)
    self.minute_pointer:update_vector()

    self.hour_pointer:update_time(passed_time)
    self.hour_pointer:update_vector()
  end

  new_clock.draw = function(self, g)
    local font = g.getFont()

    g.setColor(color.WHITE)
    g.circle("fill", self.pos_x, self.pos_y, self.radio)

    if self.digital_version then
      local digital_time = clock.format_digital_clock(
                             clock.seconds_to_hours(self.hour_pointer.current_time),
                             clock.seconds_to_minutes(self.minute_pointer.current_time),
                             clock.around(self.second_pointer.current_time)
                            )
      local text_width = font:getWidth(tostring(digital_time))
      g.print(digital_time, self.pos_x - (text_width / 2), self.pos_y + self.radio + 10)
    end

    g.setColor(color.BLACK)

    local hours = 12
    local radio = vector.ANGLE_MAX_BOUND / hours
    for hour = 1, hours, 1 do
      local point =  vector.vector_end_point(self.pos_x, self.pos_y, 100, (radio * hour))

      local text_width = font:getWidth(tostring(hour))
      local text_height = font:getHeight(tostring(hour))

      local x = point.x - (text_width / 2)
      local y = point.y - (text_height / 2)

      if self.twenty_four_hours then
        hour = hour + 12
      end

      g.print(hour, x, y)
    end

    self.second_pointer:draw(g)
    self.minute_pointer:draw(g)
    self.hour_pointer:draw(g)
  end

  new_clock.change_time_factor = function(self, new_time_factor)
    self.time_factor = new_time_factor
  end

  new_clock.after_change_position = function(self)
    self.second_pointer:change_position(self.pos_x, self.pos_y)
    self.minute_pointer:change_position(self.pos_x, self.pos_y)
    self.hour_pointer:change_position(self.pos_x, self.pos_y)
  end

  return new_clock
end

return clock