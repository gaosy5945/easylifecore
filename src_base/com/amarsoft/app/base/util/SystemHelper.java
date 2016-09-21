package com.amarsoft.app.base.util;

import java.util.Date;
import java.util.Vector;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.control.model.Parameter;
import com.amarsoft.context.ASOrg;
import com.amarsoft.context.ASUser;

public class SystemHelper {
	
	/**
	 * 获取系统参数
	 * @param curUserID
	 * @param curOrgID
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getSystemParameters(String curUserID,String curOrgID) throws Exception{
		BusinessObject parameterMap = BusinessObject.createBusinessObject();
		parameterMap.setAttributeValue("CurUserID", curUserID);
		parameterMap.setAttributeValue("CurUserName", curUserID);
		parameterMap.setAttributeValue("CurOrgID", curOrgID);
		parameterMap.setAttributeValue("CurOrgName", curOrgID);
		parameterMap.setAttributeValue("SystemDate", DateHelper.getBusinessDate());
		parameterMap.setAttributeValue("SystemTime", DateX.format(new Date(),DateHelper.AMR_NOMAL_DATETIME_FORMAT));
		parameterMap.setAttributeValue("BusinessDate", DateHelper.getBusinessDate());
		parameterMap.setAttributeValue("BusinessTime", DateX.format(new Date(),DateHelper.AMR_NOMAL_TIME_FORMAT));
		return parameterMap;
	}
	
	/**
	 * 获取系统参数
	 * @param curUserID
	 * @param curOrgID
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getSystemParameters(ASUser curUser,ASOrg curOrg) throws Exception{
		return getSystemParameters(curUser.getUserID(),curOrg.getOrgID());
	}
	
	/**
	 * 获取系统参数
	 * @param curUserID
	 * @param curOrgID
	 * @return
	 * @throws Exception
	 */
	public static String getPageParameter(Page curPage,String parameterID) throws Exception{
		for (int i = curPage.parameterList.size() - 1; i >= 0; i--) {
			Parameter parameter = (Parameter)curPage.parameterList.get(i);
			if (parameter.paraName.equalsIgnoreCase(parameterID)) {
				return parameter.paraValue;
			}
		}
		return "";
	}
	
	/**
	 * 获取系统参数
	 * @param curUserID
	 * @param curOrgID
	 * @return
	 * @throws Exception
	 */
	public static String getPageComponentParameter(Page curPage,String parameterID) throws Exception{
		for (int i = curPage.parameterList.size() - 1; i >= 0; i--) {
			Parameter parameter = (Parameter)curPage.parameterList.get(i);
			if (parameter.paraName.equalsIgnoreCase(parameterID)) {
				return parameter.paraValue;
			}
		}
		return getComponentParameter(curPage.getCurComp(),parameterID,3);
	}
	
	/**
	 * 获取系统参数
	 * @param curUserID
	 * @param curOrgID
	 * @return
	 * @throws Exception
	 */
	public static String getComponentParameter(Component curComp,String parameterID) throws Exception{
		return getComponentParameter(curComp,parameterID,3);
	}
	
	/**
	 * 获取系统参数
	 * @param curUserID
	 * @param curOrgID
	 * @return
	 * @throws Exception
	 */
	public static String getComponentParameter(Component curComp,String parameterID,int level) throws Exception{
		for (int i = curComp.getParameterList().size() - 1; i >= 0; i--) {
			Parameter parameter = (Parameter)curComp.getParameterList().get(i);
			if (parameter.paraName.equalsIgnoreCase(parameterID)) {
				return parameter.paraValue;
			}
		}
		if (level < 1) return "";
		else {
			 if (curComp.getParentComponent() != null) {
				 return getComponentParameter(curComp.getParentComponent(),parameterID,level - 1);
			 }
		}
		return "";
	}
	
	public static BusinessObject getComponentParmeters(Component component,int level) throws Exception{
		BusinessObject parameters=BusinessObject.createBusinessObject();
		Vector<Parameter> vlst=component.getParameterList();
		for(int i=0;i<vlst.size();i++){
			Parameter pm=vlst.get(i);
			String paraName=pm.paraName;
			String paraValue=pm.paraValue;
			if(paraName.equalsIgnoreCase("PG_CONTENT_TITLE")) continue;
			if(paraName.equalsIgnoreCase("randp")) continue;
			if(paraName.equalsIgnoreCase("aoID")) continue;
			if(paraName.equalsIgnoreCase("undefined")) continue;
			if(paraName.equalsIgnoreCase("CompClientID")) continue;
			if(paraName.equalsIgnoreCase("ComponentURL")) continue;
			if(paraName.equalsIgnoreCase("ToDestroyClientID")) continue;
			if(paraName.equalsIgnoreCase("TargetWindow")) continue;
			if(paraName.equalsIgnoreCase("ToDestroyAllComponent")) continue;
			if(paraName.equalsIgnoreCase("OpenerClientID")) continue;
			if(paraName.equalsIgnoreCase("DIAGLOGURL")) continue;
			if(paraName.equalsIgnoreCase("COMPPARA")) continue;
			if(paraName.startsWith("SYS_FUNCTION_")) continue;
			parameters.setAttributeValue(paraName, paraValue);
		}
		if (level < 1||component.getParentComponent()==null){
			return parameters;
		}
		else{
			level--;
			BusinessObject parentParameter = getComponentParmeters(component.getParentComponent(),level);
			parameters.appendAttributes(parentParameter);
			return parameters;
		}
	}
	
	public static BusinessObject getPageParmeters(Page curPage) throws Exception{
		BusinessObject parameters =BusinessObject.createBusinessObject();
		Vector<Parameter> vlst = curPage.getParameterList();
		for(int i=0;i<vlst.size();i++){
			Parameter pm=vlst.get(i);
			String paraName=pm.paraName;
			String paraValue=pm.paraValue;
			if(paraName.equalsIgnoreCase("PG_CONTENT_TITLE")) continue;
			if(paraName.equalsIgnoreCase("randp")) continue;
			if(paraName.equalsIgnoreCase("CompClientID")) continue;
			if(paraName.equalsIgnoreCase("ComponentURL")) continue;
			if(paraName.equalsIgnoreCase("ToDestroyClientID")) continue;
			if(paraName.equalsIgnoreCase("TargetWindow")) continue;
			if(paraName.equalsIgnoreCase("ToDestroyAllComponent")) continue;
			if(paraName.equalsIgnoreCase("OpenerClientID")) continue;
			if(paraName.equalsIgnoreCase("aoID")) continue;
			if(paraName.equalsIgnoreCase("DIAGLOGURL")) continue;
			//if(paraName.equalsIgnoreCase("SYS_FUNCTIONID")) continue;
			if(paraName.startsWith("SYS_FUNCTION_")) continue;
			parameters.setAttributeValue(paraName, paraValue);
		}
		return parameters;
	}
	
	public static BusinessObject getPageComponentParameters(Page curPage) throws Exception{
		BusinessObject parameters = getPageParmeters(curPage);
		parameters.appendAttributes(getComponentParmeters(curPage.getCurComp(),3));
		return parameters;
	}
}
