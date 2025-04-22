class_name Entity
extends Sprite2D

var health : float = 5.0
var charges : int = 0

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
signal dead

func _ready() -> void:
	pass

func take_damage(dmg : float):
	health -= dmg

func is_dead():
	if health <= 0.0:
		dead.emit()

func restart():
	health = 5.0
	charges = 0
	
func attack_opp(attack: attacks, opponent: Entity):
	var pos = global_position

	if attack <= charges:
		match attack:
			attacks.BOOM:
				charges -= 1
				opponent.take_damage(1.0)
			attacks.TORNADO:
				charges -= 2
				opponent.take_damage(2.0)
			attacks.FIREBALL:
				charges -= 3
				opponent.take_damage(3.0)
			attacks.SUPERBOOM:
				charges -= 4
				opponent.take_damage(4.0)
	else:
		take_damage(0.5)
		
	for i in range(10):
		var poffset = Vector2(50, 0) if i % 2 == 1 else Vector2(-50, 0)
		var tween = get_parent().create_tween()
		await tween.tween_property(self, "global_position", pos + poffset, 0.05).finished
		pos = pos + poffset
		
		
func defend_self(defense : defenses, attack : attacks):
	var pos = global_position
	
	if defense - 4 == attack:
		match defense:
			defenses.BLOCK:
				health += 1
			defenses.TBLOCK:
				health += 2
			defenses.FBLOCK:
				health += 3
			defenses.SBLOCK:
				health += 4
		
	for i in range(10):
		var poffset = Vector2(0, 50) if i % 2 == 1 else Vector2(0, -50)
		var tween = get_parent().create_tween()
		await tween.tween_property(self, "global_position", pos + poffset, 0.05).finished
		pos = pos + poffset
		
func show_dmg():
	var tween = create_tween()	
	tween.tween_property(self, "modulate", Color.RED, 0.35)
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)
	
