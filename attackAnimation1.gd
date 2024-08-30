extends Area2D

@export var damage = 20


func _on_body_entered(body: Node):
	if body.is_in_group("players"):
		body.emit_signal("take_damage", damage)
		#queue_free()

