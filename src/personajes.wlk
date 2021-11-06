import wollok.game.*
import utilidades.*
import nivel_bloques.*
import nivel_llaves.*
import elementos.*


// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición

/* personaje generico */
class Personaje {
	var property position = utilidadesParaJuego.posicionArbitraria()
	const property image = "heroe.png"
	var proximaPosicion = self.position()
	
	/* MOVIMIENTOS */
	method moverDerecha() {
		proximaPosicion = game.at(self.position().x() + 2, self.position().y())
		self.moverA_Haciendo(self.position().right(1))
	}
	method moverIzquierda() {
		proximaPosicion = game.at(self.position().x() - 2, self.position().y())
		self.moverA_Haciendo(self.position().left(1))
	}
	method moverArriba() {
		proximaPosicion = game.at(self.position().x(), self.position().y() + 2)
		self.moverA_Haciendo(self.position().up(1))
	}
	method moverAbajo() {
		proximaPosicion = game.at(self.position().x(), self.position().y() - 2)
		self.moverA_Haciendo(self.position().down(1))
	}
	
	method moverA_Haciendo(posicion) {
		if (utilidadesParaJuego.sePuedeMover(posicion) ) { //Si hay celdas en la posicion de destino habilita el movimiento
			self.hacerSiHayObjetoEn(posicion)
		}
	}
	method hacerSiHayObjetoEn(posicion)		// Metodo abstracto que, si hay un objeto en la posicion destino, realiza las acciones que correspondan
	method moverA(posicion){self.position(posicion)} //Mueve el personaje a una posicion	
}

/* CON personajes como Clases heredadas */
class PersonajeNivelLlaves inherits Personaje {
	var property energia=40
	var property llavesConseguidas = 0
	var efectoModificador =  {unPollo,energiaActual => unPollo.energia() }
	
	method nivelDeEnergia() = "energia:" + self.energia().toString() + " - Llaves:" + self.llavesConseguidas().toString() 
	
	method incorporaEfecto(unElemento) {efectoModificador = unElemento.efecto()} // usar con los potenciadores
	method perderEnergia(){self.energia(self.energia()-1)}
	method ganarEnergia(cantidad){self.energia(self.energia() + cantidad )}
	method perderEnergia(cantidad){self.energia(self.energia() - cantidad )}
	
	
	method comerPollo(unpollo){
		const energiaPolloModificada =  efectoModificador.apply(unpollo, self.energia())
		self.ganarEnergia(energiaPolloModificada)
		nivelLlaves.AgregarPollo()
	}
	
	method guardarLlave() { // guarda las llaves y al tener todas, indica al tablero poner la salida
		self.llavesConseguidas(self.llavesConseguidas()+1)
		if (self.llavesConseguidas() == 3)
			nivelLlaves.ponerSalida()
	}
	
	/* EVALUADORES */
	method determinarAccionPara(posicion) { if (self.energia() == 0) nivelLlaves.perder() else self.ganarSiDebe() } // evalua energia y si corresponde avanzar, ganar o perder
	method puedeGanar() = llavesConseguidas == 3 and proximaPosicion == salida.position() // Evalua si puede ganar
	method ganarSiDebe() { // si cumple las condiciones gana el juego
		if (self.puedeGanar()){
			nivelLlaves.ganar()	
		}
	}

	/* MOVIMIENTOS */
 	override method hacerSiHayObjetoEn(posicion){	// Se sobreescribe el metodo para activar un elemento si lo hay en la posicion de destino
		if(nivelLlaves.hayElementoEn(posicion)) {
			const unElemento = nivelLlaves.elementoDe(posicion)
			unElemento.reaccionarA(self)
		}else{
			self.moverA(posicion)
	
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
	override method hacerSiHayObjetoEn(posicion) {		// Se sobreescribe el metodo para mover bloque si lo hay en la posicion de destino y puede moverse
		if (nivelBloques.hayBloque(posicion) and not nivelBloques.hayBloque(proximaPosicion) ){
			const unBloque = nivelBloques.bloquesEnTablero().find( { b => b.position() == posicion } )
			unBloque.empujar(proximaPosicion)
		}
		self.moverA(posicion)
	}
	override method moverA(posicion){ 	// se sobreescrive el metodo para validar que no haya bloques cuando se mueve.
		if(not nivelBloques.hayBloque(posicion)) {
			super(posicion)
		}
	}

}