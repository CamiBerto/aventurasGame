import wollok.game.*
import utilidades.*
import elementos.*
import movimientos.*
import indicadores.*
import personaje.*

class PersonajeNivel3 inherits Personaje {

	override method avanzarOGanar() {
	}

	method serAtacadoPorBicho(unBicho) {
		game.schedule(500, { self.quitarVida(unBicho)})
		self.direccion(self.direccion().opuesto())
		2.times({ a => self.position(direccion.proximaPosicion(self.position()))})
	}

	override method avanzarHaciendoA(posicion) {
		self.avanzar()
	}

	method agarrarFlecha() {
		flechasAgarradas += 3
		self.actualizarFlechasVisual()
	}

	method dispararFlecha() {
		if (flechasAgarradas > 0) {
			const flechaLanzada = new FlechaArrojada(image = ("imgs/flecha" + self.direccion() + ".png"), position = self.direccion().siguiente(self.position()), direccion = self.direccion())
			game.addVisual(flecha)
			flechaLanzada.disparadaPor(self)
			flechasAgarradas -= 1
			game.sound(flechaLanzada.sonido()).play()
			self.actualizarFlechasVisual()
		}
	}

	override method actualizarOro(elemento) {
	}

	method esBicho() = false

}

