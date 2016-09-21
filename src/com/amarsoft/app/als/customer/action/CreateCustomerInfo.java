package com.amarsoft.app.als.customer.action;
/**
 * @������
 * �������ͻ���ͬʱ�����ͻ�����Ϊ���˿ͻ�ʱ����ind_info,customer_identity���в����������
 * ���ͻ�����Ϊ��ҵ�ͻ�ʱ����ent_info,customer_indentity���в����������
 */
import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

public class CreateCustomerInfo{
	private JSONObject inputParameter;
	private String BirthDay = "";
	private String sex = "";
	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	public void setInputParameter(String key,Object value) {
		if(this.inputParameter == null)
			inputParameter = JSONObject.createObject();
		com.amarsoft.are.lang.Element a = new com.amarsoft.are.util.json.JSONElement(key);
		a.setValue(value);
		inputParameter.add(a);
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
	
	public String CreateCustomerInfo(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String customerNameTemp = (String)inputParameter.getValue("CustomerName");
		String customerType = (String)inputParameter.getValue("CustomerType");
		String certIDTemp = (String)inputParameter.getValue("CertID");
		String certID = certIDTemp.replace(" ", "");
		String customerName = customerNameTemp.trim();
		String certType = (String)inputParameter.getValue("CertType");
		String issueCountry = (String)inputParameter.getValue("IssueCountry");
		String inputOrgID = (String)inputParameter.getValue("InputOrgID");
		String inputUserID = (String)inputParameter.getValue("InputUserID");
		String inputDate = (String)inputParameter.getValue("InputDate");
		if("03".equals(customerType)){

			String result = CreateCustomerInfo(customerName,customerType,certID,certType,issueCountry,inputOrgID,inputUserID,inputDate,tx);
			String customerID = result.split("@")[1];
			if("1".equals(certType) || "6".equals(certType) || "C".equals(certType)){
				int certIDLength = certID.length();
				if(certIDLength == 18){
					String BirthDayTemp = certID.substring(6,14);
					BirthDay = BirthDayTemp.substring(0, 4)+"/"+BirthDayTemp.substring(4, 6)+"/"+BirthDayTemp.substring(6, 8);
				}else{
					String BirthDayTemp = "19"+certID.substring(6, 12);
					BirthDay = BirthDayTemp.substring(0, 4)+"/"+BirthDayTemp.substring(4, 6)+"/"+BirthDayTemp.substring(6, 8);

				}
			}
			CreateCustomerIndInfo(customerID,BirthDay,issueCountry,inputOrgID,inputUserID,inputDate,tx);
			CreateCustomerCertInfo(customerID,certID,certType,issueCountry,inputOrgID,inputUserID,inputDate,tx);
			SelectCustomerBelong(customerID,inputOrgID,inputUserID,inputDate,tx);
			
			//ECIFInstance.queryCustomer(customerID, certType, certID, customerName, tx);
			//updateSex(customerID,certID,certType,tx);
			return result;
		}else{
			if(!StringX.isEmpty(customerType)){
				String result = CreateCustomerInfo(customerName,customerType,certID,certType,issueCountry,inputOrgID,inputUserID,inputDate,tx);
				String customerID = result.split("@")[1];
				CreateCustomerEntInfo(customerID,inputOrgID,inputUserID,inputDate,tx);
				CreateCustomerCertInfo(customerID,certID,certType,issueCountry,inputOrgID,inputUserID,inputDate,tx);
				SelectCustomerBelong(customerID,inputOrgID,inputUserID,inputDate,tx);
				
				if("2020".equals(certType)){
					//ECIFInstance.queryEntCustomer(customerID, certID, customerName, tx);
				}
				return result;
			}else{
				throw new Exception("�ͻ���"+customerName+"������ʧ�ܣ��ͻ�����Ϊ�գ�");
			}
		}
	}

	
	public String CreateCustomerInfo(String customerName,String customerType,String certID,String certType,String issueCountry,String inputOrgID,String inputUserID,String inputDate,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERNAME", customerName);
		bo.setAttributeValue("CUSTOMERTYPE", customerType);
		bo.setAttributeValue("CERTID", certID);
		bo.setAttributeValue("CERTTYPE", certType);
		bo.setAttributeValue("STATUS", "02");
		bo.setAttributeValue("ISSUECOUNTRY", issueCountry);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		
		bm.saveObject(bo);
		bo.setAttributeValue("CustomerID", "PL"+bo.getAttribute("CustomerID").getString());
		//MFCustomerID Ĭ��CustomerID����Ŀ����������Ҫ���޸�
		bo.setAttributeValue("MFCustomerID", bo.getAttribute("CustomerID").getString());
		
		bm.saveObject(bo);
		
		String customerid = bo.getAttribute("CustomerID").toString();
		String customername = bo.getAttribute("CustomerName").toString();
		String customertype = bo.getAttribute("CustomerType").toString();
		return "true@"+customerid+"@"+customername+"@"+customertype;
	}
	
	
	public String CreateCustomerIndInfo(String customerID,String BirthDay,String issueCountry,String inputOrgID,String inputUserID,String inputDate,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.IND_INFO");
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", customerID);
		bo.setAttributeValue("BIRTHDAY", BirthDay);
		bo.setAttributeValue("SEX", sex);
		bo.setAttributeValue("COUNTRY", issueCountry);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}
	
	public String CreateCustomerIndSi(String customerID,String inputOrgID,String inputUserID,String inputDate) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.IND_SI");
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", customerID);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}

	public String CreateCustomerIncome(String customerID, String inputOrgID, String inputUserID, String inputDate, JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_FINANCE");
		tx.join(bm);
		double amount = 0.0;
		Item[] temps = CodeManager.getItems("FinancialItem");
		for(Item item:temps){
			String itemno = item.getItemNo();
			if(itemno.startsWith("30") && !"30".equals(itemno)){
				BizObjectQuery q = bm.createQuery("CustomerID=:CustomerID and FinancialItem=:FinancialItem").setParameter("CustomerID", customerID).setParameter("FinancialItem", itemno);
				BizObject Data = q.getSingleResult(false);
				
				if(Data != null){
					if(!"3050".equals(itemno)){
						amount += Data.getAttribute("Amount").getDouble();
					}
				}else{
					BizObject boCreate = bm.newObject();
					boCreate.setAttributeValue("CUSTOMERID", customerID);
					boCreate.setAttributeValue("FINANCIALITEM", itemno);
					boCreate.setAttributeValue("CURRENCY", "CNY");
					boCreate.setAttributeValue("INPUTORGID", inputOrgID);
					boCreate.setAttributeValue("INPUTUSERID", inputUserID);
					boCreate.setAttributeValue("OCCURDATE", inputDate);
					bm.saveObject(boCreate);
				}
			}
		}
		//����������Ϣ����
		bm.createQuery("update O set Amount=:Amount Where CustomerID=:CustomerID and FinancialItem='3050'")
		  .setParameter("Amount",amount).setParameter("CustomerID", customerID).executeUpdate();
		
		return "SUCCEED";
	}
	
	public String CreateCustomerIndResume(String customerID,String inputOrgID,String inputUserID,String inputDate) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.IND_RESUME");
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", customerID);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}
	
	public String CreateCustomerEntInfo(String customerID,String inputOrgID,String inputUserID,String inputDate,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.ENT_INFO");
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", customerID);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}

	public String CreateCustomerCertInfo(String customerID,String certID,String certType,String issueCountry,String inputOrgID,String inputUserID,String inputDate,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_IDENTITY");
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", customerID);
		bo.setAttributeValue("CERTID", certID);
		bo.setAttributeValue("CERTTYPE", certType);
		bo.setAttributeValue("ISSUECOUNTRY", issueCountry);
		bo.setAttributeValue("STATUS", CustomerConst.CUSTOMER_IDENTITY_STATUS_1);
		bo.setAttributeValue("CUSTOMERCERTFLAG", CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_1);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}
	public String SelectCustomerBelong(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		String InputOrgID = (String)inputParameter.getValue("InputOrgID");
		String InputUserID = (String)inputParameter.getValue("InputUserID");
		String InputDate = (String)inputParameter.getValue("InputDate");
		return this.SelectCustomerBelong(CustomerID,InputOrgID,InputUserID,InputDate,tx);
	}
	
	public String SelectCustomerBelong(String CustomerID,String InputOrgID,String InputUserID,String InputDate,JBOTransaction tx) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		
		
		List<BusinessObject> list = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_BELONG", "CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID", "CustomerID", CustomerID,"OrgID", InputOrgID,"UserID", InputUserID);
		List<BusinessObject> listOthers = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_BELONG", "CustomerID=:CustomerID and BELONGATTRIBUTE = 1", "CustomerID",CustomerID);

		if((list == null || list.isEmpty())&&(listOthers == null || listOthers.isEmpty())){
			//��������ڿͻ�������customer_belong���в�������Ȩ��
			String result = ImportCustomerBelongAll(CustomerID,InputOrgID,InputUserID,InputDate,tx);
			return result;
		}else if((listOthers != null || listOthers.size() != 0) && (list == null || list.isEmpty())){
			//customer_belong�д��������û������е�Ȩ�ޣ����Ǵ˿ͻ�û��
			String result = ImportCustomerBelongOthers(CustomerID,InputOrgID,InputUserID,InputDate,tx);
			return result;
		}else{
			return "false";
		}
	}
	public String ImportCustomerBelongOthers(String CustomerID,String InputOrgID,String InputUserID,String InputDate,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
		this.setTx(tx);
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", CustomerID);
		bo.setAttributeValue("ORGID", InputOrgID);
		bo.setAttributeValue("USERID", InputUserID);
		bo.setAttributeValue("BELONGATTRIBUTE1", "1");
		bo.setAttributeValue("BELONGATTRIBUTE2", "1");
		bo.setAttributeValue("BELONGATTRIBUTE3", "1");
		bo.setAttributeValue("INPUTORGID", InputOrgID);
		bo.setAttributeValue("INPUTUSERID", InputUserID);
		bo.setAttributeValue("INPUTDATE", InputDate);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}
	public String ImportCustomerBelongAll(String CustomerID,String InputOrgID,String InputUserID,String InputDate,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
		this.setTx(tx);
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", CustomerID);
		bo.setAttributeValue("ORGID", InputOrgID);
		bo.setAttributeValue("USERID", InputUserID);
		bo.setAttributeValue("BELONGATTRIBUTE", "1");
		bo.setAttributeValue("BELONGATTRIBUTE1", "1");
		bo.setAttributeValue("BELONGATTRIBUTE2", "1");
		bo.setAttributeValue("BELONGATTRIBUTE3", "1");
		bo.setAttributeValue("INPUTORGID", InputOrgID);
		bo.setAttributeValue("INPUTUSERID", InputUserID);
		bo.setAttributeValue("INPUTDATE", InputDate);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}
	public String updateSex(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String customerID = (String)inputParameter.getValue("CustomerID");
		String certID = (String)inputParameter.getValue("CertID");
		String certType = (String)inputParameter.getValue("CertType");
		return this.updateSex(customerID,certID,certType,tx);
	}
	public String updateSex(String customerID,String certID,String certType,JBOTransaction tx) throws Exception{
		
		//���ݿͻ��Ų�ѯ�ÿͻ��Ƿ�洢���Ա����û�У��������֤�Ա���򣬽���У��
		String HaveNot = selectSexHaveNot(customerID,tx);
		if("No".equals(HaveNot)){
			if("1".equals(certType) || "6".equals(certType) || "C".equals(certType)){
				int certIDLength = certID.length();
				if(certIDLength == 18){//���֤��Ϊ18λʱ��ȡ�����ڶ�λ�����ж���ż�Ӷ��ó��Ա�
					String sexTemp = certID.substring(16,17);
					if((Integer.valueOf(sexTemp))%2 == 0){
						sex = "2";
					}else{
						sex = "1";
					}
				}else{//���֤��Ϊ15λʱ��ȡ�����ڶ�λ�����ж���ż�Ӷ��ó��Ա�
					String sexTemp = certID.substring(14);
					if((Integer.valueOf(sexTemp))%2 == 0){
						sex = "2";
					}else{
						sex = "1";
					}
				}
				//���ݻ�ȡ�����Ա����ind_info�е��Ա�
				updateIndSex(customerID,sex,tx);
			}
		}
		return "SUCCEED";
	}
	
	
	public String selectSexHaveNot(String customerid,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.IND_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", customerid);
		BizObject pr = q.getSingleResult(false);
		String  HaveNot = "";
		if(pr!=null)
		{
			HaveNot = pr.getAttribute("Sex").getString();
		}
		if("".equals(HaveNot) || HaveNot == null){
			return "No";
		}else{
			return HaveNot;
		}
	}
	
	public String updateIndSex(String customerID, String sex, JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.IND_INFO");
		tx.join(bm);
		
		bm.createQuery("update O set SEX=:SEX,UPDATEDATE=:UPDATEDATE Where customerID=:customerID")
		  .setParameter("SEX", sex).setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("customerID", customerID)
		  .executeUpdate();

		return "SUCCEED";
	}
		
}








	