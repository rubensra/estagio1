
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

-- CARREGANDO MODULOS --------------------------------------------------------

local som = require("src.audio.sons")
local imagens = require("src.carregarImagens")
local uiDisp = require("src.uiDisplay")
local heroi = require("src.heroi.Heroi")
local enemy = require("src.inimigo.Inimigo")

local transicao = require("src.fases");
-------------------------------------------------------------------------------

system.activate("multitouch") -- Ativando MultiTouch

local _W = display.contentWidth -- Largura total da Tela
local _H = display.contentHeight -- Altura total da Tela
local scrollSpeed = 1 -- Velocidade de movimento do fundo

local nave = {} -- Variavel para referenciar a Nave
local chefea -- Variavel para referenciar o chefe

local lifeChefe = 30 
local shot = false -- variavel para auxiliar no deslocamento do chefe
local ultima

local tipo
local municao

local score = 0
local vida = {}
local vidas = 3 

local inimigoLoopTimer
local ultima -- marcador da ultima fase

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-------------------------------------------------------------------------------

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 
--physics.setDrawMode( "hybrid" )

-- Criando e carregando as imagens de fundo para o efeito de movimento --
local cenarios = {}

cenarios = imagens.carregarFundo(3,backGroup)

local fundo = cenarios.um
fundo.x = display.contentCenterX 
fundo.y = display.contentHeight-560
fundo.xScale = 1.0 
fundo.yScale = 1.0

local fundo2 = cenarios.dois
fundo2.x = display.contentCenterX
fundo2.y = display.contentCenterY - display.actualContentHeight
fundo2.xScale = 1.0
fundo2.yScale = 1.0

parametrosFase = { fase = 3, imagem1 = fundo, imagem2 = fundo2, velocidade = scrollSpeed }

-------------------------------------------------------------------------------------
local function recarregar( event )
    if ( event.isShake == true and tipo ~=2 ) then
        nave:Recarregar();
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

local botao = display.newCircle( _W - 50, _H - 40, 15)
botao.alpha = 1
botao:setFillColor( 1, 0, 0 )
local disparar = function(event) if (event.phase == "began" )then display.getCurrentStage():setFocus(event.target, event.id ) return nave:Disparar(mainGroup)end if event.phase == "ended" or event.phase == "canceled" then display.getCurrentStage():setFocus(event.target, nil ) end end
botao:addEventListener("touch", disparar )


local function restoreShip()

    nave.imagem.isBodyActive = false
    botao.isBodyActive = false
    nave.imagem.x = display.contentCenterX
    nave.imagem.y = display.contentHeight - 50
   
    -- Fade in the ship

    transition.to( nave.imagem, { alpha=1, time=3000,
        onComplete = function()
            nave.imagem.isBodyActive = true
            nave.died = false
        end
    } );
    nave:Recarregar();
    transition.to( botao, { alpha = 1, time = 3000,
        onComplete = function()
            botao.isBodyActive = true
        end
    } );
end

-------------------------------------------------------------------------------------------
local function colisaoHeroi(self,event)

    if(event.phase == "began") then
        local obj1 = event.target
        local obj2 = event.other

        if( obj2.myName == "inimigo" or obj2.myName == "inimigolaser" or obj2.myName == "chefe" ) then
            
            if( nave:getVidas() == 0) then
                display.remove( obj1 )
                display.remove( botao )
                enemy.Remove(obj2)
                timer.performWithDelay(2000, transicao.fimDeJogo(lifeChefe))
            else
                enemy.Remove(obj2)
                obj1.alpha = 0
                botao.alpha = 0
                nave:setVidas(nave:getVidas()-1)
                uiDisp.AtualizaVidas(nave:getVidas())
                timer.performWithDelay( 1000, restoreShip )
            end
        end
    end
end

