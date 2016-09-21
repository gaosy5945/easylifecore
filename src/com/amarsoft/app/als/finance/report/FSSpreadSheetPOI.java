package com.amarsoft.app.als.finance.report;

import java.awt.Color;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.finance.Report;

/**
 * @author yzheng
 * @date 2014/01/15
 */
public class FSSpreadSheetPOI 
{
	//constants
	public final static String SUCCESS_STATUS = "success";
	public final static String EXCLUDED_REPORT_NAMES 
														= " '报表说明','明细附表','财务指标表','现金流量表(自动)','偿付能力状况表','非财务分析表','客户资产与负债明细' ";
	
	private final static int TITLE_ROW = 0;   //标题行
	private final static int HEADER_ROW = 1;  //数据头行
	private final static int DATA_ROW = 2;    //数据行
	
	//颜色
	private final static short TITLE_BG_COLOR = HSSFColor.GREY_50_PERCENT.index;//"#CCC8EB";//     //标题颜色
	private final static short HEADER_BG_COLOR = HSSFColor.GREY_40_PERCENT.index;//"#E4E4E4";//    //数据头颜色
	//private final static short SUBTOTAL_BG_COLOR = HSSFColor.YELLOW.index;  //小计行颜色：yellow
	//private final static short DEFAULT_BG_COLOR = HSSFColor.LIGHT_CORNFLOWER_BLUE.index;  //默认行颜色：LIGHT_CORNFLOWER_BLUE
	private final static String BODER_LINE_COLOR = "#999999";   //边框颜色
	/*扩展颜色*/
	
	//（栏-项）列值
	private final static int ONE_COL_ONE_ITEM_COLUMNS = 3;  //单栏单项列值
	private final static int ONE_COL_TWO_ITEM_COLUMNS = 4;  //单栏双项列值
	private final static int TWO_COL_TWO_ITEM_COLUMNS = 8;  //双栏双项列值
	/*扩展不同的（栏-项）列值*/
	
	//excel 2003/2010
	private final static String XLS_FORMAT = ".xls";  
	private final static String XLSX_FORMAT = ".xlsx";  
	
	//variables
	private String recordNo = "";      //报表编号
	private String objectNo = "";      //对应customerid
	private String objectType = "";    //对应CustomerFS
	private String reportDate = "";    //报表日期
	private String reportScope = "";   //报表口径
	private String fileURL = "";  	   //报表存放文件夹配置路径——导入为全部路径/导出为文件夹路径
	private String zipPkgName = "";    //报表文件存储zip名称
	private String isXlsFormat = "";  //操作文件格式.xls/.xlsx
	
	private ArrayList<Report> sheetList = new ArrayList<Report>();  //存放报表每个TAB页对应的report对象
	private NumberFormat nf = NumberFormat.getInstance();  //控制数据小数点个数
	private Workbook workBook = null;
	private boolean isHSSFWb = true;  //操作文件格式.xls/.xlsx
	
	public String getRecordNo() {
		return recordNo;
	}

