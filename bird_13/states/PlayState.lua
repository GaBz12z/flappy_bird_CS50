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

highScore = 0

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    math.randomseed(os.time())

    -- now keep track of our score
    self.score = 0

    self.spawnTiming = 0

    self.gap_height = 0

    --[[
        When the game starts, generate a random Y that decides where the first pairPipes will spawn, throughout the code, this value changes, storing the last y value and using it to create a new y value a little different 
    ]]
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- Update timer for pipe spawning
    self.timer = self.timer + dt

    --[[
        The timer is initialized to 0 in 'PlayStat:init()', and every time a new pipe is generated, a random value is assigned to the timer, which randomizes the time it takes for a pipe to spawn
    ]]
    if self.timer > self.spawnTiming then
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-80, 80),
            VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        self.gap_height = randomFloatValues(70, 100)
        table.insert(self.pipePairs, PipePair(y, self.gap_height))

        self.timer = 0

        --[[
            Lerp.
            2.5 - Shifts the value beyond 2.5 to respect the interval
            love.math.random() - Generates a float between 0 - 0.99 that multiplies the size of the interval
            (5 - 2.5) - Size of the interval
        ]]
        self.spawnTiming = randomFloatValues(2, 3)
    end

    for k, pair in pairs(self.pipePairs) do
        -- Score a point if the bird is past the pipe and ignore if it's already recorded as scored
        if not pair.scored then
            if pair.x < self.bird.x then
                gSounds['score']:play()
                self.score = self.score + 1
                if self.score > highScore then
                   highScore = highScore + 1 
                end
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
                gSounds['hurt']:play()
                gSounds['explosion']:play()
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- If the bird collides with the ground, restart
    if self.bird.y + 9 > VIRTUAL_HEIGHT - 15 then
        gSounds['hurt']:play()
        gSounds['explosion']:play()
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
    love.graphics.setFont(mediumFont)
    love.graphics.print('HighScore: ' .. tostring(highScore), 8, 44)

    love.graphics.setFont(mediumFont)
    love.graphics.print('Spawn Timer: ' .. string.format('%.3f', self.spawnTiming), 8, 110)
    love.graphics.print('Gap Height: ' .. string.format('%.3f', self.gap_height), 8, 134)
    love.graphics.print('Rotation: ' .. string.format('%.3f', rotation), 8, 158)

    self.bird:render()
end

function randomFloatValues(min, max)
    return min + love.math.random() * (max - min)
end

