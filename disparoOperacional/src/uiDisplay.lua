local imagens = require("src.carregarImagens")
local vida = {}
local scoreText
local ui = {}
--local score = 0 

function ui.Vidas(grupo,tipo,vidas)

    if( vidas == 3) then
        vida[1] = imagens.carregarHeroi(grupo, tipo) 
        vida[1].x = display.contentCenterX - 120
        vida[1].y = 20
        vida[1].xScale = 0.3
        vida[1].yScale = 0.3
        vida[2] = imagens.carregarHeroi(grupo, tipo)
        vida[2].x = display.contentCenterX - 90
        vida[2].y = 20
        vida[2].xScale = 0.3
        vida[2].yScale = 0.3 
    else
        vida[1] = imagens.carregarHeroi(grupo, tipo) 
        vida[1].x = display.contentCenterX - 120
        vida[1].y = 20
        vida[1].xScale = 0.3
        vida[1].yScale = 0.3
    end
    --return vida
end

function ui.AtualizaVidas(vidas)

    if(vidas == 2)then
        display.remove( vida[2] )
    elseif (vidas == 1 ) then
        display.remove( vida[1] )
    end
end

function ui.Score(grupo,score)

    scoreText = display.newText( grupo, "Score: " .. score, display.contentCenterX, 20, native.systemFont, 25 )
end

function ui.AtualizaScore(pontos)

    local score = pontos + 100;
    scoreText.text = "Score: " .. score
    return score
end

function ui.Mensagem(grupo,status)

    local replayButton
    if ( status == "derrota") then
        local mensagemText = display.newText(grupo, "VOCE PERDEU!!!", display.contentCenterX, display.contentCenterY, native.systemFont, 20 )
        replayButton = display.newText( grupo, "Toque pra Jogar Novamente", display.contentCenterX, display.contentCenterY + 50, native.systemFont, 20 );
        replayButton:setFillColor( 1, 1, 1)
        
    else
        local mensagemText = display.newText(grupo, "PARABENS VOCÊ VENCEU!!!", display.contentCenterX, display.contentCenterY, native.systemFont, 20 )
        replayButton = display.newText( grupo, "Toque pra Jogar Novamente", display.contentCenterX, display.contentCenterY + 50, native.systemFont, 20 );
        replayButton:setFillColor( 1, 1, 1)
       
    end
    return replayButton
end


return ui