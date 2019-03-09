package base;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class WriteOnFile {
	
	public static void writeKey(String[] keys,String fileName){
		BufferedWriter bw = null;
		FileWriter fw = null;
		try {
			fw = new FileWriter(fileName);
			bw = new BufferedWriter(fw);
			for (int i = 0; i < keys.length; i++) {
				  bw.write(keys[i]);	
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (bw != null) {
					bw.close();
				}
				if (fw != null) {
					fw.close();
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}

}

}
