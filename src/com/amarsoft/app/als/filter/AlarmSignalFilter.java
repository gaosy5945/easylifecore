package com.amarsoft.app.als.filter;

import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASFilterCustomWhereClauses;

public class AlarmSignalFilter extends ASFilterCustomWhereClauses {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Override
	public String getWhereClauses(ASDataObject bo, HttpServletRequest req)throws Exception {
		
		StringBuffer whereClaus = new StringBuffer("1=1");
		
		setWhere("CUSTOMERTYPE",req ,whereClaus);
		setWhere("INPUTDATE",req ,whereClaus);
		setWhere("SIGNALTYPE",req ,whereClaus);
		setWhere("FINISHDATE",req ,whereClaus);
		return whereClaus.toString();
	}

	/**
	 * ��������һ����ѯ����
	 * @param 
	 * @throws Exception 
	 */
	private void setWhere(String value ,HttpServletRequest req,StringBuffer whereClaus) throws Exception {
		String str = getValue(value, req);
		if("INPUTDATE".equals(value)){
			if(str == null || "".equals(str)){
			}else{
				whereClaus.append( " and o." + value + " > '" + str + "'"); 
			}	
		}else if("FINISHDATE".equals(value)){
			if(str == null || "".equals(str)){
			}else{
				whereClaus.append(" and o." + value + " < '" + str + "'"); 
			}
		}else if("SIGNALTYPE".equals(value)){
			if(str == null || "".equals(str)){
			}else{
				str = getWhereIn(str);
				whereClaus.append(" and o." + value + " in (" + str +") "); 
			}
		}else if("CUSTOMERTYPE".equals(value)){
			if(str == null || "".equals(str)){
			}else{
				str = getWhereIn(str);
				whereClaus.append(" and ci." + value + " in (" + str +") "); 
			}
		}
	}
	/**
	 * ��ȡѡ����ֵ
	 * @param sColName
	 * @param req
	 * @return
	 */
	public String getValue(String sColName ,HttpServletRequest req) {
		String sValue = "";
		try {
			sColName = sColName.toUpperCase();
			sColName = "DOFILTER_DF_" + sColName + "_1_VALUE";
			if (req.getParameter(sColName) == null)
				return "";
			sValue = URLDecoder.decode(req.getParameter(sColName)
					.toString(), "UTF-8");
			sValue=StringFunction.replace(sValue, " ","%");
			return sValue;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return sValue;
	}
	
	/**
	 * ��ȡin ������
	 * @param value
	 * @return
	 */
	private String getWhereIn(String value){
		StringBuffer returnValue = new StringBuffer("'");
		String val[] = value.split("\\|");
		for(int i = 0 ; i<val.length ;i++){
			if(i != val.length-1){returnValue.append(val[i] + "','");}
			else{
				returnValue.append(val[i] + "'");
			}
		}
		return returnValue.toString();
	}
}
