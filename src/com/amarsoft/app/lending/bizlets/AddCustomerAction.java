package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

/**
 * ����¿ͻ���Ϣ
 * @author ���� 2015/12/10 �����������
 */
public class AddCustomerAction{
	/*
	  * �ͻ�����
	 *	<li>01 ��˾�ͻ�</li> 
	 *		<li>0110 ������ҵ</li>
	 *		<li>0120 ��С��ҵ</li>  
	 *	<li>02 ���ſͻ�</li>  
	 *		<li>0210 ʵ�弯��</li>  
	 *		<li>0220 ���⼯��</li>  
	 *	<li>03 ���˿ͻ�</li>  
	 *		<li>0310 ���˿ͻ�</li>  
	 *		<li>0320 ���徭Ӫ��</li>
	 * */
	private String customerType;
	private String customerName;// �ͻ��� 
	private String certType;// ֤������ 
	private String certID;// ֤���� 
	/*
	 *  �ͻ�״̬ 
	 *	<li>01 �޸ÿͻ�</li>
	 *	<li>02 ��ǰ�û�����ÿͻ���������</li>
	 *	<li>04 ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ</li>
	 *	<li>05 ��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ</li>
	 */
	private String status;
	private String customerID;//�ͻ�ID 
	private String customerOrgType;//�������� 
	private String userID;//�û�ID
	private String orgID;// ����ID
	private String today;// ��������
	private String groupType;//���ſͻ���־ 
	private String hasCustomerType;//���ڿͻ�����
	private String nationCode;//֤������ 
	
	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCertType() {
		return certType;
	}

	public void setCertType(String certType) {
		this.certType = certType;
	}

	public String getCertID() {
		return certID;
	}

