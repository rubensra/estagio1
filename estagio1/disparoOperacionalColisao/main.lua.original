-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

system.activate("multitouch") -- Ativando MultiTouch

local _W = display.contentWidth -- Largura total da Tela
local _H = display.contentHeight -- Altura total da Tela
local scrollSpeed = 1 -- Velocidade de movimento do fundo

local died = false -- Variavel para controlar as mortes do jogador

local aliensTable = {} -- Tabela p/ guardar as naves aliens criadas

local js -- Variavel para guardar a referencai ao JoyStick Virtual
local nave -- Variavel para referenciar a Nave

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 

-- Criando e carregando as imagens de fundo para o efeito de movimento --
local fundo = display.newImageRect( backGroup, "images/circuito00_320x480.png", 320, 480 )
fundo.x = display.contentCenterX 
fundo.y = display.contentCenterY
fundo.xScale = 1.0 
fundo.yScale = 1.0

local fundo2 = display.newImageRect( backGroup, "images/circuito00_320x480.png", 320, 480 )
fundo2.x = display.contentCenterX
fundo2.y = display.contentCenterY - display.actualContentHeight
fundo2.xScale = 1.0
fundo2.yScale = 1.0
------------------------------------------------------------------------

-- Folha de sprites das naves e seus tiros --
local naveSheetOptions = 
{
    frames = {
    
        {
            -- nave_pinguim-70x80
            x=0,
            y=0,
            width=70,
            height=80,
        },
        {
            -- nave_janela-70x80
            x=70,
            y=0,
            width=70,
            height=80,
        },
        {
            -- nave_maça-70x80
            x=140,
            y=0,
            width=70,
            height=80,
        },
        {
            -- raio_nave_pinguim-15x80
            x=210,
            y=0,
            width=15,
            height=80,
        },
        {
            -- raio_nave_janela-15x80
            x=225,
            y=0,
            width=15,
            height=80,
        },
        {
            -- raio_nave_maça-15x80
            x=240,
            y=0,
            width=15,
            height=80,
        },
    },
}
-- Carregando a folha de imagens --
local naveSheet = graphics.newImageSheet( "images/herois.png", naveSheetOptions )
-------------------------------------------------------------------------------------

-- Folha de imagens das naves aliens --
local alienSheetOptions = 
{
    frames = {
    
        {
            -- laser 1
            x=0,
            y=0,
            width=50,
            height=80,
        },
        {
            -- laser 2
            x=50,
            y=0,
            width=50,
            height=80,
        },
        {
            -- laser 3
            x=100,
            y=0,
            width=50,
            height=80,
        },
        {
            -- nave 1
            x=150,
            y=0,
            width=70,
            height=80,
        },
        {
            -- nave 2
            x=220,
            y=0,
            width=50,
            height=80,
        },
        {
            -- nave 3
            x=290,
            y=0,
            width=70,
            height=80,
        },
    },
}
-- Carregando a folha de imagens --
local alienSheet = graphics.newImageSheet( "images/inimigos.png", alienSheetOptions )
-------------------------------------------------------------------------------------

-- Funcao que realiza a movimentacao do cenario de fundo
local function move( event )

    fundo.y = fundo.y + scrollSpeed
    fundo2.y = fundo2.y + scrollSpeed
    --if ( fun ) then
        --local tDelta = event.time - tPrevious
        if ( fundo.y - _H / 2 > _H ) then 
            fundo:translate( 0, -fundo.contentHeight * 2 )
        end
        if ( fundo2.y - _H / 2 > _H ) then
            fundo2:translate( 0, -fundo2.contentHeight * 2 )
        end
    --end
end
--------------------------------------------------------------------------------------

-- Funcao de disparo do Laser das naves --
local function fireLaser( spaceship )

    local nave = spaceship
    local newLaser = display.newImageRect( mainGroup, naveSheet, 4, 15, 80 )
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    newLaser.isBullet = true
    newLaser.myName = "laser"

    newLaser.x = nave.x
    newLaser.y = nave.y -- 40
    newLaser:toBack()
    newLaser.yScale = 0.3
    --newLaser:toBack()

    transition.to( newLaser, { y=-30, time=500,
        onComplete = function() display.remove( newLaser ) end
    } )
