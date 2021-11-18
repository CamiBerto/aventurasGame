import fondo.*
import wollok.game.*
import nivel_1.*
import nivel_2.*
import nivel_3.*

object pantallaInicio {

// La pantalla de configuración inicial
	const fondoEmpezar = new Fondo(image = "imgs/fondo empezar.png")
	var property nivelNoIniciado = true

	method configurate() {
		nivel1.reiniciarVariables()
			// Aranca con la dificultad normal
		game.addVisual(dificultad.fondoNormal())
		keyboard.x().onPressDo({ if (nivelNoIniciado) {
				game.addVisual(fondoEmpezar)
				game.schedule(2000, { nivel1.configurate()})
				nivelNoIniciado = false
			}
		})
		keyboard.space().onPressDo({ 
			game.addVisual(fondoEmpezar)
			game.schedule(2000, { game.stop()})
		})
		keyboard.num1().onPressDo({ dificultad.facil()})
		keyboard.num2().onPressDo({ dificultad.normal()})
		keyboard.num3().onPressDo({ dificultad.dificil()})
	}
}

object dificultad {

	const fondoFacil = new Fondo(image = "imgs/fondo facil.png")
	const property fondoNormal = new Fondo(image = "imgs/fondo normal.png")
	const fondoDificil = new Fondo(image = "imgs/fondo dificil.png")
	var property cajas = 5
	var property enemigos = 4

	method facil() {
		cajas = 3
		enemigos = 2
		if (game.hasVisual(fondoNormal)) {
			game.removeVisual(fondoNormal)
			game.addVisual(fondoFacil)
		} else if (game.hasVisual(fondoDificil)) {
			game.removeVisual(fondoDificil)
			game.addVisual(fondoFacil)
		}
	}

	method normal() {
		cajas = 5
		enemigos = 4
		if (game.hasVisual(fondoFacil)) {
			game.removeVisual(fondoFacil)
			game.addVisual(fondoNormal)
		} else if (game.hasVisual(fondoDificil)) {
			game.removeVisual(fondoDificil)
			game.addVisual(fondoNormal)
		}
	}

	method dificil() {
		cajas = 8
		enemigos = 7
		if (game.hasVisual(fondoFacil)) {
			game.removeVisual(fondoFacil)
			game.addVisual(fondoDificil)
		} else if (game.hasVisual(fondoNormal)) {
			game.removeVisual(fondoNormal)
			game.addVisual(fondoDificil)
		}
	}

}

