class_name TRECHO_OLD
extends Control

signal acabouTrecho()

@onready var particula_cena:PackedScene = preload("res://Tentativa 2/Cena/Particula.tscn")

var atual:PARTICULA
var flocosDeNeve:Array = []
var telaTamanho:Vector2
var liberador:bool = true

func _ready() -> void:
	redimensionar_tela(Vector2i(600,600))
	atual = criar_particula()

func redimensionar_tela(tamanho:Vector2i) -> void:
	get_viewport().size = tamanho
	telaTamanho = tamanho

func criar_particula(raioTela:float = telaTamanho.y/2, angulo:float = 0,raioParticula = 1) -> PARTICULA:
	var atual_instancia:PARTICULA = particula_cena.instantiate()
	atual_instancia.iniciar_valores(raioTela, angulo,raioParticula)
	add_child(atual_instancia)
	atual_instancia.get_child(0).get_child(0).shape.radius = atual_instancia.r
	return atual_instancia

func _process(_delta) -> void:
	if liberador == true:
		var contador:int = 0
		while !atual.terminado() && !atual.intersepta(flocosDeNeve):
			atual.atualizar()
			contador += 1
		
		if contador == 0:
			liberador = false
			print("acabou trecho")
			acabouTrecho.emit()
	
	flocosDeNeve.append(atual)
	atual = criar_particula()

