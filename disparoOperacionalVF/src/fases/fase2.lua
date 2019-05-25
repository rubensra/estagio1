
local composer = require( "composer" )

local scene = composer.newScene()

math.randomseed( os.time() )
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
local uiDisp = require("src.display.uiDisplay")
local heroi = require("src.heroi.Heroi")
local enemy = require("src.inimigo.Inimigo")
local item = require("src.itens.itens") -- funcoes dos itens
local transicao = require("src.fases.fases");
-------------------------------------------------------------------------------

--system.activate("multitouch") -- Ativando MultiTouch

local _W = display.contentWidth -- Largura total da Tela
local _H = display.contentHeight -- Altura total da Tela

local nave = {} -- Variavel para referenciar a Nave
local chefe -- Variavel para referenciar o chefe
local lifeChefe = 20 

local score = 0
 

local inimigoLoopTimer
local atkChefeLoopTimer
local ultima

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local atingido = false --define se o chefe foi atingido ou nao
local botaoParametros = { 
    grupo = nil,
    botaoLivre = nil,
    botaoPressionado = nil,
    especial = false,
    botaoEspecialLivre = nil,
    botaoEspecialPressionado = nil
}

local escudo = false
local escudoImg = nil
local especialImg = nil
local parametrosExplosao = { grupo = mainGroup }
local explosaoImg = imagens.carregarExplosao(parametrosExplosao)
explosaoImg.isVisible = false
-------------------------------------------------------------------------------

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 
--physics.setDrawMode( "hybrid" )

-- Criando e carregando as imagens de fundo para o efeito de movimento --
local fundo = imagens.carregarFundo(2,backGroup)
fundo.x = display.contentCenterX 
fundo.y = display.contentHeight-560
fundo.xScale = 1 
fundo.yScale = 1

parametrosFase = { fase = 2, imagem = fundo, imagem2 = nil, velocidade = nil }
--------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
local function recarregar( event )
    if ( event.isShake == true and tipo ~=2 ) then
        nave:Recarregar();
    end
end

-------------------------------------------------------------------------------------
local function dragShip( event )

    local phase = event.phase

    if(nave:getEscudo() == false) then
        
        local ship = event.target

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

    elseif(nave:getEscudo() == true ) then

        local shield = event.target

        if ( "began" == phase ) then

            display.currentStage:setFocus( shield )
            -- Store initial offset position
            if(( event.x > 10 and event.x < display.contentWidth) and (event.y > 20 and event.y < display.contentHeight)) then
                shield.touchOffsetX = event.x - shield.x
                shield.touchOffsetY = event.y - shield.y
            end
        elseif ( "moved" == phase ) then

            if(( event.x > 40 and event.x < display.contentWidth-40) and (event.y > 30 and event.y < display.contentHeight-30)) then
                shield.x = event.x - shield.touchOffsetX
                shield.y = event.y - shield.touchOffsetY
                nave.imagem.x = shield.x
                nave.imagem.y = shield.y
            end

        elseif ( "ended" == phase or "canceled" == phase ) then
            -- Release touch focus on the ship
            display.currentStage:setFocus( nil )
        end
    
    end

    return true -- Prevents touch propagation to underlying objects

end

--------- BOTAO de Disparo ----------------------

local function disparar(event)
    if (event.phase == "began" ) then
        display.getCurrentStage():setFocus(event.target, event.id )
        uiDisp.botaoPressiona(botaoParametros)
        return nave:Disparar(mainGroup)
    end
    
    if (event.phase == "ended" or event.phase == "canceled") then
        display.getCurrentStage():setFocus(event.target, nil )
        uiDisp.botaoLivre(botaoParametros)
    end   
end

local function dispararEspecial(event)
    
    if (event.phase == "began" ) then
        display.getCurrentStage():setFocus(event.target, event.id )
        uiDisp.botaoEspecialPressiona(botaoParametros)
        nave:DisparoEspecial(mainGroup)
        nave:setEspecial(0)
    end
    
    if (event.phase == "ended" or event.phase == "canceled") then
        display.getCurrentStage():setFocus(event.target, nil )
        uiDisp.botaoEspecialLivre(botaoParametros)
        local desabilitaBotaoEspecial = function() botaoParametros.botaoEspecialLivre.isVisible = false end 
        timer.performWithDelay(1000, desabilitaBotaoEspecial, 1)
    end   
end

local function explosao(alvo)

    explosaoImg.x = alvo.x
    explosaoImg.y = alvo.y
    explosaoImg.isVisible = true
    som.somExplosao()
    local desabilitaImgExplosao = function() explosaoImg.isVisible = false end
    timer.performWithDelay(200, desabilitaImgExplosao, 1)
end