end
-------------------------------------------------------------------------------------

-- Funcao de disparo do Laser das Naves Aliens --
local function fireLaserAlien( spaceship, raio )

        local alien = spaceship
        if raio == 1 then
            local newLaser = display.newImageRect( mainGroup, alienSheet, 1, 50, 80 )
            physics.addBody( newLaser, "dynamic", { isSensor=true } )
            newLaser.isBullet = true
            newLaser.myName = "alienlaser"

            newLaser.x = alien.x
            newLaser.y = alien.y
            newLaser:toBack()
            newLaser.xScale = 0.6
            newLaser.yScale = 0.6
            newLaser:setLinearVelocity( 0, 350 )
        elseif raio == 2 then
            local newLaser = display.newImageRect( mainGroup, alienSheet, 2, 50, 80 )
            physics.addBody( newLaser, "dynamic", { isSensor=true } )
            newLaser.isBullet = true
            newLaser.myName = "alienlaser"

            newLaser.x = alien.x
            newLaser.y = alien.y
            newLaser:toBack()
            newLaser.xScale = 0.6
            newLaser.yScale = 0.6
            newLaser:setLinearVelocity( 0, 350 )
        else
            local newLaser = display.newImageRect( mainGroup, alienSheet, 3, 50, 80 )
            physics.addBody( newLaser, "dynamic", { isSensor=true } )
            newLaser.isBullet = true
            newLaser.myName = "alienlaser"

            newLaser.x = alien.x
            newLaser.y = alien.y
            newLaser:toBack()
            newLaser.xScale = 0.6
            newLaser.yScale = 0.6
            newLaser:setLinearVelocity( 0, 350 )
        end
end
-------------------------------------------------------------------------------------

-- Funcao para criar e carregar as Naves Aliens de acordo com o tipo --
local function navesAliens( opcao )

    local opt = opcao
 
    if opt == 4 then
            local alien = display.newImageRect ( mainGroup, alienSheet, 4, 70, 80 )
            table.insert(alien, aliensTable)
            alien.x = display. contentCenterX + 180
            alien.y = display.contentCenterY - 200   
            physics.addBody( alien, "dynamic", { raidus = 10 })--, isSensor = true } )
            alien.xScale = 0.6
            alien.yScale = 0.6 
            alien.myName = "alien"
            alien:setLinearVelocity( -140, 180 )
            --transition.to( alien, { x = -60, y = 250, time = 4000, transition = easing.inSine, onComplete = function() display.remove(alien) end } )
            local tiro = function() return fireLaserAlien(alien, 1) end
            timer.performWithDelay(1500, tiro, 2)
            
    elseif opt == 5 then
        local alien = display.newImageRect ( mainGroup, alienSheet, 5, 70, 80 )
        table.insert(alien, aliensTable)
        alien.x = math.random(50, 270)--display.contentCenterX - math.random(100, 250)
        alien.y = display.contentCenterY - 300   
        physics.addBody( alien, "dynamic", { raidus = 10} )--, isSensor = true } ) 
        alien.xScale = 0.6
        alien.yScale = 0.6
        alien.myName = "alien"
        alien:setLinearVelocity( 0, 100 )
        --transition.to( alien, { y = 500, time = 7000, onComplete = function() display.remove(alien) end  } )
        local tiro = function() return fireLaserAlien(alien, 2) end
        timer.performWithDelay(2000, tiro, 2)

    else
        local alien = display.newImageRect ( mainGroup, alienSheet, 6, 70, 80 )
        table.insert(alien, aliensTable)
        alien.x = display. contentCenterX + 180
        alien.y = _H - 50--display.contentCenterY - 100   
        physics.addBody( alien, "dynamic", { raidus = 10} )--, isSensor = true } )
        alien.xScale = 0.6
        alien.yScale = 0.6 
        alien.myName = "alien"
        alien:setLinearVelocity( -100, -150 )
        --transition.to( alien, { x = -60, y = -150, time = 4000, onComplete = function() display.remove(alien) end  } )
        local tiro = function() return fireLaserAlien(alien, 3) end
        timer.performWithDelay(1000, tiro, 2)
    end
   
