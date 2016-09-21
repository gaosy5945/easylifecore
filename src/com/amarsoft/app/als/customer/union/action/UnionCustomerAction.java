package com.amarsoft.app.als.customer.union.action;

import java.util.List;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.union.model.UnionInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
/**
 * 客户群通用Action
 * @author wmZhu
 * @date 2014/04/11
 */
public class UnionCustomerAction {
	private String unionID;
	private String unionName;
	private String customerID;
	private String userID;
	private String orgID;
	private String status;
	
	/**
	 * 检查成员是否已经存在于其它有效客户群内
	 * @return
	 * @throws JBOException
	 */
	public String checkMemberExist() throws JBOException{
		String result = "false";
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.GROUP_MEMBER_RELATIVE);
		int iCount = bom.createQuery("Select CI.CustomerID from O,"+CustomerConst.CUSTOMER_INFO+" CI where O.GroupID=CI.CUSTOMERID" +
				" and CI.STATUS='10' and O.MemberCustomerID=:customerID")
				.setParameter("customerID", customerID).getTotalCount();
		if(iCount > 0){
			result = "true";
		}
		return result;
	}
	
	/**
	 * 检查客户群名称是否已经存在
	 * @return
	 * @throws JBOException
	 */
	public String checkUnionName() throws JBOException{
		String result = "false";
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_INFO);
		int iCount = bom.createQuery("CustomerName=:customerName and CustomerType = '04' and CustomerID <> :customerID")
				.setParameter("customerName", unionName).setParameter("customerID", unionID).getTotalCount();
		if(iCount > 0){
			result = "true";
		}
		return result;
	}
	
	/**
	 * 保存客户群成员信息
	 * @param tx
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public String saveUnionMember(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bom = JBOFactory.getFactory().getManager(CustomerConst.GROUP_MEMBER_RELATIVE);
			tx.join(bom);
			if(customerID != null && !"".equals(customerID)){
				String[] memberID = customerID.split("@");
				BizObject bo;
				for (String sCustomerID : memberID) {
					bo = bom.newObject();
					bo.setAttributeValue("GROUPID", unionID);
					bo.setAttributeValue("MEMBERCUSTOMERID", sCustomerID);
					bo.setAttributeValue("INPUTDATE", StringFunction.getToday());
					bo.setAttributeValue("INPUTUSERID", userID);
					bo.setAttributeValue("INPUTORGID", orgID);
					bom.saveObject(bo);
				}
			}
		} catch (JBOException e) {
			result = "false";
			try {
				tx.rollback();
			} catch (JBOException e1) {
			}
		}
		return result;
	}
	
	/**
	 * 获取管护人
	 * @return
	 */
	public String getManageUser(){
		UnionInfo ui = new UnionInfo(unionID);
		return ui.getManageUserID();
	}
	
	/**
	 * 设置客户群状态
	 * @return
	 * @throws JBOException 
	 */
	public String setUnionStatus(JBOTransaction tx){
		String result = "true";
		UnionInfo ui = new UnionInfo(unionID, tx);
		ui.setStatus(status);
		try {
			ui.saveUnion();
		} catch (JBOException e) {
			result = "false";
		}
		return result;
	}
	
	/**
	 * 检查成员是否存在其他有效客户群中
	 * @return
	 * @throws JBOException
	 */
	public String checkMember() throws JBOException{
		String result = "false";
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.GROUP_MEMBER_RELATIVE);
		String sql = "O.GROUPID=:unionID and O.MEMBERCustomerID in (select um.MEMBERCustomerID from "+CustomerConst.GROUP_MEMBER_RELATIVE+" um," +
				CustomerConst.CUSTOMER_INFO+" ci where um.GROUPID=ci.CustomerID and ci.Status='10' and um.GROUPID <> :unionID)";
		int iCount = bom.createQuery(sql).setParameter("unionID", this.unionID).getTotalCount();
		if(iCount > 0){
			result = "true";
		}
		return result;
	}
	
	/**
	 * 检查客户是否已存在于本客户群内
	 * @return
	 * @throws JBOException 
	 */
	public String checkInner() throws JBOException{
		String result = "false";
		UnionInfo ui = new UnionInfo(unionID);
		List<BizObject> list = ui.getMemberList();
		BizObject biz;
		String tempCustomerID;
		for (int i = 0; i < list.size(); i++) {
			biz = list.get(i);
			tempCustomerID = biz.getAttribute("MemberCustomerID").getString();
			if(customerID.equals(tempCustomerID)){
				result = "true";
				break;
			}
		}
		return result;
	}
	
	/**
	 * 删除客户群信息
	 * @param tx
	 * @return
	 */
	public String deleteUnion(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bomUM = JBOFactory.getBizObjectManager(CustomerConst.GROUP_MEMBER_RELATIVE);//成员表
			BizObjectManager bomCB = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_BELONG);//权限表
			BizObjectManager bomCI = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_INFO);//信息表
			BizObjectManager bomGI = JBOFactory.getBizObjectManager(CustomerConst.GROUP_INFO);//客户群信息
			tx.join(bomUM);
			tx.join(bomCB);
			tx.join(bomCI);
			tx.join(bomGI);
			//删除成员表
			deleteBizObject(bomUM,"GroupID",false);
			//删除管护信息
			deleteBizObject(bomCB,"CustomerID",false);
			//删除客户群信息
			deleteBizObject(bomGI,"GroupID",false);
			//删除基本信息
			deleteBizObject(bomCI,null,true);
		} catch (JBOException e) {
			result = "false";
		}
		return result;
	}
	
	/**
	 * 删除对象信息
	 * @param manager
	 * @param key
	 * @param isSingleResult 是否只有单条记录
	 */
	private void deleteBizObject(BizObjectManager manager,String key,boolean isSingleResult){
		try {
			if(isSingleResult){//单个结果
				BizObject bizObject = manager.createQuery("CUSTOMERID=:unionID")
						.setParameter("unionID", unionID).getSingleResult(true);
						manager.deleteObject(bizObject);
			}else{//多个结果
				@SuppressWarnings("unchecked")
				List<BizObject> list = manager.createQuery(key+"=:unionID")
						.setParameter("unionID", unionID).getResultList(true);
				if(null != list){
					for(BizObject obj : list){
						manager.deleteObject(obj);
					}
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 引入成员
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public String importMember(JBOTransaction tx){
		String result = "true";
		try {
			//增加成员信息
			BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.GROUP_MEMBER_RELATIVE);
			tx.join(bom);
			BizObject biz = bom.newObject();
			biz.setAttributeValue("MemberCustomerID", customerID);
			biz.setAttributeValue("GroupID", unionID);
			biz.setAttributeValue("InputOrgID", orgID);
			biz.setAttributeValue("InputUserID", userID);
			biz.setAttributeValue("InputDate", StringFunction.getToday());
			bom.saveObject(biz);
			//更新客户群成员数量
			UnionInfo ui = new UnionInfo(unionID,tx);
			String memberCount = ui.getMemberCount();
			if(memberCount == null || "".equals(memberCount)) memberCount = "0";
			int iCount = Integer.parseInt(memberCount);
			iCount += 1;
			ui.setMemberCount(String.valueOf(iCount));
			ui.saveUnion();
		} catch (JBOException e) {
			result = "false";
		}
		return result;
	}
	
	/**
	 * 移除客户群成员
	 * @param tx
	 * @return
	 */
	public String removeMember(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.GROUP_MEMBER_RELATIVE);
			tx.join(bom);
			BizObject biz = bom.createQuery("GroupID=:unionID and MemberCustomerID=:customerID")
					.setParameter("unionID", unionID).setParameter("customerid", customerID).getSingleResult(true);
			if(biz != null){
				bom.deleteObject(biz);
			}
			//更新客户群成员数量
			UnionInfo ui = new UnionInfo(unionID,tx);
			String memberCount = ui.getMemberCount();
			if(memberCount == null || "".equals(memberCount)) memberCount = "0";
			int iCount = Integer.parseInt(memberCount);
			iCount -= 1;
			ui.setMemberCount(String.valueOf(iCount));
			ui.saveUnion();
		} catch (JBOException e) {
			result = "false";
		}
		return result;
	}
	
	//获取客户群类型
	public String getUnionType(){
		UnionInfo ui = new UnionInfo(unionID);
		return ui.getUnionType();
	}
	
	/**
	 * 移除成员时，检查所在联保体是否存在在途授信申请
	 * @return
	 * @throws JBOException 
	 */
	public String checkMemberApply() throws JBOException{
		String result = "false";
		BizObjectManager bom = JBOFactory.getBizObjectManager(CreditConst.BA_JBOCLASS);
		String sql = "SELECT ba1.customerID FROM O,jbo.app.APPLY_RELATIVE ar,"+CreditConst.BA_JBOCLASS+" ba1 " +
				"where O.serialNo=ar.SerialNo and ar.ObjectNo=ba1.SerialNo and ar.ObjectType='CreditApply' " +
				"and (O.PIGEONHOLEDATE is null or O.PIGEONHOLEDATE='')" +
				"and O.CustomerID=:unionID and ba1.CustomerID=:customerID";
		int iCount = bom.createQuery(sql).setParameter("unionID", this.unionID).setParameter("customerID", this.customerID).getTotalCount();
		if(iCount > 0) result = "true";
		return result;
	}
	

	public String getUnionID() {
		return unionID;
	}
	public void setUnionID(String unionID) {
		this.unionID = unionID;
	}
	public String getCustomerID() {
		return customerID;
	}
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	public String getUnionName() {
		return unionName;
	}
	public void setUnionName(String unionName) {
		this.unionName = unionName;
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
}
