package base;

public class MainTest {

	public static void main(String[] args) {
		
		String[] fileNames = {"chiave2.txt", "chiave4.txt","chiave8.txt","chiave16.txt"};
		String key;
		String dictionary = "ABCDE";
		
		key = KeyGenerator.Generator(2, dictionary);
		WriteOnFile.writeKey(key, fileNames[0]);
		
		key = KeyGenerator.Generator(4, dictionary);
		WriteOnFile.writeKey(key, fileNames[1]);
		
		key = KeyGenerator.Generator(8, dictionary);
		WriteOnFile.writeKey(key, fileNames[2]);
		
		key = KeyGenerator.Generator(16, dictionary);
		WriteOnFile.writeKey(key, fileNames[3]);
		
	}

}
