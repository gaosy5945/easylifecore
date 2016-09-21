package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

/**
 * 添加新客户信息
 * @author 核算 2015/12/10 重新整理此类
 */
public class AddCustomerAction{
	/*
	  * 客户类型
	 *	<li>01 公司客户</li> 
	 *		<li>0110 大型企业</li>
	 *		<li>0120 中小企业</li>  
	 *	<li>02 集团客户</li>  
	 *		<li>0210 实体集团</li>  
	 *		<li>0220 虚拟集团</li>  
	 *	<li>03 个人客户</li>  
	 *		<li>0310 个人客户</li>  
	 *		<li>0320 个体经营户</li>
	 * */
	private String customerType;
	private String customerName;// 客户名 
	private String certType;// 证件类型 
	private String certID;// 证件号 
	/*
	 *  客户状态 
	 *	<li>01 无该客户</li>
	 *	<li>02 当前用户已与该客户建立关联</li>
	 *	<li>04 当前用户没有与该客户建立关联,且没有和任何客户建立主办权</li>
	 *	<li>05 当前用户没有与该客户建立关联,但和其他客户建立主办权</li>
	 */
	private String status;
	private String customerID;//客户ID 
	private String customerOrgType;//机构性质 
	private String userID;//用户ID
	private String orgID;// 机构ID
	private String today;// 当天日期
	private String groupType;//集团客户标志 
	private String hasCustomerType;//存在客户类型
	private String nationCode;//证件国别 
	
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
	 * 		<p>Status			:当前客户状态
	 * 			<li>01 无该客户</li>
	 * 			<li>02 当前用户已与该客户建立关联</li>
	 * 			<li>04 当前用户没有与该客户建立关联,且没有和任何客户建立主办权</li>
	 * 			<li>05 当前用户没有与该客户建立关联,但和其他客户建立主办权</li>
	 *		</p>
	 * 		<p>UserID			:用户ID</p>
	 * 		<p>CustomerID		:客户ID</p>
	 * 		<p>OrgID			:机构ID</p>
	 * @return 返回值说明
	 * 		返回状态 1 成功,0 失败
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
		
	   	//根据客户类型设置集团客户类型 
	  	if(customerType.equals("0210")) 
			groupType = "1";//一类集团
	  	else 
			groupType = customerType.equals("0220") ? "2" : "0";
	  	
