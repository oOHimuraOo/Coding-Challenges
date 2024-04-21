class_name DESENHO
extends Node2D

var paredes:Array = []
var raio:RAIO
var Particula:PARTICULA
var tamanhoTela:Vector2

func _ready() -> void:
	tamanhoTela = get_viewport().size
	inicializar()
	desenhar()

func inicializar() -> void:
	for i in range(5):
		var x1 = randi_range(0,tamanhoTela.x)
		var y1 = randi_range(0,tamanhoTela.y)
		var x2 = randi_range(0,tamanhoTela.x)
		var y2 = randi_range(0,tamanhoTela.y)
		paredes.append(PAREDE.new(x1,y1,x2,y2)) 
	paredes.append(PAREDE.new(-1,-1,tamanhoTela.x, -1))
	paredes.append(PAREDE.new(tamanhoTela.x, -1, tamanhoTela.x, tamanhoTela.y))
	paredes.append(PAREDE.new(tamanhoTela.x,tamanhoTela.y,-1,tamanhoTela.y))
	paredes.append(PAREDE.new(-1, tamanhoTela.y, -1,-1))
	Particula = PARTICULA.new(tamanhoTela.x/2,tamanhoTela.y/2)
	print(Particula.posicao)
	

func desenhar() -> void:
	for parede:PAREDE in paredes:
		parede.revelar(self, randf_range(5,10))
		
	Particula.revelar(self,2)
	for raio in Particula.raios:
		raio.revelar(self)

func _process(_delta):
	Particula.atualizar(get_local_mouse_position().x, get_local_mouse_position().y)
	Particula.olhar(paredes,self)
	
	
