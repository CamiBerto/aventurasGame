import wollok.game.*
import fondo.*
import personaje.*
import elementos.*
import utilidades.*
import indicadores.*
import nivel_1.*
import config.*

class Nivel {

	// Elementos del nivel	
	var property elementosEnNivel = [] // Lista de elementos recolectables interactivos, excepto enemigos
	var property enemigosEnTablero = [] // Lista de enemigos interactivos
	// Abstractos

	method personaje()

	method faltanRequisitos()

	method imagenIntermedia()

	method siguienteNivel()

	// Indica si hay elementos interactivo en la posición
	method hayElementoEn(posicion) = elementosEnNivel.any({ e => e.position() == posicion and e.esInteractivo() })

	/* Metodos que tambien interactuan con los movimientos del personaje */
	method ponerSalida() {
		game.addVisual(salida)
	} // Se agrega la salida al tablero

	method teletransportar() { // Reacción a la CeldaSorpresaA
		const unaPosicion = utilidadesParaJuego.posicionArbitraria()
		if (not self.hayElementoEn(unaPosicion)) {
			self.personaje().position(unaPosicion)
		} else {
			self.teletransportar()
		}
	}

	method agregarPollo() { // Reacción a la CeldaSorpresaD
		self.ponerElementos(1, pollo)
	}

// EL NOMBRE DEL ELEMENTO ES UN OBJETO QUE GENERA UNA NUEVA INSTANCIA CON EL METODO instanciar()
	method ponerElementos(cantidad, elemento) { // debe recibir cantidad y EL NOMBRE DE UN ELEMENTO
		if (cantidad > 0) {
			const unaPosicion = utilidadesParaJuego.posicionArbitraria()
			if (not self.hayElementoEn(unaPosicion)) { // si la posicion no está ocupada
				const unaInstancia = elemento.instanciar(unaPosicion) // instancia el elemento en una posicion
				elementosEnNivel.add(unaInstancia) // Agrega el elemento a la lista
				game.addVisual(unaInstancia) // Agrega el elemento al tablero
				self.ponerElementos(cantidad - 1, elemento) // llamada recursiva al proximo elemento a agregar
			} else { // Si había elementos, hace llamada recursiva
				self.ponerElementos(cantidad, elemento)
			}
		}
	}

	method configurate() {
		// Reinicio el estado del personaje
		self.personaje().reestablecer()
			// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo()) // Inicio de nivel
		keyboard.z().onPressDo{ self.pasarDeNivel()} // Tecla secreta para pasar de nivel
		keyboard.x().onPressDo({
		}) // ??
			// El sonido para que esté accesible desde todos los niveles
		keyboard.plusKey().onPressDo({ rain.volume(1)})
		keyboard.m().onPressDo({ rain.volume(0)})
		keyboard.minusKey().onPressDo({ rain.volume(0.5)})
		keyboard.p().onPressDo({ rain.pause()})
		keyboard.r().onPressDo({ rain.resume()})
		keyboard.s().onPressDo({ rain.stop()})
	}

	method perder() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "imgs/fondo Completo.png"))
			// después de un ratito ...
		game.schedule(1000, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "imgs/perdimos.png"))
				// después de un ratito ...
			game.schedule(4000, { // reinicia el juego
			pantallaInicio.configurate()})
		})
	}

	method terminar() {
		// sonido al ganar el juego
		game.sound("audio/ganarNivel3.mp3").play()
			// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// Fondo final
		game.addVisual(new Fondo(image = "imgs/fondo ganaste.png"))
			// después de un ratito ...
		game.schedule(4000, { // Volver al inicio 
		pantallaInicio.configurate()})
	}

	method pasarDeNivel() {
		// Generar el sonido para pasar de nivel
		const pasarNivel = game.sound("audio/pasarNivel.mp3")
		pasarNivel.play()
			// Fondo base del juego vacío
		game.addVisual(new Fondo(image = "imgs/fondo Completo.png"))
			// después de un ratito ...
		game.schedule(1000, { game.clear()
				// cambio de fondo. La imagenIntermedia cambia en cada nivel
			game.addVisual(new Fondo(image = self.imagenIntermedia()))
				// después de un ratito ...
			game.schedule(4000, { // ... limpio todo de nuevo
				game.clear() // y arranco el siguiente nivel
					// Se configura el próximo nivel
				self.siguienteNivel().configurate()
			})
		})
	}

}

