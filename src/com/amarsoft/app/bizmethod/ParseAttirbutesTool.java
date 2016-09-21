package com.amarsoft.app.bizmethod;

import java.util.HashMap;
/**
 * 
 * @author 核算团队  解析RunJavamethodTrans方法传入参数
 *
 */
public class ParseAttirbutesTool {

	public static  HashMap<String,String> parseParas(String paras,String splitStr,String paraSplit){
		if(paras==null) return null;
		if(splitStr==null) splitStr = "@~@";
		if(paraSplit==null) paraSplit = "@@";
		HashMap<String,String> paraMap = new HashMap<String,String>();
		
		String[] parasStr = paras.split(splitStr);//获取到所有的参数窜
		if(parasStr==null||parasStr.length==0) return paraMap;
		for(String temp:parasStr){//解析参数串
			paraMap.put(temp.split(paraSplit)[0], temp.split(paraSplit)[1]);//解析每一个参数串的值
		}
		return paraMap;
		
	}
	
	public static HashMap<String,String> parseParas(String paras){
		return parseParas(paras,null,null);
	}

}
