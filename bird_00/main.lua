---------------------------------------------------------------------------
--
--  main.lua - Creating a canvas
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

-- Window proportions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual window proportions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

function love.load()
    -- Point filtering
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Images loaded in a object to create background and ground
    background = love.graphics.newImage('background.png')
    ground = love.graphics.newImage('ground.png')

    love.window.setTitle('Flappy Bird in Lua')

    -- Create the virtual canvas
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')

    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    push:apply('end')
end