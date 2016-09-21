package com.amarsoft.app.als.credit.apply.action;


import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CheckStopApprove {
	private JSONObject inputParameter;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}		
	
	public String isStopApprove(JBOTransaction tx) throws JBOException {
		this.tx = tx;
		String applySerialNo = (String)inputParameter.getValue("applySerialNo");
		String isStopApprove = "0";
		/*
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.rds.OUTMESSAGE");
			this.tx.join(bm);
		    BizObject result = bm.createQuery("select REINITIATEFLAG from O where serialNo = (select max(serialNo) from O where objectno =:objectno and objecttype = 'jbo.app.BUSINESS_APPLY')").setParameter("objectno",applySerialNo).getSingleResult(true);
		    if(result == null){
		    	return "0"; //可以发起复议
		    }
		    isStopApprove = result.getAttribute("REINITIATEFLAG").getString();
	    */
		return isStopApprove;
	}
}
