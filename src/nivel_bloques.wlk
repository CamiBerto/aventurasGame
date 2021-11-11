import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel_llaves.*
import utilidades.*
import indicadores.*
import nivel.*

// TODO crear class Nivel para heredar código que se repite
object nivelBloques inherits Nivel {

	const property personaje = new PersonajeNivelBloques(nivelActual = self)

	override method faltanRequisitos() {
		if (self.todasLasCajasEnDeposito()) self.ganar() else game.say(personaje, "Faltan cajas en el depósito")
	}

	method abrirPortalSiTieneSuficientesLlaves() {
		// const llavesEnNivel = elementosEnNivel.filter{c => c.image() == "llave.png"}
		// si se cumple la cantidad de llaves aparece portal y resetea las llaves
		if (personaje.llavesAgarradas() >= 3) {
			llavesVisual.aparecerPortal()
			personaje.llavesAgarradas(0)
		}
	}

	override method configurate() {
		super()
			// otros visuals
		self.ponerCajas(5)
		self.ponerElementos(3, llave)
		self.ponerElementos(3, pollo)
		self.ponerElementos(1, reforzador)
		self.ponerElementos(1, sorpresaA)
		self.ponerElementos(2, sorpresaB)
		self.ponerElementos(1, sorpresaC)
		self.ponerElementos(1, sorpresaD)
			// Se agregan las visuales de estado de Cantidad de Oro, Vida, Llaves, Energía
		oroVisual.iniciarGrafico(personaje.oro(), "imgs/IndOro.png", "imgs/IndOroCom.png")
		vidaVisual.iniciarGrafico(personaje.vida(), "imgs/vi.png", "imgs/da.png")
		energiaVisual.iniciarGrafico(personaje.energia(), "imgs/ene.png", "imgs/rgia.png")
		llavesVisual.iniciarGrafico(personaje.llavesAgarradas(), "", "")
			// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personaje)
			// teclado
			/*Movimientos del personaje*/
		keyboard.right().onPressDo{ personaje.moverDerecha()}
		keyboard.left().onPressDo{ personaje.moverIzquierda()}
		keyboard.up().onPressDo{ personaje.moverArriba()}
		keyboard.down().onPressDo{ personaje.moverAbajo()}
		keyboard.q().onPressDo{ personaje.agarrarElemento()}
		keyboard.n().onPressDo({ // al presionar "n" finaliza el juego o da indicaciones
			if (self.todasLasCajasEnDeposito() and personaje.position() == salida.position()) self.terminar() else self.faltanRequisitos()
		})
	}

	method estado() {
		game.say(personaje, personaje.nivelDeEnergia())
	} // indica el estado de energia

	method celdasSopresa() {
		return elementosEnNivel.filter({ e => e.esCeldaSorpresa() })
	}

	method entroEnZona(posicionPersonaje, posicionCelda) {
		return (posicionCelda.x().between(posicionPersonaje.x(), posicionPersonaje.x()) and posicionCelda.y().between(posicionPersonaje.y() - 1, posicionPersonaje.y() + 1) or posicionCelda.x().between(posicionPersonaje.x() - 1, posicionPersonaje.x() + 1) and posicionCelda.y().between(posicionPersonaje.y(), posicionPersonaje.y()))
	}

	method celdaSorpresaPisada() {
		const celdas = self.celdasSopresa().filter({ e => self.entroEnZona(personaje.position(), e.position()) and not e.fueActivada() })
		if (celdas.size() > 0) {
			celdas.forEach{ celda => celda.activarSorpresa()}
		}
	}

	method AgregarPollo() {
		self.ponerElementos(1, pollo)
	}

	method EfectoPerderEnergia() {
		personaje.perderEnergia(15)
	}

	method EfectoAgregarEnergia() {
		personaje.ganarEnergia(30)
	}

	method Teletransportar() {
		personaje.position(utilidadesParaJuego.posicionArbitraria())
	}

	method ganar() {
		// sonido ganar
		// game.sound("audio/ganar.mp3").play()
		// es muy parecido al terminar() de nivelBloques
		// el perder() también va a ser parecido
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "imgs/fondoCompleto.png"))
			// después de un ratito ...
		game.schedule(1000, { 
			game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "imgs/ganamos.png"))
				// después de un ratito ...
			game.schedule(1500, { // fin del juego
			game.stop()})
		})
	}

	method perder() {
		// sonido perder
		// game.sound("audio/perder.mp3").play()
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "imgs/fondoCompleto.png"))
			// después de un ratito ...
		game.schedule(1000, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "imgs/perdimos.png"))
				// después de un ratito ...
			game.schedule(3000, { // fin del juego
			game.stop()})
		})
	}

	override method terminar() {
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "imgs/fondoCompleto.png"))
			// después de un ratito ...
		game.schedule(1000, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "imgs/finNivel1.png"))
				// después de un ratito ...
			game.schedule(1500, { // ... limpio todo de nuevo
				game.clear()
					// y arranco el siguiente nivel
				nivelLlaves.configurate()
			})
		})
	}

}

