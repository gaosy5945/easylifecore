package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class UpdateAddressIsNewHandler extends CommonHandler {
	@Override
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
		String CustomerID = bo.getAttribute("ObjectNo").getString();
		String AddressType = bo.getAttribute("AddressType").getString();
		
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.PUB_ADDRESS_INFO");
		tx.join(table);
		//当保存地址信息时，查询该客户历史地址记录，如果有地址信息，则将历史地址信息中最新地址更新为不是最新的地址
		BizObjectQuery q = table.createQuery("AddressType=:AddressType and ObjectNo=:ObjectNo and ObjectType='jbo.customer.CUSTOMER_INFO' and IsNew='1'")
				.setParameter("AddressType", AddressType).setParameter("ObjectNo", CustomerID);
		BizObject pr = q.getSingleResult(false);
		String serialNo = "";
		if(pr!=null)
		{
			serialNo = pr.getAttribute("SerialNo").getString();
			updatePAI(serialNo,tx);
		}
	}
	
	public String updatePAI(String serialNo,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.PUB_ADDRESS_INFO");
		tx.join(bm);
		
		bm.createQuery("update O set IsNew='0',UpdateDate=:UpdateDate Where SerialNo=:SerialNo")
			.setParameter("UpdateDate", DateHelper.getBusinessDate()).setParameter("SerialNo", serialNo).executeUpdate();
		return "SUCCEED";
	}
}
