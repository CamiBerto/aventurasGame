import wollok.game.*
import utilidades.*
import elementos.*
import movimientos.*
import indicadores.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición
/* personaje generico */
class Personaje {

	var efectoModificador = { unPollo , energiaActual => unPollo.energia() }
	// Config inicial
	var property position = utilidadesParaJuego.posicionArbitraria()
	var property image = "imgs/heroe.png"
	var property direccion = arriba
	// Valores de estado
	var property oro = 10
	var property vida = 25
	var property energia = 30
	var property granadas = 0
	// Juego
	var property llavesAgarradas = 0
	var property positionGuardadas = []
	var nivelActual

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

	// Valores de estado
	method perderEnergia() {
		// No puede bajar de 0
		self.energia((0).max(self.energia() - 1))
		self.actualizarEnergiaVisual()
			// Se queda sin energía
		if (self.energia() == 0) {
			game.say(self, "Me MURI!!! T.T")
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
	}

	/* MOVIMIENTOS */
	method proximaPosicion() {
		var siguientePosicion = direccion.siguiente(position)
		if (direccion.esIgual(derecha)) {
			// Si está en el borde derecho del tablero
			if (game.width() == self.position().x() + 1) {
				siguientePosicion = game.at(0, self.position().y())
			}
		} else if (direccion.esIgual(izquierda)) {
			// Si está en el borde izquierdo del tablero
			if (self.position().x() == 0) {
				siguientePosicion = game.at(game.width() - 1, self.position().y())
			}
		} else if (direccion.esIgual(abajo)) {
			if (self.position().y() == 0) {
				siguientePosicion = game.at(self.position().x(), game.height() - 1)
			}
		} else if (direccion.esIgual(arriba)) {
			if (game.height() == self.position().y() + 2) {
				siguientePosicion = game.at(self.position().x(), 0)
			}
		}
		return siguientePosicion
	}

	// Avanzar a la siguiente casilla según la dirección en la que se esté moviendo
	method avanzar() {
		if (self.energia() > 0) {
			position = self.proximaPosicion()
			self.perderEnergia()
		}
	}

	method moverDerecha() {
		self.direccion(derecha)
		self.moverA_Haciendo(self.proximaPosicion())
	}

	method moverIzquierda() {
		self.direccion(izquierda)
		self.moverA_Haciendo(self.proximaPosicion())
	}

	method moverArriba() {
		self.direccion(arriba)
		self.moverA_Haciendo(self.proximaPosicion())
	}

	method moverAbajo() {
		self.direccion(abajo)
		self.moverA_Haciendo(self.proximaPosicion())
	}

	method moverA_Haciendo(posicion) {
		// Si hay celdas en la posicion de destino habilita el movimiento
		self.hacerSiHayObjetoEn(posicion)
	}

	method hacerSiHayObjetoEn(posicion)

	method moverA(posicion) {
		self.position(posicion)
	} // Mueve el personaje a una posicion	

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

	method comerPollo(unpollo) {
		const energiaPolloModificada = efectoModificador.apply(unpollo, self.energia())
		self.ganarEnergia(energiaPolloModificada)
		game.removeVisual(unpollo)
	}

	method incorporaEfecto(unElemento) {
		efectoModificador = unElemento.efecto()
	} // usar con los potenciadores

}

class PersonajeNivel1 inherits Personaje {

	override method hacerSiHayObjetoEn(posicion) {
		/* SOLO LAS CAJAS BLOQUEAN EL PASO, LOS OTROS OBJETOS SE AGARRAN */
		// Todos los niveles tienen cajas..?? O el 2 no??
		if (nivelActual.hayCaja(posicion)) {
			// ?? Esto podría hacerse con el getObjectsIn...?? asumiendo que solo hay una visual por celda
			const unaCaja = nivelActual.cajasEnTablero().find({ b => b.position() == posicion })
			unaCaja.reaccionarA(self)
			if (not nivelActual.hayCaja(posicion)) {
				self.avanzar()
			}
		} else {
			self.avanzar()
		}
	}

}

/* CON personajes como Clases heredadas */
/* class PersonajeNivelLlaves inherits Personaje {

 * 	

 * 	method nivelDeEnergia() = "energia:" + self.energia().toString() + " - Llaves:" + self.llavesAgarradas().toString()

 * 	method perderEnergia(cantidad) {
 * 		self.energia(self.energia() - cantidad)
 * 		self.actualizarEnergiaVisual()
 * 	}

 * 	// EVALUADORES 
 * 	method determinarAccionPara(posicion) {
 * 		if (self.energia() == 0) nivelLlaves.perder() else self.ganarSiDebe()
 * 	} // evalua energia y si corresponde avanzar, ganar o perder

 * 	method ganarSiDebe() { // si cumple las condiciones gana el juego
 * 		if (self.puedeGanar()) {
 * 			nivelLlaves.ganar()
 * 		}
 * 	}
 * 	method puedeGanar() = llavesAgarradas == 3 and self.proximaPosicion() == salida.position() // Evalua si puede ganar

 * 	// MOVIMIENTOS
 * 	override method hacerSiHayObjetoEn(posicion) { // Se sobreescribe el metodo para activar un elemento si lo hay en la posicion de destino
 * 		if (nivelLlaves.hayElementoEn(posicion)) {
 * 			const unElemento = nivelLlaves.elementoDe(posicion)
 * 			unElemento.reaccionarA(self)
 * 			self.avanzar()
 * 		}
 * 	}

 * 	override method moverA(posicion) { // se sobreescrive el metodo para que pierda energia y evalue si corresponde avanzar, ganar o perder el juego.
 * 		self.perderEnergia()
 * 		self.determinarAccionPara(posicion)
 * 		super(posicion)
 * 		nivelLlaves.celdaSorpresaPisada()
 * 	}

 } */
/* class PersonajeNivelBloques inherits Personaje {

 * 	// MOVIMIENTOS
 * 	override method hacerSiHayObjetoEn(posicion) { // Se sobreescribe el metodo para mover caja si la hay en la posicion de destino y puede moverse
 * 		if (nivelBloques.hayCaja(posicion)) {
 * 			const unaCaja = nivelBloques.cajasEnTablero().find({ b => b.position() == posicion })
 * 			unaCaja.reaccionarA(self)
 * 			if (not nivelBloques.hayCaja(posicion)) {
 * 				self.avanzar()
 * 			}
 * 		} else {
 * 			self.avanzar()
 * 		}
 * 	}

 * 	override method moverA(posicion) { // se sobreescrive el metodo para validar que no haya bloques cuando se mueve.
 * 		if (not nivelBloques.hayCaja(posicion)) {
 * 			super(posicion)
 * 		}
 * 	}

 } */
