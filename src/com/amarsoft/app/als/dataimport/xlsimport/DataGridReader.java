package com.amarsoft.app.als.dataimport.xlsimport;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jxl.Cell;
import jxl.read.biff.BiffException;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;


/**
 * ���ʽ���ݶ�ȡ��
 * @author syang
 * @date 2011/08/18
 *
 */
public class DataGridReader extends ExcelReader{
	/**
	 * �Ա����ʽ��ȡʱ����ֵ����ֹ�������������������崻�
	 */
	public String VALVE_ADDRESS = "AZ20000";
	private String startAddress = "A1";		//��ʼ��ַ
	private String finishAddress = "Z3000"; //������ַ
	private BizObjectClass  jboClass;
	public DataGridReader(InputStream inputStream, int sheetIndex)
			throws BiffException, IOException {
		super(inputStream, sheetIndex);
	}

	private  List<Map<String,DataElement>> lst=new ArrayList<Map<String,DataElement>>();
	
	@Override
	public Map<String, DataElement> getDataMap() throws ExcelAddressExcpetion{
		Map<String,DataElement> map = new LinkedHashMap<String,DataElement>();
		//ȡ��������������
		int rowCount = getSheet().getRows();
		int colCount = getSheet().getColumns();
		
		//���ö�ȡ��Χ
		int startRowIndex = getRowIndex(startAddress);
		int startColIndex = getColumnIndex(startAddress);
		int finishRowIndex = getRowIndex(finishAddress);
		int finishColIndex = getColumnIndex(finishAddress);
		//���һ�µ�ַ��Χ�Ƿ�Ϸ�
		String exceptionMsg = "��ַ�쳣����ʼ��ַ:["+startAddress+"]���ڻ���ڽ�����ַ:["+startAddress+"]";
		if(startRowIndex>=finishRowIndex||startColIndex>=finishColIndex)throw new ExcelAddressExcpetion(exceptionMsg);
		//��ַ����ʵ��������͵Ͳ��͸�ԭ��
		if(finishRowIndex>=rowCount-1)finishRowIndex = rowCount-1;
		if(finishColIndex>=colCount-1)finishColIndex = colCount-1;
		
		
		
		List<DataElement> eRow = new ArrayList<DataElement>();
		for(int i=startRowIndex;i<=finishRowIndex;i++){
			//����������
			for(ExcelImportInterceptor interceptor:interceptors){
				try {
					interceptor.beforeRead(i);
				} catch (Exception e) {
					ARE.getLog().error("�������������ݳ����쳣",e);
					throw new ExcelAddressExcpetion("�������������ݳ����쳣",e);
				}
			}
			
			Cell[] row = getSheet().getRow(i);
			int colBounds = row.length-1>=finishColIndex?finishColIndex:row.length-1;
			for(int j=startColIndex;j<=colBounds;j++){
				Cell cell = row[j];
				DataElement element = getCellValue(cell);
				if(element.isNull()||element.getString()==null||element.getString().length()==0)continue;
				else eRow.add(element);
			}
			Map<String,DataElement> map2=new HashMap<String,DataElement>();
			for(int k=0;k<eRow.size();k++){
				DataElement element = eRow.get(k);
				map.put(element.getName(),element);
				
				String sColName=element.getProperty("ColName");
				sColName=getNameByProperty(sColName); 
				element = getNameByCodeMap(element,sColName);
				map2.put(sColName,element); 
			}
			this.lst.add(map2);
			
			//����������
			for(ExcelImportInterceptor interceptor:interceptors){
				try {
					interceptor.afterRead(i,map2);
				} catch (Exception e) {
					ARE.getLog().error("�������������ݳ����쳣",e);
					throw new ExcelAddressExcpetion("�������������ݳ����쳣",e);
				}
			}
			
			eRow.clear();
		}
		return map;
	}
	/**
	 * ͨ��Excel�����Ի�ö��ڵ�JBO����
	 * @param sName
	 * @return
	 * @since  2012-8-15 ����08:36:44
	 */
	private String getNameByProperty(String sName)
	{
		if(jboClass==null) return "";
		DataElement[]  elarray=this.jboClass.getAttributes();
		String strExcelCol="";
		for(DataElement el:elarray)
		{
			strExcelCol=el.getProperty("excelCol");
			if(strExcelCol==null) continue;
			if(strExcelCol.equalsIgnoreCase(sName)) return el.getName();
		}
		return sName;
	}
	
