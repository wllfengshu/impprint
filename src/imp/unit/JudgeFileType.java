package imp.unit;

public class JudgeFileType {
	
	public static String getFileType(String path){
		String[] str = path.split("\\.");
		
		return str[1].substring(0, 3).toLowerCase();
		
	}

}
