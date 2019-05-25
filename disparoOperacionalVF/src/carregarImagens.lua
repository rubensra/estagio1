local heroi = require("src.heroi.spriteHeroi")
local inimigo1 = require("src.inimigo.spriteInimigoFase1")
local inimigo2 = require("src.inimigo.spriteInimigoFase2")
local inimigo3 = require("src.inimigo.spriteInimigoFase3")
local fundo = require("src.fundo.imagemFundo")
local item = require("src.itens.itens")

local imagens = {}


function imagens.carregarFundo(fase,grupo)
    if( fase == 1 ) then
        return fundo.Fase1(grupo);
    elseif ( fase == 2 ) then
        return fundo.Fase2(grupo);
    elseif ( fase == 3 ) then
        return fundo.Fase3(grupo);
    elseif( fase == "fim") then
        return fundo.Fim(grupo);
    end

end

function imagens.carregarHeroi(grupo,tipo)

    local nave = heroi.carregarHeroi(grupo,tipo);
    nave.x = display.contentCenterX
    nave.y = display.contentCenterY
    nave.xScale = 0.8
    nave.yScale = 0.8
    nave.myName = "nave"
    return nave
end

function imagens.carregarInimigo(fase,grupo,tipo)

    if( fase == 1 ) then
        return inimigo1.carregarInimigo(grupo,tipo);
    elseif ( fase == 2 ) then
        return inimigo2.carregarInimigo(grupo,tipo);
    elseif( fase == 3 ) then
        return inimigo3.carregarInimigo(grupo,tipo);
    end
end

function imagens.carregarAntiVirus(parametros)

    return itens.antiVirus(parametros)
end

function imagens.carregarFirewall(parametros)
    itens.fireWall(parametros)
end

function imagens.carregarEscudo(parametros)

    itens.Escudo(parametros)
end

function imagens.carregarEspecial(parametros)

    itens.Especial(parametros)
end

function imagens.carregarExplosao(parametros)

    return display.newImageRect(parametros.grupo,"images/herois/explosaoAtomica_1280.png", 100, 180 )

end

return imagens

