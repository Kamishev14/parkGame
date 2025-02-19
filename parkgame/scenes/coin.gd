extends Area3D

signal collected  # Сигнал за собирање


func _ready():
	connect("body_entered", _on_body_entered)  # Поврзување на колизија

func _on_body_entered(body):
	if get_tree().get_first_node_in_group("main").game_ended:
		return  # If game ended, ignore collection
	if body.is_in_group("player"):  # Проверка дали играчот ја допрел монетата
		emit_signal("collected")  # Испраќа сигнал дека е собрана
		queue_free()  # Бришење на монетата од сцената
