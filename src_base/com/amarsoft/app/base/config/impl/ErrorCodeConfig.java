package com.amarsoft.app.base.config.impl;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

/**
 * ���������ʾ��Ϣ���档ͨ��xml�����쳣��ʾ�ʹ�����ʾ��Ϣ��
 * 
 * @author xyqu 2014��7��25��
 * 
 */
public final class ErrorCodeConfig extends XMLConfig {

	private static BusinessObjectCache errorCodeConfigCache=new BusinessObjectCache(1000);
	
	
	//����ģʽ
	private static ErrorCodeConfig ecc = null;
	
	private ErrorCodeConfig(){
		
	}
	
	public static ErrorCodeConfig getInstance(){
		if(ecc == null)
			ecc = new ErrorCodeConfig();
		return ecc;
	}

	@Override
	public synchronized void init(String file,int size)  throws Exception {
		file = ARE.replaceARETags(file);
		Document document = getDocument(file);
		BusinessObjectCache errorCodeConfigCache=new BusinessObjectCache(size);
		Element root = document.getRootElement();
		
		List<BusinessObject> errorCodeList = this.convertToBusinessObjectList(root.getChildren("ErrorCode"));
		if (errorCodeList!=null) {
			for (BusinessObject errorCodeConfig : errorCodeList) {
				errorCodeConfigCache.setCache(errorCodeConfig.getString("code"), errorCodeConfig);
			}
		}
		ErrorCodeConfig.errorCodeConfigCache = errorCodeConfigCache;
	}
	
	public static String getErrorMessage(String errorCode, String... parameters){
		BusinessObject errorCodeConfig = (BusinessObject)errorCodeConfigCache.getCacheObject(errorCode);
		if(errorCodeConfig == null){
			return errorCode;
		}
		String errorMessage=null;
		try {
			errorMessage=errorCodeConfig.getString("Describe");
			if (parameters != null) {
				for (int i = 0; i < parameters.length; i++) {
					errorMessage = errorMessage.replaceAll("\\$\\{" + i + "\\}", parameters[i]);
				}
			}
		} catch (Exception e) {
			errorMessage=errorCode;
		}
		
		return errorCode+"-"+errorMessage;
	}
}
