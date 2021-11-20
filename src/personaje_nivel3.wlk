import wollok.game.*
import utilidades.*
import elementos.*
import movimientos.*
import indicadores.*
import personaje.*
import enemigosYFlechaArrojada.*

class PersonajeNivel3 inherits Personaje {

	override method avanzarOGanar() {
	}

	override method avanzarHaciendoA(posicion) {
		self.avanzar()
	}

	override method actualizarOro(elemento) {
	}

	// La flecha consulta a los elementos con los que colisiona, si son enemigos
	method esEnemigo() = false

	method serAtacadoPorEnemigo(unEnemigo) {
		// Retrasamos el ataque para que no pierda toda la vida rápidamente
		game.schedule(500, { self.quitarVida(unEnemigo)})
			// Vuelve 2 celdas hacia atrás
		self.retrocederPasos(2)
	}

	method retrocederPasos(cantidadDePasos) {
		self.direccion(self.direccion().opuesto())
		cantidadDePasos.times({ a => self.position(direccion.proximaPosicion(self.position()))})
	}

	method agarrarFlecha() {
		flechasAgarradas += 3
		self.actualizarFlechasVisual()
	}

	method dispararFlecha() {
		if (flechasAgarradas > 0) {
			// Se crea la flecha en posición lindante a self
			const flechaLanzada = new FlechaArrojada(image = ("imgs/flecha" + self.direccion() + ".png"), position = self.direccion().siguiente(self.position()), direccion = self.direccion())
			game.addVisual(flechaLanzada)
			flechaLanzada.disparadaPor(self)
			flechasAgarradas -= 1
			game.sound(flechaLanzada.sonido()).play()
			self.actualizarFlechasVisual()
		}
	}

}

