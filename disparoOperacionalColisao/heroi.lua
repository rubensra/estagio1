
local nave;

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

local function geraNave( event )

    
    nave = display.newImageRect( mainGroup, naveSheet, 1, 70, 80 )
    nave.x = display.contentCenterX
    nave.y = display.contentHeight - 50
    nave.xScale = 0.8
    nave.yScale = 0.8
    physics.addBody( nave, "dynamic", {radius = 10} )--, isSensor=true} )
    local tiro = function() return fireLaser(nave) end
    nave.myName = "nave"
    nave:addEventListener( "tap", tiro )
end
