---------------------------------------------------------------------------
--
--  PlayState.lua 
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

-- Extends BaseState (Inheritance)
PlayState = Class{__includes = BaseState}

--[[
    All of the update that was being done in the update function in main.lua is done here know, so Bird physics, pipe spawn, despawn and movement
]]

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    -- now keep track of our score
    self.score = 0

    --[[
        When the game starts, generate a random Y that decides where the first pairPipes will spawn, throughout the code, this value changes, storing the last y value and using it to create a new y value a little different 
    ]]
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- Update timer for pipe spawning
    self.timer = self.timer + dt

        -- Spawn a pipe if the timer is past 2 seconds
    if self.timer > 2.5 then
        --[[
            Modify the last Y coordinate we placed so pipe gaps aren't too far apart, no higher than 10 below the top edge of the screen, and no lower than a gap length (90 pixels) from the bottom
        ]]
        local y = math.max(-PIPE_HEIGHT + 10, 
        math.min(self.lastY + math.random(-80, 80), 
        VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))

        -- Reset timer
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        -- Score a point if the bird is past the pipe and ignore if it's already recorded as scored
        if not pair.scored then
            if pair.x < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end

        -- Update pair each frame
        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    -- Collision between bird and pipes
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- If the bird collides with the ground, restart
    if self.bird.y + 20 > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end
