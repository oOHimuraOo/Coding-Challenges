class_name GRAIN
extends Node2D

var tamanho:Vector2
var posicao:Vector2
var cor:Color
var cor_salva:Color
var active:bool
var show:bool
var up:GRAIN
var down:GRAIN
var left:GRAIN
var right:GRAIN
var rand:int
var h:float = 0.45
var s:float = 0.45
var v:float = 0.5
var cor_modificada:bool = false

func _init(tam:Vector2, pos:Vector2, act:bool = false):
	randomize()
	tamanho = tam
	posicao = pos
	active = act
	rand = randi_range(1,10) % 2
	cor = Color.from_hsv(h, s, v)

func criar_links(cima:GRAIN, baixo:GRAIN, esquerda:GRAIN, direita:GRAIN) -> void:
	up = cima
	down = baixo
	left = esquerda
	right = direita

func redefinir_cor() -> void:
	cor = Color.from_hsv(h, s, v)
	
	if !cor_modificada:
		cor_salva = cor

func redraw(act:bool) -> void:
	active = act
	rand = randi_range(1,10) % 2
	queue_redraw()

func mouse_show(act:bool) -> void:
	show = act
	queue_redraw()

func _draw():
	if active:
		if cor_modificada:
			draw_rect(Rect2(posicao, tamanho), cor_salva)
		else:
			draw_rect(Rect2(posicao, tamanho), cor)
	elif show:
		draw_rect(Rect2(posicao, tamanho), Color("#ff00ff"))
	else:
		draw_rect(Rect2(posicao, tamanho), Color("#000000"))
