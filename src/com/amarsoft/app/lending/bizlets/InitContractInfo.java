package com.amarsoft.app.lending.bizlets;


import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.edoc.EDocPrint;
import com.amarsoft.are.jbo.JBOTransaction;

public class InitContractInfo{
	private String contractNo;
	
	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public String createDoc(JBOTransaction tx) throws Exception{
		
			BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
			BusinessObject bc = bom.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", this.contractNo);
			//业务流程定义
			String edocNos = ProductAnalysisFunctions.getComponentMandatoryValue(bc, "PRD05-05", "BusinessEDocs","0010", "01");
			if(edocNos == null || "".equals(edocNos)) edocNos = "";
			if(edocNos != null && !"".equals(edocNos)){
				String[] docArray = edocNos.split(",");
				for(String docID:docArray)
				{
					EDocPrint edp = new EDocPrint();
					edp.setDocNo(docID);	
					edp.setObjectno(contractNo);
					edp.setObjecttype("jbo.app.BUSINESS_CONTRACT");
					edp.docHandle(tx);
				}
			}
			return "true";

	}		
}
