import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel_llaves.*
import utilidades.*
import indicadores.*

// TODO crear class Nivel para heredar código que se repite
object nivelBloques {

	// Indicadores 
	const property personaje = new PersonajeNivelBloques()
	var property vidaVisual = new VidaVisual(personaje = personaje)
	var property energiaVisual = new EnergiaVisual(personaje = personaje)
	var property oroVisual = new OroVisual(personaje = personaje)
	var property llavesVisual = portalLlaveVisual
	const property bloquesEnTablero = #{}
	var property cajas = []
	var property llaves = []
	var property cajasEnDeposito = []

	method todosLosBloquesEnDeposito() = self.bloquesEnTablero().all({ b => b.estaEnDeposito() })

	method faltanRequisitos() {
		if (self.todosLosBloquesEnDeposito()) game.say(personaje, "Debo ir a la salida") else game.say(personaje, "Faltan bloques en el deposito")
	}

	method hayBloque(posicion) = self.bloquesEnTablero().any({ b => b.position() == posicion })

	method ponerBloques(cantidad) { // debe recibir cantidad y EL NOMBRE DE UN ELEMENTO
		if (cantidad > 0) {
			const unaPosicion = utilidadesParaJuego.posicionArbitraria()
			if (not self.hayBloque(unaPosicion)) { // si la posicion no eta ocupada
				const unBloque = new Bloque(position = unaPosicion) // instancia el bloque en una posicion
				bloquesEnTablero.add(unBloque) // Agrega el bloque a la lista
				game.addVisual(unBloque) // Agrega el bloque al tablero
				self.ponerBloques(cantidad - 1) // llamada recursiva al proximo bloque a agregar
			} else {
				self.ponerBloques(cantidad)
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
			agregarALista.add(new Bloque())
			game.addVisual(agregarALista.last())
			self.crearCantCajasYAgregar(agregarALista, cantidad)
		}
	}

	method abrirPortalSiTiene(num) {
		// si se cumple la cantidad de llaves seteadas por game aparece portal y resetea las llaves
		if (personaje.llavesAgarradas().size() >= num) {
			portalLlaveVisual.aparecerPortal()
			personaje.llavesAgarradas().clear()
		}
	}

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo())
			// Se agrega la salida al tablero
		game.addVisual(salida)
			// otros visuals, p.ej. bloques o llaves
		self.ponerBloques(5)
			// Se asigna el personaje actual al portalLlaveVisual
		portalLlaveVisual.personaje(personaje)
			// Se agregan las visuales de estado de Cantidad de Oro, Vida, Llaves, Energía
		oroVisual.iniciarGrafico("IndOro.png", "IndOroCom.png")
		vidaVisual.iniciarGrafico("vi.png", "da.png")
		portalLlaveVisual.iniciarGrafico("", "")
		energiaVisual.iniciarGrafico("ene.png", "rgia.png")
			// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personaje)
			// teclado
			/*Movimientos del personaje*/
		keyboard.right().onPressDo{ personaje.moverDerecha()}
		keyboard.left().onPressDo{ personaje.moverIzquierda()}
		keyboard.up().onPressDo{ personaje.moverArriba()}
		keyboard.down().onPressDo{ personaje.moverAbajo()}
		keyboard.n().onPressDo({ // al presionar "n" finaliza el juego o da indicaciones
			if (self.todosLosBloquesEnDeposito() and personaje.position() == salida.position()) self.terminar() else self.faltanRequisitos()
		})
	}

	method terminarSiCantCajas(num) {
		if (self.cajasEnDeposito().size() >= num) {
			self.terminar()
		}
	}

	method terminar() {
		// sonido pasar
		// game.sound("pasar.mp3").play()
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		game.addVisual(personaje)
			// después de un ratito ...
		game.schedule(1000, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "finNivel1.png"))
				// después de un ratito ...
			game.schedule(1500, { // ... limpio todo de nuevo
				game.clear()
					// y arranco el siguiente nivel
				nivelLlaves.configurate()
			})
		})
	}

}

