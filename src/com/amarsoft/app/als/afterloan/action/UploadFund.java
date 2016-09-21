package com.amarsoft.app.als.afterloan.action;

/**
 * 功能：冲还贷第一步批量任务更新核心利息文件日期
 * 		仇晓萍
 */
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class UploadFund {
	
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
	
	public void uploadFundUpdate(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.SYS_SETUP");
		tx.join(bm);
		String BusinessDate = (String)inputParameter.getValue("BusinessDate");
		String gjjDownLXDate = (String)inputParameter.getValue("gjjDownLXDate");
		bm.createQuery("UPDATE O SET GJJDOWNLXDATE='"+gjjDownLXDate+"' WHERE BUSINESSDATE = :BUSINESSDATE")
				.setParameter("BUSINESSDATE", BusinessDate).executeUpdate();
	}
}
