import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel_llaves.*
import utilidades.*
import indicadores.*

// TODO crear class Nivel para heredar código que se repite
object nivelBloques {

	const property personaje = new PersonajeNivelBloques()
	// Elementos del juego
	const property cajasEnTablero = #{}
	var property cajas = []
	var property llaves = []
	var property cajasEnDeposito = []

	method todasLasCajasEnDeposito() = self.cajasEnTablero().all({ b => b.estaEnDeposito() })

	method faltanRequisitos() {
		if (self.todasLasCajasEnDeposito()) game.say(personaje, "Debo ir a la salida") else game.say(personaje, "Faltan cajas en el depósito")
	}

	method hayCaja(posicion) = self.cajasEnTablero().any({ b => b.position() == posicion })

	method ponerCajas(cantidad) { // debe recibir cantidad
		if (cantidad > 0) {
			const unaPosicion = utilidadesParaJuego.posicionArbitraria()
			if (not self.hayCaja(unaPosicion)) { // si la posicion no esta ocupada
				const unaCaja = new Caja(position = unaPosicion, nivelActual = self) // instancia el bloque en una posicion
				cajasEnTablero.add(unaCaja) // Agrega el bloque a la lista
				game.addVisual(unaCaja) // Agrega el bloque al tablero
				self.ponerCajas(cantidad - 1) // llamada recursiva al proximo bloque a agregar
			} else {
				self.ponerCajas(cantidad)
			}
		}
	}

	method crearCantLlavesYAgregar(agregarALista, cantidad) {
		// es bucle que sigue hasta que la cantidad es menor que el incCont
		if (llaves.size() < cantidad) {
			agregarALista.add(new Llave())
			game.addVisual(agregarALista.last())
			self.crearCantLlavesYAgregar(agregarALista, cantidad)
		}
	}

	method crearCantCajasYAgregar(agregarALista, cantidad) {
		// es bucle que sigue hasta que la cantidad es menor que el incCont
		if (cajas.size() < cantidad) {
			agregarALista.add(new Caja(nivelActual = self))
			game.addVisual(agregarALista.last())
			self.crearCantCajasYAgregar(agregarALista, cantidad)
		}
	}

	method abrirPortalSiTieneSuficientesLlaves(numeroSuficiente) {
		// si se cumple la cantidad de llaves aparece portal y resetea las llaves
		if (personaje.llavesAgarradas() >= numeroSuficiente) {
			llavesVisual.aparecerPortal()
			personaje.llavesAgarradas(0)
		}
	}

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo())
			// Se agrega la salida al tablero
		game.addVisual(salida)
			// otros visuals, p.ej. bloques o llaves
		self.ponerCajas(5)
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
		keyboard.n().onPressDo({ // al presionar "n" finaliza el juego o da indicaciones
			if (self.todasLasCajasEnDeposito() and personaje.position() == salida.position()) self.terminar() else self.faltanRequisitos()
		})
	}

	method terminar() {
		// sonido pasar
		// game.sound("audio/pasar.mp3").play()
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "imgs/fondoCompleto.png"))
		game.addVisual(personaje)
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

