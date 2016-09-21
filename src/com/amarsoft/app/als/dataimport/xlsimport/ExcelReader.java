package com.amarsoft.app.als.dataimport.xlsimport;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jxl.BooleanCell;
import jxl.BooleanFormulaCell;
import jxl.Cell;
import jxl.CellType;
import jxl.DateCell;
import jxl.DateFormulaCell;
import jxl.ErrorCell;
import jxl.ErrorFormulaCell;
import jxl.LabelCell;
import jxl.NumberCell;
import jxl.NumberFormulaCell;
import jxl.Sheet;
import jxl.StringFormulaCell;
import jxl.Workbook;
import jxl.read.biff.BiffException;

import org.apache.commons.lang.StringUtils;

import com.amarsoft.are.lang.DataElement;

/**
 * 数据读取抽象类
 * @author syang
 *
 */
public abstract class ExcelReader {
	private InputStream inputStream = null;
	private int sheetIndex = 0;
	private Sheet sheet = null;
	private Workbook workbook;
	private Sheet[] sheets;
	protected List<ExcelImportInterceptor> interceptors = new ArrayList<ExcelImportInterceptor>(1);;
	/**
	 * 构造一个Excel数据读取器
	 * @param inputStream 数据流对象
	 * @param sheetIndex sheet页索引
	 * @throws IOException 
	 * @throws BiffException 
	 */
	public ExcelReader(InputStream inputStream,int sheetIndex) throws BiffException, IOException{
		this.inputStream = inputStream;
		this.sheetIndex = sheetIndex;
	}
	public void loadSheet() throws BiffException, IOException{
		 workbook = Workbook.getWorkbook(inputStream);
		 sheets = workbook.getSheets();
		if(sheetIndex<sheets.length){//下标检查
			sheet = sheets[sheetIndex];
		}
	}
	
	
	
	public Workbook getWorkbook() {
		return workbook;
	}
	
	public void setWorkbook(Workbook workbook) {
		this.workbook = workbook;
	}
	
	public Sheet[] getSheets() {
		return sheets;
	}
	public void setSheets(Sheet[] sheets) {
		this.sheets = sheets;
	}
	public Sheet getSheet(){
//		if(sheet==null)loadSheet();
		return sheet;
	}
	
