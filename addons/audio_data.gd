extends Node

# PROPERTIES

enum AudioKey {
	ARROW,
	ARROW2,
	ARROW_KILL,
	BOMB_COOK,
	BOMB_EXPLODE,
	BOMB_SPARKLE,
	COCK,
	ENEMY0_DIE1,
	ENEMY0_DIE2,
	ENEMY0_DIE3,
	ENEMY0_DIE4,
	ENEMY1_DIE1,
	ENEMY1_DIE2,
	ENEMY1_DIE3,
	ENEMY1_DIE4
	#SILENCE_INTRO,
	#SILENCE_LOOP,
	#BLOODYTEARS_INTRO,
	#BLOODYTEARS_LOOP,
	#MONSTERDANCE,
	#SWITCHWITHME,
	#ENERGIA,
	#ATTACK_SWING,
	#ATTACK_SWING2,
	#ATTACK_KILL,
	#ATTACK_MISS,
	#HOWL,
	#HOWL_SHORT,
	#CURSE_PICKUP,
	#HEALTH_PICKUP,
	#COIN_PICKUP,
	#LAND,
	#DEATH
}

enum Music {
	NONE, #SILENCE, BLOODYTEARS, MONSTERDANCE, SWITCHWITHME, ENERGIA
}

enum Type {
	SOUND, MUSIC_INTRO, MUSIC_LOOP
}

var music_map := {
	#Music.SILENCE: {
		#"intro": AudioKey.SILENCE_INTRO,
		#"loop": AudioKey.SILENCE_LOOP
	#},
	#Music.BLOODYTEARS: {
		#"intro": AudioKey.BLOODYTEARS_INTRO,
		#"loop": AudioKey.BLOODYTEARS_LOOP
	#},
	#Music.MONSTERDANCE: {
		#"intro": null,
		#"loop": AudioKey.MONSTERDANCE
	#},
	#Music.SWITCHWITHME: {
		#"intro": null,
		#"loop": AudioKey.SWITCHWITHME
	#},
	#Music.ENERGIA: {
		#"intro": null,
		#"loop": AudioKey.ENERGIA
	#}
}

var sounds := {
	AudioKey.ARROW: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/arrow.ogg")
	},
	AudioKey.ARROW2: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/arrow2.ogg")
	},
	AudioKey.ARROW_KILL: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/arrow_kill.ogg")
	},
	AudioKey.BOMB_COOK: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/bomb_cook.ogg")
	},
	AudioKey.BOMB_EXPLODE: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/bomb_explode.ogg")
	},
	AudioKey.BOMB_SPARKLE: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/bomb_sparkle.ogg")
	},
	AudioKey.COCK: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/cock.ogg")
	},
	AudioKey.ENEMY0_DIE1: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/enemy0_die1.ogg")
	},
	AudioKey.ENEMY0_DIE2: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/enemy0_die2.ogg")
	},
	AudioKey.ENEMY0_DIE3: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/enemy0_die3.ogg")
	},
	AudioKey.ENEMY0_DIE4: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/enemy0_die4.ogg")
	},
	AudioKey.ENEMY1_DIE1: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/enemy1_die1.ogg")
	},
	AudioKey.ENEMY1_DIE2: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/enemy1_die2.ogg")
	},
	AudioKey.ENEMY1_DIE3: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/enemy1_die3.ogg")
	},
	AudioKey.ENEMY1_DIE4: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/enemy1_die4.ogg")
	},
	#AudioKey.SILENCE_LOOP: {
		#"type": Type.MUSIC_LOOP,
		#"stream": preload("res://assets/sounds/silence_loop.ogg")
	#},
	#AudioKey.BLOODYTEARS_INTRO: {
		#"type": Type.MUSIC_INTRO,
		#"stream": preload("res://assets/sounds/bloodytears_intro.ogg")
	#},
	#AudioKey.BLOODYTEARS_LOOP: {
		#"type": Type.MUSIC_LOOP,
		#"stream": preload("res://assets/sounds/bloodytears_loop.ogg")
	#},
	#AudioKey.MONSTERDANCE: {
		#"type": Type.MUSIC_LOOP,
		#"stream": preload("res://assets/sounds/monsterdance.ogg")
	#},
	#AudioKey.SWITCHWITHME: {
		#"type": Type.MUSIC_LOOP,
		#"stream": preload("res://assets/sounds/switchwithme.ogg")
	#},
	#AudioKey.ENERGIA: {
		#"type": Type.MUSIC_LOOP,
		#"stream": preload("res://assets/sounds/energia.ogg")
	#},
	#AudioKey.ATTACK_SWING: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/attack_swing.ogg")
	#},
	#AudioKey.ATTACK_SWING2: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/attack_swing2.ogg")
	#},
	#AudioKey.ATTACK_KILL: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/attack_kill.ogg")
	#},
	#AudioKey.ATTACK_MISS: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/attack_miss.ogg")
	#},
	#AudioKey.HOWL: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/howl.ogg")
	#},
	#AudioKey.HOWL_SHORT: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/howl_short.ogg")
	#},
	#AudioKey.CURSE_PICKUP: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/curse_pickup.ogg")
	#},
	#AudioKey.HEALTH_PICKUP: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/health_pickup.ogg")
	#},
	#AudioKey.COIN_PICKUP: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/coin.ogg")
	#},
	#AudioKey.LAND: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/land.ogg")
	#},
	#AudioKey.DEATH: {
		#"type": Type.SOUND,
		#"stream": preload("res://assets/sounds/death.ogg")
	#}
}
