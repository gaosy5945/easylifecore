package com.amarsoft.app.als.credit.putout.action;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 将出账相关状态更新
 * @author xjzhao
 *
 */
public class UpdatePutOutInfo{
	
	private String userID;
	private String orgID;
	private String putoutSerialNo;
	private String flowStatus;
	
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

	public String getPutoutSerialNo() {
		return putoutSerialNo;
	}

	public void setPutoutSerialNo(String putoutSerialNo) {
		this.putoutSerialNo = putoutSerialNo;
	}

	public String getFlowStatus() {
		return flowStatus;
	}

	public void setFlowStatus(String flowStatus) {
		this.flowStatus = flowStatus;
	}

	/**
	 * 将出账相关状态更新
	 * @param tx
	 * @throws Exception
	 */
	public String update(JBOTransaction tx) throws Exception{
		//生成合同信息
		//查询申请基本信息
		BizObjectManager bpm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
		tx.join(bpm);
		BizObjectQuery bpq = bpm.createQuery("SerialNo=:SerialNo");
		bpq.setParameter("SerialNo", putoutSerialNo);
		BizObject bp = bpq.getSingleResult(true);
		if(bp == null ) throw new Exception("未找到对应申请信息，请检查配置信息！");
		bp.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
		if("1".equals(flowStatus)){
			
		}
		if("3".equals(flowStatus))
		{
			SendLoanInfo sli = new SendLoanInfo();
			sli.setPutoutNo(putoutSerialNo);
			sli.setUserID(userID);
			sli.setOrgID(orgID);
			sli.Determine(tx);
			
		}
		else if("0".equals(flowStatus))
		{
			bp.setAttributeValue("PUTOUTSTATUS", "06");
			bpm.saveObject(bp);
		}
		else
		{
			bp.setAttributeValue("PUTOUTSTATUS", "01");
			bpm.saveObject(bp);
		}
		
		
		return bp.getAttribute("SerialNo").getString();
	}
}
