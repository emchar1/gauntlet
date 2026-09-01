extends Node

# PROPERTIES

enum AudioKey {
	ARROW,
	ARROW2,
	ARROW3,
	ARROW_KILL,
	BGM,
	BODY_LAND,
	BOMB_COOK,
	BOMB_EXPLODE,
	BOMB_EXPLODE2,
	BOMB_SPARKLE,
	COCK,
	DOOR_CLOSE,
	DOOR_OPEN,
	ENEMY0_DIE1,
	ENEMY0_DIE2,
	ENEMY0_DIE3,
	ENEMY0_DIE4,
	ENEMY1_DIE1,
	ENEMY1_DIE2,
	ENEMY1_DIE3,
	ENEMY1_DIE4,
	MAGIC_ARROW,
	PLAYER_DIE,
	PLAYER_HURT0,
	PLAYER_HURT1,
	PLAYER_JUMP0,
	PLAYER_JUMP1,
	PLAYER_JUMP2,
	ROLL,
	SPAWNER_DAMAGE,
	SPAWNER_DIE,
	SPAWNER_SPAWN,
	SPLAT
}

enum Music {
	NONE, BGM
}

enum Type {
	SOUND, MUSIC_INTRO, MUSIC_LOOP
}

var music_map := {
	Music.BGM: {
		"intro": null,
		"loop": AudioKey.BGM
	}
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
	AudioKey.ARROW3: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/arrow3.ogg")
	},
	AudioKey.ARROW_KILL: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/arrow_kill.ogg")
	},
	AudioKey.BGM: {
		"type": Type.MUSIC_LOOP,
		"stream": preload("res://assets/sounds/bgm.ogg")
	},
	AudioKey.BODY_LAND: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/body_land.ogg")
	},
	AudioKey.BOMB_COOK: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/bomb_cook.ogg")
	},
	AudioKey.BOMB_EXPLODE: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/bomb_explode.ogg")
	},
	AudioKey.BOMB_EXPLODE2: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/bomb_explode2.ogg")
	},
	AudioKey.BOMB_SPARKLE: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/bomb_sparkle.ogg")
	},
	AudioKey.COCK: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/cock.ogg")
	},
	AudioKey.DOOR_CLOSE: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/door_close.ogg")
	},
	AudioKey.DOOR_OPEN: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/door_open.ogg")
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
	AudioKey.MAGIC_ARROW: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/magic_arrow.ogg")
	},
	AudioKey.PLAYER_DIE: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/player_die.ogg")
	},
	AudioKey.PLAYER_HURT0: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/player_hurt0.ogg")
	},
	AudioKey.PLAYER_HURT1: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/player_hurt1.ogg")
	},
	AudioKey.PLAYER_JUMP0: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/player_jump0.ogg")
	},
	AudioKey.PLAYER_JUMP1: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/player_jump1.ogg")
	},
	AudioKey.PLAYER_JUMP2: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/player_jump2.ogg")
	},
	AudioKey.ROLL: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/roll.ogg")
	},
	AudioKey.SPAWNER_DAMAGE: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/spawner_damage.ogg")
	},
	AudioKey.SPAWNER_DIE: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/spawner_die.ogg")
	},
	AudioKey.SPAWNER_SPAWN: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/spawner_spawn.ogg")
	},
	AudioKey.SPLAT: {
		"type": Type.SOUND,
		"stream": preload("res://assets/sounds/splat.ogg")
	}
}
