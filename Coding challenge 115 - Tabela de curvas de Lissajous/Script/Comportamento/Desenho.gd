class_name DESENHO
extends Node2D

var angulo:float = 0.0
var largura:float = 50
var colunas:int
var linhas:int
var curvas:Array
var tamanhoTela:Vector2i
var diametro:float
var raio:float
var reguas_x:Array 
var reguas_y:Array

func _ready():
	tamanhoTela = Vector2i(600,600)
	ajustar_tamanho_de_tela(tamanhoTela)
	colunas = tamanhoTela.x / largura
	linhas = tamanhoTela.y / largura
	curvas = criar_array_2d(colunas,linhas)
	diametro = largura - (0.2 * largura)
	raio = diametro/2
	
	for x in range(colunas):
		var centroEixoX1:float = (x * largura) + (largura/2)
		var centroEixoY1:float = largura/2
		
		var eixoX1:float = raio * cos(angulo * (x) - PI/2)
		var eixoY1:float = raio * sin(angulo * (x) - PI/2)
		
		for y in range(linhas):
			var centroEixoX2:float = largura/2
			var centroEixoY2:float = (y * largura) + (largura/2)
			
			var eixoX2:float = raio * cos(angulo * (y) - PI/2)
			var eixoY2:float = raio * sin(angulo * (y) - PI/2)
			
			if x != 0:
				reguas_x.append(REGUA.new(0, centroEixoX1 + eixoX1, tamanhoTela.y, centroEixoY1 + eixoY1, self, false))
			if y != 0:
				reguas_y.append(REGUA.new(0, centroEixoX2 + eixoX2, tamanhoTela.x, centroEixoY2 + eixoY2, self, true))

	for x in range(colunas):
		for y in range(linhas):
			curvas[x][y] = CURVA.new(self)


func ajustar_tamanho_de_tela(tamanho:Vector2i) -> void:
	get_viewport().size = tamanho

func criar_array_2d(eixoX:float, eixoY:float) -> Array:
	var arrayDeRetorno:Array = []
	for x in range(eixoX):
		var arrayInterno:Array = []
		for y in range(eixoY):
			arrayInterno.append(null)
		arrayDeRetorno.append(arrayInterno)
	return arrayDeRetorno

func iniciar_cabecario() -> void:
	for x in range(colunas):
		var centroEixoX1:float = (x * largura) + (largura/2)
		var centroEixoY1:float = largura/2
		
		var eixoX1:float = raio * cos(angulo * (x) - PI/2)
		var eixoY1:float = raio * sin(angulo * (x) - PI/2)
		
		for y in range(linhas):
			var centroEixoX2:float = largura/2
			var centroEixoY2:float = (y * largura) + (largura/2)
			
			var eixoX2:float = raio * cos(angulo * (y) - PI/2)
			var eixoY2:float = raio * sin(angulo * (y) - PI/2)
			
			curvas[x][0].iniciar_eixo_x_e_eixo_y(centroEixoX1 + eixoX1, centroEixoY1 + eixoY1)
			curvas[0][y].iniciar_eixo_x_e_eixo_y(centroEixoX2 + eixoX2, centroEixoY2 + eixoY2)
			get_child(get_children().find(curvas[0][0].ponto) -1).hide()
			
	
func iniciar_tabela() -> void:
	for x in range(colunas):
		if x != 0:
			for y in range(linhas):
				var centroEixoX:float = (x * largura) + (largura/2)
				var centroEixoY:float = (y * largura) + (largura/2)
			
				var eixoX:float = raio * cos(angulo * (x) - PI/2)
				var eixoY:float = raio * sin(angulo * (y) - PI/2)
				if y != 0:
					curvas[x][y].iniciar_eixo_x_e_eixo_y(centroEixoX + eixoX, centroEixoY + eixoY)

func desenhar_tabela() -> void:
	for x in range(colunas):
		for y in range(linhas):
			if x != 0:
				reguas_x[x].movimentar_regua(curvas[x][y].atual)
			if y != 0:
				reguas_y[y].movimentar_regua(curvas[x][y].atual)
			curvas[x][y].ponto.atualizar_posicao(curvas[x][y].atual)
			curvas[x][y].adicionar_ponto()
			curvas[x][y].desenhar()
	
	angulo -= 0.01
	
	if angulo < - PI * 2 :
		for x in range(colunas):
			for y in range(linhas):
				curvas[x][y].resetar()
		angulo = 0

func _process(_delta) -> void:
	iniciar_cabecario()
	iniciar_tabela()
	desenhar_tabela()


