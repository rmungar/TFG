class_name DaggerBanditChasePlayer extends ActionLeaf

@export var speed: float = 100.0
@export var range: float = 30.0

@export var attackRange = range              
@export var comfortZone = range * 0.8       
@export var panicZone = range * 0.5  

func tick(actor: Node, blackboard: Blackboard) -> int:
	
	if actor is Enemy:
		var enemy = actor as Enemy
		if !enemy.is_on_floor():
			enemy.velocity.y += enemy.gravity * blackboard.get_value("delta")
	
	var animationPlayer = actor.get_node("AnimationPlayer")
	
	var playerPosition = blackboard.get_value("player_position")
	if not playerPosition:
		return FAILURE

	var direction = playerPosition - actor.global_position
	var horizontalDistance = abs(direction.x)
	var normalizedDirection = direction.normalized()

	# Movement logic
	if horizontalDistance > attackRange:
		# Chase player 
		actor.global_position.x += normalizedDirection.x * speed * get_physics_process_delta_time()
	elif horizontalDistance < panicZone:
		# Back up 
		actor.global_position.x -= normalizedDirection.x * speed * get_physics_process_delta_time()
	elif horizontalDistance < comfortZone:
		# Slow retreat 
		actor.global_position.x -= normalizedDirection.x * speed * 0.5 * get_physics_process_delta_time()
	
	# Animation and facing
	if direction.x < 0:
		animationPlayer.play("Run_Left")
		actor.directionTowardsPlayer = -1
		setHitboxesDirection(actor, -1)
	else:
		animationPlayer.play("Run_Right") 
		actor.directionTowardsPlayer = 1
		setHitboxesDirection(actor, 1)
	
	blackboard.set_value("attack_range", range)
	blackboard.set_value("directionToPlayer", direction.x)
	
	return SUCCESS if horizontalDistance <= range else RUNNING



func setHitboxesDirection(actor: Node, directionTowardsPlayer: int):
	var basicAttackHitbox = actor.get_node("BasicAttackHitbox")
	var basicAttackHitboxCollisionShape: CollisionShape2D = basicAttackHitbox.get_child(0)
	
	var specialAttackHitbox = actor.get_node("SpecialAttackHitbox")
	var specialAttackHitboxCollisionPolygon: CollisionPolygon2D = specialAttackHitbox.get_child(0)
	var specialAttackHitboxCollisionPolygonPoints: PackedVector2Array = specialAttackHitboxCollisionPolygon.polygon
	
	
	if directionTowardsPlayer == -1:
		basicAttackHitboxCollisionShape.position.x = -19
		specialAttackHitboxCollisionPolygonPoints[2].x = -26.864
		specialAttackHitboxCollisionPolygonPoints[3].x = -45.827
	else:
		basicAttackHitboxCollisionShape.position.x = 19
		specialAttackHitboxCollisionPolygonPoints[2].x = 26.864
		specialAttackHitboxCollisionPolygonPoints[3].x = 45.827
	
	specialAttackHitboxCollisionPolygon.polygon = specialAttackHitboxCollisionPolygonPoints
