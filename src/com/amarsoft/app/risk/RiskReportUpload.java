package com.amarsoft.app.risk;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class RiskReportUpload {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter){
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx){
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager){
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	public String updateSortNo(JBOTransaction tx){
		
		String docNo = (String)inputParameter.getValue("DocNo");
		try {
			BizObjectManager bmRWO = JBOFactory.getFactory().getManager("jbo.doc.DOC_LIBRARY");
			bmRWO.createQuery("update O set O.SortNo = '0' where DocNo =:DocNo")
			.setParameter("DocNo", docNo)
			.executeUpdate();
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "false";
		}
		return "true";
	}
	
	
	public String updateIsOrNoSortNo(JBOTransaction tx){
		
		String docNo = (String)inputParameter.getValue("DocNo");
		String phaseActionType = (String)inputParameter.getValue("PhaseActionType");
		
		try {
			BizObjectManager bmRWO = JBOFactory.getFactory().getManager("jbo.doc.DOC_LIBRARY");
			if("01".equals(phaseActionType)){
				bmRWO.createQuery("update O set O.SortNo = '1' where DocNo =:DocNo")
				.setParameter("DocNo", docNo)
				.executeUpdate();
			}else{
				bmRWO.createQuery("update O set O.SortNo = '2' where DocNo =:DocNo")
				.setParameter("DocNo", docNo)
				.executeUpdate();
			}
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "false";
		}
		return "true";
	}
	
	public String getReportStatus(JBOTransaction tx) throws JBOException{
		
		String result = "true";
		String docNo = (String)inputParameter.getValue("DocNo");
		String userID = (String)inputParameter.getValue("UserID");
		
		BizObjectManager bmDL = JBOFactory.getFactory().getManager("jbo.doc.DOC_LIBRARY");
		BizObject boDL = bmDL.createQuery("DOCNO=:DOCNO").setParameter("DOCNO", docNo).getSingleResult(false);
		
		String sortNo = boDL.getAttribute("SortNo").getString();
		String inputUserID = boDL.getAttribute("INPUTUSERID").getString();
		
		if("1".equals(sortNo) || !userID.equals(inputUserID)){
			
			result = "false";
		} 
		return result;
	}
}