end
-------------------------------------------------------------------------------------

-- Funcao para gerar as naves Aliens --
local function geraAliens( event )

    local opt = math.random(4,6)
    if opt == 4 then
        local et = function() return navesAliens( opt ) end
        timer.performWithDelay(500, et, 3)
    elseif opt == 5 then
        local et = function() return navesAliens( opt ) end
        timer.performWithDelay(500, et, 3)
    else
        local et = function() return navesAliens( opt ) end
        timer.performWithDelay(800, et, 2)
    end
end
-------------------------------------------------------------------------------------

local function geraNave( event )

    local jslib = require("simpleJoystick")

    --local
    js = jslib.new( 10, 35 )
    js.x = _W / 4 - 20
    js.y = _H - 40
--]]
    --local
    nave = display.newImageRect( mainGroup, naveSheet, 1, 70, 80 )
    nave.x = display.contentCenterX
    nave.y = display.contentHeight - 50
    nave.xScale = 0.8
    nave.yScale = 0.8
    physics.addBody( nave, "dynamic", {radius = 10} )--, isSensor=true} )
    local tiro = function() return fireLaser(nave) end
    nave.myName = "nave"
    nave:addEventListener( "tap", tiro )
    js:activate(nave, display.actualContentWidth, display.actualContentHeight)    
end



local botao = display.newCircle( _W - 50, _H - 40, 15)
botao.alpha = 0.5
botao:setFillColor( 1, 0, 0 )
local disparar = function() return fireLaser(nave) end
botao:addEventListener("tap", disparar )


--##### Deteccao de Colisao ####

local function restoreShip()

    nave.isBodyActive = false
    nave.x = display.contentCenterX
    nave.y = display.contentHeight - 50

    -- Fade in the ship

    transition.to( nave, { alpha=1, time=3000,
        onComplete = function()
            nave.isBodyActive = true
            js:activate(nave, display.actualContentWidth, display.actualContentHeight)
            died = false
        end
    } )
end

local function onCollision( event )

    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "laser" and obj2.myName == "alien" ) or
             ( obj1.myName == "alien" and obj2.myName == "laser" ) )
        then
            -- Remove both the laser and asteroid
            display.remove( obj1 )
            display.remove( obj2 )

            for i = #aliensTable, 1, -1 do
                if ( aliensTable[i] == obj1 or alienssTable[i] == obj2 ) then
                    table.remove( aliensTable, i)
                    break
                end
            end
            --
            -- Increase score
            --score = score + 100
            --scoreText.text = "Score: " .. score --]]

        elseif ( ( obj1.myName == "nave" and obj2.myName == "alien" ) or
                 ( obj1.myName == "alien" and obj2.myName == "nave" ) or 
                 ( obj1.myName == "alienlaser" and obj2.myName == "nave" ) or
                 ( obj2.myName == "nave" and obj2.myName == "alienlaser") ) then
                if ( died == false ) then
                    died = true
                    --[[
                    -- Update lives
                    lives = lives - 1
                    livesText.text = "Lives: " .. lives

                    if ( lives == 0 ) then
                        display.remove( ship )
                    else--]]
                    if (obj1.myName == "alien" or obj1.myName == "alienlaser" )
                    then
                        display.remove( obj1 )
                    else
                        display.remove( obj2 )
                    end
                        js:deactivate()
                        nave.alpha = 0
                        --local restore = function() return restoreShip(nave) end
                        timer.performWithDelay( 1000, restoreShip )
                    --end
                end
        end
    end
end

--Runtime:addEventListener( "collision", onCollision )

--#############################



local function updateFrame()
    move()
    Runtime:addEventListener( "collision", onCollision )
   -- updatePlayerPos()
    --updateJoystickPos()
end

Runtime:addEventListener( "enterFrame", updateFrame )
geraNave()
timer.performWithDelay(5000, geraAliens, 0)
