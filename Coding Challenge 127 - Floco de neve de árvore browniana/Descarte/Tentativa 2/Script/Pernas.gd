class_name PERNAS_OLD
extends Control

signal acabouPerna()

@onready var trecho_cena:PackedScene = preload("res://Tentativa 2/Cena/Trecho.tscn")

var contagem:int = 0

func _ready():
	instanciar_cenas()
	

func atualizadorDeContagem() -> void:
	print('a')
	get_child(contagem).acabouTrecho.disconnect(atualizadorDeContagem)
	contagem +=1
	if contagem == 2:
		print("acabou perna")
		acabouPerna.emit()

func instanciar_cenas() -> void:
	var trecho_metade_a:TRECHO = trecho_cena.instantiate()
	trecho_metade_a.acabouTrecho.connect(atualizadorDeContagem)
	add_child(trecho_metade_a)
	
	var trecho_metade_b:TRECHO = trecho_cena.instantiate()
	trecho_metade_b.scale = Vector2(1,-1)
	trecho_metade_b.acabouTrecho.connect(atualizadorDeContagem)
	add_child(trecho_metade_b)
