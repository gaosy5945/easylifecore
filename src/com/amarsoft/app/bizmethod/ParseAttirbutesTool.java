package com.amarsoft.app.bizmethod;

import java.util.HashMap;
/**
 * 
 * @author �����Ŷ�  ����RunJavamethodTrans�����������
 *
 */
public class ParseAttirbutesTool {

	public static  HashMap<String,String> parseParas(String paras,String splitStr,String paraSplit){
		if(paras==null) return null;
		if(splitStr==null) splitStr = "@~@";
		if(paraSplit==null) paraSplit = "@@";
		HashMap<String,String> paraMap = new HashMap<String,String>();
		
		String[] parasStr = paras.split(splitStr);//��ȡ�����еĲ�����
		if(parasStr==null||parasStr.length==0) return paraMap;
		for(String temp:parasStr){//����������
			paraMap.put(temp.split(paraSplit)[0], temp.split(paraSplit)[1]);//����ÿһ����������ֵ
		}
		return paraMap;
		
	}
	
	public static HashMap<String,String> parseParas(String paras){
		return parseParas(paras,null,null);
	}

}