-- Restaura da nave apos a morte ---
local function restoreShip()

    nave.imagem.isBodyActive = false
    botaoParametros.botaoLivre.isBodyActive = false
    nave.imagem.x = display.contentCenterX
    nave.imagem.y = display.contentHeight - 50
    if(nave:getEspecial() == true ) then
        nave:setEspecial(0);
    end
   
    -- Fade in the ship

    transition.to( nave.imagem, { alpha=1, time=3000,
        onComplete = function()
            nave.imagem.isBodyActive = true
            nave.died = false
        end
    } );
    nave:Recarregar();
    transition.to( botaoParametros.botaoLivre, { alpha = 1, time = 3000,
        onComplete = function()
            botaoParametros.botaoLivre.isBodyActive = true
        end
    } );
end

local function geraItens()

    local powerup = math.random(2)

    if(powerup == 1 and nave:getEscudo() == false) then
        local parametrosItem = { grupo = mainGroup, tipo = 1}
        item.antiVirus(parametrosItem);
    elseif(powerup == 2 and nave:getEspecial() == false)then
        local parametrosEspecial = { grupo = mainGroup, tipo = 3 }
        item.Especial(parametrosEspecial)
    end
end

--##### Deteccao de Colisao ####
-- COLISAO -----------------------------------------------------------------------
local function colisaoHeroi(self,event)

    if(event.phase == "began") then
        local obj1 = event.target
        local obj2 = event.other

        if( obj2.myName == "inimigo" or obj2.myName == "inimigolaser" or obj2.myName == "chefe" ) then
            
            if(nave:getEscudo() == false)then
                if( nave:getVidas() == 0) then
                    display.remove( obj1 )
                    display.remove( botao )
                    enemy.Remove(obj2)
                    timer.performWithDelay(2000, transicao.fimDeJogo(lifeChefe))
                elseif(obj2.myName ~= "chefe") then
                    enemy.Remove(obj2)
                    obj1.alpha = 0
                    botaoParametros.botaoLivre.alpha = 0
                    nave:setVidas(nave:getVidas()-1)
                    uiDisp.AtualizaVidas(nave:getVidas())
                    timer.performWithDelay( 1000, restoreShip )
                else
                    obj1.alpha = 0
                    botaoParametros.botaoLivre.alpha = 0
                    nave:setVidas(nave:getVidas()-1)
                    uiDisp.AtualizaVidas(nave:getVidas())
                    timer.performWithDelay( 1000, restoreShip )
                end
            elseif(nave:getEscudo() == true)then
                escudoImg:removeEventListener("touch", dragShip)
                display.remove(escudoImg)
                escudoImg = nil
                enemy.Remove(obj2)
                nave:setEscudo(0)
            end
        end
        if( obj2.myName == "escudo" and nave:getEscudo() == false )then
            item.remove(obj2);
            nave:setEscudo(1);
            local parametrosEscudo = { grupo = mainGroup, tipo = 2}
            escudoImg = item.Escudo(parametrosEscudo)
            physics.addBody( escudoImg, {radius = 120, isSensor = true } )
            escudoImg.x = nave.imagem.x;
            escudoImg.y = nave.imagem.y;
            escudoImg.myName = "escudo"
            escudoImg.alpha = 0.3
            escudoImg:toFront();
            escudoImg:addEventListener("touch", dragShip);
        elseif(obj2.myName == "firewall" and nave:getEspecial() == false)then
            item.remove(obj2)
            nave:setEspecial(1);
            botaoParametros.botaoEspecialLivre.isVisible = true
            botaoParametros.botaoEspecialLivre:addEventListener("touch",dispararEspecial)
        end
    end
end

local function colisaoInimigo(self,event)

    if(event.phase == "began")then
    
        local obj1 = event.target
        local obj2 = event.other
        if((obj2.myName == "laser" or obj2.myName == "especial") and obj1.myName == "inimigo") then
            if(obj2.myName == "especial") then
                display.remove(obj2)
                explosao(obj1)
            end
            --elseif(obj2.myName == "laser") then
            display.remove(obj2)
            --end
            enemy.Remove(obj1)
            score = uiDisp.AtualizaScore(score)
        elseif((obj2.myName == "laser" or obj2.myName == "nave" or obj2.myName == "especial") and obj1.myName == "chefe" )then
            if(obj2.myName == "especial")then
                display.remove(obj2)
                explosao(obj1)
                lifeChefe = lifeChefe - 5
            else
                display.remove(obj2)
                lifeChefe = lifeChefe - 1 
            end
            if( atingido == false) then
                atingido = true
                local parametrosHit = { objchefe = obj1 }
                atingido = enemy.atingido(parametrosHit)
                print(atingido)
            end      
            if(lifeChefe == 0 )then
                nave.imagem:removeEventListener("collision")
                score = score + 200
                score = uiDisp.AtualizaScore(score)
                display.remove(obj2);
                obj2 = nil;
                display.remove(obj1);
                display.remove(escudoImg)
                local parametrosVitoria = { fase = 2, tipoNave = nave:getTipo(), totalVidas = nave:getVidas(), totalScore = score, totalMunicao = nave:getMunicao(), fim = ultima}
                transicao.posicaoVitoria(botaoParametros.botaoLivre,nave,parametrosVitoria);
            end
        end
    end
