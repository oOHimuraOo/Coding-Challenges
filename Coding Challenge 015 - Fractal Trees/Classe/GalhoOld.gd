class_name GALHO_OUTDATED
extends Line2D

var inicio:Vector2
var final:Vector2
var tamanho:float
var terminado:bool
var quantidade_de_galhos:int
var galhos:Array = []
var nodoPai

func _init(i:Vector2, f:Vector2, t:float, nP:Node2D, qtg:int = randi_range(2,4)) -> void:
	terminado = false
	inicio = i
	final = f
	tamanho = t
	nodoPai = nP
	quantidade_de_galhos = qtg
	if quantidade_de_galhos > 4:
		quantidade_de_galhos = 4
	add_point(inicio)
	add_point(final)
	width = t * 0.1
	nodoPai.add_child(self)

func criar_novo_galho():
	if quantidade_de_galhos > galhos.size():
		if galhos.size() == 0:
			var angulo:Vector2 = Vector2.from_angle(deg_to_rad(randi_range(180,360)))
			var novoGalho:GALHO = GALHO.new(final,Vector2(final.x + tamanho * angulo.x, final.y + tamanho * angulo.y),tamanho * 0.67,nodoPai)
			galhos.append(novoGalho)
		elif galhos.size() == 1:
			var angulo:Vector2 = Vector2.from_angle(deg_to_rad(randi_range(210,330))) 
			var novoGalho:GALHO = GALHO.new(final,Vector2(final.x + tamanho * angulo.x, final.y + tamanho * angulo.y),tamanho * 0.67,nodoPai)
			galhos.append(novoGalho)
		elif galhos.size() == 2:
			var angulo:Vector2 = Vector2.from_angle(deg_to_rad(randi_range(240,300)))
			var novoGalho:GALHO = GALHO.new(final,Vector2(final.x + tamanho * angulo.x, final.y + tamanho * angulo.y),tamanho * 0.67,nodoPai)
			galhos.append(novoGalho)
		elif galhos.size() == 3:
			var angulo:Vector2 = Vector2.from_angle(deg_to_rad(randi_range(180,360))) 
			var novoGalho:GALHO = GALHO.new(final,Vector2(final.x + tamanho * angulo.x, final.y + tamanho * angulo.y),tamanho * 0.67,nodoPai)
			galhos.append(novoGalho)
	

func _process(delta):
	if quantidade_de_galhos == galhos.size():
		if nodoPai.galhos.size() < randi_range(10000,15000):
			for galho in galhos:
				nodoPai.galhos.append(galho)
				galho.criar_novo_galho()
		else:
			await get_tree().create_timer(5).timeout
			nodoPai.terminado = true
			self.queue_free()
