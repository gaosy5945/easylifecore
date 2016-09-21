package com.amarsoft.app.als.dataimport.xlsimport;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.regex.Pattern;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.StringFunction;

/**
 * DataGrid格式的数据写入
 * @author syang
 * @date 2011/08/18
 *
 */
public class DataGridWriter extends JBOWriter {
	private int startRowIndex = 0;
	private int finishRowIndex = 10;
	private int commitNumber = 100;
	
	public DataGridWriter(BizObjectManager manager, BizObjectClass clazz) {
		super(manager, clazz);
	}

	private SimpleDateFormat dataFormat = new SimpleDateFormat("yyyy/MM/dd");
	@Override
	public void write(Map<String, DataElement> dataMap) {
		//取元数据设置
		DataElement[] elements = getTargetBizObjectClass().getAttributes();
		int recordCount = finishRowIndex - startRowIndex;
		JBOTransaction tx = null;
		Pattern pattern = Pattern.compile("^[A-Z]+$");
		try {
			tx = JBOFactory.getFactory().createTransaction();
			tx.join(getManager());
			int count = 0;
			boolean txSetted = false;
			for(int i=0;i<recordCount;i++){
				BizObject newBizObject = getManager().newObject();
				boolean setedValue = false;
				count ++;
				//自动补机构及用户信息
				if(getManager() instanceof ExcelImportManager){
					ExcelImportManager excelImportManager = (ExcelImportManager)getManager();
 					if(excelImportManager.getCurUser()!=null){
						//补用户
						String userField = excelImportManager.getUserField();
						if(userField!=null&&userField.length()>0){
							String[] userFields = userField.split(",");
							for(int k=0;k<userFields.length;k++){
								newBizObject.getAttribute(userFields[k]).setValue(excelImportManager.getCurUser().getUserID());
							}
						}
						//补机构
						String orgField = excelImportManager.getOrgField();
						if(orgField!=null&&orgField.length()>0){
							String[] orgFields = orgField.split(",");
							for(int k=0;k<orgFields.length;k++){
								newBizObject.getAttribute(orgFields[k]).setValue(excelImportManager.getCurUser().getOrgID());
							}
						}
						//补日期
						String dateField = excelImportManager.getDateField();
						if(dateField!=null&&dateField.length()>0){
							String[] dateFields = dateField.split(",");
							for(int k=0;k<dateFields.length;k++){
								newBizObject.getAttribute(dateFields[k]).setValue(StringFunction.getToday());
							}
						} 
 					}
				}
				//填写数据
				for(int j=0;j<elements.length;j++){
					DataElement element = elements[j];
					String sourceColName = element.getProperty("excelCol");	//读取Excel列
					
					if(sourceColName!=null&&sourceColName.length()>0){
						if(!pattern.matcher(sourceColName).matches())throw new  Exception("地址:["+sourceColName+"]格式不正确，应该配置为Excel列名，如C]");
						String sourceAddress = sourceColName+(startRowIndex+i+1);
						DataElement e = dataMap.get(sourceAddress);
						if(e==null)continue;
//						Object data = e.getValue();
						Object data = getActualValue(element,e);
						if(data!=null&&!e.isNull()){
							DataElement objElement = newBizObject.getAttribute(element.getName());
							if(data instanceof Date)objElement.setValue(dataFormat.format(e.getDate()));
							objElement.setValue(data);
							setedValue = true;
						}else{
							boolean b = setDefaultValue(newBizObject,element);	//默认值
							//if(!setedValue)//setedValue = b;
						}
					}else{
						boolean b = setDefaultValue(newBizObject,element);	//默认值
						//if(!setedValue)//setedValue = b;
					}
				}
				if(setedValue){
					//调用拦截器
					for(ExcelImportInterceptor interceptor:interceptors){
						if(!txSetted)interceptor.setTransaction(tx);//事务只能设置一次
						interceptor.beforeWrite(newBizObject);
					}
					txSetted = true;
					getManager().saveObject(newBizObject);
					
					//调用拦截器
					for(ExcelImportInterceptor interceptor:interceptors){
						interceptor.afterWrite(newBizObject);
					}
					if(count%commitNumber==0)tx.commit();
				}
			}
			tx.commit();
		} catch (Exception e) {
			ARE.getLog().error("写入数据出错",e);
	 	}finally{
			if(tx!=null) try {tx.rollback();} catch (JBOException e1){}
			dataMap.clear();
		}
	}
	/**
	 * 设置默认值，如果设置了，返回true
	 * @param bo jbo行对象
	 * @param metadataElement 源数据元素
	 * @return
	 * @throws JBOException
	 */
	private boolean setDefaultValue(BizObject bo,DataElement metadataElement) throws JBOException{
		String defaultValue = metadataElement.getProperty("defaultValue");
		if(defaultValue==null)return false;
		DataElement objElement = bo.getAttribute(metadataElement.getName());
		objElement.setValue(defaultValue);
		return true;
	}
	/**
	 * 获取实际值，如果需要作代码表转换的，需要进行代码转换
	 * @param metadataElement
	 * @param element
	 * @return
	 */
//	private Pattern jsonPattern = Pattern.compile("\\{(.+\\:.+)+\\}");
	private Object getActualValue(DataElement metadataElement,DataElement element){
		Object data = element.getValue();
		String codeMapString  = metadataElement.getProperty("codeMap");
		if(data!=null&&codeMapString!=null&&codeMapString.length()>=5){
			codeMapString = codeMapString.substring(1);
			codeMapString = codeMapString.substring(0,codeMapString.length()-1);
			
			String[] items = codeMapString.split(",");
			for(int i=0;i<items.length;i++){
				String[] item = items[i].split(":");
				if(item.length != 2)continue;
				String itemNo = item[0].trim();
				String itemName = item[1].trim();
				if(data.toString().equals(itemName))data = itemNo;
			}
		}
		
		//强制转为字符串
		if(element.getType() == DataElement.DOUBLE){
			String double2StringFormat = metadataElement.getProperty("double2StringFormat");
			if(double2StringFormat != null && double2StringFormat.length()>0){
				data = new DecimalFormat(double2StringFormat).format(element.getDouble());
			}
		}
		
		return data;
	}
	/**
	 * 获取起始行索引
	 * @return
	 */
	public int getStartRowIndex() {
		return startRowIndex;
	}
	/**
	 * 设置起始行索引
	 * @param startRowIndex
	 */
	public void setStartRowIndex(int startRowIndex) {
		this.startRowIndex = startRowIndex;
	}
	/**
	 * 获取结束行索引
	 * @return
	 */
	public int getFinishRowIndex() {
		return finishRowIndex;
	}
	/**
	 * 设置结束行索引
	 * @param finishRowIndex
	 */
	public void setFinishRowIndex(int finishRowIndex) {
		this.finishRowIndex = finishRowIndex;
	}
	/**
	 * 获取每个每个事务记录数
	 * @return
	 */
	public int getCommitNumber() {
		return commitNumber;
	}
	/**
	 * 设置每个事务记录数
	 * @param commitNumber
	 */
	public void setCommitNumber(int commitNumber) {
		this.commitNumber = commitNumber;
	}
}
