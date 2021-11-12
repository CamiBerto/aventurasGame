import wollok.game.*

class Direccion {

	method siguiente(position)

	method esIgual(unaDireccion) = unaDireccion == self

	/* Próxima posición en un tablero al estilo pacman */
	method proximaPosicion(posicion) {
		var siguientePosicion = self.siguiente(posicion)
		if (self.esIgual(derecha)) {
			// Si está en el borde derecho del tablero
			if (game.width() == posicion.x() + 1) {
				siguientePosicion = game.at(0, posicion.y())
			}
		} else if (self.esIgual(izquierda)) {
			// Si está en el borde izquierdo del tablero
			if (posicion.x() == 0) {
				siguientePosicion = game.at(game.width() - 1, posicion.y())
			}
		} else if (self.esIgual(abajo)) {
			if (posicion.y() == 0) {
				siguientePosicion = game.at(posicion.x(), game.height() - 2)
			}
		} else if (self.esIgual(arriba)) {
			if (game.height() == posicion.y() + 2) {
				siguientePosicion = game.at(posicion.x(), 0)
			}
		}
		return siguientePosicion
	}

}

object izquierda inherits Direccion {

	override method siguiente(position) = position.left(1)

	method opuesto() = derecha

}

object derecha inherits Direccion {

	override method siguiente(position) = position.right(1)

	method opuesto() = izquierda

}

object abajo inherits Direccion {

	override method siguiente(position) = position.down(1)

	method opuesto() = arriba

}

object arriba inherits Direccion {

	override method siguiente(position) = position.up(1)

	method opuesto() = abajo

}

