class_name TSP_Simples
extends Node2D

const tspMenu:PackedScene = preload("res://Cena/TSPMenu.tscn")

@onready var label = $Label

var cidades:Array = []
var totalCidades:int = 10

var DistanciaRecord:float
var MelhorCaminhoEncontrado:Array = []

var tamanhoTela:Vector2i = Vector2i(1920,1080)
var resolucao:Vector2i = Vector2i(2260,1200)
var linha_caminho:Line2D
var linha_calculo:Line2D

func _ready():
	iniciar_padronizacao_tela()
	label.position = Vector2(0,tamanhoTela.y-70)
	label.size = Vector2(tamanhoTela.x,tamanhoTela.y - (tamanhoTela.y - 70))
	#Passo 0: Criar pontos aleatorios no canvas para simbolizar os pontos de interesse do vendedor. 
	#Instanciar as linhas com os devidos pontos criados.
	for i:int in range(totalCidades):
		var cidade:Vector2 = Vector2(randi_range(0,tamanhoTela.x),randi_range(0,tamanhoTela.y))
		cidades.append(cidade)
	linha_caminho = Line2D.new()
	linha_caminho.width = 4
	linha_caminho.default_color = 'ff0000'
	
	linha_calculo = Line2D.new()
	linha_calculo.width = 1
	linha_calculo.default_color = 'ffffff75'
	
	for i in range(totalCidades):
		linha_caminho.add_point(cidades[i])
		linha_calculo.add_point(cidades[i])
	
	add_child(linha_caminho)
	add_child(linha_calculo)
	
	#passo 1: calcular a soma da distancia entre cada um dos pontos registrados no array cidades e 
	#salvar como distancia record
	var distancia:float = calcular_distancia(cidades)
	DistanciaRecord = distancia
	MelhorCaminhoEncontrado = cidades.duplicate()

func iniciar_padronizacao_tela() -> void:
	var pos_offset:Vector2 = resolucao - tamanhoTela
	get_viewport().size = tamanhoTela
	get_window().position = Vector2(pos_offset.x/2,pos_offset.y/2)

func calcular_distancia(pontos:Array) -> float:
	var soma:float = 0.0
	for i:int in range(pontos.size() -1):
		var distancia:float = pontos[i].distance_to(pontos[i+1])
		soma += distancia
	return soma

func _process(_delta):
	#passo 2: a cada frame trocar a posicao de duas casas do array cidades e atualizar a linha_calculo,
	#conforme o array trocado.
	var index_a:int = randi_range(0,cidades.size() -1)
	var index_b:int = randi_range(0,cidades.size() -1)
	trocar_posicoes_do_array(cidades,index_a,index_b)
	atualizar_linha_calculo()
	
	#passo 3: calcular novamente a distancia entre cada um dos pontos do array e verificar se a nova distancia
	#é menor do que a distancia record antiga. Se for atualizar a distancia record com o valor da distancia atual
	#e modificar a linha_caminho para o novo caminho.
	var distancia:float = calcular_distancia(cidades)
	if distancia < DistanciaRecord:
		DistanciaRecord = distancia
		MelhorCaminhoEncontrado = cidades.duplicate()
	atualizar_linha_caminho()

func trocar_posicoes_do_array(pontos:Array, idx_A:int, idx_B:int) -> void:
	var temp:Vector2 = pontos[idx_A]
	pontos[idx_A] = pontos[idx_B]
	pontos[idx_B] = temp

func atualizar_linha_calculo() -> void:
	linha_calculo.points = cidades

func atualizar_linha_caminho() -> void:
	linha_caminho.points = MelhorCaminhoEncontrado

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanhoTela),'000000')
	
	for i in totalCidades:
		draw_arc(cidades[i],8,0,359,36,'ff00ff')


func _on_timer_timeout():
	await get_tree().create_timer(5).timeout
	voltar_pro_menu()

func voltar_pro_menu() -> void:
	self.queue_free()

func _input(_event):
	if Input.is_action_just_pressed("q"):
		voltar_pro_menu()
