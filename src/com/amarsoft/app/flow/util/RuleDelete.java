package com.amarsoft.app.flow.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;
/**
 * 
 * @author T-zhangwl
 * 功能：删除授权方案或团队时同时删除该方案或团队下的信息
 */
public class RuleDelete {
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

	public String RuleDelete(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.flow.FLOW_AUTHORIZE_RULE");
		tx.join(bm);
		bm.createQuery("Delete From O Where AuthSerialNo=:AuthSerialNo")
		  .setParameter("AuthSerialNo", serialNo)
		  .executeUpdate();
		return "true";
	}
	public String RuleCopy(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String userID = (String)inputParameter.getValue("UserID");
		String orgID = (String)inputParameter.getValue("OrgID");
		String newSerialNo = "";
		BizObjectManager fa = JBOFactory.getBizObjectManager("jbo.flow.FLOW_AUTHORIZE");
		tx.join(fa);
		BizObjectQuery nfa = fa.createQuery("SerialNo=:SerialNo");
		nfa.setParameter("SerialNo", serialNo);
		List<BizObject> faList = nfa.getResultList(false);
		for(BizObject fabo:faList)
		{
			BizObject crbo = fa.newObject();
			crbo.setAttributesValue(fabo);
			crbo.setAttributeValue("InputUserID", userID);
			crbo.setAttributeValue("InputOrgID", orgID);
			crbo.setAttributeValue("InputDate", DateHelper.getBusinessDate());
			crbo.setAttributeValue("SerialNo", null);
			fa.saveObject(crbo);
			newSerialNo = crbo.getAttribute("SerialNo").toString();
		}
		
		
		BizObjectManager far = JBOFactory.getBizObjectManager("jbo.flow.FLOW_AUTHORIZE_RULE");
		tx.join(far);
		BizObjectQuery nfar = far.createQuery("SerialNo=:SerialNo");
		nfar.setParameter("SerialNo", serialNo);
		List<BizObject> farList = nfar.getResultList(false);
		for(BizObject farbo:farList)
		{
			BizObject crbo = far.newObject();
			crbo.setAttributesValue(farbo);
			crbo.setAttributeValue("AuthSerialNo", newSerialNo);
			crbo.setAttributeValue("SerialNo", null);
			far.saveObject(crbo);
		}
		return "true";
	}
	public String TeamDelete(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String teamID = (String)inputParameter.getValue("TeamID");
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.flow.TEAM_USER");
		BizObjectManager bn = JBOFactory.getBizObjectManager("jbo.flow.FLOW_AUTHORIZE_OBJECT");
		tx.join(bm);
		bm.createQuery("Delete From O Where TeamID=:TeamID")
		  .setParameter("TeamID", teamID)
		  .executeUpdate();
		tx.join(bn);
		bn.createQuery("Delete From O Where AuthObjectNo=:TeamID")
		  .setParameter("TeamID", teamID)
		  .executeUpdate();
		return "true";
	}
		
}
