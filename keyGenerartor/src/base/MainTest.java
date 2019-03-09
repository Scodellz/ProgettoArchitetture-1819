package base;

public class MainTest {

	public static void main(String[] args) {
		
		String[] prova = KeyGenerartor.Generartor(5, "ABCDE");
		
		WriteOnFile.writeKey(prova, "chiave.txt");
		
	}

}
