package com.amarsoft.app.als.project;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class QueryAccountBalance {
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
	public String queryAccountBalance(JBOTransaction tx) throws Exception{
		String AccountNo = (String)inputParameter.getValue("AccountNo");
		
		String TranTellerNo = "92261005";
		String BranchId = "2261";
		String flag = "1";
		try{
			BizObjectManager bmCMI = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
			tx.join(bmCMI);
			/*OCITransaction oci = CoreInstance.CorpCrnAcctQry(TranTellerNo, BranchId, AccountNo, tx.getConnection(bmCMI));
	
			//取返回报文的ReturnCode和ReturnMsg，判断返回报文是否正确
			String ReturnCode = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
			String ReturnMsg = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
			if(("000000000000").equals(ReturnCode)){
				String MarginBalanceTemp = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AcctBal");
				String MarginBalance = MarginBalanceTemp.replace(" ", "");
				return flag+"@"+MarginBalance;
			}else{
				flag = "2";
				return flag+"@"+ReturnMsg;
			}*/
			return "";
		}catch(Exception ex){
			ex.printStackTrace();
			flag = "2";
			return flag+"@"+ex.getMessage();
		}
	}
}
