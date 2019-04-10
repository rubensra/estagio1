
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

local aliensTable = {} -- Tabela p/ guardar as naves aliens criadas

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
local musicaFundo = audio.loadSound("audio/fasePrincipal.mp3")

local function onClose( event )
    audio.stop();
end

-------------------------------------------------------------------------------

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 

-- Criando e carregando as imagens de fundo para o efeito de movimento --
local fundo = display.newImage( backGroup, "images/fase2-1920x1280.png", 320, 480 )
fundo.x = display.contentCenterX 
fundo.y = display.contentCenterY
fundo.xScale = 1.0 
fundo.yScale = 1.0

--[[local fundo2 = display.newImageRect( backGroup, "images/circuito00_320x480.png", 320, 480 )
fundo2.x = display.contentCenterX
fundo2.y = display.contentCenterY - display.actualContentHeight
fundo2.xScale = 1.0
fundo2.yScale = 1.0]]--
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


-- Funcao que realiza a movimentacao do cenario de fundo
	local function move( event )

		if( movimento == true ) then
			fundo.y = fundo.y + scrollSpeed
			fundo2.y = fundo2.y + scrollSpeed
			if ( fundo.y - _H / 2 > _H ) then 
				fundo:translate( 0, -fundo.contentHeight * 2 )
			end
			if ( fundo2.y - _H / 2 > _H ) then
				fundo2:translate( 0, -fundo2.contentHeight * 2 )
			end
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
    botao.isBodyActive = false
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
    transition.to( botao, { alpha = 1, time = 3000, onComplete = function() botao.isBodyActive = true end } )
end

local function move()

	transition.to(fundo, { y = 900, time = 60000})

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
		vida1.y = display.contentHeight - 20
		vida1.xScale = 0.2
		vida1.yScale = 0.2
		vida2.x = display.contentCenterX - 90
		vida2.y = display.contentHeight - 20
		vida2.xScale = 0.2
		vida2.yScale = 0.2
	else
		vida1 = display.newImageRect( uiGroup, naveSheet, tipo, 70, 80 )
		vida1.x = display.contentCenterX - 120
		vida1.y = display.contentHeight - 20
		vida1.xScale = 0.2
		vida1.yScale = 0.2
	end
	--nave.imagem:addEventListener( "tap", tiro );
	nave:addEventListener("touch", dragShip);
end


local function contador(tempo)
	tempo = tempo + 1
end

local addTempo = function() contador(tempo) end
local botao = display.newCircle(mainGroup, _W - 50, _H - 40, 15)
botao.alpha = 1
botao:setFillColor( 1, 0, 0 )
local disparar = function(event) if (event.phase == "began" )then display.getCurrentStage():setFocus(event.target, event.id ) return fireLaser(nave,tipo) end if event.pahse == "ended" or event.phase == "canceled" then display.getCurrentStage():setFocus(event.target, nil ) end end
botao:addEventListener("touch", disparar )

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
	print("Tipo: " .. tipo)
	print("Municao: " .. municao)
	print("Vidas: " .. vidas)
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
		transition.to(nave, {x = display.contentCenterX, y = display.contentCenterY, time = 1000 } )
		--Runtime:addEventListener( "enterFrame", updateFrame )
		updateFrame()
        alienLoopTimer = timer.performWithDelay(5000, geraAliens, 0)
        Runtime:addEventListener( "accelerometer", recarregar );
        --chefeTimer = timer.performWithDelay(30000, chefeFinal, 1)
		--Runtime:addEventListener( "collision", onCollision )
		timer.performWithDelay(1000, addTempo, 60)
        audio.play(musicaFundo, { loops = -1 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
