package com.amarsoft.app.base.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectQuery;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectKey;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.jbo.ql.ElementIterator;
import com.amarsoft.are.jbo.ql.JBOAttribute;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;

/**
 * JBO工具类
 * @author syang,ghShi
 * @date 2013/11/18
 */
public class JBOHelper {
	
	/**
	 * 生成jbo查询，以Map方式指定参数值
	 * @param tx
	 * @param jboClass
	 * @param jbosql
	 * @param parameterString
	 * @return
	 * @throws JBOException 
	 */
	public static BizObjectQuery getQuery(String jboClass,String jbosql,List<DataElement> parameterList,JBOTransaction tx) throws JBOException{
		Map<String,Object> parameterMap = new HashMap<String,Object>();
		for(DataElement parameter:parameterList){
			parameterMap.put(parameter.getName(), parameter.getValue());
		}
		return JBOHelper.getQuery(jboClass, jbosql, parameterMap,tx);
	}
	
	
	/**
	 * 生成jbo查询，以Map方式指定参数值
	 * @param tx
	 * @param jboClass
	 * @param jbosql
	 * @param parameterString
	 * @return
	 * @throws JBOException 
	 */
	public static BizObjectQuery getQuery(String jboClass,String jbosql,Map<String,Object> parameters,JBOTransaction tx) throws JBOException{
		BizObjectManager bizManager = JBOFactory.getBizObjectManager(jboClass);
		if(tx!=null)tx.join(bizManager);
		BizObjectQuery q= JBOHelper.getQuery(bizManager, jboClass, jbosql, parameters);
		return q;
	}
	
	/**
	 * 生成jbo查询，以Map方式指定参数值
	 * @param tx
	 * @param jboClass
	 * @param jbosql
	 * @param parameterString
	 * @return
	 * @throws JBOException 
	 */
	private static BizObjectQuery getQuery(BizObjectManager bizManager,String jboClass,String jbosql,Map<String,Object> parameters) throws JBOException{
		BizObjectQuery query = bizManager.createQuery(jbosql);
		if(parameters!=null){
			for(Iterator<String> it=parameters.keySet().iterator();it.hasNext();){
				String key = it.next();
				query.setParameter(key, (String)parameters.get(key));
			}
		}
		return query;
	}
	
	public static BizObjectQuery getQuery(String jboClass,String jbosql,String parameterString,JBOTransaction tx) throws JBOException{
		return getQuery(jboClass,jbosql,parameterString,";",",",tx);
	}
	
	
	public static BusinessObjectQuery getQuery(String jboClass,Map<String,String> queryAttributes,String whereString,String parameterString,JBOTransaction tx) throws JBOException{
		return JBOHelper.getQuery(jboClass, queryAttributes, whereString, parameterString, ";", ",", tx);
	}
	/**
	 * 生成jbo查询，parameterString样式为para1=value1;para2 in a,b,c;para3 like value3%
	 * @param tx
	 * @param jboClass
	 * @param jbosql
	 * @param parameterString
	 * @return
	 * @throws JBOException 
	 */
	public static BusinessObjectQuery getQuery(String jboClass,Map<String,String> queryAttributes,String whereString,String parameterString,String parametersplit,String insplitChar,JBOTransaction tx) throws JBOException{
		String queryString = "";
		Map<String,String[]> queryAttributeMap=new HashMap<String,String[]>();
		queryString+="select ";
		for(String attributeName:queryAttributes.keySet()){
			String actualAttributeName = queryAttributes.get(attributeName);
			if(StringX.isEmpty(actualAttributeName)){
				actualAttributeName=attributeName;
			}
			String[] s=parseSelectAttribute(actualAttributeName);

			queryAttributeMap.put(attributeName, s);
			if(s[0].equalsIgnoreCase("O")){
				queryString+=s[0]+"."+actualAttributeName+",";
			}
			else{
				queryString+=s[0]+"."+actualAttributeName+" as v."+attributeName+",";
			}
			
		}
		queryString=queryString.substring(0,queryString.length()-1);
		queryString+= " "+whereString;
		
		
		if(insplitChar==null||insplitChar.length()==0) insplitChar=",";
		if(parametersplit==null||parametersplit.length()==0) parametersplit=";";
		BizObjectQuery query = JBOHelper.getQuery(jboClass, queryString, parameterString, parametersplit, insplitChar, tx);
		BusinessObjectQuery businessObjectQuery = new BusinessObjectQuery(query);
		businessObjectQuery.init(queryAttributeMap, queryString);
		return businessObjectQuery;
	}
	
	public static String[] parseSelectAttribute(String expression) throws JBOException{
		String[] s=new String[2];
		ElementIterator ei=new ElementIterator(expression);
		if(ei.hasNext()){
			JBOAttribute j= (JBOAttribute)ei.next();
			if(ei.hasNext()){//超过两个element
				s[0]="";
				s[1]=expression;
			}
			else{
				
				s[0]=j.getClassAlias();
				s[1]=j.getName();
			}
		}
		return s;
	}
	
	/**
	 * 生成jbo查询，parameterString样式为para1=value1;para2 in a,b,c;para3 like value3%
	 * @param tx
	 * @param jboClass
	 * @param jbosql
	 * @param parameterString
	 * @return
	 * @throws JBOException 
	 */
	public static BizObjectQuery getQuery(String jboClass,String jbosql,String parameterString,String parametersplit,String insplitChar,JBOTransaction tx) throws JBOException{
		if(insplitChar==null||insplitChar.length()==0) insplitChar=",";
		if(parametersplit==null||parametersplit.length()==0) parametersplit=";";
		
		BusinessObject[] parameterArray = parseJBOParamter(parameterString,parametersplit,insplitChar);
		return JBOHelper.getQuery(jboClass, jbosql, parameterArray, tx);
	}
	
