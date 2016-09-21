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
		
		//����������flowStatusΪ0(��ͬ��)ʱ����status=14(���˷��)������status=13(����ͨ��)
		if("0".equals(flowStatus)){
			status = "14";
		}else{
			status = "13";
		}
		
		//������ˮ���ж��Ƿ�Ϊ�����Ŀ
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo").setParameter("ObjectNo", serialNo);
		BizObject bo = q.getSingleResult(false);
		String prjSerialNo = bo.getAttribute("ProjectSerialNo").toString();
		
		//����prjSerialNo�Ƿ�Ϊ�գ��ж���Ŀ�Ƿ�Ϊ�����Ŀ
		if("".equals(prjSerialNo) || "null".equals(prjSerialNo) || prjSerialNo.length() == 0){
			//����Ϊ�����Ŀʱ��ֱ�Ӹ���״̬Ϊ����״̬
			bm.createQuery("UPDATE O SET STATUS = :STATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO = :SERIALNO")
			.setParameter("STATUS", status).setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", serialNo).executeUpdate();
			
		}else{
			//��Ϊ�����Ŀʱ�����ȸ��±������Ŀ״̬Ϊ����״̬��Ȼ���ڸ���ԭ��Ŀ��״̬Ϊ���ѱ����
			bm.createQuery("UPDATE O SET STATUS = :STATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO = :SERIALNO")
			.setParameter("STATUS", status).setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", prjSerialNo).executeUpdate();
			
			bm.createQuery("UPDATE O SET STATUS = :STATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO = :SERIALNO")
			.setParameter("STATUS", "17").setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", serialNo).executeUpdate();
		}
	}
}
