import wollok.game.*
import utilidades.*
import elementos.*
import movimientos.*
import indicadores.*
import personaje.*

class PersonajeNivel2 inherits Personaje {

	override method avanzarOGanar() {
	}

	override method ganarEnergia(unPollo) {
		super(unPollo)
		self.actualizarOro(unPollo)
	}

	override method avanzarHaciendoA(posicion) {
		/* SOLO LAS CAJAS BLOQUEAN EL PASO, LOS OTROS OBJETOS SE AGARRAN */
		// Si había caja, después del bloque anterior, no debería haber caja
		self.avanzar()
	}

}

