package com.amarsoft.app.als.project;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class JudgeIsAlterApply {
	private JSONObject inputParameter;
	String flag = "";
	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	public String judgeIsAlterApply(JBOTransaction tx) throws Exception{
		String AgreementNo = (String)inputParameter.getValue("AgreementNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("AgreementNo=:AgreementNo and Status in ('11','12','15')").setParameter("AgreementNo", AgreementNo);
		List<BizObject> DataLast = q.getResultList(false);
		if(DataLast != null && !DataLast.isEmpty()){
			flag = "1";
		}
		
		return flag;
	}
}
