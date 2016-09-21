package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.customer.action.CreateCustomerInfo;

/**
 * @author
 * ���˾�Ӫ���������Ӫʵ����Ϣ
 */
public class IndividualEnterpriseProcess extends ALSBusinessProcess implements BusinessObjectOWUpdater {

	@Override
	public List<BusinessObject> update(BusinessObject businessInvest,
			ALSBusinessProcess businessProcess) throws Exception {
		String tempFlag = businessInvest.getString("TEMPSAVEFLAG");
		
		String relaCustomerName = businessInvest.getString("RelaCustomerName");
		String certType = businessInvest.getString("CertType");
		String certIDTemp = businessInvest.getString("CertID");
		String certID = certIDTemp.replace(" ", "");
		String InputUserID = businessInvest.getString("InputUserID");
		String InputOrgID = businessInvest.getString("InputOrgID");
		if("0".equals(tempFlag)){
			//��idΪ�գ�˵��ҳ����δ�����пͻ���ѡ����˴������ͻ�
			if(certType==null || certType.length()==0 || certID==null || certID.length()==0 || relaCustomerName==null || relaCustomerName.length()==0)
				throw new Exception("δ¼�뾭Ӫʵ�����ơ�֤�����ͻ�֤�����룡");
			List<BusinessObject> customerList = this.bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_INFO", "CertType=:CertType and "
					+ "CertID=:CertID", "CertType",certType,"CertID",certID);
			if(customerList == null || (customerList != null && customerList.size() == 0)){
				//������ҵ�ͻ�
				CreateCustomerInfo cci = new CreateCustomerInfo();
				cci.setInputParameter("CustomerName", relaCustomerName);
				cci.setInputParameter("CustomerType", "01");
				cci.setInputParameter("CertType", certType);
				cci.setInputParameter("CertID", certID);
				cci.setInputParameter("IssueCountry", "CHN");
				cci.setInputParameter("InputUserID", InputUserID);
				cci.setInputParameter("InputOrgID", InputOrgID);
				cci.setInputParameter("InputDate", DateHelper.getBusinessDate());
				String result = cci.CreateCustomerInfo(this.bomanager.getTx());
				String customerID = result.split("@")[1];
				
				businessInvest.setAttributeValue("RelaCustomerID", customerID);
				businessInvest.setAttributeValue("CERTID", certID);
			}else{
				String customerName = customerList.get(0).getString("CUSTOMERNAME");
				String customerID = customerList.get(0).getString("CUSTOMERID");
				businessInvest.setAttributeValue("CERTID", certID);
				businessInvest.setAttributeValue("RELACUSTOMERNAME", customerName);
				businessInvest.setAttributeValue("RELACUSTOMERID", customerID);
			}
		}
		businessInvest.generateKey();
		this.bomanager.updateBusinessObject(businessInvest);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessInvest);
		
		return result;
	}
	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
