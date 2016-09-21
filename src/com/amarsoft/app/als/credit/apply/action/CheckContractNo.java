package com.amarsoft.app.als.credit.apply.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

/**
 * 查询合同号是否存在，如果存在返回客户信息
 * @author 张万亮
 *
 */

public class CheckContractNo {
private JSONObject inputParameter;
	
	public void setInputParameter(JSONObject inputParameter){
		this.inputParameter = inputParameter;
	}
	
	public String checkContractNo(JBOTransaction tx) throws JBOException{
		String ContractArtificialNo = (String)inputParameter.getValue("ContractArtificialNo");
		String CustomerName = "";
		String CertType = "";
		String CertID = "";
		String CustomerID = "";
		String flag = "false";
		BizObjectManager ba = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		tx.join(ba);
		BizObjectManager bc = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(bc);
		BizObjectManager ci = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(ci);
		//先通过BA查询客户编号
		BizObject bas = ba.createQuery("ContractArtificialNo = :ContractArtificialNo").setParameter("ContractArtificialNo",ContractArtificialNo).getSingleResult(true);
		if(bas != null){
			CustomerID = bas.getAttribute("CustomerID").getString();
			flag = "true";
		}else{
			//如果BA查不到说明是存量数据那一定有BC
			BizObject bcs = bc.createQuery("SerialNo = :ContractArtificialNo").setParameter("ContractArtificialNo",ContractArtificialNo).getSingleResult(true);
			if(bcs != null){
				CustomerID = bcs.getAttribute("CustomerID").getString();
				flag = "true";
			}
		}
		//如果可以查到则CustomerID一定有值就可以通过CUSTOMER_INFO查到客户信息
		if(!"".equals(CustomerID)){
			BizObject cis = ci.createQuery("CustomerID = :CustomerID").setParameter("CustomerID",CustomerID).getSingleResult(true);
			if(cis != null){
				CustomerName = cis.getAttribute("CustomerName").getString();
				CertType = cis.getAttribute("CertType").getString();
				CertID = cis.getAttribute("CertID").getString();
			}
		}
		return flag+"@"+CustomerName+"@"+CertType+"@"+CertID;
	}
}
