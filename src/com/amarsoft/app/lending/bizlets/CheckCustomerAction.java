package com.amarsoft.app.lending.bizlets;

/**
 * ���ͻ���Ϣ״̬
 * @author ���� 2015/12/10 �����������
 */
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

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
 * 		<p>UserID			:�û�ID</p>
 * @return ����ֵ˵��
 * 		ReturnStatus: ����״̬
 * 			<li>01 �޸ÿͻ�</li> 
 * 			<li>02 ��ǰ�û�����ÿͻ���������</li> 
 * 			<li>04 ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ</li> 
 * 			<li>05 ��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ</li> 
 * 
 */
public class CheckCustomerAction{
	private	String customerType ;
	private	String customerName;
	private	String certType ;
	private	String certID ;
	private	String userID;
	
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

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String checkCustomerAction(JBOTransaction tx) throws Exception{
		BizObjectManager bomCustomerInfo = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(bomCustomerInfo);
		if(customerType == null) customerType = "";
		if(customerName == null) customerName = "";
		if(certType == null) certType = "";
		if(certID == null) certID = "";
		if(userID == null) userID = "";
		
		String sqlStr = "";
		String customerID = "";			//�ͻ�����
		String haveCutomerType = "";		//ϵͳ���Ѵ��ڸÿͻ��Ŀͻ����ͣ�������������ʱ�Ƿ���ȷ
		String haveCutomerTypeName = "";	//ϵͳ���Ѵ��ڸÿͻ��Ŀͻ����ͣ�������������ʱ�Ƿ���ȷ
		String status = "";				//ϵͳ���Ѵ��ڸÿͻ��Ŀͻ����ͣ�������������ʱ�Ƿ���ȷ
		String returnStatus = "";			//������Ϣ
		String realCustomerName="";  // У��ͻ�����  
		List<BizObject> bos = null;//��ѯ�����
		BizObjectQuery query = null;
		//  1.���ݿͻ����ͣ�������ӦSQL 
		//01 ��˾�ͻ���ͨ��֤�����͡�֤���������Ƿ���CI���д�����Ϣ	
		if(customerType.substring(0,2).equals("01")){
			sqlStr = 	" select CustomerID,CustomerType," +
					"getItemName('CustomerType',CustomerType) as v.CustomerTypeName," +
					"Status,CustomerName "+
					" from O " +
					"where CertType = :CertType "+
					" and CertID = :CertID ";
			query = bomCustomerInfo.createQuery(sqlStr).setParameter("CertType", certType).setParameter("CertID", certID);
		//02 ���ſͻ�ͨ���ͻ����Ƽ���Ƿ���CI���д�����Ϣ
		}else if(customerType.substring(0,2).equals("02")){ 
			sqlStr = 	" select CustomerID,CustomerType," +
					"getItemName('CustomerType',CustomerType) as v.CustomerTypeName,Status,CustomerName "+
					" from O "+
					" where CustomerName = :CustomerName "+
					" and CustomerType = :CustomerType ";
			query = bomCustomerInfo.createQuery(sqlStr).setParameter("CustomerType", customerType).setParameter("CustomerName", customerName);
		//03 ���˿ͻ�
		}else if(customerType.substring(0,2).equals("03")){
			if(certType.equals("Ind01")){	
				//���Ϊ���֤������Ҫ��15λ��18λ���֤ת����Ȼ��ʹ��18λ�����֤ȥƥ��
				String sCertID18 = StringFunction.fixPID(certID);
				sqlStr = "select CustomerID,CustomerType,CustomerName," +
						"getItemName('CustomerType',CustomerType) as v.CustomerTypeName,"
						+ " Status from O,jbo.customer.IND_INFO II"
						+ " where II.CustomerID=CustomerID " +
						"and II.CertType = :sCertType and II.CertID18 = :sCertID18 ";
				query = bomCustomerInfo.createQuery(sqlStr).setParameter("sCertID18", sCertID18).setParameter("sCertType", certType);
			}else{
				sqlStr = "select CustomerID,CustomerType," +
						"getItemName('CustomerType',CustomerType) as v.CustomerTypeName,Status,CustomerName "+
						"from O where CertType =:CertType and CertID =:CertID ";
				query = bomCustomerInfo.createQuery(sqlStr).setParameter("CertType", certType).setParameter("CertID", certID);
			}
		// ���û��ָ���ͻ����ͣ���ֱ��ʹ��֤�����ͣ�֤���ţ���01 ��˾�ͻ���ͬ��
		}else{
			sqlStr = " select CustomerID,CustomerType," +
					"getItemName('CustomerType',CustomerType) as v.CustomerTypeName,Status,CustomerName "
					+ " from O where CertType = :sCertType and CertID = :sCertID ";
			query = bomCustomerInfo.createQuery(sqlStr).setParameter("sCertID", certID).setParameter("sCertType", certType);
		}
		bos = query.getResultList(false);
		// ��ȡ��ѯ���
		if(bos!=null&&bos.size()>0){
			BizObject bo = bos.get(0);
			customerID = bo.getAttribute("CustomerID").getString();
			haveCutomerType = bo.getAttribute("CustomerType").getString();
			haveCutomerTypeName = bo.getAttribute("CustomerTypeName").getString();
			status = bo.getAttribute("Status").getString();
			realCustomerName = bo.getAttribute("CustomerName").getString();  
		}
		bos = null;//��ղ�ѯ�����
		query = null;
		if(customerID == null) customerID = "";
		if(haveCutomerType == null) haveCutomerType = "";
		if(haveCutomerTypeName == null) haveCutomerTypeName = "";
		if(status == null) status = "";
		if(realCustomerName == null) realCustomerName = "";  
		
		BizObjectManager bomCustomerBelong = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
		tx.join(bomCustomerBelong);
		BizObject countCustomerBelong = null;
		//�ͻ���Ϣ���
		if(customerID.equals("")){//�޸ÿͻ�
			returnStatus = "01";
		}else{//���ڸÿͻ�������ܻ�Ȩ������Ȩ
			int iCount = 0;
			//��ȡ��ǰ�ͻ��Ƿ��뵱ǰ�û������˹���
			sqlStr = 	" select count(CustomerID) as v.count"
					+" from O "
					+" where CustomerID = :sCustomerID "
					+" and UserID = :sUserID ";
			query = bomCustomerBelong.createQuery(sqlStr).setParameter("sUserID", userID).setParameter("sCustomerID", customerID);
			countCustomerBelong = query.getSingleResult(false);
			
			if(countCustomerBelong!=null){
				iCount = Integer.parseInt(countCustomerBelong.getAttribute("count").getString());
			}
			bos = null;
			if(iCount > 0){//�û�����ÿͻ�������Ч����
				returnStatus = "02";
			}else{//���ÿͻ��Ƿ��йܻ���
				sqlStr = 	" select count(CustomerID) as v.count "
						+" from O "
						+" where CustomerID = :sCustomerID "
						+" and BelongAttribute = '1'";
				query = bomCustomerBelong.createQuery(sqlStr).setParameter("sCustomerID", customerID);
				countCustomerBelong = query.getSingleResult(false);
				if(countCustomerBelong!=null){
					iCount = Integer.parseInt(countCustomerBelong.getAttribute("count").getString());
				}
				bos = null;
				query = null;
				returnStatus = iCount > 0?"05":"04";//"05"��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ,"04"��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ
			}

			returnStatus = returnStatus+"@"+customerID+"@"+haveCutomerType+"@"+haveCutomerTypeName+"@"+status +"@"+realCustomerName;
		}
		return returnStatus;
	}
}
