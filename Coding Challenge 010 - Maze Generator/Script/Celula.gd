class_name CELULA
extends Control

var nulo:float = 12312314.1123
var p:Vector2 = Vector2(nulo,nulo)
var t:float = nulo
var l:float = nulo
var idX:float = nulo
var idY:float = nulo
var paredesAtivas:Array = [true,true,true,true]
var paredes:Array = [null, null, null, null]
var visitado:bool = false
var atual:bool = false

func _ready():
	assert(p != Vector2(nulo,nulo) && t != nulo && l != nulo && idX != nulo && idY != nulo, 'Posicao, o Tamanho, a largura da parede, index de X e o index de Y não podem ser nulo')
	modificar_tamanho_e_posicao()
	criar_paredes()

func modificar_tamanho_e_posicao() -> void:
	self.size = Vector2(nulo,nulo)
	self.position = p

func criar_paredes() -> void:
	if paredesAtivas[0] == true:
		if paredes[0] == null:
			var linha:Line2D = Line2D.new()
			linha.width = l
			# ponto 1 = posicao, posicao
			# ponto 2 = posicao + tamanho, posicao
			linha.add_point(p)
			linha.add_point(Vector2(p.x + t,p.y))
			linha.default_color = 'ffffff'
			add_child(linha)
			paredes[0] = linha
	else:
		if paredes[0] != null:
			paredes[0].queue_free()
			paredes[0] = null
	
	if paredesAtivas[1] == true:
		if paredes[1] == null:
			var linha:Line2D = Line2D.new()
			linha.width = l
			#ponto 1 = posicao + tamanho, posicao
			#ponto 2 = posicao + tamanho, posicao + tamanho
			linha.add_point(Vector2(p.x + t, p.y))
			linha.add_point(Vector2(p.x + t, p.y + t))
			linha.default_color = 'ffffff'
			add_child(linha)
			paredes[1] = linha
	else:
		if paredes[1] != null:
			paredes[1].queue_free()
			paredes[1] = null
	
	if paredesAtivas[2] == true:
		if paredes[2] == null:
			var linha:Line2D = Line2D.new()
			linha.width = l
			#ponto 1 = posicao + tamanho, posicao + tamanho
			#ponto 2 = posicao, posicao + tamanho
			linha.add_point(Vector2(p.x + t, p.y + t))
			linha.add_point(Vector2(p.x, p.y + t))
			linha.default_color = 'ffffff'
			add_child(linha)
			paredes[2] = linha
	else:
		if paredes[2] != null:
			paredes[2].queue_free()
			paredes[2] = null
	
	if paredesAtivas[3] == true:
		if paredes[3] == null:
			var linha:Line2D = Line2D.new()
			linha.width = l
			#ponto 1 = posicao, posicao + tamanho
			#ponto 2 = posicao, posicao
			linha.add_point(Vector2(p.x, p.y + t))
			linha.add_point(Vector2(p.x, p.y))
			linha.default_color = 'ffffff'
			add_child(linha)
			paredes[3] = linha
	else:
		if paredes[3] != null:
			paredes[3].queue_free()
			paredes[3] = null

func _draw():
	if atual:
		draw_rect(Rect2(p,Vector2(t,t)),'ff3545')
	else:
		if visitado:
			draw_rect(Rect2(p,Vector2(t,t)),'ff00ff')
		else:
			draw_rect(Rect2(p,Vector2(t,t)),'000000')

func verificar_visinho(celulas:Array, colunas:float, linhas:float):
	var visinhos:Array = []
	var visinhoCima
	var visinhoDireita
	var visinhoBaixo
	var visinhoEsquerda
	
	if indice(idX, idY-1, colunas, linhas) != -1:
		visinhoCima = celulas[indice(idX, idY-1, colunas, linhas)]
	else:
		visinhoCima = null

	if indice(idX+1, idY, colunas, linhas) != -1:
		visinhoDireita = celulas[indice(idX+1, idY, colunas, linhas)]
	else:
		visinhoDireita = null
	
	if indice(idX, idY+1, colunas, linhas) != -1:
		visinhoBaixo = celulas[indice(idX, idY+1, colunas, linhas)]
	else:
		visinhoBaixo = null
	
	if indice(idX-1, idY, colunas, linhas) != -1:
		visinhoEsquerda = celulas[indice(idX-1, idY, colunas, linhas)]
	else: 
		visinhoEsquerda = null
	
	if visinhoCima != null && !visinhoCima.visitado:
		visinhos.append(visinhoCima)
	if visinhoDireita != null && !visinhoDireita.visitado:
		visinhos.append(visinhoDireita)
	if visinhoBaixo != null && !visinhoBaixo.visitado:
		visinhos.append(visinhoBaixo)
	if visinhoEsquerda != null && !visinhoEsquerda.visitado:
		visinhos.append(visinhoEsquerda)
	
	if visinhos.size() > 0:
		return visinhos.pick_random()
	else:
		return null

func indice(x:float, y:float, colunas:float, linhas:float):
	var retorno 
	if x < 0 || y < 0 || x > colunas -1 || y > linhas -1:
		retorno = -1
	else:
		retorno = x + y * colunas
	return retorno

func _process(_delta):
	criar_paredes()
	queue_redraw()
