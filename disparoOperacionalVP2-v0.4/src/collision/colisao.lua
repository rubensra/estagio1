
local enemy = require("src.inimigo.Inimigo")

local colisao = {}


function colisao.colisaoHeroi(parametros)

        if( parametros.objct2.myName == "inimigo" or parametros.objct2.myName == "inimigolaser" or parametros.objct2.myName == "chefe" ) then
            
            if( parametros.objct1:getVidas() == 0) then
                display.remove( parametros.objct1.imagem )
                display.remove( parametros.botao )
                enemy.Remove(parametros.objct2)
                return "acabou"
                --timer.performWithDelay(2000, transicao.fimDeJogo(lifeChefe))
            elseif(parametros.objct2.myName ~= "chefe") then
                enemy.Remove(parametros.objct2)
                parametros.objct1.imagem.alpha = 0
                parametros.botao.alpha = 0
                parametros.objct1:setVidas(objct1:getVidas()-1)
                --uiDisp.AtualizaVidas(nave:getVidas())
                --timer.performWithDelay( 1000, restoreShip )
                return "morreu"
            else
                parametros.objct1.imagem.alpha = 0
                parametros.botao.alpha = 0
                parametros.objct1:setVidas(objct1:getVidas()-1)
                --uiDisp.AtualizaVidas(nave:getVidas())
                --timer.performWithDelay( 1000, restoreShip )
                return "morreu"
            end
        end
    end
end

function colisao.colisaoInimigo(parametros)

    
        if(obj2.myName == "laser" and obj1.myName == "inimigo") then
            display.remove(obj2)
            enemy.Remove(obj1)
            return "score"
            --score = uiDisp.AtualizaScore(score)
        elseif((obj2.myName == "laser" or obj2.myName == "nave") and obj1.myName == "chefe" )then
            display.remove(obj2)
            lifeChefe = lifeChefe - 1       
            if(lifeChefe == 0 )then
                display.remove(obj2);
                obj2 = nil;
                display.remove(obj1);
                return "chefe"
                --local parametrosVitoria = { tipoNave = nave:getTipo(), totalVidas = nave:getVidas(), totalScore = score, totalMunicao = nave:getMunicao(), fim = ultima}
                --transicao.posicaoVitoria(botao,nave,parametrosVitoria);
            end
        end
    end
end

return colisao