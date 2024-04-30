class_name PARTICULA
extends Node2D

var p:Vector2
var a:Vector2
var v:Vector2

var f:float
var m:float
var c:Color

func _init(x:float, y:float, raio:float = 4, cor:Color = 'ffffff') -> void:
	p = Vector2(x,y)
	a = Vector2.ZERO
	v = Vector2.ZERO
	m = raio
	c = cor

func no_process():
	v += a
	p += v
	a = Vector2.ZERO
	queue_redraw()

func atracao(alvo:Node2D) -> void:
	var fV = alvo.p - p
	var d = fV.length_squared()
	if d < 0.001:
		d = 0.001
	if d > 1000000:
		d = 1000000
	var g = 6.674 * pow(10,-11)
	var multiplicador = remap(alvo.m - m, m, alvo.m, 0, 1000) 
	var denominador = g * (m * multiplicador) * (alvo.m * multiplicador)
	f = denominador / d
	fV.normalized()
	fV = fV * f
	a += fV

func repulsao(alvo:Node2D) -> void:
	var fV = alvo.p - p
	var d = fV.length_squared()
	if d < 0.001:
		d = 0.001
	if d > 1000000:
		d = 1000000
	var g = 6.674 * pow(10,-11)
	var multiplicador = remap(alvo.m - m, m, alvo.m, 0, 1000) 
	var denominador = g * (m * multiplicador) * (alvo.m * multiplicador)
	f = denominador / d
	fV.normalized()
	fV = fV * f
	a += fV * -1

func intesepta(alvo:Node2D) -> bool:
	var distancia = p.distance_to(alvo.p)
	if distancia < alvo.m:
		return true
	return false

func fora_do_limite() -> bool:
	if p.x > get_viewport().size.x || p.y > get_viewport().size.y || p.x < 0 || p.y < 0:
		return true
	return false

func _draw():
	draw_circle(p,m,c)

