import wollok.game.*

class Direccion {

	method siguiente(position)

	method esIgual(unaDireccion) = unaDireccion == self

	/* Próxima posición en un tablero al estilo "pacman" */
	method proximaPosicion(posicion) {
		var siguientePosicion = self.siguiente(posicion)
		if (self.esIgual(derecha) && self.esBordeDerecho(posicion)) {
			siguientePosicion = game.at(0, posicion.y())
		} else if (self.esIgual(izquierda) and self.esBordeIzquierdo(posicion)) {
			siguientePosicion = game.at(game.width() - 1, posicion.y())
		} else if (self.esIgual(abajo) and self.esBordeInferior(posicion)) {
			siguientePosicion = game.at(posicion.x(), game.height() - 2)
		} else if (self.esIgual(arriba) and self.esBordeSuperior(posicion)) {
			siguientePosicion = game.at(posicion.x(), 0)
		}
		return siguientePosicion
	}

	method esBordeDerecho(posicion) = game.width() == posicion.x() + 1

	method esBordeIzquierdo(posicion) = posicion.x() == 0

	method esBordeInferior(posicion) = posicion.y() == 0

	// Toma en cuenta la franja reservada para los indicadores
	method esBordeSuperior(posicion) = game.height() == posicion.y() + 2

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

