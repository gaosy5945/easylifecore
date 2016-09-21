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
														= " '����˵��','��ϸ����','����ָ���','�ֽ�������(�Զ�)','��������״����','�ǲ��������','�ͻ��ʲ��븺ծ��ϸ' ";
	
	private final static int TITLE_ROW = 0;   //������
	private final static int HEADER_ROW = 1;  //����ͷ��
	private final static int DATA_ROW = 2;    //������
	
	//��ɫ
	private final static short TITLE_BG_COLOR = HSSFColor.GREY_50_PERCENT.index;//"#CCC8EB";//     //������ɫ
	private final static short HEADER_BG_COLOR = HSSFColor.GREY_40_PERCENT.index;//"#E4E4E4";//    //����ͷ��ɫ
	//private final static short SUBTOTAL_BG_COLOR = HSSFColor.YELLOW.index;  //С������ɫ��yellow
	//private final static short DEFAULT_BG_COLOR = HSSFColor.LIGHT_CORNFLOWER_BLUE.index;  //Ĭ������ɫ��LIGHT_CORNFLOWER_BLUE
	private final static String BODER_LINE_COLOR = "#999999";   //�߿���ɫ
	/*��չ��ɫ*/
	
	//����-���ֵ
	private final static int ONE_COL_ONE_ITEM_COLUMNS = 3;  //����������ֵ
	private final static int ONE_COL_TWO_ITEM_COLUMNS = 4;  //����˫����ֵ
	private final static int TWO_COL_TWO_ITEM_COLUMNS = 8;  //˫��˫����ֵ
	/*��չ��ͬ�ģ���-���ֵ*/
	
	//excel 2003/2010
	private final static String XLS_FORMAT = ".xls";  
	private final static String XLSX_FORMAT = ".xlsx";  
	
	//variables
	private String recordNo = "";      //������
	private String objectNo = "";      //��Ӧcustomerid
	private String objectType = "";    //��ӦCustomerFS
	private String reportDate = "";    //��������
	private String reportScope = "";   //����ھ�
	private String fileURL = "";  	   //�������ļ�������·����������Ϊȫ��·��/����Ϊ�ļ���·��
	private String zipPkgName = "";    //�����ļ��洢zip����
	private String isXlsFormat = "";  //�����ļ���ʽ.xls/.xlsx
	
	private ArrayList<Report> sheetList = new ArrayList<Report>();  //��ű���ÿ��TABҳ��Ӧ��report����
	private NumberFormat nf = NumberFormat.getInstance();  //��������С�������
	private Workbook workBook = null;
	private boolean isHSSFWb = true;  //�����ļ���ʽ.xls/.xlsx
	
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
	 * Ĭ�Ϲ��캯���������ڵ���
	 */
	public FSSpreadSheetPOI(){}
	
	/**
	 * �������Ĺ��캯���������ڵ���
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
	 * ��ȡ�����뱨��
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
	    
	    //ɾ���û��ύ���ļ�
	    File file = new File(fileURL);
	    if(file.exists()) file.delete();
	}
	
	/**
	 * ���ļ���������
	 * @throws Exception
	 */
	private void updateDBFromFile() throws Exception
	{
		for(int i = 0; i < sheetList.size(); i++){
			Sheet sheet = workBook.getSheet(sheetList.get(i).ReportName);
			
			//sheet����,��ֵ,��ֵ����ȫ��ƥ��У���ͨ��
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
			ARE.getLog().debug("��������(DB): " + rowCount + " sheet����(EXCEL): " + (sheet.getLastRowNum()-1)
					+ " ��������(DB): " + colCount + " sheet����(EXCEL): " + colOfSheet);
			return false;
		}
	}
	
	/**
	 * ����sheet����
	 * @param rReport
	 * @param sheet
	 * @throws Exception
	 */
	private void updateDataOfSheet(Report rReport, Sheet sheet) throws Exception 
	{
		//��������
		if(rReport.DisplayMethod.equals("1") || rReport.DisplayMethod.equals("3")){		
			updateOneColumnData(rReport, sheet);
		}
		else if(rReport.DisplayMethod.equals("2")){	
			updateTwoColumnData(rReport, sheet);
		}
		//��չ����
		//else if(rReport.DisplayMethod.equals("???"))
		
		rReport.save();  //�������ݿ�
	}

	/**
	 * ���ļ����µ���������
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
				if(rReport.ReportName.indexOf("ָ���") > -1){
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
	 * ���ļ�����˫��������
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
	 * �ͻ��˵������-���ɲ���������
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
	 * ����.xls�ļ�Ϊͬ��zip�ļ����û�����
	 * ��ѹ���ļ���-FSSheet_�����.xls
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
	 * ���ɱ������߼�
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
	 * ����sheet�߿�
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
		//��չ����
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
	 * ����cell�߿�
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
	 * ��дsheet�ı��������ͷ����
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
	 * ���ñ���
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
	 * ��������ͷ����
	 * @param rReport
	 * @param xSheet
	 * @param colCount
	 * @throws Exception
	 */
	private void setHeader(Report rReport, Sheet sheet, int colCount) throws Exception
	{
		String[] titleArray = new String[colCount];
		int i = 0;
		
		//��ñ�ͷ
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
	 * ��дsheet�����������ͷ�������������
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
		//��չ����
		//else if(rReport.DisplayMethod.equals("???"))
	}
	
	/**
	 * ���õ���������
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
	 * ����˫��������
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
	 * Ϊ��ͷ/����ͷ�����ɫ
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
	 * Ϊ��ͷ/����ͷ�����cell�����ɫ
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
	 * ����cell������Ϊ�ַ���
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
	 * ����cell������Ϊ����
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
	 * Ϊcell�����ʽ
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
	 * �����ͻ�����ɫ
	 * @param style
	 * @return �ͻ�����ɫ
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
	 * ���ݻ��ҵ�λ����this.nf������
	 * @param rReport
	 */
	private void setNFProperty(Report rReport)
	{
		String reportUnitName = rReport.ReportUnit;
		if(reportUnitName.equals("Ԫ")){
			nf.setMinimumFractionDigits(2);
			nf.setMaximumFractionDigits(2);
		}
		else if(reportUnitName.equals("ǧԪ")){
			nf.setMinimumFractionDigits(4);
			nf.setMaximumFractionDigits(4);
		}
		else{
			nf.setMinimumFractionDigits(5);
			nf.setMaximumFractionDigits(5);
		}
	}
	
	/**
	 * ��ʼ�������ÿ��TAB��Ӧ��Report����
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
			return ONE_COL_TWO_ITEM_COLUMNS; // ����˫��
		else if (rReport.DisplayMethod.equals("2"))  
			return TWO_COL_TWO_ITEM_COLUMNS; // ˫��˫��
		else if (rReport.DisplayMethod.equals("3")) 
			return ONE_COL_ONE_ITEM_COLUMNS;  // ��������
		//��չ����
		//else if(rReport.DisplayMethod.equals("???"))
		else
			return -1;  //illegal number
	}
}
