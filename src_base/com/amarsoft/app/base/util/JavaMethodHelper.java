package com.amarsoft.app.base.util;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.dw.ui.util.StringMatch;

public class JavaMethodHelper {
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Object runStaticMethod(String function,BusinessObject parameterSet)throws Exception{
		if(function==null) return null;
		int i1 = function.indexOf("(");
		int j = function.substring(0,i1).lastIndexOf(".");//���(ǰ�����һ��"."
		//�������
		String className = function.substring(0, j);
		//�������û��.
		if(className.indexOf(".")==-1)
			className = "com.amarsoft.dict.als.manage." + className;
		
		//��÷�����
		String methodName = function.substring(j+1, i1);
		function = StringMatch.getContent(function, "\\([\\w\\W]+?\\)");
		String parameterString = function.substring(1, function.length()-1);//ȥ����������
		String[] parameterValueArrary = parameterString.split("\\,");
		Class[] parameterTypeArray = new Class[parameterValueArrary.length];

		for(int i=0;i<parameterValueArrary.length;i++){
			parameterTypeArray[i] = String.class;
			if(parameterValueArrary[i].startsWith("\"") || parameterValueArrary[i].startsWith("'")){//ȥ������
				parameterValueArrary[i] = parameterValueArrary[i].substring(1,parameterValueArrary[i].length()-1);
				parameterValueArrary[i]=StringHelper.replaceString(parameterValueArrary[i], parameterSet);
			}
			else{
				if(parameterSet.getString(parameterValueArrary[i])==null)
					parameterValueArrary[i] = "";
				else
					parameterValueArrary[i] = parameterSet.getString(parameterValueArrary[i]);
			}
		}
		
		//ͨ����������
		try{
		Object result;
		Class c = Class.forName(className);
		Method m = c.getMethod(methodName, parameterTypeArray);
		Object object=c;
		if(!Modifier.isStatic(m.getModifiers())){
			object=c.newInstance();
		}
		
		if(m.getParameterTypes()==null || m.getParameterTypes().length==0)
			result = m.invoke(object);
		else
			result = (String)m.invoke(object,(Object[])parameterValueArrary);
		return result;
		}
		catch(Exception e){
			Exception e1=new Exception("������{"+className+"}����{"+methodName+"}ʱ�����������{"+parameterString+"}");
			e1.addSuppressed(e);
			throw e1;
		}
	}
	
	public static Object runMethod(String function,BusinessObject businessObject)throws Exception{
		if(function==null) return null;
		int i1 = function.indexOf("(");
		int j = function.substring(0,i1).lastIndexOf(".");//���(ǰ�����һ��"."
		//�������
		String className = function.substring(0, j);
		//�������û��.
		if(className.indexOf(".")==-1)
			className = "com.amarsoft.dict.als.manage." + className;
		
		//��÷�����
		String methodName = function.substring(j+1, i1);
		function = StringMatch.getContent(function, "\\([\\w\\W]+?\\)");
		String parameterString = function.substring(1, function.length()-1);//ȥ����������
		String[] parameterArrary = parameterString.split("\\,");
		Class[] parameterTypeArray = new Class[parameterArrary.length];
		Object[] parameterValueArrary=new Object[parameterArrary.length];

		for(int i=0;i<parameterArrary.length;i++){
			parameterArrary[i]=parameterArrary[i].trim();
			if(parameterArrary[i].startsWith("\"") || parameterArrary[i].startsWith("'")){//ȥ������
				parameterTypeArray[i] = String.class;
				parameterArrary[i] = parameterArrary[i].substring(1,parameterArrary[i].length()-1);
			}
			else if(parameterArrary[i].startsWith("{#")){//ȥ������
				List<String> paraList=StringHelper.getParameterList(parameterArrary[i]);
				String paraName=paraList.get(0);
				String objectType = paraName.substring(0,paraName.lastIndexOf("."));
				String attributeID = paraName.substring(paraName.lastIndexOf(".")+1);
				Object value=null;
				if(objectType.equals(businessObject.getBizClassName())){
					if(!businessObject.containsAttribute(attributeID))continue;
					else value=businessObject.getObject(attributeID);
				}
				else{
					BusinessObject subobject = businessObject.getBusinessObject(objectType);
					if(subobject==null) value="";
					else{
						if(!subobject.containsAttribute(attributeID)) value="";
						else value=subobject.getObject(attributeID);
					}
				}
				if(value==null) value="";
				parameterTypeArray[i] = value.getClass();
				parameterValueArrary[i] =value;
			}
			else{//����
				if(parameterArrary[i].indexOf(".")>0){
					parameterTypeArray[i] = Double.class;
					parameterValueArrary[i] =Double.parseDouble(parameterArrary[i]);
				}
				else{
					parameterTypeArray[i] = Integer.class;
					parameterValueArrary[i] =Integer.parseInt(parameterArrary[i]);
				}
			}
		}
		
		//ͨ����������
		Object result;
		Class c = Class.forName(className);
		Method m = c.getMethod(methodName, parameterTypeArray);
		Object object=c;
		if(!Modifier.isStatic(m.getModifiers())){
			object=c.newInstance();
		}

		if(m.getParameterTypes()==null || m.getParameterTypes().length==0)
			result = m.invoke(object);
		else
			result = m.invoke(object,(Object[])parameterValueArrary);
		return result;
	}
}
