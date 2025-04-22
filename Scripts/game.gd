extends Panel

@onready var player: Entity = $Sprites/Player
@onready var opponent: Entity = $Sprites/Opponent
@onready var metronome: Sprite2D = $Sprites/Metronome
@onready var input_time: Timer = $Timers/InputTime
@onready var wait_time: Timer = $Timers/WaitTime
@onready var start: Button = $UI/Start
@onready var pause: CheckButton = $UI/Pause
@onready var wait_label: Label = $UI/WaitLabel
@onready var time: Label = $UI/Time
@onready var init_health = player.health
@onready var o_charges: Label = $"../Opponent Info/Panel/MarginContainer/HBoxContainer/Charges"
@onready var o_health: Label = $"../Opponent Info/Panel/MarginContainer/HBoxContainer/Health"
@onready var p_health: Label = $"../Player Info/Panel/MarginContainer/HBoxContainer/Health"
@onready var p_charges: Label = $"../Player Info/Panel/MarginContainer/HBoxContainer/Charges"
@onready var player_move_label: Label = $"UI/Player Move"
@onready var opponent_move_label: Label = $"UI/Opponent Move"

@onready var moves: Node2D = $UI/Moves


var t = 0

const CHARGE = 0
enum attacks {
	BOOM = 1,
	TORNADO,
	FIREBALL,
	SUPERBOOM,
}
enum defenses {
	BLOCK = 5,
	TBLOCK,
	FBLOCK,
	SBLOCK,
}
var player_move = -1
var opp_move = -1

func _process(_delta: float) -> void:
	if wait_time.is_stopped():
		time.text = str(int(input_time.time_left)) + "s"
	else:
		time.text = str(int(wait_time.time_left)) + "s"
		
	$"Debug?/Label".text = """
	Player Charges: {0}
	Player Health: {1}
	Player Move: {2}
	
	Opp Charges: {3}
	Opp Health: {4}
	Opp Move: {5}
	""".format([player.charges, player.health, move(player_move),opponent.charges, opponent.health, move(opp_move)])

func _on_wait_time_timeout() -> void:
	input_time.start()
	wait_label.visible = false
	moves.visible = true
	
func _on_input_time_timeout() -> void:
	wait_time.start()
	wait_label.visible = true
	moves.visible = false
	#var opp_move = "sblock"
	#var player_move = move.text
	battle()
	player_move = -1
	opp_move = -1

func _on_start_pressed() -> void:
	start.visible = false
	pause.visible = true
	wait_label.visible = true
	wait_time.start()


func _on_pause_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if !wait_time.is_stopped():
			t = wait_time.wait_time
			wait_time.stop()
		elif !input_time.is_stopped():
			t = input_time.wait_time
			input_time.stop()
			
	else:
		if wait_time.is_stopped():
			wait_time.start(t)
		elif input_time.is_stopped():
			input_time.start(t)


func battle():
	#opp_move = [attacks.values().pick_random(), defenses.values().pick_random(), 0].pick_random()
	#opp_move = attacks.values().pick_random()
	opp_move = attack([1,2,3,4,5,6,7,8])
	opp_move = 0
	var oh = opponent.health
	var ph = player.health
	if player_move == opp_move and player_move != 0:
		# do some animation
		match player_move:
			attacks.BOOM:
				pass
			attacks.TORNADO:
				pass
			attacks.FIREBALL:
				pass
			attacks.SUPERBOOM:
				pass
			defenses.BLOCK:
				pass
			defenses.TBLOCK:
				pass
			defenses.FBLOCK:
				pass
			defenses.SBLOCK:
				pass
	else:
		if player_move != -1:
			if player_move == 0:
				player.charges += 1
			elif player_move >= 1 and player_move <= 4:
				player.attack_opp(player_move, opponent)
			elif player_move >= 5 and player_move <= 8:
				player.defend_self(player_move, opp_move)
		else:
			player.take_damage(0.5)
		if opp_move != -1:
			if opp_move == 0:
				opponent.charges += 1
			elif opp_move >=1 and opp_move <= 3:
				opponent.attack_opp(opp_move, player)
			elif opp_move >= 4 and opp_move <= 7:
				opponent.defend_self(opp_move, player_move)
		else:
			opponent.take_damage(0.5)		
	
	if opponent.health < oh:
		opponent.show_dmg()
	if player.health < ph:
		player.show_dmg()
	player.is_dead()
	opponent.is_dead()

	o_charges.text = "Charges: " + str(opponent.charges)
	p_charges.text = "Charges: " + str(player.charges)
	
	o_health.text = "Health: " + hearts(opponent.health)
	p_health.text = "Health: " + hearts(player.health)
		
	opponent_move_label.text = ("Used " + move(opp_move)) if opp_move > -1 \
	else "Played illegal move"
	player_move_label.text = ("Used " + move(player_move)) if player_move > -1 \
	else "Played illegal move"

	
func move(m):
	match m:
		0:
			return "Charge"
		1:
			return "Boom"
		2:
			return "Tornado"
		3:
			return "Fireball"
		4:
			return "Super Boom"
		5:
			return "Block"
		6:
			return "TBlock"
		7:
			return "FBlock"
		8:
			return "SBlock"


func _on_player_dead() -> void:
	print("Opponent is the winner")
	input_time.stop()
	wait_time.stop()
	moves.visible = false
	start.visible = true
	wait_label.visible = false
	player.restart()
	opponent.restart()
	o_charges.text = "Charges: " + str(opponent.charges)
	p_charges.text = "Charges: " + str(player.charges)
	
	o_health.text = "Health: " + hearts(opponent.health)
	p_health.text = "Health: " + hearts(player.health)

func _on_opponent_dead() -> void:
	print("Player is the winner")
	input_time.stop()
	wait_time.stop()
	moves.visible = false
	start.visible = true
	wait_label.visible = false
	player.restart()
	opponent.restart()
	o_charges.text = "Charges: " + str(opponent.charges)
	p_charges.text = "Charges: " + str(player.charges)
	
	o_health.text = "Health: " + hearts(opponent.health)
	p_health.text = "Health: " + hearts(player.health)
	
	
func hearts(health:float):
	var h = ''
	for i in range(int(health)):
		h += '❣️'
	if int(health) != health:
		h += '💔'
	return h


#opponent code to attack
func attack(choices):
	var opp_cha = opponent.charges
	var pl_cha = player.charges
	var mmove = -1
	var c = choices
	var d = choices
	var c1 : int
	var d1 : int
	if opp_cha == 0:
		mmove = 0
		if pl_cha > 0:
			c1 = c.slice(4,pl_cha+4).pick_random()
			mmove = [c1, c1, mmove].pick_random()
	else:
		c1 = c.slice(0,opp_cha).pick_random()
		if pl_cha > 0:
			d1 = d.slice(4,pl_cha + 4).pick_random()
			mmove = [d1, c1, c1].pick_random()
	return mmove

# button stuff

func _on_boom_pressed() -> void:
	player_move = attacks.BOOM

func _on_tornado_pressed() -> void:
	player_move = attacks.TORNADO
	
func _on_fireball_pressed() -> void:
	player_move = attacks.FIREBALL
	
func _on_super_boom_pressed() -> void:
	player_move = attacks.SUPERBOOM

func _on_block_pressed() -> void:
	player_move = defenses.BLOCK

func _on_tblock_pressed() -> void:
	player_move = defenses.TBLOCK
	
func _on_fblock_pressed() -> void:
	player_move = defenses.FBLOCK
	
func _on_sblock_pressed() -> void:
	player_move = defenses.SBLOCK

func _on_charge_pressed() -> void:
	player_move = CHARGE
