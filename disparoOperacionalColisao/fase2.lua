
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

system.activate("multitouch") -- Ativando MultiTouch

local _W = display.contentWidth -- Largura total da Tela
local _H = display.contentHeight -- Altura total da Tela
local scrollSpeed = 1 -- Velocidade de movimento do fundo

local died = false -- Variavel para controlar as mortes do jogador

local inimigoTable = {} -- Tabela p/ guardar as naves aliens criadas

local interpolacaoTable = {"transition=easing.countinousLoop", "transition=easing.inQuart", "transition=easing.outQuart", "transition=easing.inOutQuart", "transition=easing.outInBack" }

local js -- Variavel para guardar a referencai ao JoyStick Virtual
local nave -- Variavel para referenciar a Nave
local chefe -- Variavel para referenciar o chefe
local vidaChefe = 10 
local movimento = true -- variavel para auxiliar no deslocamento do background

local tempo = 0
local tipo
local municao

local score = 0
local scoreText

local vida1
local vida2
local vidas

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local function fimDeJogo()

    if( vidaChefe == 0 )then
        composer.gotoScene( "vitoria", { time=800, effect="crossFade"} )
    else
        composer.gotoScene( "fimJogo", { time=800, effect="crossFade"} )
    end
end

--[[
local function gotoFase2()
    composer.gotoScene( "fase2", { time = 800, effect = "crossFade" } )
end
]]--
-- AUDIO --------------------------------------------------------------------
local musicaFundo = audio.loadSound("audio/Tema_2aFase.mp3")

local function onClose( event )
    audio.stop();
end

local disparoHeroi = audio.loadSound("audio/heroiLaser.mp3")
-------------------------------------------------------------------------------

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 

-- Criando e carregando as imagens de fundo para o efeito de movimento --
--local fundo = display.newImage( backGroup, "images/fase2-1920x1280.png", 320, 480 )
local fundo = display.newImage( backGroup, "images/fase2_1061x1707.png", 320, 480 )
fundo.x = display.contentCenterX 
fundo.y = display.contentCenterY
fundo.xScale = 1 
fundo.yScale = 1

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

