extends Node3D

@export var total_coins = 6  # Вкупно монети
var collected_coins = 0
var game_ended = false  # Блокира контроли пред крајот

@onready var timer = $Timer
@onready var time_label = $UI/VBoxContainer/TimeLabel
@onready var coin_label = $UI/VBoxContainer/CoinLabel
@onready var end_panel = $UI/Panel
@onready var end_label = $UI/Panel/VBoxContainer/EndLabel


func _ready():
	timer.start(30)
	end_panel.visible = false  # Се крие порака за крај
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.connect("collected", _on_coin_collected)

func _process(_delta):
	if !game_ended:
		time_label.text = "Time: " + str(int(timer.time_left))  # Ажурира тајмер UI

func _on_coin_collected():
	if game_ended: 
		return
	collected_coins += 1
	coin_label.text =  "Coins: " + str(collected_coins) + "/" + str(total_coins)  # Ажурирање на UI

	if collected_coins == total_coins:
		game_won()

func _on_timer_timeout():
	if collected_coins < total_coins:
		game_over()

func game_won():
	game_ended = true
	end_label.visible = true
	end_label.text = "YOU WON!\nPress R to Restart\nPress Q to Quit"
	end_panel.visible = true


func game_over():
	game_ended = true
	end_label.text = "TRY AGAIN!\nPress R to Restart\nPress Q to Quit"
	end_label.visible = true
	end_panel.visible = true
	await get_tree().process_frame  # Чека еден фрејм за да прикаже текст



func _input(event):
	if game_ended:  # R и Q функционираат само на крај
		if event.is_action_pressed("restart"):  # За рестартирање на играта
			get_tree().reload_current_scene()
		elif event.is_action_pressed("quit"):  # За излез од играта
			get_tree().quit()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()  # Рестарт на играта

func _on_quit_button_pressed():
	get_tree().quit()  # Исклучување на играта
