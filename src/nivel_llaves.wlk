import wollok.game.*
import fondo.*
import personajes.*
import utilidades.*
import elementos.*

object nivelLlaves {
	const property personaje = new PersonajeNivelLlaves()
	const elementosEnNivel = []
	
									// EL NOMBRE DEL ELEMENTO ES UN OBJETO QUE GENERA UNA NUEVA INSTANCIA CON EL METODO instanciar()
	method ponerElementos(cantidad,elemento) { 	// debe recibir cantidad y EL NOMBRE DE UN ELEMENTO
		if(cantidad > 0) {
			const unaPosicion = utilidadesParaJuego.posicionArbitraria()
			if (not self.hayElementoEn(unaPosicion) ) {	//si la posicion no eta ocupada
				const unaInstancia = elemento.instanciar(unaPosicion) // instancia el elemento en una posicion
				elementosEnNivel.add(unaInstancia)	//Agrega el elemento a la lista
				game.addVisual(unaInstancia) //Agrega el elemento al tablero
				self.ponerElementos(cantidad -1,elemento) //llamada recursiva al proximo elemento a agregar
			}else{
				self.ponerElementos(cantidad,elemento)	
			}
		}
	}
	 
	/* Metodos que tambien interactuan con los movimientos del personaje */
	method ponerSalida(){ game.addVisual(salida) }// Se agrega la salida al tablero
	method elementoDe(posicion) = elementosEnNivel.find( { e => e.position() == posicion } )
	method hayElementoEn(posicion) = elementosEnNivel.any( { e => e.position() == posicion } )
	method estado() { game.say(personaje,personaje.nivelDeEnergia() ) } // indica el estado de energia
	method celdasSopresa(){   
			return elementosEnNivel.filter( { e => e.esCeldaSorpresa() } )
	}
	
	method entroEnZona(posicionPersonaje,posicionCelda) {
		return (posicionCelda.x().between(posicionPersonaje.x() ,posicionPersonaje.x() ) and    posicionCelda.y().between(posicionPersonaje.y() -1 ,posicionPersonaje.y() +1)
		or     posicionCelda.x().between(posicionPersonaje.x() -1 ,posicionPersonaje.x() +1) and    posicionCelda.y().between(posicionPersonaje.y()  ,posicionPersonaje.y() ))
	}
	
	method configurate() {
		
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="fondoCompleto.png"))
				 
		// otros visuals, p.ej. bloques o llaves
		self.ponerElementos(3,llave)
		self.ponerElementos(1,pollo)
		
		self.ponerElementos(1,tripleOrNada)
		self.ponerElementos(1,reforzador)
		self.ponerElementos(1,duplicador)  
		
		self.ponerElementos(1,sorpresaA)
		self.ponerElementos(2,sorpresaB)
		self.ponerElementos(1,sorpresaC)
		self.ponerElementos(1,sorpresaD)
			
		// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personaje)
		
		// teclado
		keyboard.right().onPressDo{ personaje.moverDerecha() }
		keyboard.left().onPressDo{ personaje.moverIzquierda() } 
		keyboard.up().onPressDo{ personaje.moverArriba() }
		keyboard.down().onPressDo{ personaje.moverAbajo() }
		
		keyboard.e().onPressDo{ self.estado() }
		
		// colisiones, acá sí hacen falta
		game.whenCollideDo(personaje, { 
			objeto => game.removeVisual(objeto)
			elementosEnNivel.remove(objeto)
			game.sound(objeto.sonido()).play()
			self.estado()
		} )
	}

	method celdaSorpresaPisada(){   
		const celdas = self.celdasSopresa().filter( {
			e => self.entroEnZona(personaje.position() ,e.position())
				and not e.fueActivada()
			} )	
		if (celdas.size() > 0 ){
			celdas.forEach {celda =>  celda.activarSorpresa()}
		}
	}
	
	method AgregarPollo() {
		self.ponerElementos(1,pollo)
	}
	
	method EfectoPerderEnergia() {
		personaje.perderEnergia(15)
	}
	
	method EfectoAgregarEnergia() {
		personaje.ganarEnergia(30)
	}
	
	method Teletransportar() {
		personaje.position(utilidadesParaJuego.posicionArbitraria())
	}
	
	method ganar() {
		//sonido ganar
		game.sound("ganar.mp3").play()
		// es muy parecido al terminar() de nivelBloques
		// el perder() también va a ser parecido
		
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		// después de un ratito ...
		game.schedule(1000, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="ganamos.png"))
			// después de un ratito ...
			game.schedule(1500, {
				// fin del juego
				game.stop()
			})
		})
	}

	method perder() {
		//sonido perder
		game.sound("perder.mp3").play()
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		// después de un ratito ...
		game.schedule(1000, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="perdimos.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// fin del juego
				game.stop()
			})
		})
	}
}