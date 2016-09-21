package com.amarsoft.acct.accounting.web;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

public class GetApproveData {
	private String serialno;
	private String objectType;
	private String objectNo;
	private String flowNo;
	private String phaseNo;
	private String userID;
	public String getSerialno() {
		return this.serialno;
	}

	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}
	
	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	
	public String getFlowNo() {
		return flowNo;
	}

	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

	public String getPhaseNo() {
		return phaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}
	//获取审批状态
	public String getFlowState(JBOTransaction tx) throws Exception {
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.FLOW_TASK");
		tx.join(bm);
		BizObjectQuery bq = bm.createQuery("SELECT FlowState as v.FlowState FROM O where SerialNo =:serialno").setParameter("serialno", this.serialno);
		if(bq==null) return "";
		BizObject bo = bq.getSingleResult(false);
		
		String str = null;
		if(bo!=null)
			str=bo.getAttribute("FlowState").toString();
		tx.commit();
		if(StringX.isEmpty(str)) str="";
		return str;
	}
//	//获取业务申请的阶段
//	public String getPhaseNo(JBOTransaction tx)throws Exception{
//		System.out.println("objectType="+objectType+"--------------------objectNo="+objectNo+"================");
//		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.FLOW_OBJECT");
//		tx.join(bm);
//		BizObjectQuery bq = bm.createQuery("select PhaseNo from O where ObjectType =:objectType and ObjectNo =:objectNo")
//				.setParameter("objectType", this.objectType)
//				.setParameter("objectNo", this.objectNo);
//		if(bq==null) return "";
//		String str = bq.getSingleResult(true).toString();
//		tx.commit();
//		if(StringX.isEmpty(str)) str="";
//		return str;
//	}
//	//获取未完成工作的任务流水号
//	public String getUnfinishedTaskNo(JBOTransaction tx)throws Exception{
//		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.FLOW_TASK");
//		tx.join(bm);
//		BizObjectQuery bq = bm.createQuery("select SerialNo from O where ObjectType =:objectType and ObjectNo =:objectNo and FlowNo =:flowNo and PhaseNo = :phaseNo and (PhaseAction is null or PhaseAction='') and UserID =:userID and (EndTime is null or EndTime ='')")
//				.setParameter("objectType", this.objectType)
//				.setParameter("objectNo", this.objectNo)//
//				.setParameter("flowNo", this.flowNo)//
//				.setParameter("phaseNo", this.phaseNo)//
//				.setParameter("userID", this.userID);
//		if(bq==null) return "";
//		String str = bq.getSingleResult(true).toString();
//		tx.commit();
//		if(StringX.isEmpty(str)) str="";
//		return str;
//	}
}
