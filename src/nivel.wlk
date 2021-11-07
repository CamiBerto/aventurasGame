import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel_llaves.*
import utilidades.*
import indicadores.*

class Nivel {

	// Elementos del nivel	
	const property cajasEnTablero = #{}
	var property cajas = []
	var property llaves = []
	var property cajasEnDeposito = []
	const elementosEnNivel = []

	method todasLasCajasEnDeposito() = self.cajasEnTablero().all({ b => b.estaEnDeposito() })

	method faltanRequisitos()

	method hayCaja(posicion) = self.cajasEnTablero().any({ b => b.position() == posicion })

// Los elementos del nivel
	method elementoDe(posicion) = elementosEnNivel.find({ e => e.position() == posicion })

	method hayElementoEn(posicion) = elementosEnNivel.any({ e => e.position() == posicion })

	/* Metodos que tambien interactuan con los movimientos del personaje */
	method ponerSalida() {
		game.addVisual(salida)
	} // Se agrega la salida al tablero

// EL NOMBRE DEL ELEMENTO ES UN OBJETO QUE GENERA UNA NUEVA INSTANCIA CON EL METODO instanciar()
	method ponerElementos(cantidad, elemento) { // debe recibir cantidad y EL NOMBRE DE UN ELEMENTO
		if (cantidad > 0) {
			const unaPosicion = utilidadesParaJuego.posicionArbitraria()
			if (not self.hayElementoEn(unaPosicion)) { // si la posicion no eta ocupada
				const unaInstancia = elemento.instanciar(unaPosicion) // instancia el elemento en una posicion
				elementosEnNivel.add(unaInstancia) // Agrega el elemento a la lista
				game.addVisual(unaInstancia) // Agrega el elemento al tablero
				self.ponerElementos(cantidad - 1, elemento) // llamada recursiva al proximo elemento a agregar
			} else {
				self.ponerElementos(cantidad, elemento)
			}
		}
	}

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

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo())
			// Se agrega la salida al tablero
		game.addVisual(salida)
	}

	method terminar() {
		// sonido pasar
		game.sound("audio/pasar.mp3").play()
			// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
	}

}

