package base;

import java.util.Random;

public class KeyGenerator {

	public static String Generator(Integer keyLenght, String currentDictionary) {
		String key = null;

		for (int index = 0; index < keyLenght; index++) {
			Character letter = currentDictionary.charAt((new Random()).nextInt(currentDictionary.length()));
			key += letter.toString();
		}
		return key;
	}
}
