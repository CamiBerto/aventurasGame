import wollok.game.*
import fondo.*
import elementos.*
import utilidades.*
import indicadores.*
import nivel.*
import personajes.*
import config.*
import nivel_1.*

object nivel2 inherits Nivel {
	
	var property personaje = new PersonajeNivel2(nivelActual = self)
	const property cajasEnTablero = #{}
	override method faltanRequisitos() = not (self.todasLasCajasEnDeposito() && personaje.llavesAgarradas() == 3)
	
	
	method estadoActual() {
		var palabras = ""
		if (not self.todasLasCajasEnDeposito()) {
			palabras = palabras + "Aún faltan cajas en el depósito."
		}
		if (personaje.llavesAgarradas() < 3) {
			palabras = palabras + "No encontré todas las llaves."
		}
		return palabras
	}

	method efectoPerderVida() {
		personaje.perderEnergia(15)
	}
	method efectoAgregarVida() {
		personaje.ganarEnergia(30)
	}
	
	method agregarPollo() {
		self.ponerElementos(1, pollo)
	}
	
	override method configurate() {
		super()
			// otros visuals
			// la alfombra : TODO: resolver que los otros objetos no colapsen
		self.ponerElementos(3, pollo)
		self.ponerElementos(3, pota)
		self.ponerElementos(5, oro)
		self.ponerElementos(1, sorpresaA)
		self.ponerElementos(1, sorpresaB)
		self.ponerElementos(1, sorpresaC)
		self.ponerElementos(1, sorpresaD)
			// Se agregan las visuales de estado de Cantidad de Oro, Vida, Llaves, Energía
		oroVisual.iniciarGrafico(personaje.oro(), "imgs/IndOro.png", "imgs/IndOroCom.png")
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
		keyboard.n().onPressDo({ // al presionar "n" finaliza el juego o da indicaciones
			if (not self.faltanRequisitos()) {
				game.say(personaje, "Ganamos!!!")
				game.schedule(1500, { self.pasarDeNivel()})
			} else {
				game.say(personaje, self.estadoActual())
			}
		})
	}
	
}
