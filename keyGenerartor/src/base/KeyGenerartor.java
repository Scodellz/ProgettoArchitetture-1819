package base;

import java.util.Random;

public class KeyGenerartor {
	
	public static String[] Generartor(Integer size, String currentDictionary){
		String[] key= new String[size];
		
		for(int index=0;index<size;index++) {
			Character letter=currentDictionary.charAt((new Random()).nextInt(currentDictionary.length()));
			key[index]=letter.toString(); 
		}
		return key;
	}
	

}
