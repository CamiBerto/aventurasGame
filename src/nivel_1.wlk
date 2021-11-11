import wollok.game.*
import fondo.*
import elementos.*
import utilidades.*
import indicadores.*
import nivel.*
import personajes.*

object nivel1 inherits Nivel {

	var property personaje = new PersonajeNivel1(nivelActual = self)
	const property cajasEnTablero = #{}

	override method faltanRequisitos() {
		if (self.todasLasCajasEnDeposito()) self.pasarDeNivel() else game.say(personaje, "Faltan cajas en el depósito")
	}

	method hayCaja(posicion) = self.cajasEnTablero().any({ b => b.position() == posicion })

	method todasLasCajasEnDeposito() = self.cajasEnTablero().all{ b => b.estaEnDeposito() }

	method EfectoAgregarEnergia() {
		personaje.ganarEnergia(30)
	}

	method Teletransportar() {
		personaje.position(utilidadesParaJuego.posicionArbitraria())
	}

	method EfectoPerderEnergia() {
		personaje.perderEnergia(15)
	}

	method AgregarPollo() {
		self.ponerElementos(1, pollo)
	}

	// Este método es exclusivo del nivel 1
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

	override method configurate() {
		super()
			// otros visuals
			// la alfombra : TODO: resolver que los otros objetos no colapsen
		game.addVisual(deposito)
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
			if (self.todasLasCajasEnDeposito() and personaje.position() == salida.position()) self.pasarDeNivel() else self.faltanRequisitos()
		})
	}

	method pasarDeNivel() {
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "imgs/fondo Completo.png"))
			// después de un ratito ...
		game.schedule(1000, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "imgs/finNivel1.png"))
				// después de un ratito ...
			game.schedule(1500, { // ... limpio todo de nuevo
			game.clear() // y arranco el siguiente nivel
			// nivelLlaves.configurate()
			})
		})
	}

}

