class_name DESENHO
extends Node2D

@onready var atract = $Atract
@onready var partic = $Partic

var atratores:Array = []
var particulas:Array = []

var tamanhoTela:Vector2i = Vector2i(1920,1080)
var resolucaoTela:Vector2i = Vector2i(2260,1200)

func _ready():
	randomize()
	inicializando_tela()
	for i in range(10):
		var atrator = ATRATOR.new(randi_range(0,tamanhoTela.x),randi_range(0,tamanhoTela.y),randi_range(50,200))
		atract.add_child(atrator)
		atratores.append(atrator)
	for i in range(100):
		var particula = PARTICULA.new(randi_range(0,tamanhoTela.x),randi_range(0,tamanhoTela.y),randi_range(4,40))
		partic.add_child(particula)
		particulas.append(particula)

func inicializando_tela() -> void:
	var pos_offset =  resolucaoTela - tamanhoTela
	get_viewport().size = tamanhoTela
	get_window().position = pos_offset/2

func _process(delta):
	for particula in particulas:
		for atrator:ATRATOR in atratores:
			particula.atracao(atrator)
			if particula.fora_do_limite():
				particula.queue_free()
				particulas.erase(particula)
			if particula.intesepta(atrator):
				atrator.m = atrator.m - particula.m
				atrator.queue_redraw()
				particula.queue_free()
				particulas.erase(particula)
			if atrator.m < 10:
				for i in range(20):
					var par = PARTICULA.new(randi_range(atrator.p.x,atrator.p.x + randi_range(50,200)),randi_range(atrator.p.y,atrator.p.y + randi_range(50,200)),randi_range(4,40))
					partic.add_child(par)
					particulas.append(par)
				atrator.queue_free()
				atratores.erase(atrator)
	if atratores.size() < 3:
		for i in range(5):
			var atrator = ATRATOR.new(randi_range(0,tamanhoTela.x),randi_range(0,tamanhoTela.y),randi_range(50,200))
			atract.add_child(atrator)
			atratores.append(atrator)
	if particulas.size() < 3:
		for i in range(100):
			var particula = PARTICULA.new(randi_range(0,tamanhoTela.x),randi_range(0,tamanhoTela.y),randi_range(4,40))
			partic.add_child(particula)
			particulas.append(particula)
	for i in range(particulas.size() - 1):
		particulas[i].repulsao(particulas[i+1])
	
	for particula in particulas:
		particula.no_process()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, tamanhoTela),'000000')
