package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class UpdateTelIsNewHandler  extends CommonHandler {

	@Override
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
		String CustomerID = bo.getAttribute("CustomerID").getString();
		String TelType = bo.getAttribute("TelType").getString();
		String IsInformation = bo.getAttribute("ISINFORMATION").getString();
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_TEL");
		tx.join(table);
		if("PB2004".equals(TelType)){//���绰����Ϊ�ֻ�ʱ�������Ƿ���ܶ��ţ��������ֻ���ʷ��Ϣ����Ϊ�����ܶ���
				BizObjectQuery q1 = table.createQuery("TelType=:TelType and CustomerID=:CustomerID and IsInformation='1'")
						.setParameter("TelType", TelType).setParameter("CustomerID", CustomerID);
				BizObject pr1 = q1.getSingleResult(false);
				String SerialNoIT = "";
				if(pr1!=null)
				{
					SerialNoIT = pr1.getAttribute("SerialNo").getString();
					updateInformationType(SerialNoIT,tx);
				}
		}
		//������绰��Ϣʱ����ѯ�ÿͻ���ʷ�绰��¼������е绰��Ϣ������ʷ�绰��Ϣ�����µ绰����Ϊ�������µĵ绰
		BizObjectQuery q = table.createQuery("TelType=:TelType and CustomerID=:CustomerID and IsNew='1'")
				.setParameter("TelType", TelType).setParameter("CustomerID", CustomerID);
		BizObject pr = q.getSingleResult(false);
		String serialNo = "";
		if(pr!=null)
		{
			serialNo = pr.getAttribute("SerialNo").getString();
			updateCT(serialNo,tx);
		}
	}
	
	public String updateCT(String serialNo,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_TEL");
		tx.join(bm);
		
		bm.createQuery("update O set IsNew='0',UPDATEDATE=:UPDATEDATE Where SerialNo=:SerialNo")
			.setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SerialNo", serialNo).executeUpdate();
		return "SUCCEED";
	}
	
	public String updateInformationType(String serialNo,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_TEL");
		tx.join(bm);
		
		bm.createQuery("update O set IsInformation='0',UPDATEDATE=:UPDATEDATE Where SerialNo=:SerialNo")
			.setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SerialNo", serialNo).executeUpdate();
		return "SUCCEED";
	}
	
}
