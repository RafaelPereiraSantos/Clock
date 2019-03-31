local object = {}

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