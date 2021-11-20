import wollok.game.*
import utilidades.*
import nivel_1.*
import movimientos.*

class Visual {

	var property position
	var property image = ""
	method esInteractivo() = false // son aquellos con los que interactua el personaje(ejemplo: alfombra no)

}

class ElementoJuego {

	var property position = utilidadesParaJuego.posicionArbitraria()

	method esRecolectable() = true

	method esOro() = false

	// Para que se ignore (alfombra)
	method esInteractivo() = true

	method serAgarrado() {
				utilidadesParaJuego.eliminarVisual(self)

	}

	method esEnemigo() = false

// agregar comportamiento
}

class Caja inherits ElementoJuego { // Caja

	var property image = "imgs/caja.png"
	// El nivel en el que se encuentra la caja actualmente
	var property nivelActual

	override method esRecolectable() = false

	// agregar comportamiento
	method estaEnDeposito() = deposito.contieneElemento(self)

	method sePuedeEmpujarA(posicion) = posicion.allElements().all{ e => not e.esInteractivo() } // interactivo es para ignorar alfombra

	method empujarA(posicion) {
		if (self.sePuedeEmpujarA(posicion)) {
			self.position(posicion)
		}
	}

	method siguientePosicion(posicion, direccion) = direccion.proximaPosicion(posicion) // devuelve la siguiente posicion de una posicion

	method reaccionarA(unPersonaje) {
		const direccion = unPersonaje.direccion() // direccion de personaje actual
		const proximaPosicionPersonaje = direccion.proximaPosicion(unPersonaje.position()) // posicion proxima de personaje
		const siguientePosicionCaja = self.siguientePosicion(proximaPosicionPersonaje, direccion) // posicion proxima de "la proxima" de personaje
		self.empujarA(siguientePosicionCaja)
	}

}

class Recolectable inherits ElementoJuego {

	const property sonido = "audio/coin.mp3"

	override method esRecolectable() = true

	method energiaQueOtorga() = 0

	method oroQueOtorga() = 0

	method oroQueQuita() = 0

	method vidaQueQuita() = 0

	method reaccionarA(unPersonaje) {
		self.serAgarrado()
	}

}

class Llave inherits Recolectable {

	var property image = "imgs/llave.png"

	override method sonido() = "audio/llave.mp3"

	override method reaccionarA(unPersonaje) {
		super(unPersonaje) // ser agarrado
		unPersonaje.guardarLlave()
		game.sound(self.sonido()).play()
	}

}

class Pota inherits Recolectable {

	var property image = "imgs/pocionRoja.png"
	var property vidaQueOtorga = 15.randomUpTo(20).truncate(0)

	override method sonido() = "audio/pota.mp3"

	override method oroQueOtorga() = 3

	override method reaccionarA(unPersonaje) {
		unPersonaje.aumentarVida(self)
		super(unPersonaje) // ser agarrado
		game.sound(self.sonido()).play()
	}

}

class Oro inherits Recolectable {

	var property image = "imgs/moneda.png"

	override method sonido() = "audio/coin.mp3"

	override method vidaQueQuita() = 15.randomUpTo(20).truncate(0)

	override method oroQueOtorga() = 10

	override method reaccionarA(unPersonaje) {
		unPersonaje.actualizarOro(self)
		unPersonaje.quitarVida(self)
		super(unPersonaje) // ser agarrado
		game.sound(self.sonido()).play()
	}

	override method esOro() = true

	override method esRecolectable() = false

}

class Pollo inherits Recolectable {

	var property image = "imgs/pollo.png"

	override method oroQueOtorga() = 5

	override method energiaQueOtorga() = 30

	override method sonido() = "audio/comerpollo.mp3"

	override method reaccionarA(unPersonaje) {
		unPersonaje.ganarEnergia(self.energiaQueOtorga())
		unPersonaje.actualizarOro(self)
		super(unPersonaje) // ser agarrado
		game.sound(self.sonido()).play()
	}

}

class CeldaSorpresa inherits Recolectable {

	var property fueActivada = false
	var property image = "imgs/beer premio.png"

