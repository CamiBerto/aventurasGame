import wollok.game.*
import personajes.*

class Bloque {

	var property position
	const property image = "market.png"

// generarPosicionAleatoria
// coordenadaX, coordenadaY
}

object vida {

	const imagenes = [ "green (0).png", "green (1).png", "green (2).png", "green (3).png", "green (4).png", "green (5).png", "green (6).png", "green (7).png", "green (8).png", "green (9).png" ]
	var property decimal = new Bloque(position = game.at(0, game.height() - 1), image = self.imagenDeValor(personajeSimple.vida()).get(0))
	var property unidad = new Bloque(position = game.at(1, game.height() - 1), image = self.imagenDeValor(personajeSimple.vida()).get(1))
	var property positionPrimerNumero = game.at(0, game.height() - 1)
	var property positionSegundoNumero = game.at(1, game.height() - 1)

	/* Obtiene un array con los strings de la primera y segunda imagen para los números*/
	method imagenDeValor(valor) {
		return [ imagenes.get((valor * 0.1).truncate(0)), imagenes.get(valor % 10) ]
	}

// valor actual vida
// valor actual energia = 30
// valor actual granadas 
// 
// para obtener qué imagen poner es:
// número 29, ejemplo:
// (29 * 0.1).truncate(0) => 2
// 29 % 10 (siempre mod 10) => 9
}

object granada {

	const imagenes = [ "red (0).png", "red (1).png", "red (2).png", "red (3).png", "red (4).png", "red (5).png", "red (6).png", "red (7).png", "red (8).png", "red (9).png" ]
	var property decimal = new Bloque(position = game.at(2, game.height() - 1), image = self.imagenDeValor(personajeSimple.vida()).get(0))
	var property unidad = new Bloque(position = game.at(3, game.height() - 1), image = self.imagenDeValor(personajeSimple.vida()).get(1))
	var property positionPrimerNumero = game.at(0, game.height() - 1)
	var property positionSegundoNumero = game.at(1, game.height() - 1)

	/* Obtiene un array con los strings de la primera y segunda imagen para los números*/
	method imagenDeValor(valor) {
		return [ imagenes.get((valor * 0.1).truncate(0)), imagenes.get(valor % 10) ]
	}

}

object energia {

	var imagenes = [ "blue (0).png", "blue (1).png", "blue (2).png", "blue (3).png", "blue (4).png", "blue (5).png", "blue (6).png", "blue (7).png", "blue (8).png", "blue (9).png" ]
	var property decimal = new Bloque(position = game.at(4, game.height() - 1), image = self.imagenDeValor(personajeSimple.vida()).get(0))
	var property unidad = new Bloque(position = game.at(5, game.height() - 1), image = self.imagenDeValor(personajeSimple.vida()).get(1))
	var property positionPrimerNumero = game.at(0, game.height() - 1)
	var property positionSegundoNumero = game.at(1, game.height() - 1)

	/* Obtiene un array con los strings de la primera y segunda imagen para los números*/
	method imagenDeValor(valor) {
		return [ imagenes.get((valor * 0.1).truncate(0)), imagenes.get(valor % 10) ]
	}

}

