class_name FOLHA
extends Node2D

@onready var label = $Label
@onready var folhaCena:PackedScene = preload("res://Cenas/Folha.tscn")

var valor = null
var direita:FOLHA = null
var esquerda:FOLHA = null

var pos:Vector2
var line:Line2D

func _ready():
	assert(valor != null)
	label.set_text(str(valor))

func adicionar_nova_folha(val:int,dist:int, profundidade:int, nodoPrincipal:Node2D) -> void:
	var fator = 2
	if profundidade > 4:
		nodoPrincipal.valoresAdicionados.append(val)
		return
	if val < valor:
		if esquerda == null:
			esquerda = folhaCena.instantiate()
			esquerda.valor = val
			esquerda.position = Vector2(-dist,100)
			add_child(esquerda)
		else:
			esquerda.adicionar_nova_folha(val, dist/fator, profundidade + 1, nodoPrincipal)
	elif val > valor:
		if direita == null:
			direita = folhaCena.instantiate()
			direita.valor = val
			direita.position = Vector2(dist,100)
			add_child(direita)
		else:
			direita.adicionar_nova_folha(val, dist/fator, profundidade + 1, nodoPrincipal)

func _process(delta):
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO,20,'ffffff')
	#draw_arc(Vector2.ZERO,20,0,359,36,'ffffff',2)
	if direita != null:
		draw_line(Vector2.ZERO,direita.position,'ffffff',2)
	if esquerda != null:
		draw_line(Vector2.ZERO,esquerda.position,'ffffff',2)
