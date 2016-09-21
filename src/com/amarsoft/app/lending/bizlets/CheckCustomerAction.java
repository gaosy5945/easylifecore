package com.amarsoft.app.lending.bizlets;

/**
 * 检查客户信息状态
 * @author 核算 2015/12/10 重新整理此类
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
 * @param 参数说明
 *		<p>CustomerType：客户类型
 *			<li>01    公司客户</li>
 *			<li>0110  大型企业</li>  
 *			<li>0120  中小企业</li>  
 *			<li>02    集团客户</li>  
 *			<li>0210  实体集团</li>  
 *			<li>0220  虚拟集团</li>  
 *			<li>03    个人客户</li>  
 *			<li>0310  个人客户</li>  
 *			<li>0320  个体经营户</li>
 *		</p>
 * 		<p>CustomerName	:客户名称</p>
 * 		<p>CertType		:证件类型</p>
 * 		<p>CertID			:证件号</p>
 * 		<p>UserID			:用户ID</p>
 * @return 返回值说明
 * 		ReturnStatus: 返回状态
 * 			<li>01 无该客户</li> 
 * 			<li>02 当前用户已与该客户建立关联</li> 
 * 			<li>04 当前用户没有与该客户建立关联,且没有和任何客户建立主办权</li> 
 * 			<li>05 当前用户没有与该客户建立关联,但和其他客户建立主办权</li> 
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
		String customerID = "";			//客户代码
		String haveCutomerType = "";		//系统中已存在该客户的客户类型，用以区分引入时是否正确
		String haveCutomerTypeName = "";	//系统中已存在该客户的客户类型，用以区分引入时是否正确
		String status = "";				//系统中已存在该客户的客户类型，用以区分引入时是否正确
		String returnStatus = "";			//返回信息
		String realCustomerName="";  // 校验客户名称  
		List<BizObject> bos = null;//查询结果集
		BizObjectQuery query = null;
		//  1.根据客户类型，生成相应SQL 
		//01 公司客户需通过证件类型、证件号码检查是否在CI表中存在信息	
		if(customerType.substring(0,2).equals("01")){
			sqlStr = 	" select CustomerID,CustomerType," +
					"getItemName('CustomerType',CustomerType) as v.CustomerTypeName," +
					"Status,CustomerName "+
					" from O " +
					"where CertType = :CertType "+
					" and CertID = :CertID ";
			query = bomCustomerInfo.createQuery(sqlStr).setParameter("CertType", certType).setParameter("CertID", certID);
		//02 集团客户通过客户名称检查是否在CI表中存在信息
		}else if(customerType.substring(0,2).equals("02")){ 
			sqlStr = 	" select CustomerID,CustomerType," +
					"getItemName('CustomerType',CustomerType) as v.CustomerTypeName,Status,CustomerName "+
					" from O "+
					" where CustomerName = :CustomerName "+
					" and CustomerType = :CustomerType ";
			query = bomCustomerInfo.createQuery(sqlStr).setParameter("CustomerType", customerType).setParameter("CustomerName", customerName);
		//03 个人客户
		}else if(customerType.substring(0,2).equals("03")){
			if(certType.equals("Ind01")){	
				//如果为身份证，则需要作15位，18位身份证转换，然后使用18位的身份证去匹配
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
		// 如果没有指定客户类型，则直接使用证件类型，证件号（和01 公司客户相同）
		}else{
			sqlStr = " select CustomerID,CustomerType," +
					"getItemName('CustomerType',CustomerType) as v.CustomerTypeName,Status,CustomerName "
					+ " from O where CertType = :sCertType and CertID = :sCertID ";
			query = bomCustomerInfo.createQuery(sqlStr).setParameter("sCertID", certID).setParameter("sCertType", certType);
		}
		bos = query.getResultList(false);
		// 获取查询结果
		if(bos!=null&&bos.size()>0){
			BizObject bo = bos.get(0);
			customerID = bo.getAttribute("CustomerID").getString();
			haveCutomerType = bo.getAttribute("CustomerType").getString();
			haveCutomerTypeName = bo.getAttribute("CustomerTypeName").getString();
			status = bo.getAttribute("Status").getString();
			realCustomerName = bo.getAttribute("CustomerName").getString();  
		}
		bos = null;//清空查询结果集
		query = null;
		if(customerID == null) customerID = "";
		if(haveCutomerType == null) haveCutomerType = "";
		if(haveCutomerTypeName == null) haveCutomerTypeName = "";
		if(status == null) status = "";
		if(realCustomerName == null) realCustomerName = "";  
		
		BizObjectManager bomCustomerBelong = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
		tx.join(bomCustomerBelong);
		BizObject countCustomerBelong = null;
		//客户信息检查
		if(customerID.equals("")){//无该客户
			returnStatus = "01";
		}else{//存在该客户，则检查管户权及主办权
			int iCount = 0;
			//获取当前客户是否与当前用户建立了关联
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
			if(iCount > 0){//用户已与该客户建立有效关联
				returnStatus = "02";
			}else{//检查该客户是否有管户人
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
				returnStatus = iCount > 0?"05":"04";//"05"当前用户没有与该客户建立关联,但和其他客户建立主办权,"04"当前用户没有与该客户建立关联,且没有和任何客户建立主办权
			}

			returnStatus = returnStatus+"@"+customerID+"@"+haveCutomerType+"@"+haveCutomerTypeName+"@"+status +"@"+realCustomerName;
		}
		return returnStatus;
	}
}
