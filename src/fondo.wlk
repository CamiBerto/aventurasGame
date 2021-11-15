import wollok.game.*
import utilidades.*

class Fondo {

	const property position = game.at(0, 0)
	var property image = "imgs/fondo Completo.png"

	method esRecolectable() = false

	method esInteractivo() = false

	method esOro() = false

}

