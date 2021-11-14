import wollok.game.*
import fondo.*
import elementos.*
import utilidades.*
import indicadores.*
import nivel.*
import personajes.*
import config.*

object nivelBonus inherits Nivel {

	var property cofreCreado = cofre
	var property personaje = new PersonajeNivel2(nivelActual = self)

	override method faltanRequisitos() = game.allVisuals().any{ c => c.image() == "imgs/moneda.png" }

	method estadoActual() {
		return if (self.faltanRequisitos()) {
			"Aún faltan matar bichos."
		} else {
			"Abrir el cofre"
		}
	}

	method aparecerCofreSi() {
		if (not self.faltanRequisitos()) {
			game.addVisual(cofreCreado)
		}
	}

	method efectoPerderVida() {
		personaje.perderEnergia(15)
	}

	method efectoAgregarVida() {
		personaje.ganarEnergia(30)
	}

	override method configurate() {
		super()
			// otros visuals
		self.ponerElementos(3, pollo)
		self.ponerElementos(3, pota)
		self.ponerElementos(5, oro)
		self.ponerElementos(1, sorpresaA)
		self.ponerElementos(1, sorpresaB)
		self.ponerElementos(1, sorpresaC)
		self.ponerElementos(1, sorpresaD)
			// Se agregan las visuales de estado de Cantidad de Flechas, Vida, Energía
		flechaVisual.iniciarGrafico(personaje.flechas(), "imgs/fle.png", "imgs/chas.png")
		vidaVisual.iniciarGrafico(personaje.vida(), "imgs/vi.png", "imgs/da.png")
		energiaVisual.iniciarGrafico(personaje.energia(), "imgs/ene.png", "imgs/rgia.png")
			// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personaje)
			// teclado
			/*Movimientos del personaje*/
		keyboard.right().onPressDo{ personaje.moverDerecha()}
		keyboard.left().onPressDo{ personaje.moverIzquierda()}
		keyboard.up().onPressDo{ personaje.moverArriba()}
		keyboard.down().onPressDo{ personaje.moverAbajo()}
		keyboard.q().onPressDo{ personaje.agarrarElemento()}
			// al presionar "n"  da indicaciones
		keyboard.n().onPressDo{ game.say(personaje, self.estadoActual())}
			// colicion con oro
		game.onCollideDo(personaje, { objeto => self.hayBichos(objeto)})
		game.onCollideDo(personaje, { objeto =>
			if (objeto == cofreCreado) {
				self.pasarDeNivel()
			}
		})
	}

	method hayBichos(objeto) {
		if (objeto.esBicho()) {
			personaje.serAtacadoPorBicho()
		}
	}

	override method imagenIntermedia() {
		return "imgs/fondo ganaste.png"
	}

	override method siguienteNivel() {
	}

}

