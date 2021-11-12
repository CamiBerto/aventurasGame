import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import utilidades.*
import indicadores.*

class Nivel {

	// Elementos del nivel	
	var property llaves = []
	var property elementosEnNivel = []

	method faltanRequisitos()

	// Los elementos del nivel
	method elementoDe(posicion) = elementosEnNivel.find({ e => e.position() == posicion })

	method hayElementoEn(posicion) = elementosEnNivel.any({ e => e.position() == posicion and e.esInteractivo() })

	/* Metodos que tambien interactuan con los movimientos del personaje */
	method ponerSalida() {
		game.addVisual(salida)
	} // Se agrega la salida al tablero

// EL NOMBRE DEL ELEMENTO ES UN OBJETO QUE GENERA UNA NUEVA INSTANCIA CON EL METODO instanciar()
	method ponerElementos(cantidad, elemento) { // debe recibir cantidad y EL NOMBRE DE UN ELEMENTO
		if (cantidad > 0) {
			const unaPosicion = utilidadesParaJuego.posicionArbitraria()
			if (not self.hayElementoEn(unaPosicion)) { // si la posicion no está ocupada
				const unaInstancia = elemento.instanciar(unaPosicion) // instancia el elemento en una posicion
				elementosEnNivel.add(unaInstancia) // Agrega el elemento a la lista
				game.addVisual(unaInstancia) // Agrega el elemento al tablero
				self.ponerElementos(cantidad - 1, elemento) // llamada recursiva al proximo elemento a agregar
			} else {
				self.ponerElementos(cantidad, elemento)
			}
		}
	}

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo())
	}

	method perder() {
		// sonido perder
		// game.sound("audio/perder.mp3").play()
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "imgs/fondo Completo.png"))
			// después de un ratito ...
		game.schedule(1000, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "imgs/perdimos.png"))
				// después de un ratito ...
			game.schedule(3000, { // fin del juego
			game.stop()})
		})
	}

	method terminar() {
		// sonido pasar
		game.sound("audio/pasar.mp3").play()
			// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
	}

}