	public void setRecordNo(String recordNo) {
		this.recordNo = recordNo;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getReportDate() {
		return reportDate;
	}

	public void setReportDate(String reportDate) {
		this.reportDate = reportDate;
	}

	public String getReportScope() {
		return reportScope;
	}

	public void setReportScope(String reportScope) {
		this.reportScope = reportScope;
	}

	public String getFileURL() {
		return fileURL;
	}

	public void setFileURL(String fileURL) {
		this.fileURL = fileURL;
	}

	public String getIsXlsFormat() {
		return isXlsFormat;
	}

	public void setIsXlsFormat(String isXlsFormat) {
		this.isXlsFormat = isXlsFormat;
	}
	
	public int getNumOfSheet(){
		return sheetList.size();
	}

	/**
	 * 默认构造函数——用于导出
	 */
	public FSSpreadSheetPOI(){}
	
	/**
	 * 带参数的构造函数——用于导入
	 */
	public FSSpreadSheetPOI(String pRecordNo, String pObjectNo, String pObjectType, 
			String pReportDate, String pReportScope,String pFileURL)
	{
		recordNo = pRecordNo;
		objectNo = pObjectNo;
		objectType = pObjectType;
		reportDate = pReportDate;
		reportScope = pReportScope;
		fileURL = pFileURL;
		
		if(fileURL.endsWith(".xlsx")){
			workBook = new XSSFWorkbook();
			isHSSFWb = false;
		}
	}

	/**
	 * 读取并导入报表
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String loadAndImportFSFile(JBOTransaction tx) throws Exception
	{
		initReportObjects(tx);
		
		loadFile();
	    
		updateDBFromFile();
		
		
		return SUCCESS_STATUS;
	}
	
	private void loadFile() throws Exception
	{
	    InputStream inp = new FileInputStream(fileURL);
	    workBook = WorkbookFactory.create(inp);
	    inp.close();
	    
	    //删除用户提交的文件
	    File file = new File(fileURL);
	    if(file.exists()) file.delete();
	}
	
	/**
	 * 从文件更新数据
	 * @throws Exception
	 */
	private void updateDBFromFile() throws Exception
	{
		for(int i = 0; i < sheetList.size(); i++){
			Sheet sheet = workBook.getSheet(sheetList.get(i).ReportName);
			
			//sheet名称,行值,列值三样全部匹配校验才通过
			if(sheet == null || !validateFileContent(sheetList.get(i), sheet)){ 
				continue;
			}
			
			updateDataOfSheet(sheetList.get(i), sheet);
			
//			break;  //for testing
		}
	}
	
	private boolean validateFileContent(Report rReport, Sheet sheet) 
	{
		int rowCount = rReport.ReportRows.length;
		int colCount = getColCount(rReport);
		
		if(rReport.DisplayMethod.equals("1") || rReport.DisplayMethod.equals("3")){
			
		}
		else if(rReport.DisplayMethod.equals("2")){	
			rowCount /= 2;
		}
		
		Row r = sheet.getRow(sheet.getLastRowNum());
		int colOfSheet = r.getLastCellNum();

		if((rowCount == (sheet.getLastRowNum()-1)) && (colCount == colOfSheet)){
			return true;
		}
		else{
			ARE.getLog().debug("报表行数(DB): " + rowCount + " sheet行数(EXCEL): " + (sheet.getLastRowNum()-1)
					+ " 报表列数(DB): " + colCount + " sheet列数(EXCEL): " + colOfSheet);
			return false;
		}
	}
	
	/**
	 * 更新sheet数据
	 * @param rReport
	 * @param sheet
	 * @throws Exception
	 */
	private void updateDataOfSheet(Report rReport, Sheet sheet) throws Exception 
	{
		//设置数据
		if(rReport.DisplayMethod.equals("1") || rReport.DisplayMethod.equals("3")){		
			updateOneColumnData(rReport, sheet);
		}
		else if(rReport.DisplayMethod.equals("2")){	
			updateTwoColumnData(rReport, sheet);
		}
		//扩展部分
		//else if(rReport.DisplayMethod.equals("???"))
		
		rReport.save();  //操作数据库
	}

	/**
	 * 从文件更新单栏的数据
	 * @param rReport
	 * @param sheet
	 */
	private void updateOneColumnData(Report rReport, Sheet sheet) 
	{
		int rowEnd = sheet.getLastRowNum() - DATA_ROW;
		int colCount = getColCount(rReport);
		
		for(int i = 0; i <= rowEnd; i++){
			int colIdx = 0;
			//create (i+DATA_ROW)th row
			Row row = sheet.getRow((i+DATA_ROW));

			//col 1  skip non-data col
			colIdx++;
			
			//col 2  skip non-data col
			colIdx++;
			
			//col 3
			if(colCount == ONE_COL_TWO_ITEM_COLUMNS){
				rReport.ReportRows[i].ColValue[0] = String.valueOf(row.getCell(colIdx++).getNumericCellValue());
			}
			
			//col 4
			if(colCount == ONE_COL_TWO_ITEM_COLUMNS){
				rReport.ReportRows[i].ColValue[1] = String.valueOf(row.getCell(colIdx++).getNumericCellValue());
			}
			else if(colCount == ONE_COL_ONE_ITEM_COLUMNS){
				if(rReport.ReportName.indexOf("指标表") > -1){
					rReport.ReportRows[i].ColValue[1] = String.valueOf(row.getCell(colIdx++).getNumericCellValue());
				}
				else{
					rReport.ReportRows[i].ColValue[1] = String.valueOf(row.getCell(colIdx++).getNumericCellValue());
				}
			}
			//rReport.ReportRows[i].ColValue[1] = String.valueOf(row.getCell(colIdx++).getNumericCellValue());
		}
	}
	
	/**
	 * 从文件更新双栏的数据
	 * @param rReport
	 * @param sheet
	 */
	private void updateTwoColumnData(Report rReport, Sheet sheet)
	{
		int rowEnd = sheet.getLastRowNum() - DATA_ROW;
		int rowCount = rReport.ReportRows.length;
		
		for(int i = 0; i <= rowEnd; i++)
		{
			int colIdx = 0;
			//create (i+DATA_ROW)th row
			Row row = sheet.getRow((i+DATA_ROW));
			
			for(int index = 0; index <=rowCount/2; index += rowCount/2){
				//col 1,5  skip non-data col
				colIdx++;
				
				//col 2,6  skip non-data col
				colIdx++;
				
				//col 3,7
				rReport.ReportRows[i + index].ColValue[1] = String.valueOf(row.getCell(colIdx++).getNumericCellValue());
				
				//col 4,8
				rReport.ReportRows[i + index].ColValue[0] = String.valueOf(row.getCell(colIdx++).getNumericCellValue());
			}
		}	
	}


	/**
	 * 客户端调用入口-生成并导出报表
	 * @param Sqlca
	 * @throws Exception
	 */
	public String createAndExportFSFile(JBOTransaction tx) throws Exception
	{
		if(isXlsFormat.equalsIgnoreCase("false")){
			workBook = new XSSFWorkbook();
			isHSSFWb = false;
		}
		initReportObjects(tx);
		generateExcelSpreadSheet(tx);
		saveAndZipFSExcelFile();
		return zipPkgName;
	}
	
	/**
	 * 保存.xls文件为同名zip文件供用户下载
	 * 解压缩文件名-FSSheet_随机码.xls
	 * @throws IOException
	 */
	private void saveAndZipFSExcelFile() throws IOException
	{
		// Write to a .xls/.xlsx file
		File file = new File(fileURL);
		if(!file.exists()) file.mkdirs();
		String randomFileName = UUID.randomUUID().toString();
		String savePath = fileURL + "/" + randomFileName + (isHSSFWb ? XLS_FORMAT : XLSX_FORMAT);
		
	    FileOutputStream fileOut = new FileOutputStream(savePath);
	    workBook.write(fileOut);
	    fileOut.close();
	    
	    //zip the .xls/.xlsx file
	    zipPkgName = fileURL + "/" + randomFileName + ".zip";
	    FileInputStream in = new FileInputStream(savePath);
	    ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipPkgName));
	    
