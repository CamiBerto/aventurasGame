import wollok.game.*
import fondo.*
import elementos.*
import utilidades.*
import indicadores.*
import nivel.*
import config.*
import personaje_nivel3.*

object nivelBonus inherits Nivel {

	var property cofreCreado = cofre
	var property personaje = new PersonajeNivel3(nivelActual = self)

	override method faltanRequisitos() = game.allVisuals().any{ c => enemigosEnTablero.contains(c) }

	method estadoActual() {
		return if (self.faltanRequisitos()) {
			"Tenemos batalla por delante."
		} else {
			"Agarrar el Cofre Legendario"
		}
	}

// Se utiliza al disparar una flecha
	method aparecerCofreSi() {
		// Si mata al último enemigo aparece el cofre
		if (not self.faltanRequisitos() and not game.hasVisual(cofreCreado)) {
			game.addVisual(cofreCreado)
		}
	}

	method ponerEnemigo(cantidad, unEnemigo) { // debe recibir cantidad y EL NOMBRE DE UN ELEMENTO
		if (cantidad > 0) {
			const unaPosicion = utilidadesParaJuego.posicionArbitraria()
			if (not self.hayElementoEn(unaPosicion)) { // si la posicion no está ocupada
				const unaInstancia = unEnemigo.instanciar(unaPosicion) // instancia el elemento en una posicion
				enemigosEnTablero.add(unaInstancia) // Agrega el elemento a la lista
				game.addVisual(unaInstancia) // Agrega el elemento al tablero
				self.ponerEnemigo(cantidad - 1, unEnemigo) // llamada recursiva al proximo elemento a agregar
			} else {
				self.ponerEnemigo(cantidad, unEnemigo)
			}
		}
	}

	override method configurate() {
		super()
			// otros visuals
		self.ponerElementos(3, pollo)
		self.ponerElementos(3, pota)
			// Cantidad según la dificultad
		self.ponerEnemigo(dificultad.enemigos() - 2, enemigo)
		self.ponerElementos(dificultad.enemigos(), flecha)
		self.ponerEnemigo(1, ogro)
		self.ponerEnemigo(1, demonio)
		self.ponerElementos(1, sorpresaA)
		self.ponerElementos(1, sorpresaB)
		self.ponerElementos(1, sorpresaC)
		self.ponerElementos(1, sorpresaD)
			// Se agregan las visuales de estado de Cantidad de Flechas, Vida, Energía
		flechaVisual.iniciarGrafico(personaje.flechasAgarradas(), "imgs/fle.png", "imgs/chas.png")
		vidaVisual.iniciarGrafico(personaje.vida(), "imgs/vi.png", "imgs/da.png")
		energiaVisual.iniciarGrafico(personaje.energia(), "imgs/ene.png", "imgs/rgia.png")
			// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personaje)
			// teclado
			/*Movimientos del personaje*/
		keyboard.right().onPressDo{ personaje.moverDerecha()}
		keyboard.left().onPressDo{ personaje.moverIzquierda()}
		keyboard.up().onPressDo{ personaje.moverArriba()}
		keyboard.down().onPressDo{ personaje.moverAbajo()}
		keyboard.q().onPressDo{ personaje.agarrarElemento()}
			// al presionar "n"  da indicaciones
		keyboard.n().onPressDo{ game.say(personaje, self.estadoActual())}
		keyboard.w().onPressDo{ personaje.dispararFlecha()}
			// colicion con oro
		game.onCollideDo(personaje, { objeto => self.efectoAlColisionarCon(objeto)})
		game.onCollideDo(personaje, { objeto =>
			if (objeto == cofreCreado) {
				game.say(personaje, "¡Lo Conseguimos!")
				game.schedule(3000, { self.terminar()})
			}
		})
			// Luego de agregar visuales de enemigos, ordena que se muevan
		enemigosEnTablero.forEach({ enemigos => enemigos.moverse(self.personaje())})
	}

	method efectoAlColisionarCon(objeto) {
		if (objeto.esEnemigo()) {
			personaje.serAtacadoPorEnemigo(objeto)
			game.sound("audio/sangre.mp3").play()
		}
	}

	override method imagenIntermedia() {
		return "imgs/fondo ganaste.png"
	}

	override method siguienteNivel() {
		return pantallaInicio
	}

}

