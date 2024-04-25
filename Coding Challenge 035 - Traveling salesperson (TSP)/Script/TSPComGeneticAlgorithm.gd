class_name TSP_COM_GENETIC_ALGORITHM
extends Node2D

const tspMenu:PackedScene = preload("res://Cena/TSPMenu.tscn")

@onready var label = $Label

var tamanhoTela:Vector2i = Vector2i(1920,1080)
var resolucao:Vector2i = Vector2i(2260,1200)

var totalCidades:int = 5
var cidades:Array = []

var populacaoTamanho:int = 500
var pontuacao:Array = []
var populacao:Array = []

var permutacoesTotais:float
var contador:float

var linha_caminho:Line2D
var linha_calculo:Line2D

var distanciaRecord:float = INF
var melhorCaminhoEncontrado:Array
var melhorCaminhoAtual:Array

func _ready():
	iniciar_padronizacao_tela()
	var ordem:Array = etapa_0_montagem()
	etapa_1_registro(ordem)
	permutacoesTotais = fatorar(totalCidades)

func iniciar_padronizacao_tela() -> void:
	var pos_offset:Vector2 = resolucao - tamanhoTela
	get_viewport().size = tamanhoTela
	get_window().position = Vector2(pos_offset.x/2,pos_offset.y/2)

func etapa_0_montagem() -> Array:
	var ordem:Array = []
	for i:int in range(totalCidades):
		var cidade:Vector2 = Vector2(randi_range(0,tamanhoTela.x),randi_range(0,tamanhoTela.y - 100))
		cidades.append(cidade)
		ordem.append(i)
	
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
	return ordem

func etapa_1_registro(ordem:Array) -> void:
	for i in range(populacaoTamanho):
		var novaOrdem:Array = ordem.duplicate()
		novaOrdem.shuffle()
		populacao.append(novaOrdem)

func fatorar(n:float) -> float:
	if n <= 1:
		return n
	else:
		return n * fatorar(n-1)

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
	
func trocar_posicoes_do_array(pontos:Array, idx_A:int, idx_B:int) -> void:
	var temp = pontos[idx_A]
	pontos[idx_A] = pontos[idx_B]
	pontos[idx_B] = temp

func atualizar_linha_calculo() -> void:
	for i:int in range(melhorCaminhoAtual.size()):
		var idx:int = melhorCaminhoAtual[i]
		linha_calculo.set_point_position(i,cidades[idx])

func atualizar_linha_caminho() -> void:
	for i:int in range(melhorCaminhoEncontrado.size()):
		var idx:int = melhorCaminhoEncontrado[i]
		linha_caminho.set_point_position(i,cidades[idx])

func _process(_delta):
	calcular_pontuacao()
	normalizar_pontuacao()
	proxima_geracao()
	atualizar_linha_calculo()
	atualizar_linha_caminho()
	LX_etapa_4_calcular_percentagem()

func calcular_pontuacao() -> void:
	var recordAtual:float = INF
	
	for i in range(populacao.size()):
		var distancia:float = calcular_distancia(cidades, populacao[i])
		if distancia < distanciaRecord:
			distanciaRecord = distancia
			melhorCaminhoEncontrado = populacao[i]
		if distancia < recordAtual:
			recordAtual = distancia
			melhorCaminhoAtual = populacao[i]
		pontuacao.append(1/(pow(distancia,8)+1))

func normalizar_pontuacao() -> void:
	var soma:float = 0
	for i in range(pontuacao.size()):
		soma += pontuacao[i]
	for i in range(pontuacao.size()):
		pontuacao[i] = pontuacao[i]/soma

func proxima_geracao() -> void:
	var novaPopulacao:Array = []
	
	for i in range(populacao.size()):
		var ordemA = selecionar_um(populacao, pontuacao)
		var ordemB = selecionar_um(populacao, pontuacao)
		var ordem = mesclar(ordemA, ordemB)
		mutacionar(ordem, 0.01)
		novaPopulacao.append(ordem) 
	populacao = novaPopulacao
	contador += 1
	if contador == permutacoesTotais:
		set_process(false)
		await get_tree().create_timer(5).timeout
		voltar_pro_menu()

func voltar_pro_menu() -> void:
	self.queue_free()

func selecionar_um(pop:Array, pont:Array) -> Array:
	var index:int = 0
	var rand:float = randf()
	
	while rand > 0:
		rand -= pont[index]
		index += 1
	index -= 1
	return pop[index].duplicate()

func mesclar(ordemA:Array,ordemB:Array) -> Array:
	var inicio:int = randi_range(0, ordemA.size() -1)
	var final:int = randi_range(inicio + 1, ordemA.size() - 1)

	var novaOrdem = ordemA.slice(inicio,final)
	for i in range(ordemB.size()):
		var cidade = ordemB[i]
		if !novaOrdem.has(cidade):
			novaOrdem.append(cidade)
	return novaOrdem

func mutacionar(ordem, indiceDeMutcao) -> void:
	for i in range(totalCidades):
		if randf_range(0,1) < indiceDeMutcao:
			var indexA = randi_range(0, ordem.size() -1)
			var indexB = (indexA + 1) % totalCidades
			trocar_posicoes_do_array(ordem, indexA, indexB)

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanhoTela),'000000')
	
	for i in totalCidades:
		draw_arc(cidades[i],8,0,359,36,'ff00ff')

func LX_etapa_4_calcular_percentagem() -> void:
	var calculo:float = 100.00 * (contador/permutacoesTotais)
	var porcentagem:String = "%*.*f"
	label.position = Vector2(0,tamanhoTela.y-70)
	label.size = Vector2(tamanhoTela.x,tamanhoTela.y - (tamanhoTela.y - 70))
	label.set_text(porcentagem % [3,2, calculo]  + '% completo')
