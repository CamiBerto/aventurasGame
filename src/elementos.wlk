import wollok.game.*
import utilidades.*
import nivel_bloques.*
import nivel_llaves.*

class Bloque { // Cajas

	var property position = utilidadesParaJuego.posicionArbitraria()
	var property image = "caja.png"

	// agregar comportamiento
	method estaEnDeposito() = deposito.contiene(self.position())

	method sePuedeEmpujarA(posicion) = utilidadesParaJuego.sePuedeMover(posicion) and not nivelBloques.hayBloque(posicion)

	method empujar(posicion) {
		if (self.sePuedeEmpujarA(posicion)) {
			self.position(posicion)
		}
	}

}

// TODO: resolver posición aleatoria
object deposito { // esta determinado por la zona de baldozas color naranja

	method contiene(posicion) = posicion.x().between(5, 9) and posicion.y().between(7, 12)

}

// TODO: salida automática
object salida { // la salida se visualiza siempre en el mismo lugar del tablero

	const property position = game.at(game.width() - 1, 0)
	var property image = "salida.png"
	const property sonido = "salir.mp3"

	method reaccionarA(unPersonaje) {
	} // no hace nada para respetar el polimorfismo

}

class Elemento {

	var property position = game.at(0, 0)
	const property sonido = "coin.mp3"

	method dejarPasar(unPersonaje) {
		unPersonaje.position(self.position())
	}

	method esCeldaSorpresa() {
		return false
	}

	method reaccionarA(unPersonaje) {
		self.dejarPasar(unPersonaje)
	}

}

// TODO: resolver agarrar
class Llave inherits Elemento {

	var property image = "llave.png"

	override method sonido() = "salir.mp3"

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		unPersonaje.guardarLlave()
	}

}

class Pollo inherits Elemento {

	var property energia = 30
	var property image = "pollo.png"

	override method sonido() = "comer.mp3"

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		unPersonaje.comerPollo(self)
	}

}

class Modificador inherits Elemento {

	var property image = "coin.png"

	method efecto() {
		return ({ unPollo , energiaActual => unPollo.energia() })
	}

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		unPersonaje.incorporaEfecto(self)
	}

}

class Duplicador inherits Modificador {

	override method efecto() {
		return ({ unPollo , energiaActual => unPollo.energia() * 2 })
	}

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		game.say(self, "Duplicador")
	}

}

class Reforzador inherits Modificador {

	method energiaExtra(energiaActual) = if (energiaActual < 10) 20 else 0

	override method efecto() {
		return ({ unPollo , energiaActual => unPollo.energia() * 2 + self.energiaExtra(energiaActual) })
	}

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		game.say(self, "reforzador")
	}

}

class TripleOrNada inherits Modificador {

	method multiplicador(energia) = if (energia.even()) 0 else 3

	override method efecto() {
		return ({ unPollo , energiaActual => unPollo.energia() * self.multiplicador(energiaActual) })
	}

	override method reaccionarA(unPersonaje) {
		super(unPersonaje)
		game.say(self, "triple Birra o nada")
	}

}

class CeldaSorpresa inherits Elemento {

	var property fueActivada = false
	var property image = "beer premio.png"

	method cambiarDeIMagen() {
		image = "sorpresaUsada.png"
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

