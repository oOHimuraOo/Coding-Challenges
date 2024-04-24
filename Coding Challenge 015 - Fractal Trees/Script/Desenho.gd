class_name DESENHO
extends Node2D

@onready var timer = $Timer

var tamanho_da_tela:Vector2i = Vector2i(1920,1080)
var tamanho_do_galho_inicial = 300
var arvore:Array = []
var folhas:Array = []

var contador:int = 0
var desenharFlores = false
var plano_de_fundo = false

func _ready():
	get_viewport().size = tamanho_da_tela
	var inicio:Vector2 = Vector2(tamanho_da_tela.x/2,tamanho_da_tela.y)
	var final:Vector2 = Vector2(tamanho_da_tela.x/2,tamanho_da_tela.y - tamanho_do_galho_inicial)
	var galho:GALHO = GALHO.new(inicio,final, randi_range(30,50))
	arvore.append(galho)

func _process(_delta):
	for i in range(arvore.size() -1, -1, -1):
		if !get_children().has(arvore[i]):
			arvore[i].revelar(self)
		
	queue_redraw()

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanho_da_tela),'000000ff')
	
	if desenharFlores == true:
		for folha in folhas:
			draw_circle(folha, randi_range(4,16),'eabccd60')
			draw_circle(folha+ Vector2(10,10), randi_range(4,16),'eabccd60')
			draw_circle(folha+ Vector2(-10,-10), randi_range(4,16),'eabccd60')
			draw_circle(folha+ Vector2(0,-10), randi_range(4,16),'eabccd60')
			draw_circle(folha+ Vector2(0,10), randi_range(4,16),'eabccd60')
			draw_circle(folha+ Vector2(10,0), randi_range(4,16),'eabccd60')
			draw_circle(folha+ Vector2(-10,0), randi_range(4,16),'eabccd60')
			set_process(false)
			


func _on_timer_timeout():
	print(contador)
	if contador < 10:
		for i in range(arvore.size() -1, -1, -1):
			if !arvore[i].terminado:
				arvore.append(arvore[i].galhoA())
				arvore.append(arvore[i].galhoB())
				#arvore.append(arvore[i].galhoC())
				#arvore.append(arvore[i].galhoD())
			arvore[i].terminado = true
		contador += 1
	elif contador == 10:
		for i in range(arvore.size()):
			if !arvore[i].terminado:
				desenharFlores = true
				var folha = arvore[i].f
				folhas.append(folha)
		contador += 1
	else:
		timer.stop()
		await get_tree().create_timer(5).timeout
		get_tree().reload_current_scene()
