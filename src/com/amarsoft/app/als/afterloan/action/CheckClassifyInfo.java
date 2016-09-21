package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class CheckClassifyInfo {
	private String serialNo;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String check(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		tx.join(bom);
		BizObjectQuery bq = bom.createQuery("SerialNo=:SerialNo");
		bq.setParameter("SerialNo", this.serialNo);

		BizObject cr = bq.getSingleResult(false);
		if("".equals(cr.getAttribute("REMARK").getString())||cr.getAttribute("REMARK").getString() ==null || "".equals(cr.getAttribute("ADJUSTEDGRADE").getString())||cr.getAttribute("ADJUSTEDGRADE").getString() ==null){
			return "请补填信息再提交！";		
		}else{
			return "true";	
		}
	}
}
