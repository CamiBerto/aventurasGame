import wollok.game.*
import utilidades.*
import nivel.*
import elementos.*
import movimientos.*

class Enemigo inherits ElementoJuego {

	var property direcciones = [ arriba, abajo, derecha, izquierda ]
	var property direccion = arriba
	var property image = "imgs/fantasma.png"
	var property sonido = "audio/risa.mp3"

	method vidaQueQuita() = 20

	override method esRecolectable() = false

	method moverse(unPersonaje) {
		game.onTick(1500, "bicho tonto", { self.direccionCambiante()
			position = direccion.proximaPosicion(self.position())
		})
	}

	method direccionCambiante() {
		direccion = direcciones.get(0.randomUpTo(3))
	}

	method asesinadoPor(unPersonaje) {
		game.sound(self.sonido()).play()
		self.eliminarse()
		unPersonaje.nivelActual().ponerElementos(1, flecha)
	}
	method eliminarse(){game.removeVisual(self)}

	override method esBicho() = true

}

class Demonio inherits Enemigo {

	override method sonido() = "audio/demonio.mp3"

	override method vidaQueQuita() = 30

	override method moverse(unPersonaje) {
		game.onTick(2000, "demonio", { position = new Position(x = self.asignarPosX(unPersonaje), y = self.asignarPosY(unPersonaje))})
	}

	method asignarPosX(unPersonaje) {
		const posPersonajeX = unPersonaje.position().x()
		return if (posPersonajeX > self.position().x()) {
			self.position().x() + 1
		} else {
			self.position().x() - 1
		}
	}

	method asignarPosY(unPersonaje) {
		const posPersonajeY = unPersonaje.position().y()
		return if (posPersonajeY > self.position().y()) {
			self.position().y() + 1
		} else {
			self.position().y() - 1
		}
	}

}

class Ogro inherits Enemigo {

	override method sonido() = "audio/ogro.mp3"

	override method vidaQueQuita() = 30

	override method moverse(unPersonaje) {
		game.onTick(2000, "ogro", { position = new Position(x = self.asignarPosX(unPersonaje), y = self.asignarPosY(unPersonaje))})
	}

	method asignarPosX(unPersonaje) {
		const posPersonajeX = unPersonaje.position().x()
		return if (posPersonajeX > self.position().x()) {
			self.position().x() + 1
		} else {
			self.position().x() - 1
		}
	}

	method asignarPosY(unPersonaje) {
		const posPersonajeY = unPersonaje.position().y()
		return if (posPersonajeY > self.position().y()) {
			self.position().y() + 1
		} else {
			self.position().y() - 1
		}
	}

}

class FlechaArrojada {

	var property position
	var property image
	var property direccion
	var property sonido = "audio/flechas.mp3"

	method disparadaPor(unPersonaje) {
		var asesino = false
		game.onCollideDo(self, { objeto =>
			if (objeto.esBicho()) {
				objeto.asesinadoPor(unPersonaje)
				asesino = true
				game.sound("audio/flecha2.mp3").play()
				self.serAgarrado()
				unPersonaje.nivelActual().aparecerCofreSi()
			}
		})
		game.schedule(1000, { if (not asesino) {
				self.position(direccion.siguiente(self.position()))
			}
		})
		game.schedule(2000, { if (not asesino) {
				self.position(direccion.siguiente(self.position()))
			}
		})
		game.schedule(3000, { if (not asesino) {
				self.serAgarrado()
				game.say(unPersonaje, "Casi!...")
			}
		})
	}

	method esOro() = false

	// Para que se ignore (alfombra)
	method esInteractivo() = true

	method esRecolectable() = false

	method serAgarrado() {
		game.removeVisual(self)
	}

	method esBicho() = false

}

