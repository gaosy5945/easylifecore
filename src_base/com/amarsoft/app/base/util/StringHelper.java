package com.amarsoft.app.base.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.control.model.Parameter;
/**
 * 字符串相关通用方法
 * @author ghShi
 *
 */
public class StringHelper {
	
	/**
	 * 替换字符串中{#key}的数据
	 * @param str
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String replaceString(String str,BusinessObject bo) throws Exception{
		if(str==null||str.equals("")) return "";
		try{
			List<String> paraList=StringHelper.getParameterList(str);
			for(String paraName:paraList){
				if(!bo.containsAttribute(paraName)) continue;
				String value=bo.getString(paraName);
				if(value==null) value="";
				paraName = AmarScriptHelper.SCRIPT_PARAMETER_STRING_START+paraName+AmarScriptHelper.SCRIPT_PARAMETER_STRING_END;
				str=StringHelper.replaceAllIgnoreCase(str,paraName, value);
			}
		}catch(Exception ex)
		{
			ARE.getLog().error("替换出错:"+str);
			throw ex;
		}
		return str;
	}
	
	/**
	 * 替换字符串中{#key}的数据
	 * @param str
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String replaceString(String str,String prestring,BusinessObject businessObject) throws Exception{
		if(str==null||str.equals("")) return "";
		List<String> paraList=StringHelper.getParameterList(str);
		for(String paraName:paraList){
			String parameterPre = paraName.substring(0,paraName.indexOf("."));
			String parameterName = paraName.substring(paraName.indexOf(".")+1);
			if(!parameterPre.equals(prestring)) continue;
			
			String value=businessObject.getString(parameterName);
			if(value==null) value="";
			paraName = AmarScriptHelper.SCRIPT_PARAMETER_STRING_START+paraName+AmarScriptHelper.SCRIPT_PARAMETER_STRING_END;
			str=StringHelper.replaceAllIgnoreCase(str,paraName, value);
		}
		return str;
	}
	
	/**
	 * 替换字符串中{#key}的数据,将其中的数据替换未空格
	 * @param str
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String replaceToSpace(String strScript) throws Exception{
		if(strScript==null||strScript.equals("")) return "";
		List<String> rightScriptParameterList=StringHelper.getParameterList(strScript);//参数List
		for(String paraName:rightScriptParameterList){
			strScript=StringHelper.replaceAllIgnoreCase(strScript, AmarScriptHelper.SCRIPT_PARAMETER_STRING_START+paraName+AmarScriptHelper.SCRIPT_PARAMETER_STRING_END, "");
		}
		return strScript;
	}
	
	/**
	 * 替换字符串中{#key}的数据
	 * @param str
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String replaceStringFullName(String str,BusinessObject businessObject,String flag) throws Exception{
		if(str==null||str.equals("")) return "";
		List<String> paraList=StringHelper.getParameterList(str);
		for(String paraName:paraList){
			String objectType = paraName.substring(0,paraName.lastIndexOf("."));
			String attributeID = paraName.substring(paraName.lastIndexOf(".")+1);
			String value=null;
			if(objectType.equals(businessObject.getBizClassName())){
				if(!businessObject.containsAttribute(attributeID))continue;
				else value=businessObject.getString(attributeID);
			}
			else{
				BusinessObject subobject = businessObject.getBusinessObject(objectType);
				if(subobject==null)continue;
				else{
					if(!subobject.containsAttribute(attributeID))continue;
					else value=subobject.getString(attributeID);
				}
			}
			if(value==null) value="";
			paraName = AmarScriptHelper.SCRIPT_PARAMETER_STRING_START+paraName+AmarScriptHelper.SCRIPT_PARAMETER_STRING_END;
			str=StringHelper.replaceAllIgnoreCase(str,paraName, value);
		}
		return str;
	}
	
	/**
	 * 替换字符串中{#key}的数据
	 * @param str
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String replaceStringFullName(String str,BusinessObject businessObject) throws Exception{
		return replaceStringFullName(str,businessObject,"");
	}
	
	/**
	 * 初始化参数 {#arg}匹配出arg
	 * @param parameter
	 * @throws Exception
	 */
	public static List<String> getParameterList(String parameter) throws Exception{
		List<String> list = new ArrayList<String>();
		Pattern p = Pattern.compile("\\"+AmarScriptHelper.SCRIPT_PARAMETER_STRING_START+"(.*?)\\"+AmarScriptHelper.SCRIPT_PARAMETER_STRING_END);
		Matcher match = p.matcher(parameter);
		while (match.find()){
			if(!list.contains(match.group(1).trim()))
				list.add(match.group(1).trim());
		}
		return list;
	}
	
