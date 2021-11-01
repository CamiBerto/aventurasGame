import wollok.game.*
import nivel1.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición
object personajeSimple {

	var property vida = 25
	var property energia = 30
	var property granadas = 0
	var property position = game.at(5, 5)
	const property image = "player.png"
	var property nivelActual = nivelBloques
	method actualizarEnergiaVisual(){
		nivelActual.energiaVisual().actualizarDato(energia)
	}
	method actualizarVidaVisual(){
		nivelActual.vidaVisual().actualizarDato(vida)
	}
	method actualizarGranadasVisual(){
		nivelActual.granadaVisual().actualizarDato(granadas)
	}
	method moverALaDerecha() {
		if (game.width() == self.coordenadaX() + 1) {
			self.cambiarCoordenada(0, self.coordenadaY())
		} else {
			self.position(self.position().right(0))
		}
		energia = (energia-1).max(0)
		self.actualizarEnergiaVisual()
	}

	method moverALaIzquierda() {
		if (self.coordenadaX() == 0) {
			self.cambiarCoordenada(game.width() - 1, self.coordenadaY())
		} else {
			self.position(self.position().left(0))
		}
		energia = (energia-1).max(0)
		self.actualizarEnergiaVisual()
	}

	method moverAbajo() {
		if (self.coordenadaY() == 0) {
			self.cambiarCoordenada(self.coordenadaX(), game.height() - 1)
		} else {
			self.position(self.position().down(0))
		}
		energia = (energia-1).max(0)
		self.actualizarEnergiaVisual()
	}

	method moverArriba() {
		if (game.height() == self.coordenadaY() + 1) {
			self.cambiarCoordenada(self.coordenadaX(), 0)
		} else {
			self.position(self.position().up(0))
		}
		energia = (energia-1).max(0)
		self.actualizarEnergiaVisual()
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

