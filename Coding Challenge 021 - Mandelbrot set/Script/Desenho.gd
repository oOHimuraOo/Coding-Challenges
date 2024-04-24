class_name DESENHO
extends Node2D
@onready var camera_2d = $Camera2D

var valorMinimo:float = -1.5
var valorMaximo:float = 1.5
var valor:int = 0
var valor_antigo:int = 0
var telaTamanho:Vector2i

func _ready() -> void:
	telaTamanho = Vector2i(1200,1200)
	aplicar_tamanho_de_tela(telaTamanho)

func aplicar_tamanho_de_tela(tamanho:Vector2i) -> void:
	get_viewport().size = tamanho

func _input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		camera_2d.zoom += Vector2(10,10)
		print(camera_2d.zoom)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		camera_2d.zoom -= Vector2(10,10)
		if camera_2d.zoom < Vector2(0.2,0.2):
			camera_2d.zoom = Vector2(0.1,0.1)
	elif Input.is_action_just_pressed("ui_down"):
		camera_2d.position.y += 10
		print(camera_2d.position)
	elif Input.is_action_just_pressed('ui_up'):
		camera_2d.position.y -= 10
		print(camera_2d.position)
	elif Input.is_action_just_pressed('ui_left'):
		camera_2d.position.x -= 10
		print(camera_2d.position)
	elif Input.is_action_just_pressed('ui_right'):
		camera_2d.position.x += 10
		print(camera_2d.position)
	elif Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func desenhar(valor_grupo) -> void:
	var iteracoes_maximas:int = 1000
	for x in range(valor_grupo):
		for y in range(valor_grupo):
			if x >= valor_antigo || y >= valor_antigo:
				var a:float = remap(x,0, telaTamanho.x, valorMinimo, valorMaximo)
				var b:float = remap(y,0, telaTamanho.y, valorMinimo, valorMaximo)
				
				var ca:float = a
				var cb:float = b
				
				var n:int = 0
				
				while n < iteracoes_maximas:
					var aa:float = a * a - b * b
					var bb:float = 2 * a * b
					
					a = aa + ca
					b = bb + cb
					
					if a * a + b * b > 16:
						break
					
					n += 1
				
				var brilho = remap(n, 0, iteracoes_maximas, 0, 1)
				brilho = remap(sqrt(brilho), 0, 1, 0, 255)
				
				if n == iteracoes_maximas:
					brilho = 0
				
					
				
				var retanguloDeTextura:TextureRect = TextureRect.new()
				retanguloDeTextura.size = Vector2(1,1)
				retanguloDeTextura.self_modulate = Color(brilho,brilho,brilho,255)
				retanguloDeTextura.texture = Texture2D.new()
				retanguloDeTextura.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				retanguloDeTextura.global_position = Vector2(x,y)
				add_child(retanguloDeTextura)

func _process(_delta) -> void:
	valor_antigo = valor
	if valor < telaTamanho.x || valor < telaTamanho.y:
		valor += 1
		desenhar(valor)
	else:
		set_process(false)


