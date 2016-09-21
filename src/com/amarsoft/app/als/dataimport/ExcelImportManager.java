package com.amarsoft.app.als.dataimport;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.impl.ALSBizObjectManager;
import com.amarsoft.are.lang.Element;
import com.amarsoft.are.util.json.JSONDecoder;
import com.amarsoft.are.util.json.JSONException;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.context.ASUser;


/**
 * @author syang
 * @date 2011-7-21
 * @describe Excel数据导入JBO管理器,该Manager提供给业务处理调用，不提供给批量调用
 */
public abstract class ExcelImportManager extends ALSBizObjectManager{
	
	private int sheetIndex = 0;
	private InputStream inputStream = null;
	private ASUser curUser = null;
	private String orgField = null;
	private String userField = null;
	private String dateField = null;
	private Map<String,String> parameterSet = new HashMap<String,String>();
	
	/**
	 * 加载参数
	 * @param parameterSet
	 * @throws JSONException 
	 */
	@SuppressWarnings("unchecked")
	public void loadParameterSet(String ps) throws JSONException{
		JSONObject o = JSONDecoder.decode(ps);
		
		for(int i=0;i<o.size();i++){
			Element attribute =o.get(i);
			String attributeID = attribute.getName();
			Object attributeValue = attribute.getValue();
			this.parameterSet.put(attributeID, (String)attributeValue);
		}
	}
	/**
	 * 获取参数集合对象
	 * @return
	 */
	public Map<String, String> getParameterSet() {
		return parameterSet;
	}

	/**
	 * 获取读取sheet页索引号
	 * @return
	 */
	public int getSheetIndex() {
		return sheetIndex;
	}
	/**
	 * 设置读取sheet页索引号
	 * @param sheetIndex
	 */
	public void setSheetIndex(int sheetIndex) {
		this.sheetIndex = sheetIndex;
	}
	
	public InputStream getInputStream() {
		return inputStream;
	}
	public void setInputStream(InputStream inputStream) {
		this.inputStream = inputStream;
	}
	
	public ASUser getCurUser() {
		return curUser;
	}
	public void setCurUser(ASUser curUser) {
		this.curUser = curUser;
	}
	public String getOrgField() {
		return orgField;
	}
	public void setOrgField(String orgField) {
		this.orgField = orgField;
	}
	public String getUserField() {
		return userField;
	}
	public void setUserField(String userField) {
		this.userField = userField;
	}
	
	public String getDateField() {
		return dateField;
	}
	public void setDateField(String dateField) {
		this.dateField = dateField;
	}
}
