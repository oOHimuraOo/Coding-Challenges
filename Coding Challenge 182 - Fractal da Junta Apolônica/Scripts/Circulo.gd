class_name CIRCULO
extends Area2D

var nComplexo:PackedScene

var centro:COMPLEXOS
var curvatura:float
var raio:float

func iniciarValores(X:float,Y:float,Curv:float) -> void:
	curvatura = Curv
	raio = abs(1.0/self.curvatura)
	nComplexo = load("res://Cenas/numerosComplexos.tscn")
	centro = nComplexo.instantiate()
	centro.incializar_valores(X,Y)
	


func montarCirculo() -> void:
	self.position = Vector2(centro.a,centro.b)
	var forma:CollisionShape2D = get_child(0)
	forma.shape.radius = raio
	forma.debug_color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),randf_range(0,0.25))
