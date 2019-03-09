package base;

public class MainTest {

	public static void main(String[] args) {
		
		String[] fileNames = {"chiave2.txt", "chiave4.txt","chiave8.txt","chiave16.txt"};
		String[] key;
		String dictionary = "ABCDE";
		
		key = KeyGenerartor.Generartor(2, dictionary);
		WriteOnFile.writeKey(key, fileNames[0]);
		
		key = KeyGenerartor.Generartor(4, dictionary);
		WriteOnFile.writeKey(key, fileNames[1]);
		
		key = KeyGenerartor.Generartor(8, dictionary);
		WriteOnFile.writeKey(key, fileNames[2]);
		
		key = KeyGenerartor.Generartor(16, dictionary);
		WriteOnFile.writeKey(key, fileNames[3]);
		
	}

}