local function colisaoInimigo(self,event)

    if(event.phase == "began")then
    
        local obj1 = event.target
        local obj2 = event.other
        if(obj2.myName == "laser" and obj1.myName == "inimigo") then
            display.remove(obj2)
            enemy.Remove(obj1)
            score = uiDisp.AtualizaScore(score)
        elseif(obj2.myName == "laser" and obj1.myName == "chefe" )then
            display.remove(obj2)
            lifeChefe = lifeChefe - 1       
            if(lifeChefe == 0 )then
                display.remove(obj2);
                obj2 = nil;
                display.remove(obj1);
                ultima = false
                local parametrosVitoria = { tipoNave = nave:getTipo(), totalVidas = nave:getVidas(), totalScore = score, totalMunicao = nave:getMunicao(), fim = ultima}
                transicao.posicaoVitoria(botao,nave,parametrosVitoria);
            end
        end
    end
end

-- Funcao para gerar as naves Aliens --
local function geraInimigo( event )

    local parametros = { fase = 3, grupo = mainGroup, vidas = nave:getVidas(), tipo = nil, vidaChefe = nil, hero = nave.imagem }

    if( nave:getVidas() ~= 0 )then
        local opt = math.random(2,6)
        parametros.tipo = opt
        local inimigo = enemy.tipoInimigo(parametros)--function() return enemy.tipoInimigo( parametros ) end
        inimigo.collision = colisaoInimigo
        inimigo:addEventListener("collision")
        timer.performWithDelay(500, inimigo, math.random(3))
        
    end
end

local function ataqueChefe()
    --som.temaChefe();
    transition.to(chefe, { x = math.random(50, 260), y = display.contentCenterY, time = 2000, transition=easing.continuousLoop, onComplete = function() ataqueChefe() end } )
    if(shot == false) then
        local parametros = { fase = 3, grupo = mainGroup, vidas = nave:getVidas(), tipo = 1, vidaChefe = lifeChefe }
        local tiro = function() return enemy.Disparar(chefe,parametros) end
        atkChefeLoopTimer = timer.performWithDelay(800, tiro, 0)
        timer.performWithDelay(4000, atkChefeLoopTimer, 1)
        shot = true
    end
    
end

-- Funcao para carregar o chefao ---------------------------------------------------
local function bigBoss( event )
    chefe = enemy.new(3,mainGroup,1)
    chefe.x = display.contentCenterX
    chefe.y = 50
    physics.addBody( chefe, {raidus = 30, isSensor = true } )
    chefe.collision = colisaoInimigo
    chefe:addEventListener("collision")
    chefe.alph = 0
    transition.to(chefe, { alpha = 1, time = 3000,onComplete = function() ataqueChefe() end } )
end

local function chefeFinal( event )
    
    timer.cancel( inimigoLoopTimer );
    timer.performWithDelay(3000, bigBoss, 1)

end
--#############################
local function updateFrame2()
        
    transition.to(fundo2, { y = 800, time = 15000, onComplete = function() chefeFinal() end })
end

local function updateFrame()
        
    transition.to(fundo, { y = 800, time = 15000, onComplete = function() updateFrame2() end })
end

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
    --scoreText = display.newText( uiGroup, "Score: " .. score, display.contentCenterX, 20, native.systemFont, 25 )
    uiDisp.Score(uiGroup,score);
    local tipo = event.params;
    print("Municao: " .. tipo.totalMunicao )
    --geraNave(parametro.tipoNave)
    nave = heroi:new(nil,tipo.tipoNave, tipo.totalMunicao, mainGroup)
    physics.addBody( nave.imagem, {radius = 20, isSensor=true} )
    nave.imagem:addEventListener("touch", dragShip);
    nave.imagem.collision = colisaoHeroi
    nave.imagem:addEventListener("collision")
    uiDisp.Vidas(uiGroup, tipo.tipoNave,nave:getVidas());

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
        --Runtime:addEventListener( "enterFrame", updateFrame )
        updateFrame()
        inimigoLoopTimer = timer.performWithDelay(1500, geraInimigo, 0)
        Runtime:addEventListener( "accelerometer", recarregar );
        som.somFase3();
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
        Runtime:removeEventListener("touch", botao) 
        Runtime:removeEventListener("accelerometer", recarregar );       
        som.onClose()
        physics.pause()
        composer.removeScene( "fase3" )

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
