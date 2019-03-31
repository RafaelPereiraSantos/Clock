local vector = {}

vector.ANGLE_MAX_BOUND = 360
vector.ANGLE_MIN_BOUND = 0

vector.vector_end_point = function(start_x_pos, start_y_pos, distance, angle)
  local angle_adjust = 90
  angle = math.rad(angle - angle_adjust)
  local end_x_pos = start_x_pos + (math.cos(angle) * distance)
  local end_y_pos = start_y_pos + (math.sin(angle) * distance)

  return { x=end_x_pos, y=end_y_pos }
end

function vector.new(size, initial_angle)
  local new_vector = {}

  new_vector.size = size or 1
  new_vector.angle = initial_angle or 0

  new_vector.increase_angle = function(self, angle_increase)
    local new_angle = self.angle + angle_increase

    if new_angle > vector.ANGLE_MAX_BOUND then
      new_angle = vector.ANGLE_MIN_BOUND
    end

    if new_angle < vector.ANGLE_MIN_BOUND then
      new_angle = vector.ANGLE_MAX_BOUND
    end

    self.angle = new_angle
  end

  new_vector.draw = function(self, g, color, start_x_pos, start_y_pos)
    local end_pos = vector.vector_end_point(start_x_pos, start_y_pos, self.size, self.angle)

    g.setColor(color)
    g.line(start_x_pos, start_y_pos, end_pos.x, end_pos.y)
  end

  return new_vector
end

return vector