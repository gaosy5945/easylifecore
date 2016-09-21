package com.amarsoft.app.als.sys.function.model;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * Function����
 * @author Administrator
 *
 */
public abstract class FunctionBizlet{
	
	/**
	 * ����ִ��������������Function��ͬһ�������
	 */
	private FunctionResult result=new FunctionResult();
	
	/**
	 * �����߼������࣬���ؽ���Ƿ�ɹ� ��
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public abstract boolean run(JBOTransaction tx,BusinessObject parameterPool) throws Exception;
	
	/**
	 * ��ȡ������
	 * @return
	 * @throws Exception
	 */
	public final FunctionResult getResult(){
		return result;
	}
	
	/**
	 * ���÷��ؽ��
	 * @param key ���ؽ������
	 * @param value ���ؽ��ֵ
	 * @throws Exception 
	 */
	public final void setOutputParameter(String key,Object value) throws Exception{
		result.setOutputParameter(key, value);
	}
	
	/**
	 * ���ô�����Ϣ
	 * @param key ���ؽ������
	 * @param value ���ؽ��ֵ
	 * @throws Exception 
	 */
	/**
	 * ���÷�����Ϣ
	 * @param messageCode 
	 * @param messageDesc
	 * @param functionItemID
	 */
	public final void setMessage(String messageLevel,String messageCode,String messageDesc){
		result.setMessage(messageLevel,messageCode, messageDesc, "");
	}
}
