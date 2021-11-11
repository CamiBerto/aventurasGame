import wollok.game.*
import utilidades.*
import nivel_bloques.*
import nivel_llaves.*
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
		self.energia((0).max(self.energia() - 1))
		self.actualizarEnergiaVisual()
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
	method proximaPosicion() = direccion.siguiente(position)

	// Avanzar a la siguiente casilla según la dirección en la que se esté moviendo
	method avanzar() {
		if (self.energia() > 0) {
			position = self.proximaPosicion()
			self.perderEnergia()
		}
	}

	method moverDerecha() {
		self.direccion(derecha)
		self.moverA_Haciendo(direccion.siguiente(position))
	}

	method moverIzquierda() {
		self.direccion(izquierda)
		self.moverA_Haciendo(direccion.siguiente(position))
	}

	method moverArriba() {
		self.direccion(arriba)
		self.moverA_Haciendo(direccion.siguiente(position))
	}

	method moverAbajo() {
		self.direccion(abajo)
		self.moverA_Haciendo(direccion.siguiente(position))
	}

	method moverA_Haciendo(posicion) {
		// Si hay celdas en la posicion de destino habilita el movimiento
		self.hacerSiHayObjetoEn(posicion)
	}

	method hacerSiHayObjetoEn(posicion) // Metodo abstracto que, si hay un objeto en la posicion destino, realiza las acciones que correspondan

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
		nivelLlaves.AgregarPollo()
	}

	method incorporaEfecto(unElemento) {
		efectoModificador = unElemento.efecto()
	} // usar con los potenciadores

}

/* CON personajes como Clases heredadas */
class PersonajeNivelLlaves inherits Personaje {

	var property llavesConseguidas = 0

	method nivelDeEnergia() = "energia:" + self.energia().toString() + " - Llaves:" + self.llavesConseguidas().toString()

	method perderEnergia(cantidad) {
		self.energia(self.energia() - cantidad)
		self.actualizarEnergiaVisual()
	}

	/* EVALUADORES */
	method determinarAccionPara(posicion) {
		if (self.energia() == 0) nivelLlaves.perder() else self.ganarSiDebe()
	} // evalua energia y si corresponde avanzar, ganar o perder

	method puedeGanar() = llavesConseguidas == 3 and self.proximaPosicion() == salida.position() // Evalua si puede ganar

	method ganarSiDebe() { // si cumple las condiciones gana el juego
		if (self.puedeGanar()) {
			nivelLlaves.ganar()
		}
	}

	/* MOVIMIENTOS */
	override method hacerSiHayObjetoEn(posicion) { // Se sobreescribe el metodo para activar un elemento si lo hay en la posicion de destino
		if (nivelLlaves.hayElementoEn(posicion)) {
			const unElemento = nivelLlaves.elementoDe(posicion)
			unElemento.reaccionarA(self)
			self.avanzar()
		}
	}

	override method moverA(posicion) { // se sobreescrive el metodo para que pierda energia y evalue si corresponde avanzar, ganar o perder el juego.
		self.perderEnergia()
		self.determinarAccionPara(posicion)
		super(posicion)
		nivelLlaves.celdaSorpresaPisada()
	}

}

class PersonajeNivelBloques inherits Personaje {

	/* MOVIMIENTOS */
	override method hacerSiHayObjetoEn(posicion) { // Se sobreescribe el metodo para mover caja si la hay en la posicion de destino y puede moverse
		if (nivelBloques.hayCaja(posicion)) {
			const unaCaja = nivelBloques.cajasEnTablero().find({ b => b.position() == posicion })
			unaCaja.reaccionarA(self)
			if (not nivelBloques.hayCaja(posicion)) {
				self.avanzar()
			}
		} else {
			self.avanzar()
		}
	}

	override method moverA(posicion) { // se sobreescrive el metodo para validar que no haya bloques cuando se mueve.
		if (not nivelBloques.hayCaja(posicion)) {
			super(posicion)
		}
	}

}

