package com.amarsoft.app.base.script;

import java.util.List;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.apache.commons.jexl2.Expression;
import org.apache.commons.jexl2.JexlContext;
import org.apache.commons.jexl2.JexlEngine;
import org.apache.commons.jexl2.MapContext;

import com.amarsoft.app.base.antlr.OQLLexer;
import com.amarsoft.app.base.antlr.OQLParser;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.config.impl.XMLConfig;
import com.amarsoft.app.base.script.operater.CompareOperator;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

public class ScriptConfig extends XMLConfig{
	public static final String SCRIPT_TYPE_JAVA="java";
	public static final String SCRIPT_TYPE_EL="el";
	
	private static BusinessObjectCache operatorClassCache=new BusinessObjectCache(100);
	private static BusinessObjectCache OQCache=new BusinessObjectCache(10000);
	private static BusinessObjectCache ELScriptCache=new BusinessObjectCache(2000);

	//单例模式
	private static ScriptConfig sc = null;
	
	private ScriptConfig(){
		
	}
	
	public static ScriptConfig getInstance(){
		if(sc == null)
			sc = new ScriptConfig();
		return sc;
	}
	
	public static ParseTree getParseTree(String sql) {
		ParseTree tree=(ParseTree)OQCache.getCacheObject(sql);
		if(tree==null){
			OQLLexer lexer=new OQLLexer(new ANTLRInputStream(sql));
			CommonTokenStream tokens = new CommonTokenStream(lexer);
			OQLParser parser=new OQLParser(tokens);
			tree=parser.equality_expression();
			OQCache.setCache(sql, tree);
		}
		return tree;
	}
	
	public static CompareOperator getCompareOperator(String operator) throws InstantiationException, IllegalAccessException, ClassNotFoundException{
		Class<CompareOperator> c=(Class<CompareOperator>)operatorClassCache.getCacheObject(operator);
		if(c==null){
		}
		return c.newInstance();
	}
	
	/**
	 * 通过java表达式直接调用实例对象相关方法和属性，示例代码如下：
	 * 
	 *	BusinessObject bo = BusinessObject.createBusinessObject();
	 *	bo.setAttributeValue("SerialNo", "2014");
	 *	bo.setAttributeValue("BusinessSum", 1000d);
	 *	bo.setAttributeValue("BusinessTerm", 10);
	 *	bo.setAttributeValue("Object", bo);
	 *	
	 *	BusinessObject bd = BusinessObject.createBusinessObject();
	 *	bd.setAttributeValue("SerialNo", "2015");
	 *	bd.setAttributeValue("BusinessSum", 100d);
	 *	bd.setAttributeValue("BusinessTerm", 1);
	 *	bo.appendBusinessObject("bd", bd);
	 *
	 *	System.out.println(ScriptCache.executeELScript("bo.getBusinessObject('bd').getString('SerialNo')","bo",bo));
	 * 
	 * 注意：为了加快速度，所有表达式都在编译成Expression后进行缓存，缓存后多线程安全性未进行测试。
	 * @param expression
	 * @param parameters
	 * @return
	 */
	public static Object executeELScript(String expression,Object... parameters){
		JexlEngine jexl = new JexlEngine();
		Expression e = (Expression)ELScriptCache.getCacheObject(expression);
        if(e == null) e = jexl.createExpression( expression );
        JexlContext jc = new MapContext();
        for(int i=0;i<parameters.length;i++){
        	jc.set((String)parameters[i],parameters[i+1]);
        	i++;
        }
        Object o = e.evaluate(jc);
        return o;
	}
	
	public static double getELDoubleValue(String expression,Object... parameters) throws Exception{
		try{
			Object result=executeELScript(expression,parameters);
			if(result==null||result.equals(0)) return 0d;
			else return (Double)result;
		}
		catch(Exception e){
			Exception e1 = new JBOException("执行表达式{"+expression+"}时出错！");
			e1.addSuppressed(e);
			throw e1;
		}
	}
	
	public static boolean getELBooleanValue(String expression,Object... parameters) throws Exception{
		try{
			Object result=executeELScript(expression,parameters);
			if(result==null) return false;
			else return (boolean)result;
		}
		catch(Exception e){
			Exception e1 = new JBOException("执行表达式{"+expression+"}时出错！");
			e1.addSuppressed(e);
			throw e1;
		}
	}
	
	public static String getELStringValue(String expression,Object... parameters) throws Exception{
		try{
			Object result=executeELScript(expression,parameters);
			if(result==null) return null;
			else return (String)result;
		}
		catch(Exception e){
			Exception e1 = new JBOException("执行表达式{"+expression+"}时出错！");
			e1.addSuppressed(e);
			throw e1;
		}
	}

	public synchronized void init(String file,int size) throws Exception {
		BusinessObjectCache operatorClassCache=new BusinessObjectCache(size);
		Document document = getDocument(ARE.replaceARETags(file));
		Element root = document.getRootElement();
		
		List<Element> operatorElements = root.getChild("ExpressionOperators").getChildren("ExpressionOperator");
		if (operatorElements!=null) {
			for (Element e : operatorElements) {
				String operator=e.getAttributeValue("id");
				String className=e.getAttributeValue("class");
				Class<?> c = Class.forName(className);
				operatorClassCache.setCache(operator, c);
			}
		}
		
		ScriptConfig.operatorClassCache = operatorClassCache;
	}

}
