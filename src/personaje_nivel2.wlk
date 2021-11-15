import wollok.game.*
import utilidades.*
import elementos.*
import movimientos.*
import indicadores.*
import personaje.*

class PersonajeNivel2 inherits Personaje {

	override method avanzarOGanar() {
	}

override method comerPollo(unPollo) {
	super(unPollo)
	self.ganarEnergia(unPollo.energiaQueOtorga())
}

	override method avanzarHaciendoA(posicion) {
		/* SOLO LAS CAJAS BLOQUEAN EL PASO, LOS OTROS OBJETOS SE AGARRAN */
		// Si había caja, después del bloque anterior, no debería haber caja
		self.avanzar()
	}

}

