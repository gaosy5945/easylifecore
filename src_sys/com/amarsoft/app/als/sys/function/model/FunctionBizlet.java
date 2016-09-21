package com.amarsoft.app.als.sys.function.model;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * Function功能
 * @author Administrator
 *
 */
public abstract class FunctionBizlet{
	
	/**
	 * 功能执行输出结果，整个Function是同一个结果池
	 */
	private FunctionResult result=new FunctionResult();
	
	/**
	 * 进行逻辑处理类，返回结果是否成功 ，
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public abstract boolean run(JBOTransaction tx,BusinessObject parameterPool) throws Exception;
	
	/**
	 * 获取处理结果
	 * @return
	 * @throws Exception
	 */
	public final FunctionResult getResult(){
		return result;
	}
	
	/**
	 * 设置返回结果
	 * @param key 返回结果主键
	 * @param value 返回结果值
	 * @throws Exception 
	 */
	public final void setOutputParameter(String key,Object value) throws Exception{
		result.setOutputParameter(key, value);
	}
	
	/**
	 * 设置处理消息
	 * @param key 返回结果主键
	 * @param value 返回结果值
	 * @throws Exception 
	 */
	/**
	 * 设置返回信息
	 * @param messageCode 
	 * @param messageDesc
	 * @param functionItemID
	 */
	public final void setMessage(String messageLevel,String messageCode,String messageDesc){
		result.setMessage(messageLevel,messageCode, messageDesc, "");
	}
}
