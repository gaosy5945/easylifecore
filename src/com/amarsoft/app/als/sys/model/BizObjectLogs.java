package com.amarsoft.app.als.sys.model;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

public class BizObjectLogs {

	private SystemChangeLog changeLog;
	Map<String,String> map=new HashMap<String,String>();
	private BizObject curBo=null;
	private StringBuffer display=new StringBuffer();
	private StringBuffer remark=new StringBuffer();
	private Map<String,String> codeMap=new HashMap<String,String>();

	HashMap<String, String> record = null;
	HashMap<String, Object> allRecord = new HashMap<String, Object>();
	
	/**
	 * 将BO的变化记录日志
	 * @param bo
	 * @param trans
	 * @throws JBOException
	 */
	public BizObjectLogs(BizObject bo,String sObjectType,String sObjectNo,JBOTransaction trans) throws JBOException
	{
		  curBo=bo;
		  changeLog=new SystemChangeLog(trans,sObjectType,sObjectNo);
		  setBizObject(bo);
		  changeLog.setAttribute("ObjectNo", sObjectNo);
		  changeLog.setAttribute("TABLENAME", bo.getBizObjectClass().getName());
		  changeLog.setAttribute("DONAME", bo.getBizObjectClass().getLabel());
	}
	
	/**
	 * 设置JBO，读取JBO的数据，存储
	 * @param bo
	 * @since  2012-8-16 下午02:05:49
	 */
	public void setBizObject(BizObject bo)
	{
		 curBo=bo;
		 if(curBo==null) return ;
		  DataElement[]  elements=curBo.getAttributes();
		  for(DataElement de:elements)
		  {
			  map.put(de.getName().toUpperCase(), de.getString());
		  }
	}
	/**
	 * 设置模块名称
	 * @throws JBOException 
	 */
	public void steModelName(String modelName) throws JBOException{
		changeLog.setAttribute("DoName", modelName);
	}
	/**
	 * 
	 * @return
	 * @throws JBOException
	 * @since  2012-8-16 上午11:13:23
	 */
	public BizObject saveLog() throws Exception
	{ 
		String skey,svalue="",snewValue="";
		String fieldName="";
		for(Iterator<String> it=map.keySet().iterator();it.hasNext();)
		{
			  skey=it.next();
			  svalue=map.get(skey);
			  DataElement  el=curBo.getAttribute(skey);
			  snewValue=el.getString();
			  fieldName=el.getName();
			  if(svalue==null) svalue="";
			  if(snewValue==null) snewValue="";
			  if(!svalue.equalsIgnoreCase(snewValue)) {
				   svalue=convertValue(fieldName,svalue);
				   snewValue=convertValue(fieldName,snewValue);
				  appendChange(el.getLabel(),svalue,snewValue);
				  appendRemark(fieldName,el.getLabel(),svalue,snewValue);
			  }
		} 

		String jsonStr = JSONEncoder.encode(allRecord);  
		changeLog.setAttribute("DisplayLogMap", jsonStr); 
		if(jsonStr.length()>400){
			changeLog.setAttribute("DisplayLog", jsonStr.substring(0,399));
		}else{
			changeLog.setAttribute("DisplayLog", jsonStr);
		}
		
		 return changeLog.saveLog(null);
	}
	
	/**
	 * 设置修改用户
	 * @param userID
	 */
	public void serUserID(String userID)
	{
		try {
			this.getSystemChangeLog().serUser(userID);
		} catch (Exception e) {
 			e.printStackTrace();
		}
	}
	/**
	 * 获得日志信息
	 * @return
	 */
	public SystemChangeLog getSystemChangeLog()
	{
		return changeLog;
	}
	
	/**
	 * 获得原对象的数据
	 * @param key
	 * @return
	 * @since  2012-9-6 下午06:41:05
	 */
	public String getOldValue(String key)
	{
		return map.get(key);
	}
	/**
	 * 设置日志的值
	 * @param skey
	 * @param value
	 * @throws JBOException 
	 */
	public void setAttribute(String skey,String value) throws JBOException
	{
		changeLog.setAttribute(skey, value);
	}
	 
	/**
	 * @param codeMap the codeMap to set
	 */
	public void setCodeMap(String key,String value) {
		this.codeMap.put(key.toUpperCase(), value);
	}

	/**
	 * @return the codeMap
	 */
	public String getCodeMap(String key) {
		String value=this.codeMap.get(key.toUpperCase());
		if(value==null) return "";
		return value;
	}
	/**
	 * 转化代码
	 * @param fieldName
	 * @param value
	 * @return
	 * @throws Exception 
	 */
	private String convertValue(String fieldName,String value) throws Exception
	{
		if(value==null || value.equals("")) return "空";
		String codeNo=this.getCodeMap(fieldName);
		if(codeNo.equals("")) return value;
		Item item=CodeManager.getItem(codeNo, value);
		if(item==null) return value;
		return item.getItemName()+" ["+value+"]";
	}
	/**
	 * 
	 * @param fieldName
	 * @param oldValue
	 * @param newValue
	 * @since  2012-8-16 下午01:58:12
	 */
	public  void appendChange(String fieldName,String oldValue,String newValue)
	{
		this.display.append(fieldName+":"+oldValue+" ->" +newValue);
	}
	
	public  void appendRemark(String fieldName,String fieldLable,String oldValue,String newValue)
	{
		 record=new HashMap<String, String>(); 
		record.put("ColHeader", fieldLable);
		record.put("ColName", fieldName);
		record.put("OldValue", oldValue);
		record.put("NewValue",newValue);
		this.allRecord.put(fieldName, record);
	}
}
