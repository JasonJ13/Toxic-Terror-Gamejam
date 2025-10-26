extends Node

signal open_portal_signal

var objets_nb = 1
var objets_taken := 0

var keys_nb = 1
var keys_taken := 0

func take_key():
	keys_taken += 1
	if keys_taken == keys_nb:
		open_portal_signal.emit()

func take_object():
	objets_taken += 1
