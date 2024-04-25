class_name TSP_COM_LEXIGRAFICO
extends Node2D

const tspMenu:PackedScene = preload("res://Cena/TSPMenu.tscn")

@onready var label:Label = $Label

var tamanhoTela:Vector2i = Vector2i(1920,1080)
var resolucao:Vector2i = Vector2i(2260,1200)

var totalCidades:int = 6
var cidades:Array = []

var ordem:Array = []

var permutacoesTotais:float
var contador:float

var linha_caminho:Line2D
var linha_calculo:Line2D

var distanciaRecord:float
var melhorCaminhoEncontrado:Array

func _ready():
	iniciar_padronizacao_tela()
	etapa_0_montagem()
	etapa_1_registro()
	permutacoesTotais = fatorar(totalCidades)

func iniciar_padronizacao_tela() -> void:
	var pos_offset:Vector2 = resolucao - tamanhoTela
	get_viewport().size = tamanhoTela
	get_window().position = Vector2(pos_offset.x/2,pos_offset.y/2)

func etapa_0_montagem() -> void:
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

func etapa_1_registro() -> void:
	var distancia:float = calcular_distancia(cidades, ordem)
	distanciaRecord = distancia
	melhorCaminhoEncontrado = ordem.duplicate()

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

func _process(_delta):
	#etapa_2_reorganizar()
	atualizar_linha_calculo()
	etapa_3_calcular()
	proxima_ordem()

func etapa_2_reorganizar() -> void:
	var index_a:int = randi_range(0,cidades.size() -1)
	var index_b:int = randi_range(0,cidades.size() -1)
	trocar_posicoes_do_array(cidades,index_a,index_b)
	atualizar_linha_calculo()

func trocar_posicoes_do_array(pontos:Array, idx_A:int, idx_B:int) -> void:
	var temp = pontos[idx_A]
	pontos[idx_A] = pontos[idx_B]
	pontos[idx_B] = temp

func atualizar_linha_calculo() -> void:
	for i:int in range(ordem.size()):
		var idx:int = ordem[i]
		linha_calculo.set_point_position(i,cidades[idx])

func etapa_3_calcular() -> void:
	var distancia:float = calcular_distancia(cidades,ordem)
	if distancia < distanciaRecord:
		distanciaRecord = distancia
		melhorCaminhoEncontrado = ordem.duplicate()
	atualizar_linha_caminho()

func atualizar_linha_caminho() -> void:
	for i:int in range(ordem.size()):
		var idx:int = melhorCaminhoEncontrado[i]
		linha_caminho.set_point_position(i,cidades[idx])

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanhoTela),'000000')
	
	for i in totalCidades:
		draw_arc(cidades[i],8,0,359,36,'ff00ff')

func proxima_ordem() -> void:
	contador += 1
	var maiorValorI:int = LX_etapa_1_localizar_maior()
	if maiorValorI == -1:
		linha_calculo.hide()
		set_process(false)
	var maiorValorJ:int = LX_etapa_2_localizar_proximo(maiorValorI)
	trocar_posicoes_do_array(ordem, maiorValorI,maiorValorJ)
	LX_etapa_3_inverter(maiorValorI)
	LX_etapa_4_calcular_percentagem()
	if contador == permutacoesTotais:
		await get_tree().create_timer(5).timeout
		voltar_pro_menu()
	

func LX_etapa_1_localizar_maior() -> int:
	var maiorValorI:int = -1
	for i in range(ordem.size() - 1):
		if ordem[i] < ordem[i+1]:
			maiorValorI = i
	return maiorValorI

func LX_etapa_2_localizar_proximo(mV:int) -> int:
	var maiorValorJ:int = -1
	for j in range(ordem.size()):
		if ordem[mV] < ordem[j]:
			maiorValorJ = j
	return maiorValorJ

func LX_etapa_3_inverter(mV:int) -> void:
	var finalDoArray = ordem.slice(mV + 1)
	for i in range(finalDoArray.size()):
		ordem.erase(finalDoArray[i])
	finalDoArray.reverse()
	ordem.append_array(finalDoArray)

func LX_etapa_4_calcular_percentagem() -> void:
	var calculo:float = 100.00 * (contador/permutacoesTotais)
	var porcentagem:String = "%*.*f"
	label.position = Vector2(0,tamanhoTela.y-70)
	label.size = Vector2(tamanhoTela.x,tamanhoTela.y - (tamanhoTela.y - 70))
	label.set_text(porcentagem % [3,2, calculo]  + '% completo')

func voltar_pro_menu() -> void:
	self.queue_free()
