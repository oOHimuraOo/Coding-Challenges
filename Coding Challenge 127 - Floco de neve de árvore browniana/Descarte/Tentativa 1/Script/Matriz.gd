class_name MATRIZ_OLD
extends Control

@onready var ponto_Cena:PackedScene = preload("res://Cena/ponto.tscn")

var tamanhoDaTela: Vector2i
var particula:PONTO
var particula_2:PONTO
var particula_3:PONTO
var flocoDeNeve:Array = []


func _ready():
	criar_ponto(tamanhoDaTela)

func criar_ponto(vector:Vector2 = Vector2(300,300)) -> void:
	var ponto:PONTO = ponto_Cena.instantiate()
	ponto.iniciar_valores(vector.x,vector.y)
	particula = ponto
	
	var ponto2:PONTO = ponto_Cena.instantiate()
	ponto2.iniciar_valores(vector.x,vector.y)
	ponto2.scale = Vector2(1,-1)
	particula_2 = ponto2
	
	var ponto3:PONTO = ponto_Cena.instantiate()
	ponto3.iniciar_valores(vector.x,vector.y *-1)
	particula_3 = ponto3

func _process(_delta):
	particula.movimento()
	particula_2.movimento()
	particula_3.movimento()
	
	if particula.movimentoTerminado(tamanhoDaTela) || particula.sobrepoe(flocoDeNeve):
		flocoDeNeve.append(particula)
		flocoDeNeve.append(particula_2)
		flocoDeNeve.append(particula_3)
		criar_ponto(tamanhoDaTela)
		
	adicionarParticula(particula)
	adicionarParticula(particula_2)
	adicionarParticula(particula_3)
	for ponto in flocoDeNeve:
		adicionarParticula(ponto)
	

func adicionarParticula(ponto:PONTO) -> void:
	if !get_tree().get_nodes_in_group('flocosDeNeve').has(ponto):
		add_child(ponto)



