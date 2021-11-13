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
	var property oro = 0
	var property vida = 25
	var property energia = 30
	var property granadas = 0
	// Juego
	var property llavesAgarradas = 0
	var property positionGuardadas = []
	var nivelActual
	method oro(num){oro += num}
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
		oroVisual.actualizarDato(oro)
	}

	// Valores de estado
	method perderEnergia(cantidad) {
		// No puede bajar de 0
		self.energia((0).max(self.energia() - cantidad))
		self.actualizarEnergiaVisual()
			// Se queda sin energía
		if (self.energia() == 0) {
			game.say(self, "Me MURI!!! T.T")
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
			//const llave = nivelActual.elementosEnNivel().find({c=>c.esLlave()})
			//self.oro(llave.oroQueOtorga())
			llavesAgarradas++
			self.actualizarLLaveVisual()
			self.actualizarOroVisual()
		}
		if (llavesAgarradas == 3) {
			self.actualizarOroVisual()
			game.say(self, "Tenemos todas las llaves!")
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

	method avanzarHaciendoA(posicion)

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

	method comerPollo(unPollo) {
		const comerpollo = game.sound("audio/comerpollo.mp3")
		comerpollo.play()
		const energiaPolloModificada = efectoModificador.apply(unPollo, self.energia())
		self.ganarEnergia(energiaPolloModificada)
		unPollo.serAgarrado()
	}
	method agarrarOro(){
		
	}
	method incorporaEfecto(unElemento) {
		efectoModificador = unElemento.efecto()
	} // usar con los potenciadores

	method avanzarOGanar()

}

class PersonajeNivel1 inherits Personaje {

	override method avanzarOGanar() {
		if (nivelActual.faltanRequisitos()) {
			self.avanzar()
		} else {
			game.say(self, "Ganamos!!!")
			game.schedule(1500, { nivelActual.pasarDeNivel()})
		}
	}

	override method avanzarHaciendoA(posicion) {
		/* SOLO LAS CAJAS BLOQUEAN EL PASO, LOS OTROS OBJETOS SE AGARRAN */
		if (nivelActual.hayCaja(posicion)) {
			// ?? Esto podría hacerse con el getObjectsIn...?? asumiendo que solo hay una visual por celda
			const unaCaja = nivelActual.cajasEnTablero().find({ b => b.position() == posicion })
			unaCaja.reaccionarA(self)
		}
			// Si había caja, después del bloque anterior, no debería haber caja
		if (not nivelActual.hayCaja(posicion)) {
			self.avanzarOGanar()
		}
	}

}
class PersonajeNivel2 inherits Personaje {

	override method avanzarOGanar() {
		if (nivelActual.faltanRequisitos()) {
			self.avanzar()
		} else {
			game.say(self, "Ganamos!!!")
			game.schedule(1500, { nivelActual.pasarDeNivel()})
		}
	}

	override method avanzarHaciendoA(posicion) {
		/* SOLO LAS CAJAS BLOQUEAN EL PASO, LOS OTROS OBJETOS SE AGARRAN */
		if (nivelActual.hayCaja(posicion)) {
			// ?? Esto podría hacerse con el getObjectsIn...?? asumiendo que solo hay una visual por celda
			const unaCaja = nivelActual.cajasEnTablero().find({ b => b.position() == posicion })
			unaCaja.reaccionarA(self)
		}
			// Si había caja, después del bloque anterior, no debería haber caja
		if (not nivelActual.hayCaja(posicion)) {
			self.avanzarOGanar()
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
 * 	method puedeGanar() = llavesAgarradas == 3 and direccion.proximaPosicion(self.position()) == salida.position() // Evalua si puede ganar

 * 	// MOVIMIENTOS
 * 	override method avanzarHaciendoA(posicion) { // Se sobreescribe el metodo para activar un elemento si lo hay en la posicion de destino
 * 		if (nivelLlaves.hayElementoEn(posicion)) {
 * 			const unElemento = nivelLlaves.elementoDe(posicion)
 * 			unElemento.reaccionarA(self)
 * 			self.avanzar()
 * 		}
 * 	}

 * 	override method moverA(posicion) { // se sobreescrive el metodo para que pierda energia y evalue si corresponde avanzar, ganar o perder el juego.
 * 		self.perderEnergia(1)
 * 		self.determinarAccionPara(posicion)
 * 		super(posicion)
 * 		nivelLlaves.celdaSorpresaPisada()
 * 	}

 } */
/* class PersonajeNivelBloques inherits Personaje {

 * 	// MOVIMIENTOS
 * 	override method avanzarHaciendoA(posicion) { // Se sobreescribe el metodo para mover caja si la hay en la posicion de destino y puede moverse
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
