import wollok.game.*
import utilidades.*
import elementos.*
import movimientos.*
import indicadores.*
import personaje.*


class PersonajeNivel2 inherits Personaje {

	// Solo utilizado por el personaje del nivel 1
	override method avanzarOGanar() {
	}


	// Solo utilizado por el personaje del nivel 1
	override method avanzarHaciendoA(posicion) { 
		self.avanzar()
	}

}

