package com.amarsoft.app.als.project;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class ApproveFinishUpdateStatus {
	private String status;
	private String serialNo;
	private String flowStatus;
	
	public String getStatus() {
		return status;
	}



	public void setStatus(String status) {
		this.status = status;
	}

	public String getFlowStatus() {
		return flowStatus;
	}

	public void setFlowStatus(String flowStatus) {
		this.flowStatus = flowStatus;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public void lastFinishApprove(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(bm);
		
		//当传过来的flowStatus为0(不同意)时，令status=14(复核否决)，否则status=13(复核通过)
		if("0".equals(flowStatus)){
			status = "14";
		}else{
			status = "13";
		}
		
		//根据流水号判断是否为变更项目
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo").setParameter("ObjectNo", serialNo);
		BizObject bo = q.getSingleResult(false);
		String prjSerialNo = bo.getAttribute("ProjectSerialNo").toString();
		
		//根据prjSerialNo是否为空，判断项目是否为变更项目
		if("".equals(prjSerialNo) || "null".equals(prjSerialNo) || prjSerialNo.length() == 0){
			//当不为变更项目时，直接更新状态为所传状态
			bm.createQuery("UPDATE O SET STATUS = :STATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO = :SERIALNO")
			.setParameter("STATUS", status).setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", serialNo).executeUpdate();
			
		}else{
			//当为变更项目时，首先更新变更的项目状态为所传状态，然后在更新原项目的状态为“已变更”
			bm.createQuery("UPDATE O SET STATUS = :STATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO = :SERIALNO")
			.setParameter("STATUS", status).setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", prjSerialNo).executeUpdate();
			
			bm.createQuery("UPDATE O SET STATUS = :STATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO = :SERIALNO")
			.setParameter("STATUS", "17").setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", serialNo).executeUpdate();
		}
	}
}
