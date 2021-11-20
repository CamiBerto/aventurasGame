import wollok.game.*

// Extensión para la clase Key (que no permitió heredar) para asignar combinación de teclas
class KeyExtendido {

	const property keyCodes
	var property key1pressed = false

	/**
	 * Adds a block that will be executed always self.keyCodes are pressed together.
	 * 
	 * Example:
	 * 		const combination = new Key(keyCodes = ["Shift", "Digit2"]
	 *     combination.onPressCombinationDo { if(combination.key1pressed() {(game.say(pepita, "hola!")} } 
	 *         => when user hits "shift + 2" keys, pepita will say "hola!"
	 *  TODO: The validation key1pressed should be part of onPressCombinationDo
	 */
	method onPressCombinationDo(action) {
		game.whenKeyPressedDo([ 'keypress', keyCodes.get(0) ], { => self.key1pressed(true)})
		game.whenKeyPressedDo([ 'keypress', keyCodes.get(1) ], action)
	}

}

