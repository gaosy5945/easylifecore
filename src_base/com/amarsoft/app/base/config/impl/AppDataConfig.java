package com.amarsoft.app.base.config.impl;

import java.util.Iterator;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

import net.sf.json.JSONObject;

/**
 * 
 * APP������������
 * 
 * @author zwcui 
 * 
 */
public final class AppDataConfig extends XMLConfig {
	public static final String JBO_NAME_APPDATA_CONFIG="AppDataConfig";
	public static final String JBO_NAME_PROCEDURE_CONFIG="Attribute";

	private static AppDataConfig appconfig;
	
	public static AppDataConfig getInstance(){
		if(appconfig == null)
			appconfig = new AppDataConfig();
		return appconfig;
	}
	
	/**
	 * APP��������������Ϣ
	 */
	private static BusinessObjectCache appDataConfigs=new BusinessObjectCache(100);

	/**
	 * ��ȡAPP��������������Ϣ
	 * @param transactionCode
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getAppDataConfig(String id) throws Exception {
		BusinessObject appDataConfig = (BusinessObject)appDataConfigs.getCacheObject(id);
		/*if(appDataConfig==null){
			throw new ALSException("EC4004",id);
		}*/
		return appDataConfig;
	}

	/**
	 * ��ȡAPP����������������
	 * @param transactionCode
	 * @param attributeID
	 * @return
	 * @throws Exception
	 */
	public static String getAppDataConfig(String id, String name) throws Exception {
		String value = AppDataConfig.getAppDataConfig(id).getString(name);
		return value;
	}

	/**
	 * ��ȡAPP�����������õ�����
	 * @param transactionCode
	 * @param scriptID
	 * @param attributeID
	 * @return
	 * @throws Exception
	 */
	public static String getAttributeConfig(String id, String name, String attrvalue) throws Exception {
		BusinessObject transactionScript= AppDataConfig.getAttributeConfig(id, name);
		/*if(transactionScript==null){
			throw new ALSException("EC4005",transactionCode,scriptID);
		}*/
		String value = transactionScript.getString(attrvalue);
		return value;
	}
	
	public static BusinessObject getAttributeConfig(String id, String name) throws Exception {
		BusinessObject attributeConfig= AppDataConfig.getAppDataConfig(id).getBusinessObjectByAttributes(JBO_NAME_PROCEDURE_CONFIG,"name", name);
		/*if(transactionScript==null){
			throw new ALSException("EC4005",id,name);
		}*/
		return attributeConfig;
	}

	/**
	 * ִ����ӦAPP�������õ�SQL���
	 * @author jywen
	 * @param id
	 * @param jo
	 * @param tx
	 * @return
	 * @throws Exception 
	 */
	public static JSONObject executeUpdateSql(String id,JSONObject jo,JBOTransaction tx) throws Exception{
		JSONObject result = new JSONObject();
		try{
			String sJboName = getAttributeConfig(id,"JBOName","value");
			String sSql = getAttributeConfig(id,"Sql","value");
			Iterator it = jo.keys();
			while(it.hasNext()){
				String key = it.next().toString();
				String value = jo.getString(key);
				sSql = sSql.replaceAll("\\$\\{" + key.toLowerCase() + "\\}", value);
			}
			BizObjectManager bom = JBOFactory.getBizObjectManager(sJboName, tx);
			int i = bom.createQuery(sSql).executeUpdate();
			
			if(i == 0) result.put("False", getAttributeConfig(id,"False","value"));
			else{
				result.put("Success", getAttributeConfig(id,"Success","value"));
				tx.commit();
			}
		}catch(Exception e){
			tx.rollback();
			result.put("Failure", getAttributeConfig(id,"Failure","value"));
			e.printStackTrace();
		}
		
		return result;
	}
	
	@Override
	public synchronized void init(String file,int size)  throws Exception {
		file = ARE.replaceARETags(file);
		Document document = getDocument(file);
		Element root = document.getRootElement();
		BusinessObjectCache appDataConfigs=new BusinessObjectCache(size);
		
		List<BusinessObject> appDataList = this.convertToBusinessObjectList(root.getChildren(JBO_NAME_APPDATA_CONFIG));
		if (appDataList!=null) {
			for (BusinessObject appData : appDataList) {
				appDataConfigs.setCache(appData.getString("id"), appData);
			}
		}
		AppDataConfig.appDataConfigs = appDataConfigs;
	}
}