	/**
	 * ͨ��Excel�����Ի�ö�Ӧ��codeMap
	 * @param sName
	 * @return
	 * @throws Exception 
	 * @since  2012-8-15 ����08:36:44
	 */
	private DataElement getNameByCodeMap(DataElement metadataElement, String sName) 
	{
		if(jboClass==null) return null;
		DataElement[]  elarray=this.jboClass.getAttributes();
		DataElement data = metadataElement;
		String strCodeMap="";
		String sReturn ="";
		for(DataElement el:elarray)
			{
				strCodeMap=el.getProperty("codeMap");
				if(strCodeMap==null) continue;
				String  value= (String)metadataElement.getValue();
				Item[] items=null;
				try {
					items =CodeManager.getItems(strCodeMap);// Tools.getItems(strCodeMap);
					if(items==null) continue;
				} catch (Exception e) {
                     ARE.getLog().error("��ȡ���룺"+strCodeMap+"��������",e);
				}
				for(Item item:items)
				{
					if(item.getItemName().equalsIgnoreCase(value)){
						sReturn=item.getItemNo();
						data.setValue(sReturn);
						return data;
					}
				} 
			}	 			
		return data;
	}
	/**
	 * ͨ���л��Excel����
	 * @return
	 * @since  2012-8-15 ����02:03:52
	 */
	public List<Map<String,DataElement>> getExcelList()
	{
		return this.lst;
	}
	/**
	 * ����ַ�Ƿ�Ϸ���������ҪΪ����������:<br/>
	 * 1.����ַ��ʽ�Ƿ�Ϸ�
	 * 2.����ַ�Ƿ񳬹���ֵ
	 * @param address
	 * @return
	 */
	private void checkAddress(String adr) throws ExcelAddressExcpetion{
		//���ȼ��
		if(adr.length()<2)throw new ExcelAddressExcpetion("��ַ��["+adr+"]�쳣��Excel��ַ����������λ");
		//��ʽ��飬�����Ʊ���Ϊ��ĸ�������Ʊ���Ϊ����
		String columnAdr = getColumnName(adr);
		String rowAdr = getRowName(adr);
		if(!columnAdr.matches("[A-Z]+")||!rowAdr.matches("\\d+"))throw new ExcelAddressExcpetion("��ַ��["+adr+"]�쳣��Excel��ַ��ʽ����ȷ");
		
		int columnIdx = getColumnIndex(adr);
		int rowIdx = getRowIndex(adr);
		//2.����Ƿ񳬹���ֵ��������ֵ�����׳��쳣
		int valveColumnIdx = getColumnIndex(VALVE_ADDRESS);
		int valveRowIdx = getRowIndex(VALVE_ADDRESS);
		if(columnIdx>valveColumnIdx||rowIdx>valveRowIdx) throw new ExcelAddressExcpetion("��ַ��["+adr+"]�쳣��������ֵ:["+VALVE_ADDRESS+"]");
	}

 
	public String getVALVE_ADDRESS() {
		return VALVE_ADDRESS;
	}
	public void setVALVE_ADDRESS(String vALVE_ADDRESS) {
		VALVE_ADDRESS = vALVE_ADDRESS;
	}
	public void setJboClass(BizObjectClass jboClass) {
		this.jboClass = jboClass;
	}

	/**
	 * ��ȡ��ȡ��ʼ��ַ
	 * @return
	 */
	public String getStartAddress() {
		return startAddress;
	}
	/**
	 * ���ö�ȡ�����ַ
	 * @param startAddress
	 * @throws ExcelAddressExcpetion ����ַ��ʽ�Ƿ������׳��쳣
	 */
	public void setStartAddress(String startAddress) throws ExcelAddressExcpetion {
		checkAddress(startAddress);
		this.startAddress = startAddress;
	}
	/**
	 * ��ȡ��ȡ������ַ
	 * @return
	 */
	public String getFinishAddress() {
		return finishAddress;
	}
	/**
	 * ���ö�ȡ��Χ
	 * @param startAddress ��ʼ��ַ
	 * @param finishAddress ������ַ
	 * @throws ExcelAddressExcpetion
	 */
	public void setReadRange(String startAddress,String finishAddress) throws ExcelAddressExcpetion{
		setStartAddress(startAddress);
		setFinishAddress(finishAddress);
	}
	/**
	 * ���ö�ȡ������ַ
	 * @param finishAddress
	 * @throws ExcelAddressExcpetion ����ַ��ʽ�Ƿ������׳��쳣
	 */
	public void setFinishAddress(String finishAddress) throws ExcelAddressExcpetion {
		checkAddress(finishAddress);
		this.finishAddress = finishAddress;
	}
	
}
