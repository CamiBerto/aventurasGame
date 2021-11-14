import wollok.game.*
import utilidades.*
import nivel_1.*
import movimientos.*

class Visual {

	var property position
	var property image = ""

	method esInteractivo() = false

}

class ElementoJuego {

	var property position = utilidadesParaJuego.posicionArbitraria()

	method esRecolectable() = true

	method esOro() = false

	// Para que se ignore (alfombra)
	method esInteractivo() = true

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

	// method sePuedeEmpujarA(posicion) = super(posicion) && nivelActual.hayCaja(posicion)
	method empujarA(posicion) {
		if (self.sePuedeEmpujarA(posicion)) {
			self.position(posicion)
		}
	}

	method siguientePosicion(posicion, direccion) = direccion.proximaPosicion(posicion)

	method reaccionarA(unPersonaje) {
		const direccion = unPersonaje.direccion() // direccion de personaje actual
		const proximaPosicionPersonaje = direccion.proximaPosicion(unPersonaje.position()) // posicion proxima de personaje
		const siguientePosicionCaja = self.siguientePosicion(proximaPosicionPersonaje, direccion) // posicion proxima de proxima de personaje
		self.empujarA(siguientePosicionCaja)
	}

	method sePuedeEmpujarA(posicion) = posicion.allElements().all{ e => not e.esInteractivo() } // interactivo es para ignorar alfombra

}

class Recolectable inherits ElementoJuego {

	const property sonido = "audio/coin.mp3"

	method dejarPasar(unPersonaje) {
		unPersonaje.position(self.position())
	}

	override method esRecolectable() = true

	method esCeldaSorpresa() {
		return false
	}

	method oroQueOtorga() = 0

	method oroQueQuita() = 0

	method vidaQueQuita() = 0

	override method serAgarrado() {
		game.removeVisual(self)
	}

	method reaccionarA(unPersonaje) {
		self.dejarPasar(unPersonaje)
	}

}

class Llave inherits Recolectable {

	var property image = "imgs/llave.png"

	override method sonido() = "audio/llave.mp3"

	override method reaccionarA(unPersonaje) {
		unPersonaje.guardarLlave()
		self.serAgarrado()
		game.sound(self.sonido()).play()
	}

}

class Modificador inherits Recolectable {

	method efecto() {
		return ({ unPollo => unPollo.energia() })
	}

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		unPersonaje.incorporaEfecto(self)
	}

}

class Pota inherits Recolectable {

	var property image = "imgs/pocionRoja.png"
	var property vidaQueOtorga = 15.randomUpTo(20).truncate(0)

	override method sonido() = "audio/pota.mp3"

	method efecto() {
		return ({ potita /*energiaActual*/ => potita.vida() })
	}

	override method oroQueOtorga() = 3

	override method reaccionarA(unPersonaje) {
		unPersonaje.aumentarVida(self)
		self.serAgarrado()
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
		self.serAgarrado()
		game.sound(self.sonido()).play()
	}

	override method esOro() = true

	override method esRecolectable() = false

}

class Pollo inherits Modificador {

	var property energia = 30
	var property image = "imgs/pollo.png"

	override method oroQueOtorga() = 5

	override method sonido() = "audio/comer.mp3"

	override method reaccionarA(unPersonaje) {
		unPersonaje.comerPollo(self)
	}

}

class CeldaSorpresa inherits Modificador {

	var property fueActivada = false
	var property image = "imgs/beer premio.png"

	method cambiarDeIMagen() {
		image = "imgs/caiste.png"
	}

	override method esCeldaSorpresa() {
		return true
	}

	override method reaccionarA(unPersonaje) {
		self.activarSorpresa(unPersonaje.nivelActual())
	}

	method activarSorpresa(unNivel) {
		self.cambiarDeIMagen()
		fueActivada = true
		game.schedule(500, { game.removeVisual(self)})
	}

}

class CeldaSorpresaA inherits CeldaSorpresa {

	override method activarSorpresa(unNivel) {
		super(unNivel)
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
		super(unNivel)
		unNivel.personaje().actualizarOro(self)
		unNivel.efectoAgregarEnergia()
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
		super(unNivel)
		unNivel.personaje().actualizarOro(self)
		unNivel.efectoPerderEnergia()
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
		super(unNivel)
		unNivel.agregarPollo()
	}

	override method cambiarDeIMagen() {
		image = "imgs/ver.png"
		game.say(self, "Más pollos!!!")
	}

}

class Flecha inherits Recolectable {

	var property image = "imgs/flechas.png"

	override method sonido() = "audio/flechas.mp3"

	override method reaccionarA(unPersonaje) {
		unPersonaje.agarrarFlecha()
		self.serAgarrado()
		game.sound(self.sonido()).play()
	}

}

class Bicho inherits ElementoJuego {

	method saludQueQuita() = 20

	override method esRecolectable() = false

	method morir() {
		game.removeVisual(self)
	}

}

object cofre { // la salida se visualiza siempre en el mismo lugar del tablero

	const property position = utilidadesParaJuego.posicionArbitraria()
	var property image = "imgs/portal.png"
	const property sonido = "audio/salir.mp3"

	method esOro() = false

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

	method esInteractivo() = false

	method contieneElemento(unElemento) = unElemento.position().x().between(self.position().x(), self.position().x() + 3) && unElemento.position().y().between(self.position().y(), self.position().y() + 3)

}

object salida { // la salida se visualiza siempre en el mismo lugar del tablero

	const property position = utilidadesParaJuego.posicionArbitraria()
	var property image = "imgs/portal.png"
	const property sonido = "audio/salir.mp3"

	method esOro() = false

	method esRecolectable() = false

	method reaccionarA(unPersonaje) {
	} // no hace nada para respetar el polimorfismo

}

