package com.planm.board;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.HashMap;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);


	@RequestMapping(value = "/board/test.do", method = { RequestMethod.GET,RequestMethod.POST })
    public ModelAndView test(Model model, @RequestParam HashMap<String, Object> paramMap) throws Exception {	
		String sample = "D:\\PLANM\\file\\excel\\test.xlsx";
		
		File file = new File(sample);

		return new ModelAndView("download", "downloadFile", file); 
	}
	
	@RequestMapping(value = "/board/goToExcel.do", method = { RequestMethod.GET,RequestMethod.POST })
    public ModelAndView goToExcel(Model model, @RequestParam HashMap<String, Object> paramMap) throws Exception {		          	  	
		String sample = "D:\\PLANM\\file\\excel\\reserv.xlsx";
		
		try {			
			File file = new File(sample);

			Workbook workbook = WorkbookFactory.create(new FileInputStream(file));
			Sheet    sheet 	  = workbook.getSheet("Sheet1");
						
			String name  = (String) paramMap.get("name");
			String email = (String) paramMap.get("email");			
			int persons  = Integer.parseInt(paramMap.get("persons").toString());
			int money    = Integer.parseInt(paramMap.get("money").toString());
				
			// -------- 엑셀 파일 수정
			Cell cell = null;
					
			cell = getCell(sheet, 1, CellReference.convertColStringToIndex("B"));
			cell.setCellValue(name);
			
			cell = getCell(sheet, 2, CellReference.convertColStringToIndex("B"));	// Cell 알파벳 -> 숫자			
			cell.setCellValue(email);
			
			cell = getCell(sheet, 1, CellReference.convertColStringToIndex("E"));
			cell.setCellValue(money);
			
			cell = getCell(sheet, 2, CellReference.convertColStringToIndex("E"));
			cell.setCellValue(persons);
			
			cell = getCell(sheet, 3, CellReference.convertColStringToIndex("E"));
			cell.setCellFormula("E2*E3");
			// ----------------------------------------------------
			
			// -------- 엑셀 파일 저장
			FileOutputStream fos = new FileOutputStream(new File(sample));
			workbook.write(fos);
			// ----------------------------------------------------
					
			if(fos != null) fos.close();
			
			if(workbook != null) workbook.close();											
		} catch (Exception e) {
			e.printStackTrace();						
		}
		File file = new File(sample);
		
		return new ModelAndView("download", "downloadFile", file); 
    }
	
	public Cell getCell(Sheet sheet, int rownum, int cellnum) {
    	Row row = sheet.getRow(rownum);
    	
    	if(row == null) row = sheet.createRow(rownum);    	
    	
    	Cell cell = row.getCell(cellnum);
    	
    	if(cell == null) cell = row.createCell(cellnum);    	

    	return cell;
   	}    
}
