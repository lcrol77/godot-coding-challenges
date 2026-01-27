extends Control

signal retry()

func _ready() -> void:
	$VBoxContainer/RetryBtn.grab_focus()

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_retry_btn_pressed() -> void:
	emit_signal("retry")
	queue_free()
