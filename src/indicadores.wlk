import elementos.*
import wollok.game.*
import utilidades.*
import personaje.*

class Indicador {

	// creacion imagenes de numeros
	var property decimal = new Visual(position = self.positionDecimal())
	var property unidad = new Visual(position = self.positionUnidad())

	// El nombre que se usa para la imagen del indicador
	method nombreImagenIndicador()

	/* Asignar las imágenes para un número de dos cifras */
	method definirImagenesContador(unNumero) {
		const numeroUnidad = unNumero % 10
		const numeroDecena = (unNumero * 0.1).truncate(0)
			// Asigno la imagen para decimal
		self.decimal().image(self.imagenDeValor(numeroDecena))
			// Asigno la imagen para decimal
		self.unidad().image(self.imagenDeValor(numeroUnidad))
	}

	method imagenDeValor(unValor) {
		return "imgs/" + self.nombreImagenIndicador() + " (" + unValor.toString() + ").png"
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

	override method nombreImagenIndicador() = "vida"

	override method positionDecimal() = game.at(0, game.height() - 1)

	override method positionUnidad() = game.at(1, game.height() - 1)

}

object flechaVisual inherits Indicador {

	override method positionDecimal() = game.at(game.center().x() - 1, game.height() - 1)

	override method nombreImagenIndicador() = "flecha"

	override method positionUnidad() = game.at(game.center().x(), game.height() - 1)

}

object energiaVisual inherits Indicador {

	override method positionDecimal() = game.at(game.width() - 2, game.height() - 1)

	override method nombreImagenIndicador() = "energia"

	override method positionUnidad() = game.at(game.width() - 1, game.height() - 1)

}

object oroVisual inherits Indicador {

	override method positionDecimal() = game.at(game.center().x() - 1, game.height() - 1)

	override method positionUnidad() = game.at(game.center().x(), game.height() - 1)

	override method nombreImagenIndicador() = "oro"

}

// La visual de llaves recolectadas (3 por nivel)
object llavesVisual inherits Indicador {

	// El contador de llaves que aparece en la cabecera
	var property contadorLlaves = new Visual(position = game.at(3, game.height() - 1))

	override method nombreImagenIndicador() = "visualFlecha"

	// Para respetar polimorfismo asigno misma posición
	override method positionDecimal() = game.at(3, game.height() - 1)

	override method positionUnidad() = game.at(3, game.height() - 1)

	/* Asignar las imágenes según la cantidad de llaves, al no ser dos dígitos, se sobneescribe */
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

