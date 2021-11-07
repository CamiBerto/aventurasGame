class Direccion {

	method siguiente(position)

}

object izquierda inherits Direccion {

	override method siguiente(position) = position.left(1)

	method opuesto() = derecha

}

object derecha inherits Direccion {

	override method siguiente(position) = position.right(1)

	method opuesto() = izquierda

}

object abajo inherits Direccion {

	override method siguiente(position) = position.down(1)

	method opuesto() = arriba

}

object arriba inherits Direccion {

	override method siguiente(position) = position.up(1)

	method opuesto() = abajo

}

