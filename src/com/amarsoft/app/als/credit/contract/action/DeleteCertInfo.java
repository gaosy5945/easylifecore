package com.amarsoft.app.als.credit.contract.action;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.credit.guaranty.guarantycontract.CeilingCmis;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.jbo.LocalTransaction;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.Transaction;



/**
 * @author t-wur
 *
 */
public class DeleteCertInfo {
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
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	public String deleteCert(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.deleteCert(serialNo);
	}
	
	public String deleteCert(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject arc = bomanager.keyLoadBusinessObject("jbo.app.ASSET_RIGHT_CERTIFICATE", serialNo);
	
		String WrntId = arc.getString("CMISSERIALNO");

		//Ȩ֤��Ϣɾ��
		try{
	   Transaction Sqlca = Transaction.createTransaction(tx);
	   // OCITransaction oci = ClrInstance.WrntInfoDel(WrntId,Sqlca.getConnection());
		}catch(Exception ex)
		{
			ex.printStackTrace();
			ARE.getLog().error("ASSET_RIGHT_CERTIFICATE_"+arc.getKeyString()+"_save_error.");
			//��ʱ���׳��쳣
			throw ex;
		}
		
	    bomanager.updateBusinessObject(arc);
		bomanager.updateDB();
		
		//����ͬѺƷȨ֤��ŵ�Ȩ֤��Ϣɾ��������ɾ��һ���󣬵���ɾ���ӿڱ���
		deleteSameCmis(WrntId,tx);
		
		return "true";
	}
	public void deleteSameCmis(String CmisSerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.ASSET_RIGHT_CERTIFICATE");
		tx.join(bm);
		bm.createQuery("Delete From O Where CmisSerialNo=:CmisSerialNo").setParameter("CmisSerialNo", CmisSerialNo).executeUpdate();
	}
}