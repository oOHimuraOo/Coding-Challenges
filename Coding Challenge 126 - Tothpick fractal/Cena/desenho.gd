class_name DESENHO
extends Node2D

var palitos:Array = []
var palitos_antigos:Array = []
var tamanho_dos_palitos = 50.0

var tamanho_da_tela:Vector2i = Vector2i(1920.0,1080.0)

func _ready():
	iniciar_tamanho_da_tela()
	var palito:PALITO = PALITO.new(tamanho_da_tela.x/2, tamanho_da_tela.y/2, 1, 1, tamanho_dos_palitos, Vector2(tamanho_da_tela))
	palitos.append(palito)

func iniciar_tamanho_da_tela() -> void:
	get_viewport().size = tamanho_da_tela

func no_process(_delta:float, nodoPai:Node2D) -> void:
	print(palitos.size())
	for palito:PALITO in palitos:
		if !get_children().has(palito.linha):
			palito.iniciar_linha(nodoPai)
			
	var proximo:Array = []
	for palito:PALITO in palitos:
		if palito.novo_palito:
			palito.linha.default_color = Color('ff00ff')
			var proximoA = palito.criar_palito(palitos)[0]
			var proximoB = palito.criar_palito(palitos)[1]
			if proximoA != null:
				proximo.append(proximoA)
			if proximoB != null:
				proximo.append(proximoB)
			palito.novo_palito = false
		else:
			palito.linha.default_color = Color('0f00f0')
	
	for i in proximo:
		if !palitos.has(i):
			palitos.append(i)
	
	if get_child_count() >= 1000:
		set_process(false)

func _process(delta):
	no_process(delta, self)

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		no_process(0.016, self)
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanho_da_tela),'000000')