	    String zipFileName = "FSSheet_" + randomFileName + (isHSSFWb ? XLS_FORMAT : XLSX_FORMAT);
	    out.putNextEntry(new ZipEntry(zipFileName)); //name the file inside the zip file
	    
	    byte[]b = new byte[1024];
	    int count = 0;
	    
	    while((count = in.read(b)) > 0){
	    	out.write(b, 0, count);
	    }
	    out.close();
	    in.close();
	    
	    //delete original .xls/.xlsx file
	    new File(savePath).delete();
	}
	
	/**
	 * 生成报表主逻辑
	 * @param Sqlca
	 * @throws Exception
	 */
	private void generateExcelSpreadSheet(JBOTransaction tx) throws Exception
	{
		for(int i = 0; i < sheetList.size(); i++){
			Sheet sheet = workBook.createSheet(sheetList.get(i).ReportName);
			
			fillHeaderPartOfSheet(tx, sheetList.get(i), sheet);
			fillRestOfSheet(sheetList.get(i), sheet);
			
			drawBorderOfSheet(sheetList.get(i), sheet);
		}
	}
	
	/**
	 * 绘制sheet边框
	 * @param rReport
	 * @param sheet
	 */
	private void drawBorderOfSheet(Report rReport, Sheet sheet)
	{
		int rowCount = rReport.ReportRows.length;
		int colCount = getColCount(rReport);
		
		if(rReport.DisplayMethod.equals("1") || rReport.DisplayMethod.equals("3")){
			
		}
		else if(rReport.DisplayMethod.equals("2")){
			rowCount /= 2;
		}
		//扩展部分
		//else if(rReport.DisplayMethod.equals("???"))
		
//		drawBorderOfCell(sheet.getRow(TITLE_ROW).getCell(0)); //draw border of header
		for(int i = HEADER_ROW; i < rowCount + DATA_ROW; i++)
		{
			Row row = sheet.getRow(i);
			for(int j = 0; j < colCount; j++)
			{
				Cell cell = row.getCell(j);
				drawBorderOfCell(cell, getCustomColor(BODER_LINE_COLOR));
			}
		}
	}
	
	/**
	 * 绘制cell边框
	 * @param cell
	 * @param color
	 */
	private void drawBorderOfCell(Cell cell, Color color)
	{
		if(isHSSFWb){
			HSSFPalette palette = ((HSSFWorkbook) workBook).getCustomPalette();
			HSSFColor hssfColor = palette.findSimilarColor((byte)color.getRed(), (byte)color.getGreen(), (byte)color.getBlue());
			short colorIdx = hssfColor.getIndex();
			
		    CellStyle style = cell.getCellStyle();
		    style.setBorderBottom(CellStyle.BORDER_THIN);
		    style.setBottomBorderColor(colorIdx);  //IndexedColors.BLACK.getIndex()
		    style.setBorderLeft(CellStyle.BORDER_THIN);
		    style.setLeftBorderColor(colorIdx);
		    style.setBorderRight(CellStyle.BORDER_THIN);
		    style.setRightBorderColor(colorIdx);
		    style.setBorderTop(CellStyle.BORDER_THIN);
		    style.setTopBorderColor(colorIdx);
		    cell.setCellStyle(style);
		}
		else{
			XSSFCellStyle style = (XSSFCellStyle) cell.getCellStyle();
		    style.setBorderBottom(CellStyle.BORDER_THIN);
		    style.setBottomBorderColor(new XSSFColor(color));  //IndexedColors.BLACK.getIndex()
		    style.setBorderLeft(CellStyle.BORDER_THIN);
		    style.setLeftBorderColor(new XSSFColor(color));
		    style.setBorderRight(CellStyle.BORDER_THIN);
		    style.setRightBorderColor(new XSSFColor(color));
		    style.setBorderTop(CellStyle.BORDER_THIN);
		    style.setTopBorderColor(new XSSFColor(color));
			cell.setCellStyle(style);
		}
	}
	
	
	/**
	 * 填写sheet的标题和数据头名称
	 * @param Sqlca
	 * @param rReport
	 * @param sheet
	 * @throws Exception
	 */
	private void fillHeaderPartOfSheet(JBOTransaction tx, Report rReport, Sheet sheet) throws Exception
	{
		String customerName = getCustomerName(tx);
		int colCount = getColCount(rReport);
		String header = customerName + " " + rReport.ReportDate + " " + rReport.ReportName;
		
		//set title
		setTitle(sheet, header, colCount);
		
		//set header
		setHeader(rReport, sheet, colCount);
	}
	
	/**
	 * 设置标题
	 * @param sheet
	 * @param header
	 * @param colCount
	 * @throws Exception
	 */
	private void setTitle(Sheet sheet, String header, int colCount) throws Exception
	{
		//merge TITLE_ROW(index 0)
	    sheet.addMergedRegion(new CellRangeAddress(
	    		TITLE_ROW, //first row (0-based)
	    		TITLE_ROW, //last row  (0-based)
	            0, //first column (0-based)
	            colCount-1  //last column  (0-based)
	    ));
		
	    //set text title and properties
	    Row row = sheet.createRow(TITLE_ROW);
	    createCellWithStr(row, 0, header, CellStyle.ALIGN_CENTER);
	    appendCellWithColor(row, 0, 0, TITLE_BG_COLOR);
	}
	
	/**
	 * 设置数据头名称
	 * @param rReport
	 * @param xSheet
	 * @param colCount
	 * @throws Exception
	 */
	private void setHeader(Report rReport, Sheet sheet, int colCount) throws Exception
	{
		String[] titleArray = new String[colCount];
		int i = 0;
		
		//获得表头
		StringTokenizer st = new StringTokenizer(rReport.HeaderMethod,"&");
		while (st.hasMoreTokens()){
			titleArray[i++] = st.nextToken("&");
		}
		
		//create HEADER_ROW and set its cells values
		Row row = sheet.createRow(HEADER_ROW);
		for(i = 0; i < colCount; i++) { 
			createCellWithStr(row, i, titleArray[i], CellStyle.ALIGN_GENERAL);
		}
		
		appendCellWithColor(row, 0, colCount-1, HEADER_BG_COLOR);
	}
	
	/**
	 * 填写sheet除标题和数据头名称以外的内容
	 * @param rReport
	 * @param sheet
	 * @throws Exception
	 */
	private void fillRestOfSheet(Report rReport, Sheet sheet) throws Exception
	{
		setNFProperty(rReport);
		if(rReport.DisplayMethod.equals("1") || rReport.DisplayMethod.equals("3")){		
			setOneColumnData(rReport, sheet);
			sheet.autoSizeColumn(0);  //adjust width of the first column
		}
		else if(rReport.DisplayMethod.equals("2")){	
			setTwoColumnData(rReport, sheet);
			sheet.autoSizeColumn(0);  //adjust width of the 0th column
			sheet.autoSizeColumn(TWO_COL_TWO_ITEM_COLUMNS/2);  //adjust width of the 4th column
		}
		//扩展部分
		//else if(rReport.DisplayMethod.equals("???"))
	}
	
	/**
	 * 设置单栏的数据
	 * @param rReport
	 * @param xSheet
	 * @throws Exception
	 */
	private void setOneColumnData(Report rReport, Sheet sheet) throws Exception
	{
		int rowCount = rReport.ReportRows.length;
		int colCount = getColCount(rReport);
		
		for(int i = 0; i < rowCount; i++){
			int colIdx = 0;
			//create (i+DATA_ROW)th row
			Row row = sheet.createRow((i+DATA_ROW));

			//col 1
			createCellWithStr(row, colIdx++, 
					DataConvert.toString(rReport.ReportRows[i].RowName), CellStyle.ALIGN_LEFT);
			
			//col 2
			createCellWithNum(row, colIdx++, (i*1.0+1), CellStyle.ALIGN_CENTER);
			
			//col 3
			if(colCount == ONE_COL_TWO_ITEM_COLUMNS){
				createCellWithNum(row, colIdx++, 
						Double.parseDouble(rReport.ReportRows[i].ColDisplay[0]), CellStyle.ALIGN_RIGHT);
			}
			
			//col 4
			createCellWithNum(row, colIdx++, 
					Double.parseDouble(rReport.ReportRows[i].ColDisplay[1]), CellStyle.ALIGN_RIGHT);
			
		    String rowAttribute = DataConvert.toString(rReport.ReportRows[i].RowAttribute);
		    String style = StringFunction.getProfileString(rowAttribute,"style");
		    
		    //set bg color for a row
		    if(style.indexOf("background-color") != -1){
		    	appendCellWithColor(row, colIdx - colCount, colIdx-1, getCustomColor(style));
			}
		}
	}
	
	/**
	 * 设置双栏的数据
	 * @param rReport
	 * @param sheet
	 * @throws Exception
	 */
	private void setTwoColumnData(Report rReport, Sheet sheet) throws Exception
	{
		int rowCount = rReport.ReportRows.length;
		int colCount = getColCount(rReport);
		
		for(int i = 0; i < rowCount/2; i++)
		{
			int colIdx = 0;
			//create (i+DATA_ROW)th row
			Row row = sheet.createRow((i+DATA_ROW));
			
			for(int index = 0; index <=rowCount/2; index += rowCount/2){
				//col 1,5
				createCellWithStr(row, colIdx++, 
						DataConvert.toString(rReport.ReportRows[i + index].RowName), CellStyle.ALIGN_LEFT);
				
				//col 2,6
				createCellWithNum(row, colIdx++, (i*1.0 + 1 + index), CellStyle.ALIGN_CENTER);
				
				//col 3,7
				createCellWithNum(row, colIdx++, 
						Double.parseDouble(rReport.ReportRows[i + index].ColDisplay[1]), CellStyle.ALIGN_RIGHT);
				
				//col 4,8
				createCellWithNum(row, colIdx++, 
						Double.parseDouble(rReport.ReportRows[i + index].ColDisplay[0]), CellStyle.ALIGN_RIGHT);
				
				//set bg color for a row
				String rowAttribute = DataConvert.toString(rReport.ReportRows[i + index].RowAttribute);
				String style = StringFunction.getProfileString(rowAttribute,"style");
			    if (style == null) style = "";
			    
				if(style.indexOf("background-color") != -1){
					appendCellWithColor(row, colIdx - colCount/2, colIdx-1, getCustomColor(style));
				}
			}
		}	
	}
	
	/**
	 * 为表头/数据头添加颜色
	 * @param row
	 * @param start
	 * @param end
	 * @param color short
	 */
	private void appendCellWithColor(Row row, int start, int end, short color)
	{
		for(int i = start; i <= end; i++){
			Cell cell = row.getCell(i);
			CellStyle style = cell.getCellStyle();
			style.setFillForegroundColor(color);
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			cell.setCellStyle(style);
		}
	}
	
	/**
	 * 为表头/数据头以外的cell添加颜色
	 * @param row
	 * @param start
	 * @param end
	 * @param color Color
	 */
	private void appendCellWithColor(Row row, int start, int end, Color color)
	{
		for(int i = start; i <= end; i++){
			if(isHSSFWb){
				Cell cell = row.getCell(i);
				CellStyle style = cell.getCellStyle();
				HSSFPalette palette = ((HSSFWorkbook) workBook).getCustomPalette();
				HSSFColor hssfColor = palette.findSimilarColor((byte)color.getRed(), (byte)color.getGreen(), (byte)color.getBlue());
				style.setFillForegroundColor(hssfColor.getIndex());
				style.setFillPattern(CellStyle.SOLID_FOREGROUND);
				cell.setCellStyle(style);
			}
			else{
				XSSFCell cell = (XSSFCell) row.getCell(i);
				XSSFCellStyle style = cell.getCellStyle();
				style.setFillForegroundColor(new XSSFColor(color));
				style.setFillPattern(CellStyle.SOLID_FOREGROUND);
				cell.setCellStyle(style);
			}
		}
	}
	
	/**
	 * 生成cell，内容为字符串
	 * @param row
	 * @param column
	 * @param cellTxt
	 * @param halign
	 */
	private void createCellWithStr(Row row, int column, String cellTxt, short halign) 
	{
		Cell cell = row.createCell(column);
        cell.setCellValue(cellTxt);
        appendCellWithStyle(cell, halign);
    }
	
	/**
	 * 生成cell，内容为数字
	 * @param row
	 * @param column
	 * @param cellNum
	 * @param halign
	 */
	private void createCellWithNum(Row row, int column, double cellNum, short halign) 
	{
		Cell cell = row.createCell(column);
        cell.setCellValue(cellNum);
        appendCellWithStyle(cell, halign);
    }
	
	/**
	 * 为cell添加样式
	 * @param cell
	 * @param halign
	 */
	private void appendCellWithStyle(Cell cell, short halign) 
	{
        CellStyle cellStyle = workBook.createCellStyle();
        cellStyle.setAlignment(halign);
        cell.setCellStyle(cellStyle);
    }
	
	/**
	 * 解析客户化颜色
	 * @param style
	 * @return 客户化颜色
	 */
	private Color getCustomColor(String style)
	{
		if(style.indexOf("#") != -1){
			int sharpIdx = style.indexOf("#");
			return Color.decode(style.substring(sharpIdx, sharpIdx+7));
		}
		else if(style.indexOf("yellow") != -1){
			return Color.YELLOW;
		}
		else{
			return Color.LIGHT_GRAY;
		}
	}
	
	/**
	 * 根据货币单位设置this.nf的属性
	 * @param rReport
	 */
	private void setNFProperty(Report rReport)
	{
		String reportUnitName = rReport.ReportUnit;
		if(reportUnitName.equals("元")){
			nf.setMinimumFractionDigits(2);
			nf.setMaximumFractionDigits(2);
		}
		else if(reportUnitName.equals("千元")){
			nf.setMinimumFractionDigits(4);
			nf.setMaximumFractionDigits(4);
		}
		else{
			nf.setMinimumFractionDigits(5);
			nf.setMaximumFractionDigits(5);
		}
	}
	
	/**
	 * 初始化报表的每个TAB对应的Report对象
	 * @param Sqlca
	 * @throws Exception
	 */
	private void initReportObjects(JBOTransaction tx) throws Exception
	{
		//jbo.finasys.REPORT_RECORD
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.finasys.REPORT_RECORD");
		tx.join(bm);
		String sql = "objectno = :objectno and objectType = :objectType " 
				 + " and reportdate = :reportdate and reportScope = :reportScope "
				 + " and reportname not in ( " + EXCLUDED_REPORT_NAMES +" )  order by modelno";
		BizObjectQuery query = bm.createQuery(sql);
		
		query.setParameter("objectno",objectNo).setParameter("objectType",objectType)
								.setParameter("reportdate",reportDate).setParameter("reportScope", reportScope);
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
		
		if(bos!=null){
			Transaction Sqlca = Transaction.createTransaction(tx);
			for(BizObject bo:bos){
				String reportNo = bo.getAttribute("reportno").getString();
				Report rReport = new Report(reportNo,Sqlca);
				sheetList.add(rReport);
			}
		}
	}
	
	private String getCustomerName(JBOTransaction tx) throws Exception
	{
		String customerName = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(bm);
		BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",objectNo);
		@SuppressWarnings("unchecked")
		List<BizObject> bos = bq.getResultList(false);
		if(bos!=null){
			customerName =  bos.get(0).getAttribute("CustomerName").getString();
		}
		return customerName;
	}
	
	private int getColCount(Report rReport)
	{
		if(rReport.DisplayMethod.equals("1")) 
			return ONE_COL_TWO_ITEM_COLUMNS; // 单栏双项
		else if (rReport.DisplayMethod.equals("2"))  
			return TWO_COL_TWO_ITEM_COLUMNS; // 双栏双项
		else if (rReport.DisplayMethod.equals("3")) 
			return ONE_COL_ONE_ITEM_COLUMNS;  // 单栏单项
		//扩展部分
		//else if(rReport.DisplayMethod.equals("???"))
		else
			return -1;  //illegal number
	}
}
