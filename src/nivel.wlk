import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import utilidades.*
import indicadores.*
import nivel_1.*

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

object pantallaInicio {
	const fondoEmpezar = new Fondo(image = "imgs/fondo empezar.png")
	method configurate(){
		game.addVisual(dificultad.fondoNormal())
		keyboard.x().onPressDo({game.addVisual(fondoEmpezar)
								game.schedule(2000, {nivel1.configurate()})
							  })
		keyboard.num1().onPressDo({dificultad.facil()})
		keyboard.num2().onPressDo({dificultad.normal()})
		keyboard.num3().onPressDo({dificultad.dificil()})
	}
}

object dificultad{
	const fondoFacil = new Fondo(image = "imgs/fondo facil.png")
	const property fondoNormal = new Fondo(image = "imgs/fondo normal.png")
	const fondoDificil = new Fondo(image = "imgs/fondo dificil.png")
	var property cajas = 5
	var property enemigos = 4
	method facil(){
		cajas = 3
		enemigos = 2
		return if(game.hasVisual(fondoNormal)) {
			game.removeVisual(fondoNormal)
			game.addVisual(fondoFacil)
		}else{
			game.removeVisual(fondoDificil)
			game.addVisual(fondoFacil)
		}	
	}
	method normal(){
		cajas = 5
		enemigos = 4
		return if(game.hasVisual(fondoFacil)) {
			game.removeVisual(fondoFacil)
			game.addVisual(fondoNormal)
		}else{
			game.removeVisual(fondoDificil)
			game.addVisual(fondoNormal)
		}	
	}
	method dificil(){
		cajas = 8
		enemigos = 7
		return if(game.hasVisual(fondoFacil)) {
			game.removeVisual(fondoFacil)
			game.addVisual(fondoDificil)
		}else{
			game.removeVisual(fondoNormal)
			game.addVisual(fondoDificil)
		}	
	}
}

