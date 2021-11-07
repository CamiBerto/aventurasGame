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
		self.energia(self.energia() - 1)
		self.actualizarEnergiaVisual()
	}

	method ganarEnergia(cantidad) {
		self.energia(self.energia() + cantidad)
		self.actualizarEnergiaVisual()
	}

	/* MOVIMIENTOS */
	method proximaPosicion() = direccion.siguiente(position)

	// Avanzar a la siguiente casilla según la dirección en la que se esté moviendo
	method avanzar() {
		position = self.proximaPosicion()
		self.perderEnergia()
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
		if (utilidadesParaJuego.sePuedeMover(posicion)) { // Si hay celdas en la posicion de destino habilita el movimiento
			self.hacerSiHayObjetoEn(posicion)
		}
	}

	method hacerSiHayObjetoEn(posicion) // Metodo abstracto que, si hay un objeto en la posicion destino, realiza las acciones que correspondan

	method moverA(posicion) {
		self.position(posicion)
	} // Mueve el personaje a una posicion	

}

/* CON personajes como Clases heredadas */
class PersonajeNivelLlaves inherits Personaje {

	var property llavesConseguidas = 0
	var efectoModificador = { unPollo , energiaActual => unPollo.energia() }

	method nivelDeEnergia() = "energia:" + self.energia().toString() + " - Llaves:" + self.llavesConseguidas().toString()

	method incorporaEfecto(unElemento) {
		efectoModificador = unElemento.efecto()
	} // usar con los potenciadores

	method perderEnergia(cantidad) {
		self.energia(self.energia() - cantidad)
		self.actualizarEnergiaVisual()
	}

	method comerPollo(unpollo) {
		const energiaPolloModificada = efectoModificador.apply(unpollo, self.energia())
		self.ganarEnergia(energiaPolloModificada)
		nivelLlaves.AgregarPollo()
	}

	method guardarLlave() { // guarda las llaves y al tener todas, indica al tablero poner la salida
		self.llavesConseguidas(self.llavesConseguidas() + 1)
		if (self.llavesConseguidas() == 3) nivelLlaves.ponerSalida()
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
		}
		self.avanzar()
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
		if (nivelBloques.hayCaja(posicion) and not nivelBloques.hayCaja(self.proximaPosicion())) {
			const unaCaja = nivelBloques.cajasEnTablero().find({ b => b.position() == posicion })
			unaCaja.empujar(self.proximaPosicion())
		}
		self.avanzar()
	}

	override method moverA(posicion) { // se sobreescrive el metodo para validar que no haya bloques cuando se mueve.
		if (not nivelBloques.hayCaja(posicion)) {
			super(posicion)
		}
	}

}