end
-------------------------------------------------------------------------------------

local function ataqueChefe(chefe)
    som.temaChefe();
    local movimento2 = transition.to(chefe, { x = 260, time = 3000, iterations = 0, transition=easing.continuousLoop})--onComplete = function() ataqueChefe(chefe) end } )
    local parametros = { fase = 2, grupo = mainGroup, vidas = nave:getVidas(), tipo = 4, vidaChefe = lifeChefe }
    local tiro = function() return enemy.Disparar(chefe,parametros) end
    atkChefeLoopTimer = timer.performWithDelay(800, tiro, 0)    
end

-- Funcao para carregar o chefao
local function bigBoss( event )
    som.onClose();
    som.morteChefe();
    som.onClose();
    chefe = enemy.new(2,mainGroup,4)
    chefe.x = display.contentCenterX -100
    chefe.y = 50
    physics.addBody( chefe, {radius = 30, isSensor = true } )
    --chefe.myName = "chefe"
    chefe.collision = colisaoInimigo
    chefe:addEventListener("collision")
    chefe.alpha = 0
    transition.to(chefe, {alpha = 1, time = 2000, onComplete = function() ataqueChefe(chefe) end } )     
end

local function chefeFinal( event )

    timer.cancel( inimigoLoopTimer );
    timer.cancel( itemLoopTimer );
    timer.performWithDelay(3000, bigBoss, 1)
end

-------- GERA INIMIGOS --------------------------------------------------------------
-- Funcao para gerar as naves Aliens --
local function geraInimigo( event )

    local parametros = { fase = 2, grupo = mainGroup, vidas = nave:getVidas(), tipo = nil, vidaChefe = nil }

    if( nave:getVidas() ~= 0 )then
        local opt = math.random(1,3)
        parametros.tipo = opt
        local inimigo = enemy.tipoInimigo(parametros)--function() return enemy.tipoInimigo( parametros ) end
        inimigo.collision = colisaoInimigo
        inimigo:addEventListener("collision")
        timer.performWithDelay(500, inimigo, math.random(3))
        
    end
end

local function updateFrame()
    transition.to(fundo, { y = 800, time = 45000, onComplete = function() chefeFinal() end })
end

----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    -------------------------------------------------------------------
    physics.pause();
	sceneGroup:insert(backGroup);
	sceneGroup:insert(mainGroup);
    sceneGroup:insert(uiGroup);
    --scoreText = display.newText( uiGroup, "Score: " .. score, display.contentCenterX, 20, native.systemFont, 25 )
    local tipo = event.params;
    print("Municao: " .. tipo.totalMunicao )
    --geraNave(parametro.tipoNave)
    ultima = tipo.fim
    nave = heroi:new(nil,tipo.tipoNave, tipo.totalMunicao, mainGroup, tipo.totalVidas)
    nave.imagem.x = display.contentCenterX
    nave.imagem.y = display.contentHeight + 100
    physics.addBody( nave.imagem, {radius = 20, isSensor=true} )
    nave.imagem:addEventListener("touch", dragShip);
    nave.imagem.collision = colisaoHeroi
    nave.imagem:addEventListener("collision")
    score = tipo.totalScore
    uiDisp.Score(uiGroup, score);
    uiDisp.Vidas(uiGroup, nave:getTipo(),nave:getVidas());
    local uidispParametros = { grupo = uiGroup }
    uiDisp.Preparar(uidispParametros);
    botaoParametros.grupo = uiGroup;
    uiDisp.Botao(botaoParametros)
    botaoParametros.botaoLivre:addEventListener("touch",disparar)
    
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
		transition.to(nave.imagem, {x = display.contentCenterX, y = display.contentCenterY, time = 3000, transition=easing.inOutBack } )
		updateFrame()
        inimigoLoopTimer = timer.performWithDelay(2500, geraInimigo, 0)
        Runtime:addEventListener( "accelerometer", recarregar );
        itemLoopTimer = timer.performWithDelay(7000, geraItens, 0)
        som.somFase2();
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        --timer.cancel( atkChefeLoopTimer )
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        transition.cancel()
        Runtime:removeEventListener("accelerometer", recarregar);
        Runtime:removeEventListener("touch", botao) 
        som.onClose()
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