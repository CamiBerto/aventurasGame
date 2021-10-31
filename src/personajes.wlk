import wollok.game.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición
object personajeSimple {

	var property vida = 25
	var property position = game.at(5, 5)
	const property image = "player.png"

	method moverALaDerecha() {
		if (game.width() == self.coordenadaX() + 1) {
			self.cambiarCoordenada(0, self.coordenadaY())
		} else {
			self.position(self.position().right(1))
		}
	}

	method moverALaIzquierda() {
		if (self.coordenadaX() == 0) {
			self.cambiarCoordenada(game.width() - 1, self.coordenadaY())
		} else {
			self.position(self.position().left(1))
		}
	}

	method moverAbajo() {
		if (self.coordenadaY() == 0) {
			self.cambiarCoordenada(self.coordenadaX(), game.height() - 1)
		} else {
			self.position(self.position().down(1))
		}
	}

	method moverArriba() {
		if (game.height() == self.coordenadaY() + 1) {
			self.cambiarCoordenada(self.coordenadaX(), 0)
		} else {
			self.position(self.position().up(1))
		}
	}

	/* Devuelve coordenada x del personaje */
	method coordenadaX() {
		return position.x()
	}

	/* Devuelve coordenada y del personaje */
	method coordenadaY() {
		return position.y()
	}

	/* Cambia la coordenada del personaje  */
	method cambiarCoordenada(a, b) {
		position = game.at(a, b)
	}

//
}

