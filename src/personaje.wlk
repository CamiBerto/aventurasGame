import wollok.game.*
import utilidades.*
import elementos.*
import movimientos.*
import indicadores.*

/* personaje generico */
class Personaje {
	// Config inicial
	var property position = utilidadesParaJuego.posicionArbitraria()
	var property image = "imgs/heroe.png"
	var property direccion = arriba
	// Valores de estado
	var property oroJuntado = 0
	var property vida = 50
	var property energia = 30
	var property flechasAgarradas = 0
	// Juego
	var property llavesAgarradas = 0
	var property positionGuardadas = []
	var property nivelActual

	// Abstractos
	method avanzarOGanar()
	method avanzarHaciendoA(posicion) // En nivel 1 resuelve lógica de empujar cajas, en el 2 y el 3, solo avanza

	/* VISUALES */
	method actualizarEnergiaVisual() {
		energiaVisual.actualizarDato(energia)
	}

	method actualizarVidaVisual() {
		vidaVisual.actualizarDato(vida)
	}

	method actualizarLLaveVisual() {
		llavesVisual.actualizarDato(llavesAgarradas)
	}

	method actualizarOroVisual() {
		oroVisual.actualizarDato(oroJuntado)
	}

	method actualizarFlechasVisual() {
		flechaVisual.actualizarDato(flechasAgarradas)
	}

	// Valores de estado
	method perderEnergia(cantidad) {
		// No puede bajar de 0
		self.energia((0).max(self.energia() - cantidad))
		self.actualizarEnergiaVisual()
			// Se queda sin energía
		if (self.energia() == 0) {
			game.say(self, "Me MURI!!! T.T")
			image = "imgs/heroe caido.png"
			const muri = game.sound("audio/muri.mp3")
			muri.play()
			game.schedule(2000, { => nivelActual.perder()})
		}
	}

	method ganarEnergia(cantidad) {
		self.energia((99).min(self.energia() + cantidad))
		self.actualizarEnergiaVisual()
	}

	method guardarLlave() {
		if (llavesAgarradas < 3) {
			llavesAgarradas++
			self.actualizarLLaveVisual()
		}
		if (llavesAgarradas == 3) {
			game.say(self, "Tenemos todas las llaves!")
		}
	}

	method quitarVida(elemento) {
		self.vida(0.max(self.vida() - elemento.vidaQueQuita()))
		self.actualizarVidaVisual()
		if (self.vida() == 0) {
			game.say(self, "Me MURI!!! T.T")
			image = "imgs/heroe caido.png"
			const muri = game.sound("audio/muri.mp3")
			muri.play()
			game.schedule(2000, { => nivelActual.perder()})
		}
	}

	method aumentarVida(elemento) {
		self.vida(99.min(self.vida() + elemento.vidaQueOtorga()))
		self.actualizarVidaVisual()
	}

	method sacarOro(elemento) {
		oroJuntado = 0.max(self.oroJuntado() - elemento.oroQueQuita())
	}

	method sumarOro(elemento) {
		oroJuntado = 99.min(self.oroJuntado() + elemento.oroQueOtorga())
	}

	method actualizarOro(elemento) { // Se utiliza en las reacciones con elementos
		self.sacarOro(elemento)
		self.sumarOro(elemento)
		self.actualizarOroVisual()
		if (not nivelActual.faltanRequisitos()) {
			nivelActual.aparecerPortalSi()
		}
	}

	// Avanzar a la siguiente casilla según la dirección en la que se esté moviendo
	method avanzar() {
		if (self.energia() > 0) {
			const caminar = game.sound("audio/caminar.mp3")
			caminar.play()
			position = direccion.proximaPosicion(self.position())
			self.perderEnergia(1)
		}
	}

	method moverDerecha() {
		self.direccion(derecha)
		self.avanzarHaciendoA(direccion.proximaPosicion(self.position()))
	}

	method moverIzquierda() {
		self.direccion(izquierda)
		self.avanzarHaciendoA(direccion.proximaPosicion(self.position()))
	}

	method moverArriba() {
		self.direccion(arriba)
		self.avanzarHaciendoA(direccion.proximaPosicion(self.position()))
	}

	method moverAbajo() {
		self.direccion(abajo)
		self.avanzarHaciendoA(direccion.proximaPosicion(self.position()))
	}

	// Agarrar priemer elemento que se encuentre a mi alrededor
	method agarrarElemento() {
		const elementosRecolectables = self.elementosRecolectablesAlrededor()
		if (not elementosRecolectables.isEmpty()) {
			elementosRecolectables.first().reaccionarA(self)
		}
	}

	// Elementos recolectables alrededor
	method elementosRecolectablesAlrededor() {
		const lindanteDerecha = (new Position(x = self.position().x() + 1, y = self.position().y())).allElements()
		const lindanteIzquierda = (new Position(x = self.position().x() - 1, y = self.position().y())).allElements()
		const lindanteArriba = (new Position(x = self.position().x(), y = (self.position().y() + 1))).allElements()
		const lindanteAbajo = (new Position(x = self.position().x(), y = self.position().y() - 1)).allElements()
		const celdasLindantes = lindanteDerecha + lindanteIzquierda + lindanteArriba + lindanteAbajo
		return if (not celdasLindantes.isEmpty()) {
			celdasLindantes.filter{ e => e.esRecolectable()}
		} else {
			[]
		}
	}




}

