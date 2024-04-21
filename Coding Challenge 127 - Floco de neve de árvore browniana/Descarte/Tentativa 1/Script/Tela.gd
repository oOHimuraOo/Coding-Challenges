class_name TELA_OLD
extends Node2D

@onready var matriz_cena:PackedScene = preload("res://Cena/Matriz.tscn")

@onready var matriz = $Matriz
@onready var matriz_2 = $Matriz2
@onready var matriz_3 = $Matriz3
@onready var matriz_4 = $Matriz4
@onready var matriz_5 = $Matriz5
@onready var matriz_6 = $Matriz6


var tamanho_da_tela:Vector2i = Vector2i(600,600)
## esse script precisará instanciar 6 matriz e inciar elas.

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().set_size(tamanho_da_tela)
	matriz.tamanhoDaTela = tamanho_da_tela
	matriz_2.tamanhoDaTela = tamanho_da_tela
	matriz_3.tamanhoDaTela = tamanho_da_tela
	matriz_4.tamanhoDaTela = tamanho_da_tela
	matriz_5.tamanhoDaTela = tamanho_da_tela
	matriz_6.tamanhoDaTela = tamanho_da_tela
	#instanciar_matrizes()


func instanciar_matrizes() -> void:
	var rotacao:float
	for i in range(6):
		var matriz:MATRIZ = matriz_cena.instantiate()
		matriz.tamanhoDaTela = tamanho_da_tela
		matriz.rotation = 45
		add_child(matriz)
