import wollok.game.*
import elementos.*

object utilidadesParaJuego {

	method posicionArbitraria() { // Delimita el rango aleatorio dejando una celda de margen para que los bloques no aparzcan pegados a la pared
		return game.at(1.randomUpTo(game.width() - 2).truncate(0), 1.randomUpTo(game.height() - 2).truncate(0))
	}

	method sePuedeMover(posicion) {
		return posicion.x().between(0, game.width() - 1) and posicion.y().between(0, game.height() - 1)
	}

}

/* INSTANCIAR OBJETOS PARA NO USAR STRINGS*/
object llave {

	method instanciar(unaPosicion) = new Llave(position = unaPosicion)

}

object pollo {

	method instanciar(unaPosicion) = new Pollo(position = unaPosicion)

}

// object duplicador{ method instanciar(unaPosicion) = new Duplicador(position=unaPosicion) }
object reforzador {

	method instanciar(unaPosicion) = new Reforzador(position = unaPosicion)

}

/* CELDAS SORPRESA */
object sorpresaA {

	method instanciar(unaPosicion) = new CeldaSorpresaA(position = unaPosicion)

}

object sorpresaB {

	method instanciar(unaPosicion) = new CeldaSorpresaB(position = unaPosicion)

}

object sorpresaC {

	method instanciar(unaPosicion) = new CeldaSorpresaC(position = unaPosicion)

}

object sorpresaD {

	method instanciar(unaPosicion) = new CeldaSorpresaD(position = unaPosicion)

}

