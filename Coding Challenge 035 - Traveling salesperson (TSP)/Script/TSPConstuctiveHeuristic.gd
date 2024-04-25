class_name TSP_CONSTRUCTIVE_HEURISTIC
extends Node2D

const tspMenu:PackedScene = preload("res://Cena/TSPMenu.tscn")

@onready var label = $Label

var tamanhoTela:Vector2i = Vector2i(1920,1080)
var resolucao:Vector2i = Vector2i(2260,1200)

var qtdCidades:int = 100 #maximo suportado no godot 1022
var arrayCidades:Array = []
var arrayDeComparacao:Array = []
var arrayCaminhos:Array = []
var melhoCaminho:Array = []

var linhaCalculo:Line2D
var linhaCaminho:Line2D

var contador:float

var cidadeAtual:Vector2
var menorDistPont:Vector2

func _ready():
	iniciar_padronizacao_tela()
	etapa_0_gerar_pontos()

func iniciar_padronizacao_tela() -> void:
	var pos_offset:Vector2 = resolucao - tamanhoTela
	get_viewport().size = tamanhoTela
	get_window().position = Vector2(pos_offset.x/2,pos_offset.y/2)

func etapa_0_gerar_pontos() -> void:
	for i in range(qtdCidades):
		var cidade:Vector2 = Vector2(randi_range(0,tamanhoTela.x),randi_range(0,tamanhoTela.y-100))
		arrayCidades.append(cidade)
	arrayDeComparacao = arrayCidades.duplicate()
	
	linhaCalculo = Line2D.new()
	linhaCalculo.width = 1
	linhaCalculo.default_color = 'ffffff98'
	add_child(linhaCalculo)
	
	linhaCaminho = Line2D.new()
	linhaCaminho.width = 4
	linhaCaminho.default_color = 'ff0000ff'
	add_child(linhaCaminho)
	
	for i in range(qtdCidades):
		linhaCalculo.add_point(arrayCidades[i])
		linhaCaminho.add_point(arrayCidades[i])
	
	linhaCaminho.hide()

func rodar_programa() -> void:
	if arrayCaminhos.size() < arrayCidades.size():
		if arrayDeComparacao.size() < 1:
			etapa_5_selecionar_novo_ponto_aleatorio()
			var temp:Array = etapa_2_verificar_menor_distancia()
			etapa_4_armazenar_novo_caminho(temp)
		else:
			etapa_1_selecionar_inicial_aleatorio()
			var temp:Array = etapa_2_verificar_menor_distancia()
			etapa_4_armazenar_novo_caminho(temp)
	else:
		etapa_6_atribuir_pontuacao_para_cada_caminho()

func etapa_1_selecionar_inicial_aleatorio() -> void:
	cidadeAtual = arrayDeComparacao.pick_random()
	arrayDeComparacao.erase(cidadeAtual)

func etapa_2_verificar_menor_distancia() -> Array:
	var retorno:Array = []
	var distanciaRecord:float = INF
	for i in range(arrayDeComparacao.size()):
		var distancia:float = cidadeAtual.distance_to(arrayDeComparacao[i])
		if distancia < distanciaRecord:
			distanciaRecord = distancia
			menorDistPont = arrayDeComparacao[i]
	if !retorno.has(cidadeAtual):
		retorno.append(cidadeAtual)
	if !retorno.has(menorDistPont):
		retorno.append(menorDistPont)
	if arrayDeComparacao.size() > 0:
		etapa_3_selecionar_proximo()
		retorno.append_array(etapa_2_verificar_menor_distancia())
	return retorno

func etapa_3_selecionar_proximo() -> void:
	cidadeAtual = menorDistPont
	arrayDeComparacao.erase(cidadeAtual)

func etapa_4_armazenar_novo_caminho(arr:Array) -> void:
	var novoCaminho:Array = []
	for i in range(arr.size()):
		if !novoCaminho.has(arr[i]):
			novoCaminho.append(arr[i])
	arrayCaminhos.append(novoCaminho)
	linhaCalculo.points = arrayCaminhos[-1]
	contador += 1

func etapa_5_selecionar_novo_ponto_aleatorio() -> void:
	var array_de_pontos_iniciais_ja_selecionados:Array = []
	for i in range(arrayCaminhos.size()):
		array_de_pontos_iniciais_ja_selecionados.append(arrayCaminhos[i][0])
	arrayDeComparacao = arrayCidades.duplicate()
	for i in range(array_de_pontos_iniciais_ja_selecionados.size()):
		arrayDeComparacao.erase(array_de_pontos_iniciais_ja_selecionados[i])
	cidadeAtual = arrayDeComparacao.pick_random()
	arrayDeComparacao = arrayCidades.duplicate()
	arrayDeComparacao.erase(cidadeAtual)

func etapa_6_atribuir_pontuacao_para_cada_caminho() -> void:
	var arrayDeSomas:Array = []
	var arrayDePosicoes:Array = []
	for i in range(arrayCaminhos.size()):
		arrayDePosicoes.append(i)
	
	for i in range(arrayCaminhos.size()):
		var soma:float = round(calcular_distancia(arrayCaminhos[i], arrayDePosicoes))
		arrayDeSomas.append(soma)
	if melhoCaminho.size() < 1:
		melhoCaminho.append_array(arrayCaminhos[arrayDeSomas.find(arrayDeSomas.min())])
	atualizar_linha_caminho()

func calcular_distancia(pontos:Array, posicao:Array) -> float:
	var soma:float = 0.0
	for i:int in range(posicao.size() -1):
		var idxA:int = posicao[i]
		var cidadeA:Vector2 = pontos[idxA]
		var idxB:int = posicao[i+1]
		var cidadeB:Vector2 = pontos[idxB]
		
		var distancia:float = cidadeA.distance_to(cidadeB)
		soma += distancia
	return soma

func _process(_delta):
	rodar_programa()
	LX_etapa_4_calcular_percentagem()

func atualizar_linha_caminho() -> void:
	for i:int in range(melhoCaminho.size()):
		linhaCaminho.set_point_position(i,melhoCaminho[i])
	linhaCaminho.show()
	linhaCalculo.hide()
	await get_tree().create_timer(5).timeout
	voltar_pro_menu()

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanhoTela),'000000')
	
	for i in qtdCidades:
		draw_arc(arrayCidades[i],8,0,359,36,'ff00ff')

func LX_etapa_4_calcular_percentagem() -> void:
	var calculo:float = 100.00 * (contador/qtdCidades)
	var porcentagem:String = "%*.*f"
	label.position = Vector2(0,tamanhoTela.y-70)
	label.size = Vector2(tamanhoTela.x,tamanhoTela.y - (tamanhoTela.y - 70))
	label.set_text(porcentagem % [3,2, calculo]  + '% completo')

func voltar_pro_menu() -> void:
	self.queue_free()
