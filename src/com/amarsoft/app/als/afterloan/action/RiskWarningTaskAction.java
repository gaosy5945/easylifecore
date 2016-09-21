package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;


public class RiskWarningTaskAction {
	//参数
	private String serialNo;//流水
	private String returnValue = "Success";
	
	//三色预警定量处理提交动作
	public String TaskDtSubmit(JBOTransaction tx) throws Exception{
		BizObjectManager bm;
		try {
			bm = JBOFactory.getBizObjectManager("jbo.al.RISK_WARNING_SIGNAL");
			BizObject bo = bm.createQuery("serialno = :serialno")
						.setParameter("serialno", this.serialNo).getSingleResult(true);
			bo.setAttributeValue("STATUS", "1");
			bo.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
			bm.saveObject(bo);
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "提交出错：JBO执行失败";
		}
		return this.returnValue;
	}
	
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
}
