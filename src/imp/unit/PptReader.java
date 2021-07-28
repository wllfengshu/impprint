package imp.unit;
import java.io.FileInputStream;
import java.io.IOException;

import org.apache.poi.POIXMLDocument;
import org.apache.poi.hslf.HSLFSlideShow;
import org.apache.poi.hslf.model.Slide;
import org.apache.poi.hslf.model.TextRun;
import org.apache.poi.hslf.usermodel.SlideShow;
import org.apache.poi.openxml4j.exceptions.OpenXML4JException;
import org.apache.poi.xslf.XSLFSlideShow;
import org.apache.poi.xslf.extractor.XSLFPowerPointExtractor;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFSlide;
import org.apache.xmlbeans.XmlException;
import org.openxmlformats.schemas.drawingml.x2006.main.CTRegularTextRun;
import org.openxmlformats.schemas.drawingml.x2006.main.CTTextBody;
import org.openxmlformats.schemas.drawingml.x2006.main.CTTextParagraph;
import org.openxmlformats.schemas.presentationml.x2006.main.CTGroupShape;
import org.openxmlformats.schemas.presentationml.x2006.main.CTShape;
import org.openxmlformats.schemas.presentationml.x2006.main.CTSlide;

public class PptReader {

    /**
     * @param args
     */
    public static String getTextFromPPT2003(String path) {

        StringBuffer content = new StringBuffer("");
        try {

            SlideShow ss = new SlideShow(new HSLFSlideShow(path));// path为文件的全路径名称，建立SlideShow
            Slide[] slides = ss.getSlides();// 获得每一张幻灯片
            for (int i = 0; i < slides.length; i++) {
                TextRun[] t = slides[i].getTextRuns();// 为了取得幻灯片的文字内容，建立TextRun
                for (int j = 0; j < t.length; j++) {
                    content.append(t[j].getText());// 这里会将文字内容加到content中去
                }
                content.append(slides[i].getTitle());
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return content.toString();

    }

    public static String getTextFromPPT2007(String path) {
        XSLFSlideShow slideShow;
        String reusltString=null;
        try {
            slideShow = new XSLFSlideShow(path);
            XMLSlideShow xmlSlideShow = new XMLSlideShow(new FileInputStream(path));
          
        XSLFSlide[] slides = xmlSlideShow.getSlides();
        System.out.println(slides.length);
            StringBuilder sb = new StringBuilder();
          /*  for (XSLFSlide slide : slides) {
                CTSlide rawSlide = slide._getCTSlide();
                CTGroupShape gs = rawSlide.getCSld().getSpTree();
                CTShape[] shapes = gs.getSpArray();
                for (CTShape shape : shapes) {
                    CTTextBody tb = shape.getTxBody();
                    if (null == tb)
                        continue;
                    CTTextParagraph[] paras = tb.getPArray();
                    for (CTTextParagraph textParagraph : paras) {
                        CTRegularTextRun[] textRuns = textParagraph.getRArray();
                        for (CTRegularTextRun textRun : textRuns) {
                            sb.append(textRun.getT());
                        }
                    }
                }
            }*/
        reusltString=sb.toString();
        } catch (OpenXML4JException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (XmlException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return reusltString;
    }

    public static void main(String[] args) {
        //System.out.println(PptReader.getTextFromPPT2003("c:/test.ppt"));
       // System.out.println(PptReader.getTextFromPPT2007("E:\\临时文件\\名称：基于二维码扫描的.pptx"));
    
    	 
    }

}
