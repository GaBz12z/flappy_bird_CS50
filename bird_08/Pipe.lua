---------------------------------------------------------------------------
--
--  Pipe.lua
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- Pipe speed to move rigth to left
PIPE_SPEED = 60

PIPE_HEIGHT = PIPE_IMAGE:getHeight()
PIPE_WIDTH = PIPE_IMAGE:getWidth()

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH

    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

--[[
    if self.orientation == 'top' then
        y position = self.y + PIPE_HEIGHT
    else
        y position = self.y 
    end
]]
function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE, 
        self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 
        1, 
        self.orientation == 'top' and -1 or 1)
end