--------------------------------------------------------------------------------------
local inimigoSheetOptions = 
{
    frames = {
    
        {
            -- 1) besouro Amarelo 200x200
            x=0,
            y=0,
            width=200,
            height=200,
        },
        {
            -- 2) besouro Azul-200x200
            x=200,
            y=0,
            width=200,
            height=200,
        },
        {
            -- 3) ladyBug -200x200
            x=400,
            y=0,
            width=200,
            height=200,
        },
        {
            -- 4) Chefe Maripos 200x200
            x = 600,
            y = 0,
            width = 200,
            height = 200,
        },
        {
            -- 5) nuvem Amarela - 100x200
            x=800,
            y=0,
            width=100,
            height=200,
        },
        {
            -- 6) nuvem Azul - 100x200
            x=900,
            y=0,
            width=100,
            height=200,
        },
        {
            -- 7) nuvem Cinza - 100x200
            x=1000,
            y=0,
            width=100,
            height=200,
        },
    },
}
-- Carregando a folha de imagens --
local inimigoSheet = graphics.newImageSheet( "images/inimigosFase2.png", inimigoSheetOptions )
---------------------------------------------------------------------------------------------
local function fireLaserAlien( spaceship, raio )

    if( vidas ~= 0 )then
        local inimigo = spaceship
    
        local newLaser = display.newImageRect( mainGroup, inimigoSheet, raio+4, 100, 200 )
        physics.addBody( newLaser, "dynamic", { radius = 4, isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "inimigolaser"

        newLaser.x = inimigo.x
        newLaser.y = inimigo.y
        newLaser:toBack()
        newLaser.xScale = 0.3
        newLaser.yScale = 0.3
        --newLaser:setLinearVelocity( 0, 350 )
        transition.to(newLaser, {y = 500, time = 3000, onComplete = function() display.remove(newLaser) end } )
    end
end

-----------------------------------------------------------------------------------------------------------------
local function ataqueInimigo(inimigo, opt)

    local atk = math.random(5)

    if ( inimigo.x <1 and inimigo.y < display.contentCenterY / 2 ) then
        transition.to( inimigo, {x = 340,  y = display.contentCenterY, time = 7000, transition=easing.inOutQuart, onComplete = function() display.remove(inimigo) end } )
        --print("inOutQuart")
    elseif( inimigo.y < 1 ) then
        transition.to( inimigo, {y = display.contentHeight + 200, time = 10000, onComplete = function() display.remove(inimigo) end } )
        --print("inOutBack")
    else
        transition.to( inimigo, {x = -100,  y = display.contentCenterY + 200, time = 4000, transition=easing.outInBack, onComplete = function() display.remove(inimigo) end } )
        --print("outInBack")
    end
    if(opt == 1 or opt == 2) then
        local tiro = function() if (inimigo) then return fireLaserAlien(inimigo, opt)end end
        timer.performWithDelay(1500, tiro, 2)
    end
end


-------- GERA INIMIGOS --------------------------------------------------------------
-- Funcao para criar e carregar as Naves Aliens de acordo com o tipo --
local function navesAliens( opcao )

    local opt = opcao
    local inimigo = display.newImageRect ( mainGroup, inimigoSheet, opt, 200, 200 )
    table.insert(inimigoTable, inimigo)
    local posicao = math.random(1,3)
    if (posicao == 1) then
        inimigo.x = math.random(-100,1)
        inimigo.y = math.random(1, display.contentCenterY)
    elseif (posicao == 2) then
        inimigo.x = math.random(20,300)
        inimigo.y = -50
    else 
        inimigo.x = math.random(320,350)
        inimigo.y = math.random(0, display.contentCenterY)
    end
    physics.addBody( inimigo,{ raidus = 2, isSensor = true } )
    inimigo.xScale = 0.4
    inimigo.yScale = 0.4
    inimigo.myName = "inimigo"
    ataqueInimigo(inimigo,opt)
    --inimigo:setLinearVelocity( -140, 180 )
    --transition.moveBy( inimigo, { x = 220, y = 220, time = 4000, interpolacaoTable[math.random(5)], onComplete = function() display.remove(inimigo) end } )
end

-- Funcao para gerar as naves Aliens --
local function geraInimigo( event )

    if( vidas ~= 0 )then
        local opt = math.random(3)
        local inimigo = function() return navesAliens( opt ) end
        timer.performWithDelay(500, inimigo, math.random(3))
    end
end
--------------------------------------------------------------------------------------
	
	-- Funcao de disparo do Laser das naves --
	local function fireLaser( spaceship, tipo )
	
		local nave = spaceship;
		local newLaser;
		if ( municao > 0 ) then
			if(tipo == 2) then
				newLaser = display.newImageRect( mainGroup, naveSheet, 5, 15, 80 )
			elseif (tipo == 3) then
				newLaser = display.newImageRect( mainGroup, naveSheet, 6, 15, 80 )
			else newLaser = display.newImageRect( mainGroup, naveSheet, 4, 15, 80 )
			end
			--newLaser = display.newImageRect( mainGroup, naveSheet, nave.tipo+3, 15, 80 )
			physics.addBody( newLaser, "dynamic", { radius = 3, isSensor=true } )
			newLaser.isBullet = true
			newLaser.myName = "laser"
	
			newLaser.x = nave.x
			newLaser.y = nave.y -- 40
			newLaser:toBack()
			newLaser.yScale = 0.3
			--newLaser:toBack()
            audio.play(disparoHeroi, { channel = 2, loops = 1 } )
			transition.to( newLaser, { y=-30, time=500,
				onComplete = function() display.remove( newLaser ) end
            } )
            
		end
		if( municao ~= 99 ) then
			municao = municao - 1;
		end
	end

	-------------------------------------------------------------------------------------
local function recarregar( event )
    if ( event.isShake == true and tipo ~=2 ) then
        municao = 10
    end
end


-------------------------------------------------------------------------------------
local function dragShip( event )

    local ship = event.target
    local phase = event.phase

    if ( "began" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( ship )
        -- Store initial offset position
        if(( event.x > 10 and event.x < display.contentWidth) and (event.y > 20 and event.y < display.contentHeight)) then
            ship.touchOffsetX = event.x - ship.x
            ship.touchOffsetY = event.y - ship.y
        end

    elseif ( "moved" == phase ) then
        -- Move the ship to the new touch position
        if(( event.x > 40 and event.x < display.contentWidth-40) and (event.y > 30 and event.y < display.contentHeight-30)) then
            ship.x = event.x - ship.touchOffsetX
            ship.y = event.y - ship.touchOffsetY
        end

    elseif ( "ended" == phase or "canceled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
    end

    return true -- Prevents touch propagation to underlying objects

end


--##### Deteccao de Colisao ####

local function restoreShip()

    nave.isBodyActive = false
    --botao.isBodyActive = false
    nave.x = display.contentCenterX
    nave.y = display.contentHeight - 50

    -- Fade in the ship

    transition.to( nave, { alpha=1, time=3000,
        onComplete = function()
            nave.isBodyActive = true
           -- botao.isBodyActive = true
            died = false
        end
    } )
    if (tipo ~= 2) then
        municao = 10
    end
    --transition.to( botao, { alpha = 1, time = 3000, onComplete = function() botao.isBodyActive = true end } )
end

local function move()

	transition.to(fundo, { y = 800, time = 60000})

end

local function updateFrame()
    move()
end

local function geraNave(tipo,vidas)

	local selecao
	--if ( spaceship == "Janela") then
		nave = display.newImageRect( mainGroup, naveSheet, tipo, 70, 80 )
        --municao = 99
        nave.isBodyActive = true
    --nave = display.newImageRect( mainGroup, naveSheet, selecao, 70, 80 )
    nave.x = display.contentCenterX
    nave.y = display.contentHeight + 100 
    nave.xScale = 0.8
    nave.yScale = 0.8
    physics.addBody( nave, {radius = 10, isSensor=true} )
    local tiro = function() return fireLaser(nave,tipo) end
    nave.myName = "nave"
    
	if(vidas == 2) then
		vida1 = display.newImageRect( uiGroup, naveSheet, tipo, 70, 80 )
        vida2 = display.newImageRect( uiGroup, naveSheet, tipo, 70, 80 )
		vida1.x = display.contentCenterX - 120
		vida1.y = 20
		vida1.xScale = 0.2
		vida1.yScale = 0.2
		vida2.x = display.contentCenterX - 90
		vida2.y = 20
		vida2.xScale = 0.2
		vida2.yScale = 0.2
	elseif (vidas == 1) then
		vida1 = display.newImageRect( uiGroup, naveSheet, tipo, 70, 80 )
		vida1.x = display.contentCenterX - 120
		vida1.y = 20
		vida1.xScale = 0.2
		vida1.yScale = 0.2
	end
	--nave.imagem:addEventListener( "tap", tiro );
	nave:addEventListener("touch", dragShip);
end

local botao = display.newCircle(mainGroup, _W - 50, _H - 40, 15)
botao.alpha = 1
botao:setFillColor( 1, 0, 0 )
local disparar = function(event) if (event.phase == "began" )then display.getCurrentStage():setFocus(event.target, event.id ) return fireLaser(nave,tipo) end if event.pahse == "ended" or event.phase == "canceled" then display.getCurrentStage():setFocus(event.target, nil ) end end
botao:addEventListener("touch", disparar )

-- COLISAO -----------------------------------------------------------------------

local function colisaoHeroiAlien(obj1, obj2)
    if ( died == false ) then
        died = true
        -- Update lives
        vidas = vidas - 1
        if(vidas == 2)then
            display.remove( vida2 )
        elseif (vidas == 1 ) then
            display.remove( vida1 )
        elseif ( vidas == 0 and obj1.myName == "nave") then
            display.remove( obj1 )
            display.remove( botao )
            timer.performWithDelay(2000, fimDeJogo)
        elseif ( vidas == 0 and obj2.myName == "nave") then
            display.remove ( obj2 )
            display.remove( botao )
            timer.performWithDelay( 2000, fimDeJogo )
        end

        if (obj1.myName == "inimigo" or obj2.myName == "alien" ) then
            for i = #inimigoTable, 1, -1 do
                if ( inimigoTable[i] == obj1 or inimigoTable[i] == obj2 ) then
                    table.remove( inimigoTable, i)
                    break
                end
            end
        end
        nave.alpha = 0
        --botao.alpha = 0
        timer.performWithDelay( 1000, restoreShip )
    end
end

local function colisaoHeroiLaser(obj1, obj2)
    if ( died == false ) then
        died = true
        -- Update lives
        vidas = vidas - 1
        if(vidas == 2)then
            display.remove( vida2 )
        elseif (vidas == 1 ) then
            display.remove( vida1 )
        elseif ( vidas == 0 and obj1.myName == "nave") then
            display.remove( obj1 )
            display.remove( botao )
            timer.performWithDelay( 2000, fimDeJogo )
        elseif ( vidas == 0 and obj2.myName == "nave") then
            display.remove( obj2 )
            display.remove( botao )
            timer.performWithDelay( 2000, fimDeJogo )
        end

        if (obj1.myName == "inimigolaser" )then
            display.remove( obj1 )
        else
            display.remove( obj2 )
        end
    nave.alpha = 0;
    --botao.alpha = 0;
    timer.performWithDelay( 1000, restoreShip );
    end
end

--[[local function proximaFase()

    display.remove(botao)
    local parametros = { tipoNave = tipo , totalVidas = vidas, totalScore = score, totalMunicao = municao }
    transition.to( nave, { y = -50, time = 3000, transition=easing.inQuad, onComplete = function() gotoFase2(parametros) end } )

end

local function posicaoVitoria(spaceship)

    transition.moveTo(spaceship, { x = display.contentCenterX, y = display.contentHeight - 50, time = 2000, onComplete = function() proximaFase() end } )

end
]]--
-- Colisao Geral ---------------------------------
local function onCollision( event )
    local pontos
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "laser" and obj2.myName == "inimigo" ) or
             ( obj1.myName == "inimigo" and obj2.myName == "laser" ) ) then
            -- Remove both the laser and asteroid
            display.remove( obj1 )
            display.remove( obj2 )
            for i = #inimigoTable, 1, -1 do
                if ( inimigoTable[i] == obj1 or inimigoTable[i] == obj2 ) then
                    table.remove( inimigoTable, i)
                    break
                end
            end
            --[[ Increase score]]--
            score = score + 100;
            scoreText.text = "Score: " .. score
        --[[elseif (obj1.myName == "laser" and obj2.myName == "chefe") then
                display.remove(obj1);
                vidaChefe = vidaChefe - 1
                if(vidaChefe == 0 )then
                    display.remove(chefe)
                    posicaoVitoria(nave);
                end
        elseif (obj1.myName == "chefe" and obj2.myName == "laser")then
                display.remove(obj2);
                vidaChefe = vidaChefe - 1
                if(vidaChefe == 0 )then
                    display.remove( chefe )
                    --display.remove( botao )
                    --display.remove( nave )
                    posicaoVitoria(nave);                
                    --timer.performWithDelay( 1000, fimDeJogo )
                end]]--
        elseif ( ( obj1.myName == "nave" and obj2.myName == "inimigo" ) or
                ( obj1.myName == "inimigo" and obj2.myName == "nave" )) then 
                colisaoHeroiAlien(obj1,obj2);
        elseif  (( obj1.myName == "inimigolaser" and obj2.myName == "nave" ) or
                ( obj1.myName == "nave" and obj2.myName == "inimigolaser") ) then
                colisaoHeroiLaser(obj1,obj2);
        end
    end
end

----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause();
	sceneGroup:insert(backGroup);
	sceneGroup:insert(mainGroup);
    sceneGroup:insert(uiGroup);
	local parametros = event.params
	tipo = parametros.tipoNave
	municao = parametros.totalMunicao
	score = parametros.totalScore
	vidas = parametros.totalVidas
    print("vidas: " .. vidas )
    print("tipo: " .. tipo )
    print("municao: " .. municao )
	scoreText = display.newText( uiGroup, "Score: " .. score, display.contentCenterX, 20, native.systemFont, 25 )
	geraNave(tipo,vidas)
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		transition.to(nave, {x = display.contentCenterX, y = display.contentCenterY, time = 3000, transition = easing.inOutBack } )
		--Runtime:addEventListener( "enterFrame", updateFrame )
		updateFrame()
        inimigoLoopTimer = timer.performWithDelay(4000, geraInimigo, 0)
        Runtime:addEventListener( "accelerometer", recarregar );
        --chefeTimer = timer.performWithDelay(30000, chefeFinal, 1)
		Runtime:addEventListener( "collision", onCollision )
        audio.play(musicaFundo, { loops = -1, fadein = 2000 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel(  inimigoLoopTimer )
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        transition.cancel()
        timer.cancel(inimigoLoopTimer)
        Runtime:removeEventListener("accelerometer", recarregar);
        Runtime:removeEventListener("collision", onCollision);
        onClose()
        physics.pause()
        composer.removeScene( "fase2" )

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
