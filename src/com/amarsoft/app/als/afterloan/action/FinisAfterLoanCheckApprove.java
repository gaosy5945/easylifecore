package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

/**
 * 完成流程审批时 改变状态为完成
 * @author 张万亮
 *
 */
public class FinisAfterLoanCheckApprove{
	
	private String status;
	private String serialNo;
	
	public String getStatus() {
		return status;
	}



	public void setStatus(String status) {
		this.status = status;
	}



	public String getSerialNo() {
		return serialNo;
	}



	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String finishInspectRecord(JBOTransaction tx) throws Exception{
		String objectType = "",objectNo = "",flowSerialNo = "",checkFrequency = "";
		BizObjectManager bd = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		tx.join(bd);
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.INSPECT_RECORD");
		tx.join(bm);
		bm.createQuery("UPDATE O SET STATUS = '3',UPDATEDATE='"+StringFunction.getToday()+"',OPERATEDATE='"+StringFunction.getToday()+"' WHERE SERIALNO = :SERIALNO")
		.setParameter("SERIALNO", serialNo).executeUpdate();
		BizObjectQuery arq = bm.createQuery("SerialNo=:SerialNo");
		arq.setParameter("SerialNo", serialNo);
		BizObject bms = arq.getSingleResult(false);
		BizObjectQuery fo =  JBOFactory.getFactory().getManager("jbo.flow.FLOW_OBJECT").createQuery("ObjectNo=:ObjectNo and ObjectType like 'jbo.al.INSPECT_RECORD%'");
		fo.setParameter("ObjectNo", serialNo);
		BizObject fos = fo.getSingleResult(false);
		if(fos != null){
			flowSerialNo = fos.getAttribute("FlowSerialNo").getString();
			BizObjectQuery ft =  JBOFactory.getFactory().getManager("jbo.flow.FLOW_TASK").createQuery("FlowSerialNo=:FlowSerialNo order by TaskSerialNo desc");//desc?
			ft.setParameter("FlowSerialNo", flowSerialNo);
			BizObject fts = ft.getSingleResult(false);
			if(fts != null){
				checkFrequency = fts.getAttribute("PhaseAction1").getString();
				if(checkFrequency == null) checkFrequency = "";
			}
		}
		if(bms != null){
			objectType = bms.getAttribute("ObjectType").getString();
			objectNo = bms.getAttribute("ObjectNo").getString();
			if(objectType.indexOf("jbo.prj.PRJ_BASIC_INFO") > -1){
				/*BizObjectManager prj = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
				tx.join(prj);
					
				*/
				
			}else{
				bd.createQuery("UPDATE O SET CHECKFREQUENCY = :CHECKFREQUENCY where SerialNo = :SerialNo")
				.setParameter("CHECKFREQUENCY", checkFrequency).setParameter("SerialNo", objectNo).executeUpdate();
			}
		}
		
		
		return "检查完成";
	}
}
