package imp.unit;

import com.itextpdf.text.pdf.PdfStructTreeController.returnType;

public class DealFileName {
	public static String getFileName(String filename){
		
		String[] strs = filename.split("\\.");
	 	String str = strs[0];
	 	if(str.length()<13){
	 		str = strs[0] +"."+ strs[1];
	 	}else {
			str = strs[0].substring(0, 13)+"...";
		}
		return str;
	}

}
