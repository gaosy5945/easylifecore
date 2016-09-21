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
 * ���ݶ�ȡ������
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
	 * ����һ��Excel���ݶ�ȡ��
	 * @param inputStream ����������
	 * @param sheetIndex sheetҳ����
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
		if(sheetIndex<sheets.length){//�±���
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
	 * ��ȡ��һ����ĸ��������
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
			}else{//ֻҪ�ҵ�һ��������ĸ�ģ��ͽ�����
				break;
			}
		}
		return preIndex;
	}
	/**
	 * ��ȡ�е�ַ����
	 * @param adr excel��ַ
	 * @return
	 */
	public static  String getColumnName(String adr){
		int firstEndCharIdx = getFirstEndCharIndex(adr);
		return adr.substring(0,firstEndCharIdx+1).toUpperCase();
	}
	/**
	 * ��������������ȡExcel�е�ַ
	 * @param columnIndex
	 * @return
	 */
	public static  String getColumnName(int columnIndex){
		return convert10To26(columnIndex);
	}
	/**
	 * ��ȡ�е�ַ����
	 * @param adr excel��ַ
	 * @return
	 */
	public static  String getRowName(String adr){
		int firstEndCharIdx = getFirstEndCharIndex(adr);
		return adr.substring(firstEndCharIdx+1);
	}
	/**
	 * ��������������ȡExcel�е�ַ
	 * @param rowIndex
	 * @return
	 */
	public static  String getRowName(int rowIndex){
		return ""+(rowIndex+1);
	}
	/**
	 * 26����תΪ10����
	 * @param str
	 * @return
	 */
	public static  int convert26To10(String str){
		String sq = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		char[] letter = str.toCharArray();
		int reNum = 0;
		int power = 1; 							//���ڴη���ֵ
		int times = 1;  						//���λ��Ҫ��1
		int num = letter.length;				//�õ��ַ�������
		reNum += sq.indexOf(letter[num - 1]);	//�õ����һ����ĸ��β��ֵ
		//�õ������һ����ĸ������ֵ,������λ��ִ���������
		if (num >= 2){
			for (int i = num - 1; i > 0; i--){
				power = 1;									//��1��������һ��ѭ��ʹ�ôη�����
				for (int j = 0; j < i; j++) power *= 26;	//�ݣ�j�η���Ӧ���к���
				reNum += (power * (sq.indexOf(letter[num - i - 1]) + times));  //���λ��Ҫ��1���м�λ������Ҫ��һ
				times = 0;
			}
		}
		return reNum;
	}	
	/**
	 * ʮ������תΪ26���� 
	 * @param num
	 * @return
	 */
	public static  String convert10To26(int value){
		String sq = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        //�˴��ж�������Ƿ�����ȷ�����֣��ԣ����ڱ��ʽ�жϣ�
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
	 * ��ȡ������
	 * @param adr excel��ַ
	 * @return
	 */
	public static  int getColumnIndex(String adr){
		String columnAdr = getColumnName(adr);
		return convert26To10(columnAdr);
	}
	/**
	 * ��ȡ������
	 * @param adr
	 * @return
	 */
	public static  int getRowIndex(String adr){
		String rowAdr = getRowName(adr);
		return Integer.parseInt(rowAdr)-1;
	}	
	/**
	 * ȡ��Ԫ���е�ֵ
	 * @param cell
	 * @return
	 */
	public static  DataElement getCellValue(Cell cell){
		
		//����Ԫ�ض���
		int colIndex = cell.getColumn();
		int rowIndex = cell.getRow();
		String colName = getColumnName(colIndex);
		String rowName = getRowName(rowIndex);
		DataElement element = new DataElement(colName+rowName);	//����Ϊ��Ԫ���ַ
		element.setProperty("ColName", colName);
		element.setProperty("RoName", rowName);
		//��ʼȡֵ
		CellType cellType = cell.getType();
		if(cellType == CellType.EMPTY){
			element.setNull();											//��ֵ
		}else if(cellType == CellType.BOOLEAN){
			element.setValue(((BooleanCell) cell).getValue());			//����ֵ
		}else if(cellType == CellType.BOOLEAN_FORMULA){
			element.setValue(((BooleanFormulaCell) cell).getValue());	//����ֵ��ʽ
		}else if(cellType == CellType.DATE){
			element.setValue(((DateCell) cell).getDate());				//������
		}else if(cellType == CellType.DATE_FORMULA){
			element.setValue(((DateFormulaCell)cell).getDate());			//���ڹ�ʽ
		}else if(cellType == CellType.NUMBER){
			element.setValue(((NumberCell) cell).getValue());			//����
		}else if(cellType == CellType.NUMBER_FORMULA){
			element.setValue(((NumberFormulaCell) cell).getValue());		//���ֹ�ʽ
		}else if(cellType == CellType.LABEL){
			if(StringUtils.isNotBlank(((LabelCell) cell).getContents())){
				element.setValue(((LabelCell) cell).getContents().replaceAll("\\p{C}",""));			//��ǩ
			}
		}else if(cellType == CellType.STRING_FORMULA){
			element.setValue(((StringFormulaCell) cell).getString());	//�ַ�����ʽ
		}else if(cellType == CellType.ERROR){
			element.setValue(((ErrorCell) cell).getContents());			//������Ϣ
		}else if(cellType == CellType.FORMULA_ERROR){
			element.setValue(((ErrorFormulaCell) cell).getContents());	//��ʽ����
		}else element.setValue(cell.getContents());																	//���ֱܷ�
		//����
		return element;
	}
	/**
	 * ��ȡ���ݼ�,��Map����
	 * @return ��Map����ʽ���� keyֵΪExcel��Ԫ���ַ valueֵΪDataElement
	 */
	public abstract Map<String,DataElement> getDataMap() throws Exception;
}
