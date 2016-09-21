package com.amarsoft.app.als.customer.partner.action;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.partner.model.PartnerProjectInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 客户的校验检查操作
 * @author Administrator
 *
 */
public class CustomerOperate {
	/**
	 * 校验客户是否存在、或者已经是合作方客户
	 * 返回第一个参数 为 1 时 已经是合作方客户 2 时 是已经存在的对公客户 3 时 不存在此客户
	 * @return
	 * @throws JBOException
	 */
	public String customerAction() throws JBOException{
		
		String returnValue = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_INFO);
		BizObjectManager bmc = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_PARTNER);
		BizObject bo = bm.createQuery("certtype=:CertType and certID=:CertID").setParameter("CertType", certType)
		.setParameter("CertID", certID).getSingleResult(false);
		if(bo!=null){
			//客户存在
			BizObject boc = bmc.createQuery("Customerid=:customerid")
							.setParameter("customerid", bo.getAttribute("CustomerID").getString())
							.getSingleResult(false);
			if(boc!=null){
				//合作方存在
				returnValue = "1@";
			}else{
				//客户存在 合作方不存在需引入
				BizObjectManager bme = JBOFactory.getBizObjectManager(CustomerConst.ENT_INFO);
				BizObject entbo = bme.createQuery("Customerid=:customerid")
				.setParameter("customerid", bo.getAttribute("CustomerID").getString())
				.getSingleResult(false);
				returnValue = "2@"+entbo.getAttribute("OrgNature").getString()+"@"
					+ bo.getAttribute("CustomerID").getString() + "@"
					+ bo.getAttribute("CustomerName").getString() + "@"
					+ bo.getAttribute("CustomerType").getString();
			}
		}else{
			//新客户
			returnValue = "3@";
		}
		return returnValue;
	}
	
	public String removePartner() throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.PARTNER_PROJECT_INFO);
		BizObject bo = bm.createQuery("" +
				"customerid=:customerID ")
				.setParameter("customerID", customerID)
				.getSingleResult(false);
		if(bo!=null) return "2";//已经存在此关联
		
		BizObjectManager bmc = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_PARTNER);
		bmc.createQuery("delete from o where customerid =:customerid").setParameter("customerid", customerID)
			.executeUpdate();	
		return "1";
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
	public String getCustomerID() {
		return customerID;
	}
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	
	private String certID;
	private String certType;
	private String customerID;
}
