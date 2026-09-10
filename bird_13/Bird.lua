---------------------------------------------------------------------------
--
--  Bird.lua
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

Bird = Class{}

local GRAVITY = 980
local rotationSpeed = 0.10
rotation = 0

function Bird:init()
    -- Load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.rotation = 0

    -- Position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2

    -- Y velocity
    self.dy = 0
end

function Bird:collides(pipe)
    --[[
        The 2's are left an top offsets, the 4's are right and bottom offsets, the offsets are used to shrink the collision box, and make it less punishing for the player

        (self.x + 3) + (self.width - 6) - Right edge of the Bird
        (self.x + 2) - Left edge of the bird

        (self.y + 3) + (self.height - 5) - Bottom part of the Bird
        (self.y + 2) - Top part of the Bird
    ]]
    if (self.x + ((self.width / 2) - 5)) >= pipe.x and (self.x - ((self.width / 2) - 5)) <= pipe.x + PIPE_WIDTH then
        if (self.y + ((self.height / 2) - 3)) >= pipe.y and (self.y - ((self.height / 2) - 3)) <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    -- Apply gravity to velocity in Y-axis
    self.dy = self.dy + GRAVITY * dt

    -- Add a sudden burst of negative gravity if we hit space
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -250
        gSounds['jump']:play()
    end

    -- Apply gravity through the velocity in dy
    self.y = self.y + self.dy * dt
    self.rotation = self.dy / 80  * rotationSpeed
    rotation = self.rotation
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y, self.rotation, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.rectangle('line', self.x - (self.width / 2 - 5), self.y - (self.height / 2 - 3), self.width - 10, self.height - 6)
end