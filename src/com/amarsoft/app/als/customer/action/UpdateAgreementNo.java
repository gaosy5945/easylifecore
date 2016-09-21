package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class UpdateAgreementNo {
		private JSONObject inputParameter;
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
		public String udpateAgreementNo(JBOTransaction tx) throws Exception{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
			tx.join(bm);
			
			String SerialNo = (String)inputParameter.getValue("SerialNo");
			
			bm.createQuery("update O set AgreementNo=:AgreementNo,UpdateDate=:UpdateDate Where SerialNo=:SerialNo")
			  .setParameter("AgreementNo",SerialNo).setParameter("UpdateDate",DateHelper.getBusinessDate()).setParameter("SerialNo", SerialNo).executeUpdate();
			
			return "SUCCEED";
		}
		public String udpateProejctStatus(JBOTransaction tx) throws Exception{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
			tx.join(bm);
			
			String SerialNo = (String)inputParameter.getValue("SerialNo");
			
			bm.createQuery("update O set Status=:Status Where SerialNo=:SerialNo")
			  .setParameter("Status","13").setParameter("SerialNo", SerialNo).executeUpdate();
			
			return "SUCCEED";
		}
}
