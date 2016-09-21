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
 * �ͻ�Ⱥ����
 * @author wmZhu
 * @date 2014/04/11
 */
public class UnionInfo {
	
	private String unionID;//�ͻ�Ⱥ���
	private String unionName;//�ͻ�Ⱥ����
	private String unionType;//�ͻ�Ⱥ����
	private String status;//�ͻ�Ⱥ״̬
	private String memberCount;//��Ա����
	private String manageUserID;//�ܻ���
	private String manageOrgID;//�ܻ�����
	private BizObject unionBiz;//�ͻ�Ⱥ����
	private List<BizObject> memberList;//��Ա�б�
	
	private BizObjectManager bom;
	private BizObjectManager bomCI;
	private BizObject boCI;
	
	/**
	 * ���ظ÷���ֻ�����ڲ�ѯ,�������޸ġ���:�޷�ʹ��saveUnion����
	 * @param unionID
	 */
	public UnionInfo(String unionID){
		this.unionID = unionID;
		init(null,false);
	}
	/**
	 * ����tx����,��Ҫ���ڲ�ѯ����Ҫ�޸Ŀͻ�Ⱥ��Ϣ
	 * @param unionID
	 * @param tx
	 */
	public UnionInfo(String unionID,JBOTransaction tx){
		this.unionID = unionID;
		init(tx,true);
	}
	
	private void init(JBOTransaction tx,boolean paramBoolean){
		try {
			//��ȡ�ͻ�Ⱥ������Ϣ
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
	 * ��ȡ�ܻ���Ϣ
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
