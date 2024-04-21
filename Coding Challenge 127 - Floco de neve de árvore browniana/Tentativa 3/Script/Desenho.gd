class_name DESENHO
extends Node2D

@export var Tamanho_de_tela:Vector2i = Vector2i(600,600)

var atual:PARTICULA
var flocosDeNeve:Array = []

func _ready():
	_definir_tamanho_de_tela(Tamanho_de_tela)
	atual = PARTICULA.new(0, Tamanho_de_tela.y/2)
	if !get_tree().get_nodes_in_group('particula').has(atual):
		add_child(atual)

func _definir_tamanho_de_tela(Tt:Vector2i) -> void:
	get_viewport().size = Tt

func _process(_delta):
	var contador:int = 0
	while !atual.terminado() && !atual.intersepta(flocosDeNeve):
			atual.atualizar()
			contador += 1

	if contador == 0:
		print("acabou trecho")
		set_process(false)
	
	flocosDeNeve.append(atual)
	atual = PARTICULA.new(0, Tamanho_de_tela.y/2)
	if !get_tree().get_nodes_in_group('particula').has(atual):
		add_child(atual)
	
	atual.queue_redraw()
	for flocos in flocosDeNeve:
		flocos.queue_redraw()

