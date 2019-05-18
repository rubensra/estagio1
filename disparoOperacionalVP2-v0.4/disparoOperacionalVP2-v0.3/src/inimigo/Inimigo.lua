local imagens = require("src.carregarImagens")
local disparo = require("src.disparo.disparo")

--Inimigo = {tipo = nil, imagem = nil, nome = nil, vidas = nil }
Inimigo = {}

function Inimigo.new (fase, grupo, tipo)

    local imagem;
    if( fase == 1 )then
        if( tipo > 1) then
            imagem = imagens.carregarInimigo(fase,grupo, tipo);
            imagem.myName = "inimigo";
        else
            imagem = imagens.carregarInimigo(fase,grupo, tipo);
            imagem.myName = "chefe";
        end
    elseif( fase == 2 ) then
        if( tipo < 4) then
            imagem = imagens.carregarInimigo(fase,grupo, tipo);
            imagem.myName = "inimigo";
        else
            imagem = imagens.carregarInimigo(fase,grupo, tipo);
            imagem.myName = "chefe"; 
        end
    elseif( fase == 3 ) then
        if( tipo > 1 )then
            imagem = imagens.carregarInimigo(fase,grupo, tipo);
            imagem.myName = "inimigo";
        else
            imagem = imagens.carregarInimigo(fase,grupo, tipo);
            imagem.myName = "chefe";
        end
    end
    return imagem
end


function Inimigo.Disparar(inimigo,parametros)

    if(parametros.fase == 1 and parametros.tipo ~= 1) then
        disparo.Inimigo1(inimigo,parametros.tipo,parametros.grupo,parametros.vidas);
    elseif( parametros.fase == 1 and parametros.tipo == 1 )then
        if(inimigo ~= nil )then
            disparo.Chefe1(inimigo,parametros.tipo,parametros.grupo,parametros.vidas,parametros.vidaChefe);
        end
    end
    
    if(parametros.fase == 2 and parametros.tipo ~= 4) then
        disparo.Inimigo2(inimigo,parametros.tipo,parametros.grupo,parametros.vidas);
    elseif( parametros.fase == 2 and parametros.tipo == 4) then
        disparo.Chefe2(inimigo,parametros.tipo, parametros.grupo,parametros.vidas,parametros.vidaChefe);
    end

    if(parametros.fase == 3 and parametros.tipo == 2) then
        disparo.Inimigo3(inimigo,parametros.tipo,parametros.grupo,parametros.vidas,parametros.hero);
    elseif( parametros.fase == 3 and parametros.tipo == 1) then
            if( inimigo ~= nil )then
                disparo.Chefe3(inimigo,parametros.tipo, parametros.grupo,parametros.vidas,parametros.vidaChefe,parametros.nave);
            end
    end
end

function Inimigo.Remove(inimigo)

    transition.cancel(inimigo)
    display.remove(inimigo)
end

-----------------------------------------------------------------------------------------------------------------

function Inimigo.ataqueInimigo(inimigo,parametros)

    if( parametros.fase == 1) then
        if ( inimigo.x <1 and inimigo.y < display.contentCenterY / 2 ) then
            transition.to( inimigo, {x = 340,  y = display.contentCenterY, time = 3000, transition=easing.inOutSine, onComplete = function() Inimigo.Remove(inimigo) end } )

        elseif( inimigo.y < 1 ) then
            transition.to( inimigo, {y = display.contentHeight + 200, time = 10000, onComplete = function() Inimigo.Remove(inimigo) end } )

        else
            transition.to( inimigo, {x = -100,  y = display.contentCenterY + 200, time = 4000, transition=easing.inExpo, onComplete = function() Inimigo.Remove(inimigo) end } )

        end
        local tiro = function() return Inimigo.Disparar(inimigo,parametros) end
        timer.performWithDelay(1200, tiro, 2)

    elseif(parametros.fase == 2 )then
    
        if ( inimigo.x <1 and inimigo.y < display.contentCenterY / 2 ) then
            transition.to( inimigo, {x = 340,  y = display.contentCenterY, time = 7000, transition=easing.inOutQuart, onComplete = function() Inimigo.Remove(inimigo) end } )
            --print("inOutQuart")
        elseif( inimigo.y < 1 ) then
            transition.to( inimigo, {y = display.contentHeight + 200, time = 10000, onComplete = function() Inimigo.Remove(inimigo) end } )
            --print("inOutBack")
        else
            transition.to( inimigo, {x = -100,  y = display.contentCenterY + 200, time = 4000, transition=easing.outInBack, onComplete = function() Inimigo.Remove(inimigo) end } )
            --print("outInBack")
        end
        if(parametros.tipo == 1 or parametros.tipo == 2) then
            local tiro = function() return Inimigo.Disparar(inimigo, parametros) end
            timer.performWithDelay(1500, tiro, 2)
        end

    elseif(parametros.fase == 3 ) then

        transition.moveTo(inimigo, {x = parametros.hero.x, y = parametros.hero.y + 100, time = 6000, onComplete = function() Inimigo.Remove(inimigo) end } )
        if(parametros.tipo == 3 ) then
            local tiro = function() return Inimigo.Disparar(inimigo, parametros) end
            timer.performWithDelay(1200, tiro, 3)
        end
    end
end

-- Funcao para criar e carregar as Naves Aliens de acordo com o tipo --
function Inimigo.tipoInimigo(parametros)

    local inimigo = Inimigo.new(parametros.fase,parametros.grupo,parametros.tipo);
    local posicao = math.random(1,3)
    if (posicao == 1) then
        inimigo.x = math.random(-100,1)
        inimigo.y = math.random(1, display.contentCenterY)
    elseif (posicao == 2) then
        inimigo.x = math.random(30,280)
        inimigo.y = -50
    else 
        inimigo.x = math.random(320,350)
        inimigo.y = math.random(0, display.contentCenterY)
    end
    physics.addBody( inimigo,{ radius = 15, isSensor = true } )
    Inimigo.ataqueInimigo(inimigo,parametros)
    return inimigo
    
end
   

function Inimigo.atingido(parametros)

        --local piscar = 
        transition.to(parametros.objchefe, {alpha = 0.3, time = 800, onComplete = function() transition.to(parametros.objchefe, {alpha = 1, time = 300, onComplete = function() return false end }) end } )
        --timer.performWithDelay(100, piscar, 1 )
        --return parametros.status
end

-------------------------------------------------------------------------------------

return Inimigo