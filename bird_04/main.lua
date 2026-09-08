---------------------------------------------------------------------------
--
--  main.lua - Using input to make the bird fly
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

--[[
    Loads an image from a graphics file in an object from a specific path

    love.graphics.newImage(path)

    end
]]

-- Referecing push to create cirtual canvas
push = require 'push'

-- Referencing class to deal with POO
Class = require 'class'

-- Bird class
require 'Bird'

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
local BACKGROUND_LOOPING_POINT = 413
local BACKGROUND_2_LOOPING_POINT = 384

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
    backgroundScroll_2 = (backgroundScroll_2 + BACKGROUND_2_SCROLL_SPEED * dt) % BACKGROUND_2_LOOPING_POINT

    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- Adding gravity to the bird sprite
    bird:update(dt)

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

    -- Draw the ground on top of the background, towards the bottom of the screen, at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:apply('end')
end