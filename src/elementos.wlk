import wollok.game.*
import utilidades.*
import nivel_bloques.*
import nivel_llaves.*

class Visual {

	var property position
	var property image = ""

}

class ElementoJuego {
	var property position = utilidadesParaJuego.posicionArbitraria()
	method esRecolectable() = true
	method serAgarrado() {
		game.removeVisual(self)
	}
	// agregar comportamiento
	
}

class Caja inherits ElementoJuego { // Caja

	var property image = "imgs/caja.png"
	// El nivel en el que se encuentra la caja actualmente
	var property nivelActual

	override method esRecolectable() = false

	// agregar comportamiento
	method estaEnDeposito() = deposito.contieneElemento(self)

	//method sePuedeEmpujarA(posicion) = super(posicion) && nivelActual.hayCaja(posicion)

	method empujarA(posicion) {
		if (self.sePuedeEmpujarA(posicion)) {
			self.position(posicion)
		}
	}
	method reaccionarA(unPersonaje) {
		self.empujarA(unPersonaje.direccion().siguiente(unPersonaje.proximaPosicion()))
	}

	method sePuedeEmpujarA(posicion) = posicion.allElements().isEmpty()
}

object deposito {

	var property position = utilidadesParaJuego.posicionArbitraria()
	var property image = "imgs/alfombra4x4.png"

	method esRecolectable() = false

	method contieneElemento(unElemento) = unElemento.position().x().between(self.position().x(), self.position().x() + 2) && unElemento.position().y().between(self.position().y(), self.position().y() + 2)

}

// TODO: salida automática
object salida { // la salida se visualiza siempre en el mismo lugar del tablero

	const property position = game.at(game.width() - 1, 0)
	var property image = "imgs/portal.png"
	const property sonido = "audio/salir.mp3"

	method esRecolectable() = false

	method reaccionarA(unPersonaje) {
	} // no hace nada para respetar el polimorfismo

}

class Recolectable inherits ElementoJuego{
	const property sonido = "audio/coin.mp3"
	method dejarPasar(unPersonaje) {
		unPersonaje.position(self.position())
	}
	override method esRecolectable() = true
	method esCeldaSorpresa() {
		return false
	}
	override method serAgarrado(){
		game.removeVisual(self)
	}
	method reaccionarA(unPersonaje) {
		self.dejarPasar(unPersonaje)
	}
}


class Llave inherits Recolectable {

	var property image = "imgs/llave.png"

	override method sonido() = "audio/salir.mp3"

	override method reaccionarA(unPersonaje) {
		unPersonaje.guardarLlave()
		self.serAgarrado()
	}

}


class Modificador inherits Recolectable {

	method efecto() {
		return ({ unPollo , energiaActual => unPollo.energia() })
	}

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		unPersonaje.incorporaEfecto(self)
	}

}

class Pollo inherits Modificador {

	var property energia = 30
	var property image = "imgs/pollo.png"

	override method sonido() = "audio/comer.mp3"

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		unPersonaje.comerPollo(self)
	}

}
class Duplicador inherits Modificador {

	var property image = "imgs/coin.png"

	override method efecto() {
		return ({ unPollo , energiaActual => unPollo.energia() * 2 })
	}

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		game.say(self, "Duplicador")
	}

}

class Reforzador inherits Modificador {

	var property image = "imgs/coin.png"

	method energiaExtra(energiaActual) = if (energiaActual < 10) 20 else 0

	override method efecto() {
		return ({ unPollo , energiaActual => unPollo.energia() * 2 + self.energiaExtra(energiaActual) })
	}

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		game.say(self, "reforzador")
	}

}

class CeldaSorpresa inherits Modificador {

	var property fueActivada = false
	var property image = "imgs/beer premio.png"

	method cambiarDeIMagen() {
		image = "imgs/sorpresaUsada.png"
	}

	override method reaccionarA(unPersonaje) { // DETERMINAR Y CODIFICAR ACCION
	}

	override method esCeldaSorpresa() {
		return true
	}

	method activarSorpresa() {
		self.cambiarDeIMagen()
		fueActivada = true
	}

}

class CeldaSorpresaA inherits CeldaSorpresa {

	override method activarSorpresa() {
		super()
		nivelLlaves.Teletransportar()
	}

}

class CeldaSorpresaB inherits CeldaSorpresa {

	override method activarSorpresa() {
		super()
		nivelLlaves.EfectoAgregarEnergia()
	}

}

class CeldaSorpresaC inherits CeldaSorpresa {

	override method activarSorpresa() {
		super()
		nivelLlaves.EfectoPerderEnergia()
	}

}

class CeldaSorpresaD inherits CeldaSorpresa {

	override method activarSorpresa() {
		super()
		nivelLlaves.AgregarPollo()
	}

}

