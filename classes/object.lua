local object = {}

object.clicked_on = function(object, click_x_pos, click_y_pos)

  local o_start_x_pos = object.pos_x
  local o_start_y_pos = object.pos_y
  local o_end_x_pos = o_start_x_pos + object.width
  local o_end_y_pos = o_start_y_pos + object.height

  local over_horizontal_area = o_start_x_pos <= click_x_pos and click_x_pos <= o_end_x_pos
  local over_vertical_area = o_start_y_pos <= click_y_pos and click_y_pos <= o_end_y_pos

  return over_horizontal_area and over_vertical_area
end

function object.new(pos_x, pos_y, width, height)
  local new_object = {}

  new_object.pos_x = pos_x
  new_object.pos_y = pos_y
  new_object.width = width
  new_object.height = height

  new_object.change_position = function(self, new_x_pos, new_y_pos)
    self.pos_x = new_x_pos
    self.pos_y = new_y_pos
    self:after_change_position()
  end

  new_object.after_change_position = function(self)
  end

  return new_object
end

return object