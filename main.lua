local clock = require ("classes.clock")
local widget = require ("classes.widget")
local object = require("classes.object")

local gc = love.graphics
local ms = love.mouse

local now = os.date("*t")

local ck01 = clock.new.analog_clock(now.hour, now.min, now.sec, 400, 300)

local w = widget.new(200, 200, 200, 200, ck01)
w.debugger_mode = true

function love.load()
  ck01:show_digital_time()
end

function love.update(dt)
  local left_click = ms.isDown("l")
  local right_click = ms.isDown("r")
  
  if left_click then
    local pos_x = ms.getX()
    local pos_y = ms.getY()

    if object.clicked_on(w, pos_x, pos_y) then
      w:change_position_center_based(pos_x, pos_y)
    end

  end

  local key_down = love.keyboard.isDown

    if key_down("escape") then
      love.event.quit()
    end

  w:update(dt)

end

function love.draw()
  gc.clear()
  w:draw(gc)
end

function love.mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
end