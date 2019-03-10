package base;

import java.util.Random;

public class KeyGenerator {

	public static String[] Generator(Integer keyLenght, String currentDictionary) {
		String[] key = new String[keyLenght];

		for (int index = 0; index < keyLenght; index++) {
			Character letter = currentDictionary.charAt((new Random()).nextInt(currentDictionary.length()));
			key[index] = letter.toString();
		}
		return key;
	}
}
