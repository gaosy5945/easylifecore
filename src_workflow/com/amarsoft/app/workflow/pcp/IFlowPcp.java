package com.amarsoft.app.workflow.pcp;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public interface IFlowPcp {
	
	/**
	 * ��ȡ��������ض���
	 * @param fi ����ʵ������
	 * @param fp ���̽׶ζ������
	 * @return
	 * @throws Exception
	 */
	public String getFlowPool(BusinessObject fi, BusinessObject fp, BusinessObjectManager bomanager) throws Exception;
	
	/**
	 * ��ȡ�����û��б�
	 * @param fi ����ʵ������
	 * @param fp ���̽׶ζ������
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getFlowUsers(BusinessObject fi, BusinessObject fp, BusinessObjectManager bomanager) throws Exception;
	
}
