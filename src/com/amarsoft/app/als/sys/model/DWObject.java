package com.amarsoft.app.als.sys.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.DataElement;
/**
 * ObjectWindow,DataWindow 数据对象
 * @author Administrator
 *
 */
public class DWObject {

	public  HashMap<String, Object>  data=new HashMap();
	public  String userId="";
	public  String userName="";
	public  String orgId="";
	public  String orgName="";
	private String actionCode="";//action编码，定义在CodeNo=ActionCode 中
	private Map<String,String> paraMap=new HashMap<String,String>();
	private Map<String,Object> dwMap=new HashMap<String,Object>();
	private Map<String,String> valueMap=new HashMap<String,String>();
	private Map<String,String> userMap=new HashMap<String,String>();
	private Map<String,DataElement> dataMap=new HashMap<String,DataElement>();
	private Map<String,Object> cachePool=new HashMap<String,Object>();
	private Map<String,Object> attrMap=new HashMap<String,Object>();
	
	/**
	 * 打印传入数据
	 * @return
	 * @throws Exception 
	 */
	public String printDWData() throws Exception{
		Map<String,Object> map2=(Map<String,Object>)data.get("data");
		List<Map<String,String>> lst=(ArrayList<Map<String,String>>)map2.get("lst");
		for(Map map3:lst){
			String colName=map3.get("colName").toString().toUpperCase();
			String colValue = "";
			if(map3.get("colValue") != null){
				colValue=map3.get("colValue").toString();
			}
			//IE8等部分浏览器中，显示模板的未输项返回值不是""，用Tomcat发布为null,用webSphere发布为NULL。
			if(colValue == null || colValue.toUpperCase().equals("NULL")){
				colValue = null;
				continue;
			}
			dwMap.put(colName, map3);
			DataElement de=new DataElement(colName);
			de.setLabel(map3.get("colHeader").toString());
			de.setValue(colValue);
			dataMap.put(colName, de);
			valueMap.put(colName, colValue);
		}
		
		userMap=(Map<String,String>)map2.get("User");
		userId=userMap.get("userID");
		userName=userMap.get("userName");
		orgId=userMap.get("orgID");
		orgName=userMap.get("orgName");
		valueMap.put("InputUserID", userId);
		valueMap.put("InputOrgID", orgId); 
		valueMap.put("UpdateUserID", userId);
		valueMap.put("UpdateOrgID", orgId);
		valueMap.put("InputDate",DateHelper.getBusinessDate());
		valueMap.put("UpdateDate",DateHelper.getBusinessDate());
		//paraMap=(Map<String, String>) map2.get("Parameter");
		 Map<String, String> tempMap=(Map<String, String>) map2.get("Parameter");
		for(Iterator<String> it=tempMap.keySet().iterator();it.hasNext();)
		{
			String key=it.next();
			paraMap.put(key.toUpperCase(), tempMap.get(key));
		}
		actionCode=(String)map2.get("actionCode");
 
		return data.toString();
	}

	/**
	 * 获得其中的数据
	 * @param colName
	 * @return
	 */
	public String getString(String colName){
		String value=this.getItemValue(colName);
		if(value==null || value.equals("")) value=this.getParameter(colName);
		if(value==null  || value.equals("")) {
			if(this.getObject(colName)!=null){
				value=this.getObject(colName).toString();
			}
		}
		return value;
	}
	/**
	 * 获得模板中所有数据的值
	 * @return
	 */
	public Map<String,String> getItemValues(){
		return valueMap;
	}
	/**
	 * 获得
	 * @param colName
	 * @return
	 */
	public String getItemValue(String colName){
		return valueMap.get(colName.toUpperCase());
	}
	/**
	 * 设置DW数据
	 * @return
	 */
	public HashMap<String, Object> getData() {
		return data;
	}
	/**
	 * 获得参数
	 * @param paraName
	 * @return
	 */
	public String getParameter(String paraName){
		return paraMap.get(paraName.toUpperCase());
	}

	public void setData(HashMap<String, Object> data) throws Exception {
		this.data = data;
		printDWData();
	}

	public String getActionCode() {
		return actionCode;
	}

	/**
	 * 获得主键存储的对象
	 * @param key
	 * @return
	 */
	public Object getObject(String key) {
		return this.cachePool.get(key.toUpperCase());
	}

	/**
	 * 设置主键字段
	 * @param key
	 * @param obj
	 */
	public void setObject(String key, Object obj) {
		this.cachePool.put(key, obj);
	}
	
	private String message="";
	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	
	
}
