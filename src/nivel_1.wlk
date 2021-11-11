import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel_llaves.*
import utilidades.*
import indicadores.*
import nivel.*

object nivel1 inherits Nivel {
	var personaje = ""
	override method configurate() {
		personaje = new Personaje(nivelActual = self)
		super()
			// otros visuals
		self.ponerCajas(5)
		self.ponerElementos(3, llave)
		self.ponerElementos(3, pollo)
		self.ponerElementos(1, sorpresaA)

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
			if (self.todasLasCajasEnDeposito() and personaje.position() == salida.position()) self.pasarANivel2() else self.faltanRequisitos()
		})
	}

	override method faltanRequisitos() {
		if (self.todasLasCajasEnDeposito()) self.pasarANivel2() else game.say(personaje, "Faltan cajas en el depósito")
	}
	method ponerCajas(cantidad) { // debe recibir cantidad
		if (cantidad > 0) {
			const unaPosicion = utilidadesParaJuego.posicionArbitraria()
			if (not self.hayElementoEn(unaPosicion)) { // si la posicion no esta ocupada
				const unaCaja = new Caja(position = unaPosicion, nivelActual = self) // instancia el bloque en una posicion
				cajasEnTablero.add(unaCaja) // Agrega el bloque a la lista
				game.addVisual(unaCaja) // Agrega el bloque al tablero
				self.ponerCajas(cantidad - 1) // llamada recursiva al proximo bloque a agregar
			} else {
				self.ponerCajas(cantidad)
			}
		}
	}
	method pasarANivel2() {
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "imgs/fondoCompleto.png"))
			// después de un ratito ...
		game.schedule(1000, { 
			game.clear()
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
