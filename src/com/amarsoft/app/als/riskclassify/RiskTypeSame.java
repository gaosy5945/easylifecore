package com.amarsoft.app.als.riskclassify;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class RiskTypeSame {
	private String serialNo;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		serialNo = serialNo.replace("@", ",");
		serialNo = serialNo.substring(1);
		this.serialNo = serialNo;
	}

	public Object execute(JBOTransaction tx) throws Exception {
		String returnValue = "";
		BizObjectManager bm = JBOFactory
				.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		tx.join(bm);
		String sSql = " select count(distinct CLASSIFYMETHOD) as v.count from O where SERIALNO in("
				+ serialNo + " )";
		BizObjectQuery boq = bm.createQuery(sSql);
		returnValue = boq.getSingleResult(false).getAttribute("count").toString();
		if (returnValue == null) {
			returnValue = "";
		}
		return returnValue;
	}

}

