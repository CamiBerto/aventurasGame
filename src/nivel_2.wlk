import config.*
import wollok.game.*
import elementos.*
import utilidades.*
import indicadores.*
import nivel.*
import nivel_3.*
import personaje_nivel2.*

object nivel2 inherits Nivel {

	var property portalCreado = salida
	var property personaje = new PersonajeNivel2(nivelActual = self)

	override method faltanRequisitos() = game.allVisuals().any{ c => self.listBolsasOro().contains(c) }

	method estadoActual() {
		return if (self.faltanRequisitos()) {
			"Aún faltan recolectar ORO."
		} else {
			"ir a la salida"
		}
	}

	method listBolsasOro() {
		return elementosEnNivel.filter{ c => c.esOro() }
	}
	// Si agarró todos los oros del tablero, aparece el portal
	method aparecerPortalSi() {
		if (not self.faltanRequisitos() and not game.hasVisual(portalCreado)) {
			game.addVisual(portalCreado)
		}
	}

	override method configurate() {
		super()
			// otros visuals
			// la alfombra
		self.ponerElementos(3, pollo)
		self.ponerElementos(3, pota)
		self.ponerElementos(5, oro)
		self.ponerElementos(1, sorpresaA)
		self.ponerElementos(1, sorpresaB)
		self.ponerElementos(1, sorpresaC)
		self.ponerElementos(1, sorpresaD)
		// Se agregan las visuales de estado de Cantidad de Oro, Vida, Energía
		oroVisual.iniciarGrafico(personaje.oroJuntado(), "imgs/IndOro.png", "imgs/IndOroCom.png")
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
		game.onCollideDo(personaje, { objeto => self.efectoAlColisionarCon(objeto)})
		// Si colapsa con el portal, pasa de nivel
		game.onCollideDo(personaje, { objeto =>
			if (objeto == portalCreado) {
				self.pasarDeNivel()
			}
		})
	}

	method efectoAlColisionarCon(objeto) {
		if (objeto.esOro()) {
			objeto.reaccionarA(personaje)
			self.aparecerPortalSi()
		}
	}

	override method imagenIntermedia() {
		return "imgs/fondoFinNivel2.png"
	}

	override method siguienteNivel() = nivelBonus

}

