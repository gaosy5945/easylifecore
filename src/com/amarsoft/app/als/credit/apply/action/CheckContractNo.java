package com.amarsoft.app.als.credit.apply.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

/**
 * ��ѯ��ͬ���Ƿ���ڣ�������ڷ��ؿͻ���Ϣ
 * @author ������
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
		//��ͨ��BA��ѯ�ͻ����
		BizObject bas = ba.createQuery("ContractArtificialNo = :ContractArtificialNo").setParameter("ContractArtificialNo",ContractArtificialNo).getSingleResult(true);
		if(bas != null){
			CustomerID = bas.getAttribute("CustomerID").getString();
			flag = "true";
		}else{
			//���BA�鲻��˵���Ǵ���������һ����BC
			BizObject bcs = bc.createQuery("SerialNo = :ContractArtificialNo").setParameter("ContractArtificialNo",ContractArtificialNo).getSingleResult(true);
			if(bcs != null){
				CustomerID = bcs.getAttribute("CustomerID").getString();
				flag = "true";
			}
		}
		//������Բ鵽��CustomerIDһ����ֵ�Ϳ���ͨ��CUSTOMER_INFO�鵽�ͻ���Ϣ
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
