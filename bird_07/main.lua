---------------------------------------------------------------------------
--
--  main.lua - Collision update
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

--[[
    Loads an image from a graphics file in an object from a specific path

    love.graphics.newImage(path)

    end
]]

-- transform.rotation = Quaternion.Euler(0, 0, rb.velocity.y * rotationSpeed);

-- Referecing push to create cirtual canvas
push = require 'push'

-- Referencing class to deal with POO
Class = require 'class'

-- Bird class
require 'Bird'

-- Pipe class
require 'Pipe'

-- PipePair class
require 'PipePair'

-- Window proportions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual window proportions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Ground and background starting scroll location on the x-axis
local backgroundScroll_2 = 0
local backgroundScroll = 0
local groundScroll = 0

-- Speed at which the sprites will move
local BACKGROUND_2_SCROLL_SPEED = 25
local BACKGROUND_SCROLL_SPEED = 35
local GROUND_SCROLL_SPEED = 50


-- Dimension in the sprite where the code loops the background 
local BACKGROUND_LOOPING_POINT = 288
local BACKGROUND_2_LOOPING_POINT = 288

-- Table to spawn pipes (array)
local pipePairs = {}

-- Timer to spawn the pipes
local spawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

local scrolling = true

function love.load()
    -- Point filtering
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Images loaded in a object to create background and ground
    background_2 = love.graphics.newImage('background-2.png')
    background = love.graphics.newImage('background.png')
    ground = love.graphics.newImage('ground.png')

    -- Loading the bird.png image
    bird = Bird()

    love.window.setTitle('Flappy Bird in Lua')

    -- Create the virtual canvas
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- Initialize input table, you can add any table that you wnat
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)
    -- Add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    Used to store any key that is fired at that frame, is a extensions inside love.keyboard space
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.update(dt)
    if scrolling then
        backgroundScroll_2 = (backgroundScroll_2 + BACKGROUND_2_SCROLL_SPEED * dt) % BACKGROUND_2_LOOPING_POINT

        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        spawnTimer = spawnTimer + dt

        -- Spawn a pipe if the timer is past 2 seconds
        if spawnTimer > 2.5 then
            --[[
                Modify the last Y coordinate we placed so pipe gaps aren't too far apart, no higher than 10 below the top edge of the screen, and no lower than a gap length (90 pixels) from the bottom
            ]]
            local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-80, 80), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT))
            lastY = y

            -- Basically and .append in python
            table.insert(pipePairs, PipePair(y))
            spawnTimer = 0
        end

        -- Adding gravity to the bird sprite
        bird:update(dt)

        --[[
            Similar to python: k, pipe is basically k = 1, pipe = pipe object in index 1, this two came in pairs.
        ]]
        for k, pair in pairs(pipePairs) do
            pair:update(dt)

            --[[
                Checks to see if the bird collided with the paired pipes
            ]]
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    scrolling = false
                end
            end

            if pair.x < -PIPE_WIDTH then
                pair.remove = true
            end
        end

        --[[
            Remove any flagged pipes, we need this second loop, rather than deleting in the previous loop, because modifying the table in-place without explicit keys will result in skipping the next pipte, since all implicit keys (numerical indices) are automatically shifted down after a table removal
        ]]
        for k, pair in pairs(pipePairs) do
            if pair.remove then
                -- Garbage collector
                table.remove(pipePairs, k)
            end
        end
    end

    -- Reset input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:apply('start')

    --[[
        We draw our images shifted to the left by their looping point, eventually they will revert to 0 once both values in % are equal, the division will be = 0 and the images will be reverted to their x = 0
    ]]

    -- Draw the background at the negative looping point
    love.graphics.draw(background_2, -backgroundScroll_2, 0)

    -- Draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    -- Render all the pipes in our scene
    for k, pair in pairs(pipePairs) do
        pair:render()
    end
 
    -- Draw the ground on top of the background, towards the bottom of the screen, at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:apply('end')
end