	public static BizObjectQuery getQuery(BizObjectKey[] bizObjectKeyArray,JBOTransaction tx) throws JBOException{
		BizObjectClass clazz = bizObjectKeyArray[0].getBizObjectClass();
		String[] keys = clazz.getKeyAttributes();
		if(keys == null || keys.length <= 0) throw new JBOException("该对象【"+clazz.getRoot().getAbsoluteName()+"】未定义主键！");
		String jbosql = "(";
		int parameterCount =bizObjectKeyArray.length* keys.length;
		BusinessObject[] parameterArray = new BusinessObject[parameterCount];
		
		int m=0;
		for(int j=0;j<bizObjectKeyArray.length;j++){
			String keySql="(";
			for(int i = 0; i < keys.length; i++){
				if(i>0) keySql += " and ";
				keySql += " "+keys[i]+"=:"+keys[i]+m;
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", keys[i]+m);
				parameter.setAttributeValue("Value", bizObjectKeyArray[j].getAttribute(keys[i]));
				parameter.setAttributeValue("Operate", "=");
				parameterArray[m]=parameter;
				m++;
			}
			keySql+=")";
			if(j>0)jbosql+=" or ";
			jbosql+=keySql;
		}
		jbosql+=")";
		return JBOHelper.getQuery(clazz.getRoot().getAbsoluteName(), jbosql, parameterArray, tx);
	}
	
	public static BizObjectQuery getQuery(String jboClass,String jbosql,BusinessObject[] parameterArray,JBOTransaction tx) throws JBOException{
		for(BusinessObject parameter:parameterArray){
			String parameterName = parameter.getString("Name");
			if(StringX.isEmpty(parameterName)) continue;
			String operator = parameter.getString("Operate");
			if(StringX.isEmpty(operator)) operator="=";
			operator=operator.trim();
			
			if(operator.equalsIgnoreCase("in")) {
				Object value = parameter.getObject("Value");
				String insql="";
				Object[] valueArray = (Object[])value;
				for(int i=0;i<valueArray.length;i++){
					insql +=","+":SYS_GEN_"+parameterName+"_"+i;
				}
				if(insql.length()>0) insql=insql.substring(1);
				jbosql = StringHelper.replaceAllIgnoreCase(jbosql, ":"+parameterName, insql);
			}
		}

		BizObjectManager manager = JBOFactory.getBizObjectManager(jboClass);
		if(tx!=null)tx.join(manager);
		BizObjectQuery query = manager.createQuery(jbosql);
		
		for(BusinessObject parameter:parameterArray){
			String parameterName = parameter.getString("Name");
			
			if(StringX.isEmpty(parameterName)) continue;
			String operator = parameter.getString("Operate");
			if(StringX.isEmpty(operator)) operator="=";
			operator=operator.trim();
			
			if(operator.equalsIgnoreCase("in")) {
				Object[] values = (Object[])parameter.getObject("Value");
				for(int i=0;i<values.length;i++){
					String parameterName_IN ="SYS_GEN_"+parameterName+"_"+i;
					query.setParameter(parameterName_IN, (String)values[i]);
				}
			}
			else{
				DataElement dataElement = new DataElement(parameterName);
				dataElement.setValue(parameter.getObject("Value"));
				query.setParameter(dataElement);
			}
		}
		return query;
	}

	public static BusinessObject[] parseJBOParamter(String parameterString,String splitChar,String insplitChar) throws JBOException{
		if(parameterString==null||parameterString.length()==0) return new BusinessObject[0];
		if(StringX.isEmpty(splitChar)) splitChar=";";
		if(StringX.isEmpty(insplitChar)) insplitChar=",";
		
		String[] s1= parameterString.split(splitChar);
		BusinessObject[] paramters = new BusinessObject[s1.length];
		
		int i=0;
		for(String s2:s1){
			s2 = s2.trim();
			String parameterName="";
			String parameterOperater="";
			Object parameterValue=null;

			if(s2.toUpperCase().endsWith(" IN")||s2.toUpperCase().indexOf(" IN ")>0){
				if(s2.toUpperCase().endsWith(" IN"))
					parameterName = s2.substring(0,s2.toUpperCase().indexOf(" IN")).trim();
				else 
					parameterName = s2.substring(0,s2.toUpperCase().indexOf(" IN ")).trim();
				parameterOperater = "in";
				
				String inValueString = "";
				if(s2.toUpperCase().endsWith(" IN"))
					inValueString = s2.substring(s2.toUpperCase().indexOf(" IN")+3).trim();
				else
					inValueString = s2.substring(s2.toUpperCase().indexOf(" IN ")+4).trim();
				parameterValue = inValueString.split(insplitChar);
			}
			else{
				parameterName= s2.substring(0,s2.indexOf("=")).trim();
				parameterOperater = "=";
				parameterValue = s2.substring(s2.indexOf("=")+1).trim();
			}
			BusinessObject parameter = BusinessObject.createBusinessObject();
			parameter.setAttributeValue("Name", parameterName);
			parameter.setAttributeValue("Operate", parameterOperater);
			parameter.setAttributeValue("Value", parameterValue);
			paramters[i]=parameter;
			i++;
		}
		return paramters;
	}
}