	/**
	 * 获得替换后的数据
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public static String replaceString(String str,Map<String,Object> parameterMap) throws Exception{
		return replaceString(str,BusinessObject.createBusinessObject(parameterMap));
	}

	
	/**
	 * 获得替换后的数据
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public static String replaceString(String str,Page curPage) throws Exception{
		if(str==null||str.length()==0) return str;
		Vector<Parameter> paraList = curPage.getCurComp().getParameterList();
		for(Parameter para:paraList){
			String value=para.paraValue;
			if(value==null) value="";
			str=StringHelper.replaceAllIgnoreCase(str,AmarScriptHelper.SCRIPT_PARAMETER_STRING_START+para.paraName+AmarScriptHelper.SCRIPT_PARAMETER_STRING_END,value);
		}
		paraList = curPage.getParameterList();
		for(Parameter para:paraList){
			String value=para.paraValue;
			if(value==null) value="";
			str=StringHelper.replaceAllIgnoreCase(str,AmarScriptHelper.SCRIPT_PARAMETER_STRING_START+para.paraName+AmarScriptHelper.SCRIPT_PARAMETER_STRING_END,value);
		}
		return str;
	}
	
	/**
	 * 获得替换后的数据
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject replaceString(BusinessObject parameterIDArray,BusinessObject parameterValueArray) throws Exception{
		BusinessObject result = BusinessObject.createBusinessObject(parameterIDArray);
		String[] idarray=parameterIDArray.getAttributeIDArray();
		for(String id:idarray){
			String valueScript = parameterIDArray.getString(id);
			String value = StringHelper.replaceString(valueScript, parameterValueArray);
			value= StringHelper.replaceToSpace(value);
			result.setAttributeValue(id, value);
		}
		return result;
	}
	
	public static String replaceAllIgnoreCase(String s1, String s2, String s3) {
		if(s3==null)s3="";
	    Matcher localMatcher = Pattern.compile(Pattern.quote(s2),Pattern.CASE_INSENSITIVE).matcher(s1);
	    if(s3.indexOf("$") > -1) 
	    	s3 = s3.replaceAll("\\$", "\\\\\\$");
		return localMatcher.replaceAll(s3);
	}
	
	public static Map<String,Object> stringToHashMap(String s,String split,String operator){
		if(s==null||s.length()==0) return null;
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		if(split==null||split.length()==0) split=";";
		if(operator==null||operator.length()==0) operator="=";
		String[] s1= s.split(split);
		for(String s2:s1){
			String[] s3 = s2.split(operator);
			String key =s3[0];
			String value = "";
			if(s3.length>1)
				value=s2.substring(s2.indexOf(operator)+operator.length());
			map.put(key, value);
		}
		return map;
	}
	
	public static BusinessObject stringToBusinessObject(String objectType,String s,String split,String operator) throws Exception{
		if(s==null||s.length()==0) return null;
		BusinessObject map = BusinessObject.createBusinessObject(objectType);
		
		if(split==null||split.length()==0) split=";";
		if(operator==null||operator.length()==0) operator="=";
		String[] s1= s.split(split);
		for(String s2:s1){
			String[] s3 = s2.split(operator);
			String key =s3[0];
			String value = "";
			if(s3.length>1)
				value=s2.substring(s2.indexOf(operator)+operator.length());
			map.setAttributeValue(key, value);
		}
		return map;
	}
	
	public static BusinessObject stringToBusinessObject(String s,String split,String operator) throws Exception{
		return stringToBusinessObject(BusinessObject.OBJECT_TYPE_DEFAULT_NAME,s,split,operator);
	}

	public static boolean contains(String a, String b) {
		return contains(a,b,",");
	}
	
	public static boolean contains(String a, String b,String split) {
		if(a.startsWith(b+split)||a.endsWith(split+b)||a.indexOf(split+b+split)>=0||a.equals(b)) return true;
		else return false;
	}
	
	@SuppressWarnings("rawtypes")
	public static String parseToString(Object o){
		if(o==null) return null;
		else if(o instanceof String) return (String)o;
		else if(o instanceof Double){//转为字符，不要出现科学计数法
			return String.valueOf(o);
		}
		else if(o instanceof Integer){//转为字符，不要出现科学计数法
			return String.valueOf(o);
		}
		else if(o instanceof List){//以逗号分隔
			String stringValue = "";
			for(Object value:(List)o){
				stringValue+=","+value.toString();
			}
			if(stringValue.length()>0)stringValue=stringValue.substring(1);
			return stringValue;
		}
		else if(o instanceof String[]){//以逗号分隔
			String s1="";
			String[] s=(String[])o;
			for(String s2: s){
				if(s1=="") s1=s2;
				else s1+=","+s2;
			}
			return s1;
		}
		else if(o instanceof Set){//以逗号分隔
			String stringValue = "";
			for(Object value:(Set)o){
				stringValue+=","+value.toString();
			}
			if(stringValue.length()>0)stringValue=stringValue.substring(1);
			return stringValue;
		}
		else return String.valueOf(o); 
	}
}