	method cambiarDeIMagen() { // varia segun la sorpresa, a veces esta vacia
		image = "imgs/caiste.png"
	}

	override method reaccionarA(unPersonaje) {
		self.activarSorpresa(unPersonaje.nivelActual())
	}

	method activarSorpresa(unNivel) {
		self.cambiarDeIMagen()
		fueActivada = true
		game.schedule(500, { self.serAgarrado()}) // agrega un delay para que de tiempo a cambiarImagen()
	}

}

class CeldaSorpresaA inherits CeldaSorpresa {

	override method activarSorpresa(unNivel) {
		super(unNivel) // activarSorpresa(unNivel)
		unNivel.personaje().actualizarOro(self)
		unNivel.teletransportar()
	}

	override method oroQueQuita() = 5

	override method cambiarDeIMagen() {
		image = "imgs/ver.png"
		const comerManzana = game.sound("audio/telepor.mp3")
		comerManzana.play()
		game.say(self, "MALDITOS PORTALES")
	}

}

class CeldaSorpresaB inherits CeldaSorpresa {

	override method activarSorpresa(unNivel) {
		super(unNivel) // activarSorpresa(unNivel)
		unNivel.personaje().actualizarOro(self)
		unNivel.personaje().ganarEnergia(30)
	}

	override method oroQueOtorga() = 2

	override method cambiarDeIMagen() {
		image = "imgs/manzana.png"
		const comerManzana = game.sound("audio/comer_manzana.mp3")
		comerManzana.play()
		game.say(self, "Energía")
	}

}

class CeldaSorpresaC inherits CeldaSorpresa {

	override method activarSorpresa(unNivel) {
		super(unNivel) // activarSorpresa(unNivel)
		unNivel.personaje().actualizarOro(self)
		unNivel.personaje().perderEnergia(15)
	}

	override method oroQueQuita() = 20

	override method cambiarDeIMagen() {
		image = "imgs/caiste.png"
		const caiste = game.sound("audio/caiste.mp3")
		caiste.play()
		game.say(self, "Golpe Bajo de Energía")
	}

}

class CeldaSorpresaD inherits CeldaSorpresa {

	override method activarSorpresa(unNivel) {
		super(unNivel) // activarSorpresa(unNivel)
		unNivel.agregarPollo()
	}

	override method cambiarDeIMagen() {
		image = "imgs/ver.png"
		game.say(self, "¡¡¡Más pollos!!!")
	}

}

class FlechaEnPiso inherits Recolectable {

	var property image = "imgs/flechas.png"

	override method sonido() = "audio/flechas.mp3"

	override method reaccionarA(unPersonaje) {
		unPersonaje.agarrarFlecha()
		super(unPersonaje) // serAgarrado()
		game.sound(self.sonido()).play()
	}

}

object cofre { // el cofre se visualiza siempre en el mismo lugar del tablero

	const property position = utilidadesParaJuego.posicionArbitraria()
	var property image = "imgs/cofre.png"
	const property sonido = "audio/curar.mp3"

	method esOro() = false

	method esEnemigo() = false

	method esRecolectable() = false

	method reaccionarA(unPersonaje) {
	} // no hace nada para respetar el polimorfismo

}

object deposito {

	var property image = "imgs/alfombra4x4.png"
	var property position = self.posicionAleatoria()

	method posicionAleatoria() {
		return game.at(0.randomUpTo(game.width() - 4).truncate(0), 0.randomUpTo(game.height() - 5).truncate(0))
	}

	method esRecolectable() = false

	method esEnemigo() = false

	method esInteractivo() = false

	method contieneElemento(unElemento) = unElemento.position().x().between(self.position().x(), self.position().x() + 3) && unElemento.position().y().between(self.position().y(), self.position().y() + 3)

}

object salida { // la salida se visualiza siempre en el mismo lugar del tablero

	const property position = utilidadesParaJuego.posicionArbitraria()
	var property image = "imgs/portal.png"
	const property sonido = "audio/salir.mp3"

	method esOro() = false

	method esEnemigo() = false

	method esRecolectable() = false

	method reaccionarA(unPersonaje) {
	} // no hace nada para respetar el polimorfismo

}

