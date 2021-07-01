package com.planm.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class FileDownload extends AbstractView {
  
	public void Download(){     
		setContentType("application/download; utf-8");
    }
 
    @Override
    protected void renderMergedOutputModel(Map<String, Object> model
    									 , HttpServletRequest request
    									 , HttpServletResponse response) throws Exception {
        
        File file = (File) model.get("downloadFile");
        
	 	logger.info("----------------------- FILE DOWNLOAD START ---------------------------");
	 	logger.info("File Path : " + file.getPath());
	 	logger.info("File Name : " + file.getName());
	 	logger.info("----------------------- FILE DOWNLOAD END -----------------------------");
	 	        
        String fileName = null;	// 저장될 파일 이름
        
        // 파일 인코딩
        if(request.getHeader("User-Agent").indexOf("MSIE") > -1) {		// IE 인 경우	             
            fileName = URLEncoder.encode(file.getName(), "UTF-8").replaceAll("\\+", " ");                         
        } else {             
            fileName = new String(file.getName().getBytes("UTF-8"), "8859_1");
        }        
	 	
        response.setContentType(getContentType());
        response.setContentLength((int)file.length());
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
        response.setHeader("Content-Transfer-Encoding", "binary");
      
        OutputStream out = response.getOutputStream();
        FileInputStream fis = null;        

        try {
            fis = new FileInputStream(file);
            FileCopyUtils.copy(fis, out);
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if(fis != null){
                try{
                    fis.close();
                }catch(Exception e){}
            }
        }
        
        out.flush();        
    }
}
