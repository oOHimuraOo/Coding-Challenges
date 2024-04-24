class_name DESENHO
extends Node2D

var nulo:Vector2 = Vector2(1826397.1823,1298376.812763)
var raio_limite:float = 30
var constante_de_tentativas:float = 30
var tamanho_da_tela:Vector2i = Vector2i(1920,1080)

var mapeamento:Array

var coluna:int #representa o eixo x do array.
var linha:int #representa o eixo y do array.
var dimensoes:Array = [coluna,linha] #o tamanho do array indica a quantidade de dimensões e os valores dentro dele, o tamanho de cada eixo.
var tamanho_da_celula:float = raio_limite / sqrt(dimensoes.size())

var ativos:Array = []
var ordenado:Array = []

func _ready():
	get_viewport().size = tamanho_da_tela
	
	#PASSO 0: Inicializa um mapa de "n" dimensoes para armazenar as amostras e acelerar a proximas buscas. O tamanho
	# de cada celula do mapa precisa ser limitada pela variavel Tamanho_da_celula, fazendo assim com que cada celula tenha
	# no maximo 1 amostra. Sendo assim o numero armazenado no array deverá indicar o index da amostra localizada na celula,
	# caso não exista nenhuma amostra na celula o valor armazenado é comumente -1.
	
	coluna = round(tamanho_da_tela.x/tamanho_da_celula)
	linha = round(tamanho_da_tela.y/tamanho_da_celula)
	for i in range(dimensoes.size()):
		if i == 0: #se a imagem tiver todos os lados iguais você não precisa desse verificador. estou mantendo pq pretendo colocar array de diferentes tamanhos.
			dimensoes[i] = coluna
		else:
			dimensoes[i] = linha
	mapeamento = criar_um_array_de_N_dimensoes(dimensoes)
	for i in range(coluna):
		for j in range(linha):
			mapeamento[i][j] = nulo
	
	#PASSO 1: selecione aleatoriamente uma amostra qualquer. insira no seu array multidimensional e 
	#inicialize a lista de amostras ativas com indice [0].
	
	var x:float = tamanho_da_tela.x /2
	var y:float = tamanho_da_tela.y /2
	var index_X = round(x/tamanho_da_celula)
	var index_y = round(y/tamanho_da_celula)
	var pos:Vector2 = Vector2(index_X,index_y)
	mapeamento[index_X][index_y] = pos
	ativos.append(pos)

func criar_um_array_de_N_dimensoes(dim:Array) -> Array:
	if dim.size() < 1:
		return [] #o valor deve ser mantido vazio, e acrescentado posteriormente fora dessa função.
	var resultado = []
	var size = dim[0]
	for i in range(size):
		resultado.append(criar_um_array_de_N_dimensoes(dim.slice(1)))
	return resultado

func _process(_delta):
	if ativos.size() > 0:
		queue_redraw()

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanho_da_tela),'000000')
	
	# passo 2: enquanto a lista de amostras ativas não estiver vazia, escolha um index aleatorio a partir
	# do slot da amostra ativa atual e gere uma quantidade de pontos igual a constante_de_tentativas, levando
	# em consideração uma area que seja entre 2r e r ao redor da amostra ativa.  Para cada ponto verifique se dentro 
	# de sua area existem outros pontos. Se o ponto estiver adequadamente distante de todos os outros pontos desenhe-o
	# e acrescente-o a lista de amostras ativas. Caso se apos uma quantidade de tentativas igual a constante_de_tentativas,
	# não existir pontos a serem adicionados remova a amostra atual da lista de amostras ativas.
	
	#while ativos.size() > 0: nesse modo os pixels são desenhados todos em um frame só. 
	if (ativos.size() > 0): #nesse modo os pixels são desenhados a cada frame. Apesar de mais bonito. Muito mais lento
		var indexAleatorio:int = randi_range(0,ativos.size()-1)
		var pos:Vector2 = ativos[indexAleatorio]
		var encontrado:bool = false
		for n in range(constante_de_tentativas):
			var amostra:Vector2 = Vector2(randf_range(-1,1),randf_range(-1,1))
			var magnitude:float = randf_range(raio_limite, 2*raio_limite)
			amostra = amostra * magnitude
			amostra = amostra + pos
			
			var col:int = floor(amostra.x/tamanho_da_celula)
			var lin:int = floor(amostra.y/tamanho_da_celula)
			
			if col > -1 && lin > -1 && col < coluna && lin < linha && mapeamento[col][lin] == nulo: 
				var ok:bool = true
				for x in range(-1,2):
					for y in range(-1,2):
						var indice_x:int = col + x 
						var indice_y:int = lin + y 
						
						if indice_x < coluna && indice_y < linha:
							var visinho:Vector2 = mapeamento[indice_x][indice_y]
							
							if visinho != nulo:
								var distancia:float = amostra.distance_to(visinho)
								
								if distancia < raio_limite:
									ok = false
				if ok:
					encontrado = true
					mapeamento[col][lin] = amostra
					ativos.append(amostra)
					ordenado.append(amostra)
					break
		
		if !encontrado:
			ativos.remove_at(indexAleatorio)
		
	for a in range(ordenado.size()):
		draw_circle(ordenado[a],raio_limite/4, '0000ff')
	
	for b in range(ativos.size()):
		draw_circle(ativos[b],raio_limite/4, 'ff0000')

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
