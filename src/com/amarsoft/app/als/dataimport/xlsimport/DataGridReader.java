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
 * 表格式数据读取类
 * @author syang
 * @date 2011/08/18
 *
 */
public class DataGridReader extends ExcelReader{
	/**
	 * 以表格形式读取时，阀值，防止数据量过大引起服务器宕机
	 */
	public String VALVE_ADDRESS = "AZ20000";
	private String startAddress = "A1";		//起始地址
	private String finishAddress = "Z3000"; //结束地址
	private BizObjectClass  jboClass;
	public DataGridReader(InputStream inputStream, int sheetIndex)
			throws BiffException, IOException {
		super(inputStream, sheetIndex);
	}

	private  List<Map<String,DataElement>> lst=new ArrayList<Map<String,DataElement>>();
	
	@Override
	public Map<String, DataElement> getDataMap() throws ExcelAddressExcpetion{
		Map<String,DataElement> map = new LinkedHashMap<String,DataElement>();
		//取总行数，总列数
		int rowCount = getSheet().getRows();
		int colCount = getSheet().getColumns();
		
		//设置读取范围
		int startRowIndex = getRowIndex(startAddress);
		int startColIndex = getColumnIndex(startAddress);
		int finishRowIndex = getRowIndex(finishAddress);
		int finishColIndex = getColumnIndex(finishAddress);
		//检查一下地址范围是否合法
		String exceptionMsg = "地址异常，开始地址:["+startAddress+"]大于或等于结束地址:["+startAddress+"]";
		if(startRowIndex>=finishRowIndex||startColIndex>=finishColIndex)throw new ExcelAddressExcpetion(exceptionMsg);
		//地址根据实际情况，就低不就高原则
		if(finishRowIndex>=rowCount-1)finishRowIndex = rowCount-1;
		if(finishColIndex>=colCount-1)finishColIndex = colCount-1;
		
		
		
		List<DataElement> eRow = new ArrayList<DataElement>();
		for(int i=startRowIndex;i<=finishRowIndex;i++){
			//调用拦截器
			for(ExcelImportInterceptor interceptor:interceptors){
				try {
					interceptor.beforeRead(i);
				} catch (Exception e) {
					ARE.getLog().error("拦截器处理数据出现异常",e);
					throw new ExcelAddressExcpetion("拦截器处理数据出现异常",e);
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
			
			//调用拦截器
			for(ExcelImportInterceptor interceptor:interceptors){
				try {
					interceptor.afterRead(i,map2);
				} catch (Exception e) {
					ARE.getLog().error("拦截器处理数据出现异常",e);
					throw new ExcelAddressExcpetion("拦截器处理数据出现异常",e);
				}
			}
			
			eRow.clear();
		}
		return map;
	}
	/**
	 * 通过Excel的属性获得对于的JBO名称
	 * @param sName
	 * @return
	 * @since  2012-8-15 下午08:36:44
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
	 * 通过Excel的属性获得对应的codeMap
	 * @param sName
	 * @return
	 * @throws Exception 
	 * @since  2012-8-15 下午08:36:44
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
                     ARE.getLog().error("读取代码："+strCodeMap+"发生错误",e);
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
	 * 通过行获得Excel数据
	 * @return
	 * @since  2012-8-15 下午02:03:52
	 */
	public List<Map<String,DataElement>> getExcelList()
	{
		return this.lst;
	}
	/**
	 * 检查地址是否合法，其检查主要为以下两方面:<br/>
	 * 1.检查地址格式是否合法
	 * 2.检查地址是否超过阀值
	 * @param address
	 * @return
	 */
	private void checkAddress(String adr) throws ExcelAddressExcpetion{
		//长度检查
		if(adr.length()<2)throw new ExcelAddressExcpetion("地址：["+adr+"]异常，Excel地址长度少于两位");
		//格式检查，列名称必需为字母，行名称必需为数字
		String columnAdr = getColumnName(adr);
		String rowAdr = getRowName(adr);
		if(!columnAdr.matches("[A-Z]+")||!rowAdr.matches("\\d+"))throw new ExcelAddressExcpetion("地址：["+adr+"]异常，Excel地址格式不正确");
		
		int columnIdx = getColumnIndex(adr);
		int rowIdx = getRowIndex(adr);
		//2.检查是否超过阀值，超出阀值，则抛出异常
		int valveColumnIdx = getColumnIndex(VALVE_ADDRESS);
		int valveRowIdx = getRowIndex(VALVE_ADDRESS);
		if(columnIdx>valveColumnIdx||rowIdx>valveRowIdx) throw new ExcelAddressExcpetion("地址：["+adr+"]异常，超过阀值:["+VALVE_ADDRESS+"]");
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
	 * 获取读取起始地址
	 * @return
	 */
	public String getStartAddress() {
		return startAddress;
	}
	/**
	 * 设置读取地起地址
	 * @param startAddress
	 * @throws ExcelAddressExcpetion 若地址格式非法，则抛出异常
	 */
	public void setStartAddress(String startAddress) throws ExcelAddressExcpetion {
		checkAddress(startAddress);
		this.startAddress = startAddress;
	}
	/**
	 * 获取读取结束地址
	 * @return
	 */
	public String getFinishAddress() {
		return finishAddress;
	}
	/**
	 * 设置读取范围
	 * @param startAddress 开始地址
	 * @param finishAddress 结束地址
	 * @throws ExcelAddressExcpetion
	 */
	public void setReadRange(String startAddress,String finishAddress) throws ExcelAddressExcpetion{
		setStartAddress(startAddress);
		setFinishAddress(finishAddress);
	}
	/**
	 * 设置读取结束地址
	 * @param finishAddress
	 * @throws ExcelAddressExcpetion 若地址格式非法，则抛出异常
	 */
	public void setFinishAddress(String finishAddress) throws ExcelAddressExcpetion {
		checkAddress(finishAddress);
		this.finishAddress = finishAddress;
	}
	
}
