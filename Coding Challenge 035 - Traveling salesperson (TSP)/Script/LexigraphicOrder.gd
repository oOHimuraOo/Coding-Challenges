class_name LEXIGROPHIC_ORDER
extends Node2D

const tspMenu:PackedScene = preload("res://Cena/TSPMenu.tscn")

@onready var label:Label = $Label
@onready var label_2:Label = $Label2
@onready var label_3:Label = $Label3

var valores:Array = [0,1,2,3,4]

var tamanhoTela:Vector2i = Vector2i(1920,1080)
var resolucao:Vector2i = Vector2i(2260,1200)
var contador = 0

func _ready():
	iniciar_padronizacao_tela()
	label.position = Vector2(round(tamanhoTela.x/2.0), round(tamanhoTela.y/2.0) - 100)
	label.set_text('Ordenação Lexigrofica')
	label_2.position = round(tamanhoTela/2.0)
	label_2.set_text('irei mostrar as três ultimas organizações lexigroficas')
	label_3.position = Vector2(round(tamanhoTela.x/2.0),round(tamanhoTela.y/2.0) + 100)
	label_3.set_text('Clique para iniciar')
	set_process(false)

func iniciar_padronizacao_tela() -> void:
	var pos_offset:Vector2 = resolucao - tamanhoTela
	get_viewport().size = tamanhoTela
	get_window().position = Vector2(pos_offset.x/2,pos_offset.y/2)

func _input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		label.set_text('calculando')
		set_process(true)
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanhoTela), '000000')

func _process(_delta):
	#passo 1: encontre o maior valor que seja menor do que valor da ultima casa do array. se esse 
	#valor não existir é pq acabaram as possibilidades então finalize o programa.
	var maiorValorI:int = -1
	for i in range(valores.size() - 1):
		if valores[i] < valores[i+1]:
			maiorValorI = i
	if maiorValorI == -1:
		print('acabou!')
		set_process(false)
	
	#passo 2: encontre o maior valor que seja menor do que o valor registrado em MaiorValorI
	#e registre.
	var maiorValorJ:int = -1
	for j in range(valores.size()):
		if valores[maiorValorI] < valores[j]:
			maiorValorJ = j
	
	#passo 3: troque as posições do valor i com o valor j no array
	trocar_posicoes_do_array(valores, maiorValorI,maiorValorJ)
	
	#passo 4: inverta as posicoes do array que vierem depois de maiorValorI:
	var finalDoArray = valores.slice(maiorValorI + 1)
	for i in range(finalDoArray.size()):
		valores.erase(finalDoArray[i])
	finalDoArray.reverse()
	valores.append_array(finalDoArray)
	contador += 1
	
	
	if contador == fatorar(valores.size()) -1:
		var texto:String = ''
		for i in range(valores.size()):
			texto += str(valores[i])
		label.set_text(texto)
		await get_tree().create_timer(5).timeout
		voltar_pro_menu()
	elif contador == fatorar(valores.size()) - 2:
		var texto:String = ''
		for i in range(valores.size()):
			texto += str(valores[i])
		label_2.set_text(texto)
	if contador < fatorar(valores.size()) - 3:
		var texto:String = ''
		for i in range(valores.size()):
			texto += str(valores[i])
		label_3.set_text(texto)
		label_2.set_text(texto)

func voltar_pro_menu() -> void:
	self.queue_free()

func trocar_posicoes_do_array(pontos:Array, idx_A:int, idx_B:int) -> void:
	var temp:int = pontos[idx_A]
	pontos[idx_A] = pontos[idx_B]
	pontos[idx_B] = temp

func fatorar(n:int) -> int:
	if n <= 1:
		return n
	else:
		return n * fatorar(n-1)
