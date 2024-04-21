class_name REGUA
extends Node2D

var t1:Vector2
var t2:Vector2
var p:Vector2
var l:float
var c:Color
var regua:Line2D
var horizontal:bool

func _init(eixo_x_inicial:float, eixo_y_inicial:float, eixo_x_final:float, eixo_y_final:float, nodoPai:Node2D, movimento:bool) -> void:
	t1 = Vector2(eixo_x_inicial,eixo_y_inicial)
	t2 = Vector2(eixo_x_final,eixo_y_final)
	l = 2
	c = Color('0000ff')
	horizontal = movimento
	iniciar_regua(nodoPai)

func iniciar_regua(nodoPai:Node2D) -> void:
	regua = Line2D.new()
	regua.default_color = c
	regua.width = l
	nodoPai.add_child(regua)

func movimentar_regua(posicao:Vector2) -> void:
	p = posicao
	var array_de_posicoes:Array
	if horizontal:
		var movimentacao_x1:Vector2 = p - Vector2(t1.x - t2.x, 0)
		var movimentacao_x2:Vector2 = p + Vector2(t1.x - p.x, 0)
		array_de_posicoes = [movimentacao_x1, movimentacao_x2]
	else:
		var movimentacao_y1:Vector2 = p 
		var movimentacao_y2:Vector2 = p + Vector2(0, t2.y - p.y)
		array_de_posicoes = [movimentacao_y1, movimentacao_y2]
	regua.points = array_de_posicoes
