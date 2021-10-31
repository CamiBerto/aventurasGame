import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel2.*

object nivelBloques {

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
			// otros visuals, p.ej. bloques o llaves
		game.addVisual(new Bloque(position = game.at(3, 12)))
			// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personajeSimple)
		game.addVisual(vida.decimal())
		game.addVisual(vida.unidad())
		game.addVisual(granada.decimal())
		game.addVisual(granada.unidad())
		game.addVisual(energia.decimal())
		game.addVisual(energia.unidad())
		game.addVisual(new Bloque(position = game.at(0, game.height() - 1), image = "vi.png"))
		game.addVisual(new Bloque(position = game.at(1, game.height() - 1), image = "da.png"))
		game.addVisual(new Bloque(position = game.at(2, game.height() - 1), image = "gran.png"))
		game.addVisual(new Bloque(position = game.at(3, game.height() - 1), image = "adas.png"))
		game.addVisual(new Bloque(position = game.at(4, game.height() - 1), image = "ene.png"))
		game.addVisual(new Bloque(position = game.at(5, game.height() - 1), image = "rgia.png"))
			// teclado
			// este es para probar, no es necesario dejarlo
		keyboard.t().onPressDo({ self.terminar()})
	// en este no hacen falta colisiones
	}

	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		game.addVisual(personajeSimple)
			// después de un ratito ...
		game.schedule(2500, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "finNivel1.png"))
				// después de un ratito ...
			game.schedule(3000, { // ... limpio todo de nuevo
				game.clear()
					// y arranco el siguiente nivel
				nivelLlaves.configurate()
			})
		})
	}

}

