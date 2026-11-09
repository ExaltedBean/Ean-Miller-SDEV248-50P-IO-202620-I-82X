extends Node

enum Forms {
	SOOT,
	PARTIAL,
	STABLE
}

var lives = 3
var dna_collected = 0
var form = Forms.SOOT

const REQUIRED_DNA = 10
