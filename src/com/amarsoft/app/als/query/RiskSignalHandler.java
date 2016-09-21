package com.amarsoft.app.als.query;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * ���ٲ�ѯԤ���ź�ͳ�ƴ�����
 * @author Administrator
 *
 */
public class RiskSignalHandler extends CommonHandler {
	//��ʼ������
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		super.initDisplayForEdit(bo);
		//��ȡ��ѯ����
		String whereClause = asDataObject.getJboWhere();
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.RISK_SIGNAL");
		@SuppressWarnings("unchecked")
		List<BizObject> boList = bm.createQuery("select SIGNALSTATUS from o,jbo.app.CUSTOMER_INFO ci where " + whereClause)
		.setParameter("inputorgid", curUser.getOrgSortNo() +"%").getResultList(false);
		//��ֵ�����в���
		int newSignle = 0;
		int affirming = 0;
		int valid = 0;
		int novalid = 0;
		int sum1 = 0;
		//������ѯ��ÿһ���ж��ٸ���¼
		if(boList.size() != 0){
			sum1 = boList.size();
			for(BizObject bo1 : boList){
				String status = bo1.getAttribute("SIGNALSTATUS").getString();
				if("10".equals(status)) newSignle += 1;
				if("15".equals(status) || "20".equals(status)) affirming += 1;
				if("30".equals(status)) valid += 1;
				if("40".equals(status)) novalid += 1;
			}
		}
		
		bo.setAttributeValue("newSignle", newSignle);
		bo.setAttributeValue("affirming", affirming);
		bo.setAttributeValue("valid", valid);
		bo.setAttributeValue("novalid", novalid);
		bo.setAttributeValue("sum1", sum1);
	}
}
