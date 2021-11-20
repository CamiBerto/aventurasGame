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
		self.morir()
		unPersonaje.nivelActual().ponerElementos(1, flecha)
	}

	method morir() {
				utilidadesParaJuego.eliminarVisual(self)

	}

	override method esEnemigo() = true

}

// Un enemigo que persigue al personaje
class EnemigoAgresivo inherits Enemigo {

	override method vidaQueQuita() = 30

	override method moverse(unPersonaje) {
		game.onTick(2000, "enemigo se mueve", { position = new Position(x = self.acercarseHorizontalA(unPersonaje), y = self.acercarseVerticalA(unPersonaje))})
	}

	method acercarseHorizontalA(unPersonaje) {
		return if (self.estaALaIzquierdaDe(unPersonaje)) {
			self.position().x() + 1
		} else {
			self.position().x() - 1
		}
	}

	method acercarseVerticalA(unPersonaje) {
		return if (self.estaAbajoDe(unPersonaje)) {
			self.position().y() + 1
		} else {
			self.position().y() - 1
		}
	}

	method estaALaIzquierdaDe(unElemento) = unElemento.position().x() > self.position().x()

	method estaAbajoDe(unElemento) = unElemento.position().y() > self.position().y()

}

class Demonio inherits EnemigoAgresivo {

	override method sonido() = "audio/demonio.mp3"

}

class Ogro inherits EnemigoAgresivo {

	override method sonido() = "audio/ogro.mp3"

}

class FlechaArrojada {

	var property position
	var property image
	var property direccion
	var property sonido = "audio/flechas.mp3"

	method disparadaPor(unPersonaje) {
		var acerto = false
		game.onCollideDo(self, { objeto =>
			if (objeto.esEnemigo()) {
				objeto.asesinadoPor(unPersonaje)
				acerto = true
				game.sound("audio/flecha2.mp3").play()
				self.desaparecer()
				unPersonaje.nivelActual().aparecerCofreSi()
			}
		})
		game.schedule(1000, { if (not acerto) {
				self.position(direccion.siguiente(self.position()))
			}
		})
		game.schedule(2000, { if (not acerto) {
				self.position(direccion.siguiente(self.position()))
			}
		})
		game.schedule(3000, { if (not acerto) {
				self.desaparecer()
				game.say(unPersonaje, "Casi...")
			}
		})
	}

	method esOro() = false

	// Para que se ignore (alfombra)
	method esInteractivo() = true

	method esRecolectable() = false

	method desaparecer() {
		utilidadesParaJuego.eliminarVisual(self)
	}

	method esEnemigo() = false

}