	public List<ExcelImportInterceptor> getInterceptors() {
		return interceptors;
	}
	public void setInterceptors(List<ExcelImportInterceptor> interceptors) {
		this.interceptors = interceptors;
	}
	/**
	 * 读取第一个字母结束索引
	 * @param adr
	 * @return
	 */
	public static  int getFirstEndCharIndex(String adr){
		int preIndex = 0;
		for(int i=0;i<adr.length();i++){
			Character ch = adr.charAt(i);
			ch = Character.toUpperCase(ch);
			if(ch>='A'&&ch<='Z'){
				preIndex = i;
			}else{//只要找到一个不是字母的，就结束掉
				break;
			}
		}
		return preIndex;
	}
	/**
	 * 读取列地址名称
	 * @param adr excel地址
	 * @return
	 */
	public static  String getColumnName(String adr){
		int firstEndCharIdx = getFirstEndCharIndex(adr);
		return adr.substring(0,firstEndCharIdx+1).toUpperCase();
	}
	/**
	 * 根据列索引，读取Excel列地址
	 * @param columnIndex
	 * @return
	 */
	public static  String getColumnName(int columnIndex){
		return convert10To26(columnIndex);
	}
	/**
	 * 读取行地址名称
	 * @param adr excel地址
	 * @return
	 */
	public static  String getRowName(String adr){
		int firstEndCharIdx = getFirstEndCharIndex(adr);
		return adr.substring(firstEndCharIdx+1);
	}
	/**
	 * 根据行索引，读取Excel行地址
	 * @param rowIndex
	 * @return
	 */
	public static  String getRowName(int rowIndex){
		return ""+(rowIndex+1);
	}
	/**
	 * 26进制转为10进制
	 * @param str
	 * @return
	 */
	public static  int convert26To10(String str){
		String sq = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		char[] letter = str.toCharArray();
		int reNum = 0;
		int power = 1; 							//用于次方算值
		int times = 1;  						//最高位需要加1
		int num = letter.length;				//得到字符串个数
		reNum += sq.indexOf(letter[num - 1]);	//得到最后一个字母的尾数值
		//得到除最后一个字母的所以值,多于两位才执行这个函数
		if (num >= 2){
			for (int i = num - 1; i > 0; i--){
				power = 1;									//置1，用于下一次循环使用次方计算
				for (int j = 0; j < i; j++) power *= 26;	//幂，j次方，应该有函数
				reNum += (power * (sq.indexOf(letter[num - i - 1]) + times));  //最高位需要加1，中间位数不需要加一
				times = 0;
			}
		}
		return reNum;
	}	
	/**
	 * 十进制数转为26进制 
	 * @param num
	 * @return
	 */
	public static  String convert10To26(int value){
		String sq = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        //此处判断输入的是否是正确的数字，略（正在表达式判断）
		StringBuilder sb = new StringBuilder();
        int remainder = value % 26;
        int front = (value - remainder) / 26;
        if (front < 26) {
        	if(front>0)sb.append(sq.charAt(front-1));
        	return sb.append(sq.charAt(remainder)).toString();
        }
        else return convert10To26(front) + sq.charAt(remainder);
	}
	/**
	 * 获取列索引
	 * @param adr excel地址
	 * @return
	 */
	public static  int getColumnIndex(String adr){
		String columnAdr = getColumnName(adr);
		return convert26To10(columnAdr);
	}
	/**
	 * 获取行索引
	 * @param adr
	 * @return
	 */
	public static  int getRowIndex(String adr){
		String rowAdr = getRowName(adr);
		return Integer.parseInt(rowAdr)-1;
	}	
	/**
	 * 取单元格中的值
	 * @param cell
	 * @return
	 */
	public static  DataElement getCellValue(Cell cell){
		
		//构建元素对象
		int colIndex = cell.getColumn();
		int rowIndex = cell.getRow();
		String colName = getColumnName(colIndex);
		String rowName = getRowName(rowIndex);
		DataElement element = new DataElement(colName+rowName);	//名称为单元格地址
		element.setProperty("ColName", colName);
		element.setProperty("RoName", rowName);
		//开始取值
		CellType cellType = cell.getType();
		if(cellType == CellType.EMPTY){
			element.setNull();											//空值
		}else if(cellType == CellType.BOOLEAN){
			element.setValue(((BooleanCell) cell).getValue());			//布尔值
		}else if(cellType == CellType.BOOLEAN_FORMULA){
			element.setValue(((BooleanFormulaCell) cell).getValue());	//布尔值公式
		}else if(cellType == CellType.DATE){
			element.setValue(((DateCell) cell).getDate());				//日期类
		}else if(cellType == CellType.DATE_FORMULA){
			element.setValue(((DateFormulaCell)cell).getDate());			//日期公式
		}else if(cellType == CellType.NUMBER){
			element.setValue(((NumberCell) cell).getValue());			//数字
		}else if(cellType == CellType.NUMBER_FORMULA){
			element.setValue(((NumberFormulaCell) cell).getValue());		//数字公式
		}else if(cellType == CellType.LABEL){
			if(StringUtils.isNotBlank(((LabelCell) cell).getContents())){
				element.setValue(((LabelCell) cell).getContents().replaceAll("\\p{C}",""));			//标签
			}
		}else if(cellType == CellType.STRING_FORMULA){
			element.setValue(((StringFormulaCell) cell).getString());	//字符串公式
		}else if(cellType == CellType.ERROR){
			element.setValue(((ErrorCell) cell).getContents());			//错误消息
		}else if(cellType == CellType.FORMULA_ERROR){
			element.setValue(((ErrorFormulaCell) cell).getContents());	//公式错误
		}else element.setValue(cell.getContents());																	//不能分辨
		//返回
		return element;
	}
	/**
	 * 读取数据集,以Map返回
	 * @return 以Map的形式返回 key值为Excel单元格地址 value值为DataElement
	 */
	public abstract Map<String,DataElement> getDataMap() throws Exception;
}
