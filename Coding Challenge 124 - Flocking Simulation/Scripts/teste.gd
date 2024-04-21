extends Node2D

@onready var mapa = $Mapa
@onready var dinoCena:PackedScene = preload("res://Cenas/Dino.tscn")

var tamanhoTela:Vector2i = Vector2i(640,320)
var dinos:Array = []

func _ready():
	iniciar_tamanho_tela()
	for i in range(30): #min(tamanhoTela.x/10.0,tamanhoTela.y/7.0)
		var dino:DINO = dinoCena.instantiate()
		dino.pos = Vector2(randi_range(16,tamanhoTela.x-16),randi_range(16,tamanhoTela.y-16))
		dino.vel = Vector2(randi_range(-1,1),randi_range(-1,1))
		dino.tamTel = tamanhoTela
		add_child(dino)
		dinos.append(dino)

func iniciar_tamanho_tela() -> void:
	get_viewport().size = tamanhoTela

func _physics_process(delta):
	for dino:DINO in dinos:
		dino.bordas()
		dino.rebanho(dinos)
		dino.no_processamento_de_fisica(delta,dinos)
