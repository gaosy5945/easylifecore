package com.amarsoft.app.als.customer.union.model;

import java.util.List;

import com.amarsoft.app.als.customer.model.CustomerBelong;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
/**
 * 客户群对象
 * @author wmZhu
 * @date 2014/04/11
 */
public class UnionInfo {
	
	private String unionID;//客户群编号
	private String unionName;//客户群名称
	private String unionType;//客户群类型
	private String status;//客户群状态
	private String memberCount;//成员数量
	private String manageUserID;//管护人
	private String manageOrgID;//管护机构
	private BizObject unionBiz;//客户群对象
	private List<BizObject> memberList;//成员列表
	
	private BizObjectManager bom;
	private BizObjectManager bomCI;
	private BizObject boCI;
	
	/**
	 * 重载该方法只适用于查询,不适用修改。即:无法使用saveUnion方法
	 * @param unionID
	 */
	public UnionInfo(String unionID){
		this.unionID = unionID;
		init(null,false);
	}
	/**
	 * 增加tx参数,主要用于查询后需要修改客户群信息
	 * @param unionID
	 * @param tx
	 */
	public UnionInfo(String unionID,JBOTransaction tx){
		this.unionID = unionID;
		init(tx,true);
	}
	
	private void init(JBOTransaction tx,boolean paramBoolean){
		try {
			//获取客户群基本信息
			bom = JBOFactory.getBizObjectManager(CustomerConst.GROUP_INFO);
			if(tx != null){
				bomCI = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_INFO);
				tx.join(bom);
				tx.join(bomCI);
				boCI = bomCI.createQuery("CustomerID=:customerID").setParameter("customerID", unionID).getSingleResult(true);
			}
			unionBiz = bom.createQuery("GroupID=:groupID").setParameter("groupID", unionID).getSingleResult(paramBoolean);
			if(unionBiz != null){
				this.unionName = unionBiz.getAttribute("GroupName").getString();
				this.unionType = unionBiz.getAttribute("GroupType1").getString();
				this.status = unionBiz.getAttribute("Status").getString();
				this.memberCount = unionBiz.getAttribute("ATT01").getString();
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 获取管护信息
	 */
	private void getManage(){
		try {
			CustomerBelong cb = new CustomerBelong(null, unionID, null);
			String[] manager = cb.getManageUser();
			if(manager != null){
				this.manageUserID = manager[0];
				this.manageOrgID = manager[1];
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}
	
	public void saveUnion() throws JBOException{
			unionBiz.setAttributeValue("GroupName", unionName);
			unionBiz.setAttributeValue("Status", status);
			unionBiz.setAttributeValue("ATT01", memberCount);
			bom.saveObject(unionBiz);
			boCI.setAttributeValue("CustomerName", unionName);
			boCI.setAttributeValue("Status", status);
			bomCI.saveObject(boCI);
	}
	
	public String getUnionID() {
		return unionID;
	}
	public void setUnionName(String unionName){
		this.unionName = unionName;
	}
	public String getUnionName() {
		return unionName;
	}
	public String getUnionType() {
		return unionType;
	}
	public void setStatus(String status){
		this.status = status;
	}
	public String getStatus() {
		return status;
	}
	public void setMemberCount(String memberCount){
		this.memberCount = memberCount;
	}
	public String getMemberCount() {
		return memberCount;
	}
	public String getManageUserID(){
		if(manageUserID == null) getManage();
		return manageUserID;
	}
	public String getManageOrgID() {
		if(manageOrgID == null) getManage();
		return manageOrgID;
	}
	public BizObject getUnionBiz() {
		return unionBiz;
	}
	@SuppressWarnings("unchecked")
	public List<BizObject> getMemberList() {
		try {
			BizObjectManager bomMB = JBOFactory.getBizObjectManager(CustomerConst.GROUP_MEMBER_RELATIVE);
			memberList = bomMB.createQuery("GroupID=:unionID").setParameter("unionID", unionID).getResultList(false);
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return memberList;
	}
	
}
