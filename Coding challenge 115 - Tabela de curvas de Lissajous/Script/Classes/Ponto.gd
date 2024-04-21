class_name PONTO
extends Node2D

var angulo:int = 36
var p:Vector2
var r:float
var c:Color
var circulo:Polygon2D


func _init(nodoPai:Node2D, posicao:Vector2, raio:float = 5.0, cor:Color = Color("00ff00")) -> void:
	p = posicao
	r = raio
	c = cor
	iniciar_circulo(nodoPai)

func iniciar_circulo(nodoPai:Node2D) -> void:
	circulo = Polygon2D.new()
	var incremento_de_angulo:float = 2 * PI / angulo
	var pontos:Array = []
	for ang in range(angulo):
		var x = (r * cos(ang * incremento_de_angulo))
		var y = (r * sin(ang * incremento_de_angulo))
		pontos.append(Vector2(x, y))
	circulo.polygon = pontos
	circulo.color = c
	nodoPai.add_child(circulo)

func atualizar_posicao(posicao:Vector2) -> void:
	p = posicao
	var incremento_de_angulo:float = 2 * PI / angulo
	var pontos:Array = []
	for ang in range(angulo):
		var x = p.x + (r * cos(ang * incremento_de_angulo))
		var y = p.y + (r * sin(ang * incremento_de_angulo))
		pontos.append(Vector2(x, y))
	circulo.polygon = pontos

	
	
	
