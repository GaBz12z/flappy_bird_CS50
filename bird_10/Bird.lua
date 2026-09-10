---------------------------------------------------------------------------
--
--  Bird.lua
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

Bird = Class{}

local GRAVITY = 980

function Bird:init()
    -- Load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Y velocity
    self.dy = 0
end

function Bird:collides(pipe)
    --[[
        The 2's are left an top offsets, the 4's are right and bottom offsets, the offsets are used to shrink the collision box, and make it less punishing for the player
    ]]
    if (self.x + 3) + (self.width - 6) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 3) + (self.height - 5) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    -- Apply gravity to velocity in Y-axis
    self.dy = self.dy + GRAVITY * dt

    -- Add a sudden burst of negative gravity if we hit space
    if love.keyboard.wasPressed('space') then
        self.dy = -250
    end

    -- Apply gravity through the velocity in dy
    self.y = self.y + self.dy * dt
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end