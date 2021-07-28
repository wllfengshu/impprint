package imp.unit;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import org.apache.poi.POIXMLDocument;
import org.apache.poi.hpsf.SummaryInformation;
import org.apache.poi.hslf.HSLFSlideShow;
import org.apache.poi.hslf.model.Slide;
import org.apache.poi.hslf.usermodel.SlideShow;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.openxml4j.exceptions.OpenXML4JException;

import org.apache.poi.xslf.XSLFSlideShow;
import org.apache.poi.xslf.extractor.XSLFPowerPointExtractor;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFSlide;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.xmlbeans.XmlException;

import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStructTreeController.returnType;


public class GetFilePages {
	/*
	 * param filepath
	 * 获取成功返回得到的页码数，否则返回0
	 */
	public static int getWordPage(String filepath) throws Exception{
		
		 File file = new File(filepath);
		 if(!file.exists()){
			 return 0;
		 }
		 String type ="" + filepath.charAt(filepath.length() - 4)+filepath.charAt(filepath.length() - 3)+filepath.charAt(filepath.length() - 2)+filepath.charAt(filepath.length() - 1);
		 if(type.equals(".doc")){
			 
			 HWPFDocument doc = new HWPFDocument(new FileInputStream(filepath));
		     int pages = doc.getSummaryInformation().getPageCount();//总页数
		     return pages;
		 }else if(type.equals("docx")){
			
			 XWPFDocument docx = new XWPFDocument(POIXMLDocument.openPackage(filepath));
			 int pages = docx.getProperties().getExtendedProperties().getUnderlyingProperties().getPages();//总页数
			 return pages;
		 }else {
	
			return 0;
		}
	}
	
	public static int getPdfPage(String filepath) throws Exception{
		
		PdfReader reader= new PdfReader(filepath);
		int pagecount= reader.getNumberOfPages(); 
		return pagecount;
	}
	 public static int getPptPage(String filepath) throws IOException, OpenXML4JException, XmlException{
	    	
	    	File file = new File(filepath);
	    	if(!file.exists()){
				 return 0;
			 }
	    	 String type ="" + filepath.charAt(filepath.length() - 4)+filepath.charAt(filepath.length() - 3)+filepath.charAt(filepath.length() - 2)+filepath.charAt(filepath.length() - 1);
	    	
			 if(type.equals(".ppt")){
				 
				 	FileInputStream fin=new FileInputStream(file);
			        SlideShow ss=new SlideShow(new HSLFSlideShow(fin));
			        Slide[] slides=ss.getSlides();
			        fin.close();
			        return slides.length;
			}else if(type.equals("pptx")){
				XSLFSlideShow slideShow;
				slideShow = new XSLFSlideShow(filepath);
	            XMLSlideShow xmlSlideShow = new XMLSlideShow(new FileInputStream(filepath));
	            XSLFSlide[] slides = xmlSlideShow.getSlides();
				//XSLFPowerPointExtractor xslfPowerPointExtractor =  new XSLFPowerPointExtractor(POIXMLDocument.openPackage(filepath));
				
				//return xslfPowerPointExtractor.getExtendedProperties().getPages();
				return slides.length;
			}else {
				return 0;
			}
	    	
	      
	    }
	
	/*public static void main(String[] args) throws Exception {
		System.out.println(GetFilePages.getWordPage("E:\\附近帮.doc"));
		System.out.println(GetFilePages.getPptPage("E:\\演示文稿.ppt"));
		System.out.println(GetFilePages.getPdfPage("E:\\彻底搞定C指针.pdf"));
		//System.out.println(getPptPage("E:\\ppt5256.ppt"));
	}*/
}
