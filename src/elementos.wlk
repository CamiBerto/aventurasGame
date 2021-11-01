import wollok.game.*
import personajes.*

class Bloque {

	var property position
	var property image = "market.png"

// generarPosicionAleatoria
// coordenadaX, coordenadaY
}
class Indicador{
	//creacion bloques imagenes de numeros
	var property decimal = new Bloque(position = self.positionDecimal())
	var property unidad = new Bloque(position = self.positionUnidad())
	method imagenes()
	/* Obtiene un array con los strings de la primera y segunda imagen para los números*/
	method imagenDeValor(valor) {
		return [ self.imagenes().get((valor * 0.1).truncate(0)), self.imagenes().get(valor % 10) ]
	}
	method positionDecimal()
	method positionUnidad()
	method imagenesDato()
	//iniciar graficos de numero y titulo
	method iniciarGrafico(imagenDecimal,imagenUnidad){
		self.imagenesDato()
		//visual de datos
		game.addVisual(self.decimal())
		game.addVisual(self.unidad())
		//visual de titulo
		game.addVisual(new Bloque(position = self.positionDecimal(), image = imagenDecimal))
		game.addVisual(new Bloque(position = self.positionUnidad(), image = imagenUnidad))
	}
	method actualizarDato(elemento){
			unidad.image(self.imagenDeValor(elemento).get(1))
			decimal.image(self.imagenDeValor(elemento).get(0))
		}
}

class Vida inherits Indicador {
	var property imagenes = [ "green (0).png", "green (1).png", "green (2).png", "green (3).png", "green (4).png", "green (5).png", "green (6).png", "green (7).png", "green (8).png", "green (9).png" ]
	// asignar posicion de los numeros y titulo
	override method imagenesDato(){
		self.decimal().image( self.imagenDeValor(personajeSimple.vida()).get(0))
		self.unidad().image( self.imagenDeValor(personajeSimple.vida()).get(1))
	}
	override method positionDecimal() = game.at(0, game.height() - 1)
	override method positionUnidad() = game.at(1, game.height() - 1)
}

class Granada inherits Indicador {
	var property imagenes = [ "red (0).png", "red (1).png", "red (2).png", "red (3).png", "red (4).png", "red (5).png", "red (6).png", "red (7).png", "red (8).png", "red (9).png" ]
	// asignar posicion de los numeros y titulo
	override method imagenesDato(){
		self.decimal().image( self.imagenDeValor(personajeSimple.granadas()).get(0))
		self.unidad().image( self.imagenDeValor(personajeSimple.granadas()).get(1))
	}
	override method positionDecimal() = game.at(game.center().x()-1, game.height() - 1)
	override method positionUnidad() = game.at(game.center().x(), game.height() - 1)
}

class Energia inherits Indicador {
	var property imagenes = [ "blue (0).png", "blue (1).png", "blue (2).png", "blue (3).png", "blue (4).png", "blue (5).png", "blue (6).png", "blue (7).png", "blue (8).png", "blue (9).png" ]
	// asignar posicion de los numeros y titulo
	override method imagenesDato(){
		self.decimal().image( self.imagenDeValor(personajeSimple.energia()).get(0))
		self.unidad().image( self.imagenDeValor(personajeSimple.energia()).get(1))
	}
	override method positionDecimal() = game.at(game.width()-2, game.height() - 1)
	override method positionUnidad() = game.at(game.width()-1, game.height() - 1)
}
// valor actual vida
// valor actual energia = 30
// valor actual granadas 
// 
// para obtener qué imagen poner es:
// número 29, ejemplo:
// (29 * 0.1).truncate(0) => 2
// 29 % 10 (siempre mod 10) => 9

