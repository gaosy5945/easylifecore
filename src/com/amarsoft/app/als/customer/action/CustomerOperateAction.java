package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.als.customer.common.action.CustomerCertAction;
import com.amarsoft.app.als.customer.model.CustomerBelong;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ��������ʱ�Կͻ��Ĳ���У��
 * @author dqchen
 *
 */
public class CustomerOperateAction {

	private String certID;
	private String certType;
	private String userID;
	private String issueCountry = "CHN";
	
	/**
	 * У��ͻ��Ƿ���ڡ����������жϵ�ǰ�û��Ƿ���Ȩ�޷���ҵ��
	 * @return
	 * @throws JBOException 
	 */
	public String customerVerify(JBOTransaction tx) throws JBOException{
		CustomerCertAction cc = new CustomerCertAction();
		cc.setCertID(certID);
		cc.setCertType(certType);
		cc.setIssueCountry(issueCountry);
		CustomerInfo ci=cc.getCustomerInfo(tx);
		
		if(ci.getBizObject()==null){//�ͻ�������
			return "1@�ͻ�������������";
		}else{
			String customerID = ci.getBizObject().getAttribute("CustomerID").getString();
			CustomerBelong cb=new CustomerBelong(tx, customerID, this.userID);
			BizObject cbBo = cb.getBizObject();
			if(cbBo == null){
				return "2@��û������ÿͻ���������ÿͻ�";
			}else if(!"1".equals(cbBo.getAttribute("BelongAttribute3").getString())){
				return "2@��û�иÿͻ���ҵ�����Ȩ��������";
			}
			else{
				return "3@"+customerID+"@"+ci.getBizObject().getAttribute("CustomerName").getString();
			}
		}
	}
	
	public String getCertID() {
		return certID;
	}
	public void setCertID(String certID) {
		this.certID = certID;
	}
	public String getCertType() {
		return certType;
	}
	public void setCertType(String certType) {
		this.certType = certType;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getIssueCountry() {
		return issueCountry;
	}

	public void setIssueCountry(String issueCountry) {
		this.issueCountry = issueCountry;
	}
}
