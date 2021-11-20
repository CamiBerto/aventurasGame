import fondo.*
import wollok.game.*
import nivel_1.*
import nivel_2.*
import nivel_3.*
import keyExtendido.*

const rain = game.sound("audio/nivel.mp3")

object pantallaInicio {

// La pantalla de configuración inicial
	const fondoEmpezar = new Fondo(image = "imgs/fondo empezar.png")

	method configurate() {
		nivel1.personaje().reestablecer()
			// Aranca con la dificultad normal
		game.addVisual(dificultad.fondoNormal())
		keyboard.x().onPressDo({ if (not game.hasVisual(fondoEmpezar)) {
				game.addVisual(fondoEmpezar)
				game.schedule(2000, { nivel1.configurate()})
			}
		})
		keyboard.space().onPressDo({ game.addVisual(fondoEmpezar)
			game.schedule(2000, { game.stop()})
		})
		keyboard.num1().onPressDo({ dificultad.facil()})
		keyboard.num2().onPressDo({ dificultad.normal()})
		keyboard.num3().onPressDo({ dificultad.dificil()})
			// combinación de teclas secretas para pasar a niveles
		const shift2 = new KeyExtendido(keyCodes = [ 'Shift', 'Digit2' ]) // shift + 2
		const shift3 = new KeyExtendido(keyCodes = [ 'Shift', 'Digit3' ]) // shift + 3
		shift2.onPressCombinationDo({ if (shift2.key1pressed()) { // TODO: no logré meter esa validación en el bloque de KeyExtendido
				game.clear()
				nivel2.configurate()
			}
		})
		shift3.onPressCombinationDo({ if (shift3.key1pressed()) {
				game.clear()
				nivelBonus.configurate()
			}
		})
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

