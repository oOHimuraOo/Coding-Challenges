class_name PALITO
extends Node2D

var posicao_lado_a:Vector2
var posicao_lado_b:Vector2

var linha:Line2D
var largura:float
var tamanho:float
var direcao:int
var novo_palito:bool

var proximo_palito_a:PALITO
var proximo_palito_b:PALITO

var tamanho_tela:Vector2

func _ready():
	pass

func _init(pX:float, pY:float, d:int, l:float,t:float, tT:Vector2) -> void:
	novo_palito = true
	largura = l
	tamanho = t
	tamanho_tela = tT
	direcao = d
	if direcao == -1:
		posicao_lado_a = Vector2(pX-tamanho/2, pY)
		posicao_lado_b = Vector2(pX+tamanho/2, pY)
	else:
		posicao_lado_a = Vector2(pX, pY-tamanho/2)
		posicao_lado_b = Vector2(pX, pY+tamanho/2)

func iniciar_linha(nodoPai:Node2D) -> void:
	linha = Line2D.new()
	linha.width = largura
	linha.add_point(posicao_lado_a)
	linha.add_point(posicao_lado_b)
	nodoPai.add_child(linha)

func intersepta(x:float,y:float) -> bool:
	if self.posicao_lado_a.x == x && self.posicao_lado_a.y == y:
		return true
	elif self.posicao_lado_b.x == x && self.posicao_lado_b.y == y:
		return true
	else:
		return false

func criar_palito(outros_palitos:Array):
	var disponiveis:Array = [null, null]
	var disponivel_a:bool = true
	var disponivel_b:bool = true
	for outro in outros_palitos:
		if outro != self:
			if outro.intersepta(self.posicao_lado_a.x, self.posicao_lado_a.y):
				disponivel_a = false
			if outro.intersepta(self.posicao_lado_b.x, self.posicao_lado_b.y):
				disponivel_b = false
	if disponivel_a:
		proximo_palito_a = PALITO.new(posicao_lado_a.x, posicao_lado_a.y, direcao * -1, largura, tamanho, tamanho_tela)
		disponiveis[0] = proximo_palito_a
	if disponivel_b:
		proximo_palito_b = PALITO.new(posicao_lado_b.x, posicao_lado_b.y, direcao * -1, largura, tamanho, tamanho_tela)
		disponiveis[1] = proximo_palito_b
	return disponiveis

func _process(_delta):
	if !self.novo_palito:
		pass