	public void setCertID(String certID) {
		this.certID = certID;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getCustomerOrgType() {
		return customerOrgType;
	}

	public void setCustomerOrgType(String customerOrgType) {
		this.customerOrgType = customerOrgType;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getToday() {
		return today;
	}

	public void setToday(String today) {
		this.today = today;
	}

	public String getGroupType() {
		return groupType;
	}

	public void setGroupType(String groupType) {
		this.groupType = groupType;
	}

	public String getHasCustomerType() {
		return hasCustomerType;
	}

	public void setHasCustomerType(String hasCustomerType) {
		this.hasCustomerType = hasCustomerType;
	}
	public String getNationCode() {
		return nationCode;
	}

	public void setNationCode(String nationCode) {
		this.nationCode = nationCode;
	}
	/**
	 * @param ����˵��
	 *		<p>CustomerType���ͻ�����
	 *			<li>01    ��˾�ͻ�</li>
	 *			<li>0110  ������ҵ</li>  
	 *			<li>0120  ��С��ҵ</li>
	 *			<li>02    ���ſͻ�</li>  
	 *			<li>0210  ʵ�弯��</li>  
	 *			<li>0220  ���⼯��</li>
	 *			<li>03    ���˿ͻ�</li>  
	 *			<li>0310  ���˿ͻ�</li>  
	 *			<li>0320  ���徭Ӫ��</li>
	 *		</p>
	 * 		<p>CustomerName	:�ͻ�����</p>
	 * 		<p>CertType		:֤������</p>
	 * 		<p>CertID			:֤����</p>
	 * 		<p>Status			:��ǰ�ͻ�״̬
	 * 			<li>01 �޸ÿͻ�</li>
	 * 			<li>02 ��ǰ�û�����ÿͻ���������</li>
	 * 			<li>04 ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ</li>
	 * 			<li>05 ��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ</li>
	 *		</p>
	 * 		<p>UserID			:�û�ID</p>
	 * 		<p>CustomerID		:�ͻ�ID</p>
	 * 		<p>OrgID			:����ID</p>
	 * @return ����ֵ˵��
	 * 		����״̬ 1 �ɹ�,0 ʧ��
	 * 
	 */
	public String addCustomerAction(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(bom);
		if(customerType == null) customerType = "";
		if(customerName == null) customerName = "";
		if(certType == null) certType = "";
		if(certID == null) certID = "";
		if(customerID == null) customerID = "";
		if(customerOrgType == null) customerOrgType = "";
		if(status == null) status = "";
		if(userID == null) userID = "";
		if(orgID == null) orgID = "";
		if(hasCustomerType == null) hasCustomerType = "";
		if(nationCode == null) nationCode="";
		String sReturn = "0";
		today = StringFunction.getToday();
		
	   	//���ݿͻ��������ü��ſͻ����� 
	  	if(customerType.equals("0210")) 
			groupType = "1";//һ�༯��
	  	else 
			groupType = customerType.equals("0220") ? "2" : "0";
	  	
		//01Ϊ�޸ÿͻ� 
	  	if(status.equals("01")){
	  		try{
	  			insertCustomerInfo(customerType,tx);//1.����CI��
	  			
	  			insertCustomerBelong("1",tx);//2.����CB��,Ĭ��ȫ�����Ȩ��
	  			
	  			//����ENT_INFO����IND_INFO��
	  			if(customerType.substring(0,2).equals("01") ||customerType.substring(0,2).equals("02")){//��˾�ͻ����߼��ſͻ�
	  				insertEntInfo(customerType,certType,tx);
	  			}else if(customerType.substring(0,2).equals("03")){//���˿ͻ�
	  				insertIndInfo(certType,tx);
	  			}
	  			sReturn = "1";
			} catch(Exception e){
				throw new Exception("������ʧ�ܣ�"+e.getMessage());
			}
		//�ÿͻ�û�����κ��û�������Ч����
		}else if(status.equals("04")){
			if(hasCustomerType.equals(customerType)){
				String sSql = 	" update O set Channel = '1' where CustomerID =:CustomerID ";//����Դ������"2"���"1"
				bom.createQuery(sSql).setParameter("CustomerID", customerID).executeUpdate();
				insertCustomerBelong("1",tx);//����CB��,Ĭ��ȫ�����Ȩ��
				sReturn = "1";
			}else{
				sReturn = "2";//��������ͻ����ʹ���
			}
		}else if(status.equals("05")){
			if(hasCustomerType.equals(customerType)){
				insertCustomerBelong("2",tx);
				sReturn = "1";
			}else{
				sReturn = "2";
			}
		}
		return sReturn;
	}
	
	/**
	 * ����������CUSTOMER_INFO
	 * @param cusType �ͻ����ͣ���ͬ�Ŀͻ����ͣ�������ֶλ�������ͬ
	 * @throws Exception 
	 */
  	private void insertCustomerInfo(String cusType,JBOTransaction tx) throws Exception{
  		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
  		tx.join(bom);
  		
		StringBuffer sbSql = new StringBuffer();
		sbSql.append(" insert into O(") 
			.append(" CustomerID,")					//010.�ͻ����
			.append(" CustomerName,")				//020.�ͻ�����
			.append(" CustomerType,")				//030.�ͻ�����
			.append(" CertType,")					//040.֤������
			.append(" CertID,")						//050.֤����
			.append(" InputOrgID,")					//060.�Ǽǻ���
			.append(" InputUserID,")				//070.�Ǽ��û�
			.append(" InputDate,")					//080.�Ǽ�����
			.append(" Channel")						//090.��Դ����
			.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :InputOrgID, :InputUserID, :InputDate, '1')");
		
		BizObjectQuery boq = bom.createQuery(sbSql.toString())
			.setParameter("CustomerID", customerID)
			.setParameter("CustomerName", customerName)
			.setParameter("CustomerType", customerType);
		//���ſͻ�(��֤�����ͣ�֤����)
		if(cusType.substring(0,2).equals("02")){
			boq.setParameter("CertType", "").setParameter("CertID", "");
		}else{
			boq.setParameter("CertType", certType).setParameter("CertID", certID);
		}
		boq.setParameter("InputOrgID", orgID).setParameter("InputUserID", userID).setParameter("InputDate", today);
		boq.executeUpdate();
  	}
  	
  	/**
  	 * ����������CUSTOMER_BELONG
  	 * @param attribute [����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ]��־
  	 * @throws Exception
  	 */
  	private void insertCustomerBelong(String attribute,JBOTransaction tx) throws Exception{
  		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
  		tx.join(bom);
  		
  		StringBuffer sbSql = new StringBuffer("");
		sbSql.append("insert into O(")
			.append(" CustomerID,")					//010.�ͻ�ID
			.append(" OrgID,")						//020.��Ȩ����ID
			.append(" UserID,")						//030.��Ȩ��ID
			.append(" BelongAttribute,")			//040.����Ȩ
			.append(" BelongAttribute1,")			//050.��Ϣ�鿴Ȩ
			.append(" BelongAttribute2,")			//060.��Ϣά��Ȩ
			.append(" BelongAttribute3,")			//070.ҵ�����Ȩ
			.append(" BelongAttribute4,")			//080.
			.append(" InputOrgID,")					//090.�Ǽǻ���
			.append(" InputUserID,")				//100.�Ǽ���
			.append(" InputDate,")					//110.�Ǽ�����
			.append(" UpdateDate")					//120.��������
			.append(" )values(:CustomerID, :OrgID1, :UserID1, :attribute, :attribute1, :attribute2, :attribute3, :attribute4, :OrgID2, :UserID2, :InputDate, :UpdateDate)");
		
		BizObjectQuery boq = bom.createQuery(sbSql.toString())
				.setParameter("CustomerID", customerID)
				.setParameter("OrgID1", orgID)
				.setParameter("UserID1", userID)
				.setParameter("attribute", attribute)
				.setParameter("attribute1", attribute)
				.setParameter("attribute2", attribute)
				.setParameter("attribute3", attribute)
				.setParameter("attribute4", attribute)
				.setParameter("OrgID2", orgID)
				.setParameter("UserID2", userID)
				.setParameter("InputDate", today)
				.setParameter("UpdateDate", today);
		boq.executeUpdate();
  	}
  	
  	/**
  	 * ����������ENT_INFO,��ͬ�Ŀͻ������Լ�֤�����ͣ�������ֶλ�������
  	 * @param cusType �ͻ�����
  	 * @param entCertType	֤������
  	 * @throws Exception 
  	 */
  	private void insertEntInfo(String cusType,String entCertType,JBOTransaction tx) throws Exception{
  		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.ENT_INFO");
  		tx.join(bom);
  		StringBuffer sbSql = new StringBuffer("");
  		//�Ȳ���ͨ����Ϣ
  		sbSql.append("insert into O(")
			.append(" CustomerID,")					//010.�ͻ�ID
			.append(" EnterpriseName,")				//020.�ͻ�����
			.append(" OrgNature,")					//040.��������
			.append(" GroupFlag,")					//050.���ſͻ���־
			.append(" InputUserID,")				//060.�Ǽ���
			.append(" InputOrgID,")					//070.�Ǽǻ���
			.append(" InputDate,")					//080.�Ǽ�����
			.append(" UpdateUserID,")				//090.������
			.append(" UpdateOrgID,")				//100.���»���
			.append(" UpdateDate,")					//110.��������
			.append(" TempSaveFlag")				//120.�ݴ��־
			.append(" )values(:CustomerID, :EnterpriseName, :OrgNature, :GroupFlag, :InputUserID, :InputOrgID, :InputDate, :UpdateUserID, :UpdateOrgID, :UpdateDate, '1')");
  		BizObjectQuery boq = bom.createQuery(sbSql.toString())
  				.setParameter("CustomerID", customerID)
  				.setParameter("EnterpriseName", customerName)
  				.setParameter("OrgNature", customerOrgType)
  				.setParameter("GroupFlag", groupType)
  				.setParameter("InputUserID", userID)
  				.setParameter("InputOrgID", orgID)
  				.setParameter("InputDate", today)
  				.setParameter("UpdateUserID", userID)
  				.setParameter("UpdateOrgID", orgID)
  				.setParameter("UpdateDate", today);
		boq.executeUpdate();
		
		//�ٸ���������Ϣ
  		if(customerType.substring(0,2).equals("01")){//[01] ��˾�ͻ�
			//֤������ΪӪҵִ��
			if(certType.equals("Ent02")){//����Ӫҵִ�պ�
				bom.createQuery("update O set LicenseNo = :LicenseNo where CustomerID = :CustomerID")
					.setParameter("CustomerID", customerID)
					.setParameter("LicenseNo", certID)
					.executeUpdate();
			}else{//����֤��
				bom.createQuery("update O set CorpID = :CorpID where CustomerID = :CustomerID")
				.setParameter("CustomerID", customerID)
				.setParameter("CorpID", certID)
				.executeUpdate();
			}
  		}else if(customerType.substring(0,2).equals("02")){//[02] �������ſͻ�
			//������֯�������루ϵͳ�Զ����⣬ͬ���ſͻ���ţ�
  			bom.createQuery("update O set CorpID = :CorpID where CustomerID = :CustomerID")
  				.setParameter("CustomerID", customerID)
  				.setParameter("CorpID", customerID)
  				.executeUpdate();
  		}
  	}
  	
  	/**
  	 * ����������IND_INFO,��ͬ��֤�����ͣ�������ֶλ�������
  	 * @throws Exception 
  	 */
  	private void insertIndInfo(String indCertType,JBOTransaction tx) throws Exception{
  		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.IND_INFO");
  		tx.join(bom);
  		String sCertID18 = "";
  		StringBuffer sbSql = new StringBuffer("");
  		//���Ϊ���֤,����18λת��
  		sCertID18 = indCertType.equals("Ind01")?StringFunction.fixPID(certID):"";
		
		sbSql.append("insert into O(")
		.append(" CustomerID,")					//010.�ͻ�ID
		.append(" FullName,")					//020.�ͻ���
		.append(" CertType,")					//030.֤������
		.append(" CertID,")						//040.֤����
		.append(" CertID18,")					//050.18λ֤����
		.append(" NationCode,")				//֤������
		.append(" InputOrgID,")					//060.�Ǽǻ���
		.append(" InputUserID,")				//070.�Ǽ���
		.append(" InputDate,")					//080.�Ǽ�����
		.append(" UpdateDate,")					//090.��������
		.append(" TempSaveFlag")				//100.�ݴ��־
		.append(" )values(:CustomerID, :FullName, :CertType, :CertID, :CertID18,:NationCode, :sOrgID, :sUserID, :InputDate, :UpdateDate, '1')");
		
		
		bom.createQuery(sbSql.toString())
			.setParameter("CustomerID", customerID)
			.setParameter("FullName", customerName)
			.setParameter("CertType", certType)
			.setParameter("CertID", certID)
			.setParameter("CertID18", sCertID18)
			.setParameter("NationCode",nationCode)
			.setParameter("sOrgID", orgID)
			.setParameter("sUserID", userID)
			.setParameter("InputDate", today)
			.setParameter("UpdateDate", today)
			.executeUpdate();
  	}
}
