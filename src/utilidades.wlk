import wollok.game.*
import elementos.*
import enemigosYFlechaArrojada.*

object utilidadesParaJuego {

	method posicionArbitraria() { // Delimita el rango aleatorio dejando una celda de margen para que los bloques no aparzcan pegados a la pared
		return game.at(1.randomUpTo(game.width() - 2).truncate(0), 1.randomUpTo(game.height() - 2).truncate(0))
	}

	method sePuedeMover(posicion) {
		return posicion.x().between(0, game.width() - 1) and posicion.y().between(0, game.height() - 1)
	}

	method eliminarVisual(visual) {
		if(game.hasVisual(visual)) {
			game.removeVisual(visual)
		}
	}
}

/* INSTANCIAR OBJETOS PARA NO USAR STRINGS*/
object llave {method instanciar(unaPosicion) = new Llave(position = unaPosicion)}
object pollo {method instanciar(unaPosicion) = new Pollo(position = unaPosicion)}
object oro {method instanciar(unaPosicion) = new Oro(position = unaPosicion)}
object pota {method instanciar(unaPosicion) = new Pota(position = unaPosicion)}
object flecha {method instanciar(unaPosicion) = new FlechaEnPiso(position = unaPosicion)}

object enemigo {method instanciar(unaPosicion) = new Enemigo(position = unaPosicion)}
object demonio {method instanciar(unaPosicion) = new Demonio(position = unaPosicion, image = "imgs/golem.png", sonido = "audio/demonio.mp3")}
object ogro {method instanciar(unaPosicion) = new Ogro(position = unaPosicion, image = "imgs/ogro.png", sonido = "audio/ogro.mp3")}

/* CELDAS SORPRESA */
object sorpresaA {method instanciar(unaPosicion) = new CeldaSorpresaA(position = unaPosicion)}
object sorpresaB {method instanciar(unaPosicion) = new CeldaSorpresaB(position = unaPosicion)}
object sorpresaC {method instanciar(unaPosicion) = new CeldaSorpresaC(position = unaPosicion)}
object sorpresaD {method instanciar(unaPosicion) = new CeldaSorpresaD(position = unaPosicion)}

