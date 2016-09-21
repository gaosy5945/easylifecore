package com.amarsoft.app.lending.bizlets;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class CheckBankRoleHandler extends CommonHandler{

	/**
	 * @hzcheng 2013-11-27
	 * 
	 * ������֯��ʽǣͷ���ж�
	 * history 2014-04-17 xfliu  ������У���Ϊ����ʱ����Ѿ�����ǣͷ�У���ֻ�ṩ����ѡ������ǣͷ��ѡ�
	 *                           ����ѯ�����޸Ĵ˷���������Ӱ�������߼�
	 */
	private String objectNo = "";
	private String objectType = "";

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}
	/**
	 * �ж�ǣͷ�м�¼�Ƿ����
	 * @param objectNo
	 * @param objectType
	 * @return
	 * @throws JBOException
	 */
	public static String isExistLeadRole(String objectNo,String objectType) throws JBOException{
		BizObjectManager m = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PROVIDER");
		List<BizObject> boList= m.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getResultList(false);
		String returnMessage = "FALSE";
		if(boList.size()>0){
			returnMessage = "TRUE";
		}
		return returnMessage;
	}
	/**
	 * �ж�ǣͷ�м�¼�Ƿ����
	 * @return
	 * @throws Exception
	 */
	public String isExistLeadRole() throws Exception{
		return isExistLeadRole(objectNo,objectType);
	}
}