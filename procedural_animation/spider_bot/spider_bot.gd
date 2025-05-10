@tool
extends Node3D

@onready var front_left_ik: SkeletonIK3D = $Armature/Skeleton3D/FrontLeftIK
@onready var front_right_ik: SkeletonIK3D = $Armature/Skeleton3D/FrontRightIK
@onready var back_left_ik: SkeletonIK3D = $Armature/Skeleton3D/BackLeftIK
@onready var back_right_ik: SkeletonIK3D = $Armature/Skeleton3D/BackRightIK

func _ready() -> void:
	front_left_ik.start()
	front_right_ik.start()
	back_left_ik.start()
	back_right_ik.start()
	print("asdf")
