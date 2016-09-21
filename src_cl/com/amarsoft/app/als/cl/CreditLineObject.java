package com.amarsoft.app.als.cl;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;


/**
 * Class <code>CreditLineObject</code>�Ƕ�ȶ���Ļ����ӿ�. 
 *
 * @author  xjzhao
 * @version 1.0, 20120406
 */

public abstract class CreditLineObject extends CreditObject {
	/**
	 * ���ڱ����ȶ�������Ĳ����Ϣ����CL_INFO��
	 */
	protected List<BusinessObject> splitObjects=null;
	/**
	 * ���ڱ����ȿ������Ž��
	 */
	public double doSum = 0.0;
	/**
	 * ���浥�����Ŵ������ռ���ϲ������
	 */
	protected double useBalance = 0.0d;
	
	/**
	 * ���浥�����Ŵ�����ռ���ϲ��Ƚ��
	 */
	protected double useSum = 0.0d;
	
	/**
	 *@param BusinessObject ͨ���ⲿ���벻ͨ�����ݿ����ӳ�ʼ��
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(BusinessObject creditObject) throws SQLException,Exception{
		this.CreditObject = creditObject;
	}
	
	/**
	 *@param BusinessObject ͨ���ⲿ���벻ͨ�����ݿ����ӳ�ʼ��
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(BusinessObject creditObject,List<BusinessObject> splitObjects) throws SQLException,Exception{
		if(creditObject!=null) load(creditObject);
		if(splitObjects!=null) this.splitObjects = splitObjects;
	}
	
}
