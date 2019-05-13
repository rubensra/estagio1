local tiroHeroi = require("src.heroi.spriteHeroi")
local tiroInimigo = require("src.inimigo.spriteInimigoFase1")
local tiroInimigo2 = require("src.inimigo.spriteInimigoFase2")
local tiroInimigo3 = require("src.inimigo.spriteInimigoFase3")
local som = require("src.audio.sons")

local disparo = {}


function disparo.Heroi(nave,tipo,grupo, municao)

    if ( municao > 0 ) then
        local newLaser = tiroHeroi.carregarTiro(grupo,tipo)
        physics.addBody( newLaser, "dynamic", { radius = 5, isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "laser" 
        newLaser.x = nave.x
        newLaser.y = nave.y
        newLaser:toBack()
        newLaser.yScale = 0.3
        transition.to( newLaser, { y=-30, time=500, onComplete = function() display.remove( newLaser ) end } )
        som.somDisparo()
        return newLaser
    end
end

function disparo.Inimigo1(inimigo, tipo, grupo, vidas)

    if( vidas ~= 0 and inimigo )then  
        local newLaser = tiroInimigo.carregarTiro(grupo,tipo)
        physics.addBody( newLaser, "dynamic", { radius = 10, isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "inimigolaser"
        newLaser.x = inimigo.x
        newLaser.y = inimigo.y
        newLaser:toBack()
        newLaser.xScale = 0.3
        newLaser.yScale = 0.3
        transition.to(newLaser, {y = 500, time = 2000, onComplete = function() display.remove(newLaser) end } )
    end
end

function disparo.Inimigo2(inimigo, tipo, grupo, vidas)

    if( vidas ~= 0 and inimigo )then  
        local newLaser = tiroInimigo2.carregarTiro(grupo,tipo)
        physics.addBody( newLaser, "dynamic", { radius = 10, isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "inimigolaser"
        newLaser.x = inimigo.x
        newLaser.y = inimigo.y
        newLaser:toBack()
        newLaser.xScale = 0.3
        newLaser.yScale = 0.3
        transition.to(newLaser, {y = 500, time = 3000, onComplete = function() display.remove(newLaser) end } )
    end
end

function disparo.Inimigo3(inimigo, tipo, grupo, vidas,nave)

    if( vidas ~= 0 and inimigo )then  
        local newLaser = tiroInimigo3.carregarTiro(grupo,tipo)
        physics.addBody( newLaser, "dynamic", { radius = 10, isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "inimigolaser"
        newLaser.x = inimigo.x
        newLaser.y = inimigo.y
        newLaser:toBack()
        newLaser.xScale = 0.3
        newLaser.yScale = 0.3
        transition.moveTo(newLaser, {x = nave.x, y = nave.y + 100, time = 3000, onComplete = function() display.remove(newLaser) end } )
    end
end


function disparo.Chefe1(inimigo, tipo, grupo, vidas, vidaChefe)

    if( inimigo.y ~= nil and vidas ~= 0 and vidaChefe ~= 0 ) then
        local newLaser = tiroInimigo.carregarTiro(grupo, tipo)
        physics.addBody( newLaser, "dynamic", { radius = 15, isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "inimigolaser"
        newLaser.x = inimigo.x
        newLaser.y = inimigo.y+5
        newLaser:toBack()
        newLaser.xScale = 0.8
        newLaser.yScale = 0.8
        transition.to(newLaser, { x = math.random(-100,330), y = 490, time = 1000, onComplete = function() display.remove(newLaser) end } )
    end
end

function disparo.Chefe2(inimigo,tipo, grupo, vidas, vidaChefe)
    if( inimigo.y ~= nil and vidas ~= 0 and vidaChefe ~= 0 )then
        local newLaser = tiroInimigo2.carregarTiro(grupo, tipo)
        physics.addBody( newLaser, "dynamic", { radius = 15, isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "inimigolaser"
        newLaser.x = inimigo.x
        newLaser.y = inimigo.y+5
        newLaser:toBack()
        newLaser.xScale = 0.5
        newLaser.yScale = 0.5
        transition.to(newLaser, { y = 490, time = 1000, onComplete = function() display.remove(newLaser) end } )
    end
end

function disparo.Chefe3(inimigo,tipo, grupo, vidas, vidaChefe)
    if( inimigo.y ~= nil and vidas ~= 0 and vidaChefe ~= 0 )then
        local newLaser = tiroInimigo3.carregarTiro(grupo, tipo)
        physics.addBody( newLaser, "dynamic", { radius = 15, isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "inimigolaser"
        newLaser.x = inimigo.x
        newLaser.y = inimigo.y+5
        newLaser:toBack()
        newLaser.xScale = 0.3
        newLaser.yScale = 0.3
        transition.to(newLaser, { y = 490, time = 1500, onComplete = function() display.remove(newLaser) end } )
    end
end


return disparo