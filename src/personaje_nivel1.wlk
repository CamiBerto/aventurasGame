import wollok.game.*
import utilidades.*
import elementos.*
import movimientos.*
import indicadores.*
import personaje.*

class PersonajeNivel1 inherits Personaje {

	override method avanzarOGanar() {
		if (nivelActual.faltanRequisitos()) {
			self.avanzar()
		} else {
			game.say(self, "¡¡¡Ganamos!!!")
			game.schedule(1500, { nivelActual.pasarDeNivel()})
		}
	}

	override method avanzarHaciendoA(posicion) {
		/* SOLO LAS CAJAS BLOQUEAN EL PASO, LOS OTROS OBJETOS SE AGARRAN */
		if (nivelActual.hayCaja(posicion)) {
			// ?? Esto podría hacerse con el getObjectsIn...?? asumiendo que solo hay una visual por celda
			const unaCaja = nivelActual.cajasEnTablero().find({ b => b.position() == posicion })
			unaCaja.reaccionarA(self)
		}
			// Si había caja, después del bloque anterior, no debería haber caja
		if (not nivelActual.hayCaja(posicion)) {
			self.avanzarOGanar()
		}
	}

}

