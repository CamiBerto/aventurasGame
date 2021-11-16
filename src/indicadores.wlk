import elementos.*
import wollok.game.*
import utilidades.*
import personaje.*

class Indicador {

	// creacion imagenes de numeros
	var property decimal = new Visual(position = self.positionDecimal())
	var property unidad = new Visual(position = self.positionUnidad())

	method imagenes()

	/* Obtiene el string de una imagen para un valor de 0 a 9*/
	method imagenDeValor(unValor) {
		return self.imagenes().get(unValor)
	}

	/* Asignar las imágenes para un número de dos cifras */
	method definirImagenesContador(unNumero) {
		const numeroUnidad = unNumero % 10
		const numeroDecena = (unNumero * 0.1).truncate(0)
			// Asigno la imagen para decimal
		self.decimal().image(self.imagenDeValor(numeroDecena))
			// Asigno la imagen para decimal
		self.unidad().image(self.imagenDeValor(numeroUnidad))
	}

	// La posición del decimal
	method positionDecimal()

	// La posición de la unidad
	method positionUnidad()

	// iniciar graficos de numero y titulo
	method iniciarGrafico(valorInicial, partTituloDecimal, partTituloUnidad) {
		// Definir las imagenes para decimal y unidad
		self.definirImagenesContador(valorInicial)
			// agregar visual unidad y decimal
		game.addVisual(self.decimal())
		game.addVisual(self.unidad())
			// agregar visual de titulo (la posición es la misma que la de los números)
		game.addVisual(new Visual(position = self.positionDecimal(), image = partTituloDecimal))
		game.addVisual(new Visual(position = self.positionUnidad(), image = partTituloUnidad))
	}

	// Actualiza las imágenes según un nuevo valor
	method actualizarDato(nuevoValor) {
		self.definirImagenesContador(nuevoValor)
	}

}

object vidaVisual inherits Indicador {

	var property imagenes = [ "imgs/red (0).png", "imgs/red (1).png", "imgs/red (2).png", "imgs/red (3).png", "imgs/red (4).png", "imgs/red (5).png", "imgs/red (6).png", "imgs/red (7).png", "imgs/red (8).png", "imgs/red (9).png" ]

	override method positionDecimal() = game.at(0, game.height() - 1)

	override method positionUnidad() = game.at(1, game.height() - 1)

}

object flechaVisual inherits Indicador {

	var property imagenes = [ "imgs/green (0).png", "imgs/green (1).png", "imgs/green (2).png", "imgs/green (3).png", "imgs/green (4).png", "imgs/green (5).png", "imgs/green (6).png", "imgs/green (7).png", "imgs/green (8).png", "imgs/green (9).png" ]

	override method positionDecimal() = game.at(game.center().x() - 1, game.height() - 1)

	override method positionUnidad() = game.at(game.center().x(), game.height() - 1)

}

object energiaVisual inherits Indicador {

	var property imagenes = [ "imgs/blue (0).png", "imgs/blue (1).png", "imgs/blue (2).png", "imgs/blue (3).png", "imgs/blue (4).png", "imgs/blue (5).png", "imgs/blue (6).png", "imgs/blue (7).png", "imgs/blue (8).png", "imgs/blue (9).png" ]

	override method positionDecimal() = game.at(game.width() - 2, game.height() - 1)

	override method positionUnidad() = game.at(game.width() - 1, game.height() - 1)

}

object oroVisual inherits Indicador {

	var property imagenes = [ "imgs/oro (0).png", "imgs/oro (1).png", "imgs/oro (2).png", "imgs/oro (3).png", "imgs/oro (4).png", "imgs/oro (5).png", "imgs/oro (6).png", "imgs/oro (7).png", "imgs/oro (8).png", "imgs/oro (9).png" ]

	override method positionDecimal() = game.at(game.center().x() - 1, game.height() - 1)

	override method positionUnidad() = game.at(game.center().x(), game.height() - 1)

}

// La visual de llaves recolectadas (3 por nivel)
object llavesVisual inherits Indicador {

	var property imagenes = [ "imgs/0-Llave.png", "imgs/1raLlave.png", "imgs/2dallave.png", "imgs/3raLlave.png" ]
	// El contador de llaves que aparece en la cabecera
	var property contadorLlaves = new Visual(position = game.at(3, game.height() - 1))

	// Para respetar polimorfismo asigno misma posición
	override method positionDecimal() = game.at(3, game.height() - 1)

	override method positionUnidad() = game.at(3, game.height() - 1)

	/* Asignar las imágenes según la cantidad de llaves */
	override method definirImagenesContador(unNumero) {
		// Asigno la imagen del contador de llaves
		contadorLlaves.image(self.imagenDeValor(unNumero))
	}

	// iniciar gráfico de contador de llaves
	override method iniciarGrafico(valorInicial, inutilizado1, inutilizado2) {
		// Definir la imagen del contador de llaves
		self.definirImagenesContador(valorInicial)
			// agregar visual de contador de llaves
		game.addVisual(self.contadorLlaves())
	}

	// Actualiza las imágenes según un nuevo valor cuando guardarLlave()
	override method actualizarDato(nuevoValor) {
		self.definirImagenesContador(nuevoValor)
	}
}

