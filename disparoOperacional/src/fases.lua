local composer = require( "composer" )

local transicao = {}

function transicao.fimDeJogo( vidaChefe)

    if( vidaChefe == 0 )then
        composer.gotoScene( "vitoria", { time=800, effect="crossFade"} )
    else
        composer.gotoScene( "fimJogo", { time=800, effect="crossFade"} )
    end
end

function transicao.gotoFase2(parametros)
    --local parametros = parametros;
    composer.gotoScene( "fase2", { time = 800, effect = "crossFade", params = parametros } )
end

function transicao.gotoFase3(parametros)
    --local parametros = parametros;
    composer.gotoScene( "fase3", { time = 800, effect = "crossFade", params = parametros } )
end

-- Vai pra proxima fase
function transicao.proximaFase(nave,parametros)

    if(parametros.fim == false) then
        if(parametros.fase == 1 ) then
            transition.to( nave.imagem, { y = -50, time = 3000, transition=easing.inQuad, onComplete = function() transicao.gotoFase2(parametros) end } )
        else
            transition.to( nave.imagem, { y = -50, time = 3000, transition=easing.inQuad, onComplete = function() transicao.gotoFase3(parametros) end } )
        end
    else
        transition.to( nave.imagem, { y = -50, time = 3000, transition=easing.inQuad, onComplete = function() transicao.fimDeJogo(0) end } )
    end
end

-- Prepara a ida pra proxima fase
function transicao.posicaoVitoria(botao,nave,parametros)

    display.remove(botao)
    nave.imagem.isBodyActive = false
    transition.moveTo(nave.imagem, { x = display.contentCenterX, y = display.contentHeight - 50, time = 2000, onComplete = function() transicao.proximaFase(nave,parametros) end } )

end

return transicao