		//01为无该客户 
	  	if(status.equals("01")){
	  		try{
	  			insertCustomerInfo(customerType,tx);//1.插入CI表
	  			
	  			insertCustomerBelong("1",tx);//2.插入CB表,默认全部相关权限
	  			
	  			//插入ENT_INFO或者IND_INFO表
	  			if(customerType.substring(0,2).equals("01") ||customerType.substring(0,2).equals("02")){//公司客户或者集团客户
	  				insertEntInfo(customerType,certType,tx);
	  			}else if(customerType.substring(0,2).equals("03")){//个人客户
	  				insertIndInfo(certType,tx);
	  			}
	  			sReturn = "1";
			} catch(Exception e){
				throw new Exception("事务处理失败！"+e.getMessage());
			}
		//该客户没有与任何用户建立有效关联
		}else if(status.equals("04")){
			if(hasCustomerType.equals(customerType)){
				String sSql = 	" update O set Channel = '1' where CustomerID =:CustomerID ";//将来源渠道由"2"变成"1"
				bom.createQuery(sSql).setParameter("CustomerID", customerID).executeUpdate();
				insertCustomerBelong("1",tx);//插入CB表,默认全部相关权限
				sReturn = "1";
			}else{
				sReturn = "2";//存在引入客户类型错误
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
	 * 插入数据至CUSTOMER_INFO
	 * @param cusType 客户类型，不同的客户类型，插入的字段会有所不同
	 * @throws Exception 
	 */
  	private void insertCustomerInfo(String cusType,JBOTransaction tx) throws Exception{
  		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
  		tx.join(bom);
  		
		StringBuffer sbSql = new StringBuffer();
		sbSql.append(" insert into O(") 
			.append(" CustomerID,")					//010.客户编号
			.append(" CustomerName,")				//020.客户名称
			.append(" CustomerType,")				//030.客户类型
			.append(" CertType,")					//040.证件类型
			.append(" CertID,")						//050.证件号
			.append(" InputOrgID,")					//060.登记机构
			.append(" InputUserID,")				//070.登记用户
			.append(" InputDate,")					//080.登记日期
			.append(" Channel")						//090.来源渠道
			.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :InputOrgID, :InputUserID, :InputDate, '1')");
		
		BizObjectQuery boq = bom.createQuery(sbSql.toString())
			.setParameter("CustomerID", customerID)
			.setParameter("CustomerName", customerName)
			.setParameter("CustomerType", customerType);
		//集团客户(无证件类型，证件号)
		if(cusType.substring(0,2).equals("02")){
			boq.setParameter("CertType", "").setParameter("CertID", "");
		}else{
			boq.setParameter("CertType", certType).setParameter("CertID", certID);
		}
		boq.setParameter("InputOrgID", orgID).setParameter("InputUserID", userID).setParameter("InputDate", today);
		boq.executeUpdate();
  	}
  	
  	/**
  	 * 插入数据至CUSTOMER_BELONG
  	 * @param attribute [主办权，信息查看权，信息维护权，业务办理权]标志
  	 * @throws Exception
  	 */
  	private void insertCustomerBelong(String attribute,JBOTransaction tx) throws Exception{
  		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
  		tx.join(bom);
  		
  		StringBuffer sbSql = new StringBuffer("");
		sbSql.append("insert into O(")
			.append(" CustomerID,")					//010.客户ID
			.append(" OrgID,")						//020.有权机构ID
			.append(" UserID,")						//030.有权人ID
			.append(" BelongAttribute,")			//040.主办权
			.append(" BelongAttribute1,")			//050.信息查看权
			.append(" BelongAttribute2,")			//060.信息维护权
			.append(" BelongAttribute3,")			//070.业务办理权
			.append(" BelongAttribute4,")			//080.
			.append(" InputOrgID,")					//090.登记机构
			.append(" InputUserID,")				//100.登记人
			.append(" InputDate,")					//110.登记日期
			.append(" UpdateDate")					//120.更新日期
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
  	 * 插入数据至ENT_INFO,不同的客户类型以及证件类型，插入的字段会有区别
  	 * @param cusType 客户类型
  	 * @param entCertType	证件类型
  	 * @throws Exception 
  	 */
  	private void insertEntInfo(String cusType,String entCertType,JBOTransaction tx) throws Exception{
  		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.ENT_INFO");
  		tx.join(bom);
  		StringBuffer sbSql = new StringBuffer("");
  		//先插入通用信息
  		sbSql.append("insert into O(")
			.append(" CustomerID,")					//010.客户ID
			.append(" EnterpriseName,")				//020.客户名称
			.append(" OrgNature,")					//040.机构性质
			.append(" GroupFlag,")					//050.集团客户标志
			.append(" InputUserID,")				//060.登记人
			.append(" InputOrgID,")					//070.登记机构
			.append(" InputDate,")					//080.登记日期
			.append(" UpdateUserID,")				//090.更新人
			.append(" UpdateOrgID,")				//100.更新机构
			.append(" UpdateDate,")					//110.更新日期
			.append(" TempSaveFlag")				//120.暂存标志
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
		
		//再更新特殊信息
  		if(customerType.substring(0,2).equals("01")){//[01] 公司客户
			//证件类型为营业执照
			if(certType.equals("Ent02")){//更新营业执照号
				bom.createQuery("update O set LicenseNo = :LicenseNo where CustomerID = :CustomerID")
					.setParameter("CustomerID", customerID)
					.setParameter("LicenseNo", certID)
					.executeUpdate();
			}else{//其他证件
				bom.createQuery("update O set CorpID = :CorpID where CustomerID = :CustomerID")
				.setParameter("CustomerID", customerID)
				.setParameter("CorpID", certID)
				.executeUpdate();
			}
  		}else if(customerType.substring(0,2).equals("02")){//[02] 关联集团客户
			//更新组织机构代码（系统自动虚拟，同集团客户编号）
  			bom.createQuery("update O set CorpID = :CorpID where CustomerID = :CustomerID")
  				.setParameter("CustomerID", customerID)
  				.setParameter("CorpID", customerID)
  				.executeUpdate();
  		}
  	}
  	
  	/**
  	 * 插入数据至IND_INFO,不同的证件类型，插入的字段会有区别
  	 * @throws Exception 
  	 */
  	private void insertIndInfo(String indCertType,JBOTransaction tx) throws Exception{
  		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.IND_INFO");
  		tx.join(bom);
  		String sCertID18 = "";
  		StringBuffer sbSql = new StringBuffer("");
  		//如果为身份证,则作18位转换
  		sCertID18 = indCertType.equals("Ind01")?StringFunction.fixPID(certID):"";
		
		sbSql.append("insert into O(")
		.append(" CustomerID,")					//010.客户ID
		.append(" FullName,")					//020.客户名
		.append(" CertType,")					//030.证件类型
		.append(" CertID,")						//040.证件号
		.append(" CertID18,")					//050.18位证件号
		.append(" NationCode,")				//证件国别
		.append(" InputOrgID,")					//060.登记机构
		.append(" InputUserID,")				//070.登记人
		.append(" InputDate,")					//080.登记日期
		.append(" UpdateDate,")					//090.更新日期
		.append(" TempSaveFlag")				//100.暂存标志
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
