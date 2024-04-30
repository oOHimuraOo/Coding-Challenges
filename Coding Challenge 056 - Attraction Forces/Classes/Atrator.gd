class_name ATRATOR
extends Node2D

var p:Vector2
var a:Vector2
var v:Vector2

var f:float
var m:float
var c:Color

func _init(x:float, y:float, raio:float = 8, cor:Color = 'ff00ff') -> void:
	p = Vector2(x,y)
	a = Vector2.ZERO
	v = Vector2.ZERO
	m = raio
	c = cor

func _draw():
	draw_circle(p,m,c)
