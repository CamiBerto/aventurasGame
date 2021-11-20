import wollok.game.*
import fondo.*
import elementos.*
import utilidades.*
import indicadores.*
import nivel.*
import personaje_nivel1.*
import config.*
import nivel_2.*

object nivel1 inherits Nivel {

	// Personaje nivel 1
	var property personaje = new PersonajeNivel1(nivelActual = self)
	// cajasEnTablero se utiliza al  momento de usar ponerCajas()
	const property cajasEnTablero = #{}

	override method faltanRequisitos() = not (self.todasLasCajasEnDeposito() && personaje.llavesAgarradas() == 3)

	// hayCaja lo utiliza ponerCajas como condición para agregar una en la posición
	method hayCaja(posicion) = self.cajasEnTablero().any({ b => b.position() == posicion })

	method todasLasCajasEnDeposito() = not self.cajasEnTablero().any{ b => !b.estaEnDeposito()}

	// Se activa con la tecla "n"
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

	// Este método es exclusivo del nivel 1
	method ponerCajas(cantidad) { // debe recibir cantidad
		const unaPosicion = utilidadesParaJuego.posicionArbitraria()
		if (cantidad > 0) {
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
		game.addVisual(deposito)
			// La cantidad de cajas depende de la dificultad seleccionada
		self.ponerCajas(dificultad.cajas())
		self.ponerElementos(3, llave)
		self.ponerElementos(3, pollo)
		self.ponerElementos(1, sorpresaA)
		self.ponerElementos(1, sorpresaB)
		self.ponerElementos(1, sorpresaC)
		self.ponerElementos(1, sorpresaD)
			// Se agregan las visuales de estado de Cantidad de Oro, Vida, Llaves, Energía
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
			if (not self.faltanRequisitos()) {
				game.say(personaje, "¡¡¡Ganamos!!!")
				game.schedule(1500, { self.pasarDeNivel()})
			} else {
				game.say(personaje, self.estadoActual())
			}
		})
	}

	// Se utiliza en pasarDeNivel()
	override method imagenIntermedia() {
		return "imgs/fondoFinNivel1.png"
	}

	// Se utiliza en pasarDeNivel()
	override method siguienteNivel() = nivel2

}

