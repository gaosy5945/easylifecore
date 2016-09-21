package com.amarsoft.app.als.afterloan.action;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class FLowTaskCheckFrequencyHandler extends ALSBusinessProcess implements BusinessObjectOWUpdater{

	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		
		String FLOWSERIALNO = businessObject.getString("FLOWSERIALNO");
		String TASKSERIALNO = businessObject.getString("TASKSERIALNO");
		String sCHECKFREQUENCY = businessObject.getString("CHECKFREQUENCY");
		if(FLOWSERIALNO==null) FLOWSERIALNO="";
		if(sCHECKFREQUENCY==null) sCHECKFREQUENCY="";
		
		BizObjectManager ft = JBOFactory.getBizObjectManager("jbo.flow.FLOW_TASK");
		
		BizObjectQuery q =  JBOFactory.getFactory().getManager("jbo.flow.FLOW_OBJECT").createQuery("FlowSerialNo=:FLOWSERIALNO and ObjectType like 'jbo.al.INSPECT_RECORD%'");
		q.setParameter("FLOWSERIALNO", FLOWSERIALNO);
		BizObject bo = q.getSingleResult(false);
		String sInspectSerialNo = bo.getAttribute("ObjectNo").toString();
		String sFlowObjectType = bo.getAttribute("ObjectType").toString();
		if(sInspectSerialNo==null) sInspectSerialNo="";
		if(sFlowObjectType==null) sFlowObjectType="";
		
//		String sContractNoSerialNo = "";
		String sObjectNo = "";
		
		BizObjectQuery query =  JBOFactory.getFactory().getManager("jbo.al.INSPECT_RECORD").createQuery("SerialNo=:IRSerialNo");
		query.setParameter("IRSerialNo", sInspectSerialNo);
		BizObject ir = query.getSingleResult(false);
		
		if(ir!=null){
			sObjectNo = ir.getAttribute("ObjectNo").toString();
		}
		if(sObjectNo==null) sObjectNo="";//借据编号（包括经营类贷款检查）
//		if(sFlowObjectType.equals("jbo.al.INSPECT_RECORD")){//经营类贷款检查
//			sContractNoSerialNo = sObjectNo;
//		}else if(sFlowObjectType.equals("jbo.al.INSPECT_RECORD_02")){//资金用途检查（经营类贷款相关）此时objectNo为借据编号
//			BizObject bd = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL").createQuery("SerialNo=:SerialNo").
//					setParameter("SerialNo", sObjectNo).getSingleResult(false);
//			if(bd!=null){
//				sObjectNo = bd.getAttribute("CONTRACTSERIALNO").toString();
//				sContractNoSerialNo = sObjectNo;
//			}
//		}
//		
//		if(sContractNoSerialNo==null) sContractNoSerialNo="";
		
		BizObject boc2 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL").createQuery("SerialNo=:SerialNo").
				setParameter("SerialNo", sObjectNo).getSingleResult(true);
		if(boc2!=null){
			boc2.setAttributeValue("CHECKFREQUENCY", sCHECKFREQUENCY);
			
			BizObjectManager bmc = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL");
			bmc.saveObject(boc2);
		}
		
		//将页面上的数据更新到数据库
		BizObject ftbo = ft.createQuery("TASKSERIALNO=:TASKSERIALNO and FLOWSERIALNO=:FLOWSERIALNO").setParameter("TASKSERIALNO", TASKSERIALNO)
				        .setParameter("FLOWSERIALNO", FLOWSERIALNO).getSingleResult(false);
		if(ftbo==null){
			BizObject ftnewbo = ft.newObject();
			ftnewbo.setAttributeValue("TASKSERIALNO", TASKSERIALNO);
			ftnewbo.setAttributeValue("FLOWSERIALNO", FLOWSERIALNO);
			ft.saveObject(ftnewbo);
		}		
		ft.createQuery("update O set PHASEACTIONTYPE=:PHASEACTIONTYPE,"
						+ "PHASENO=:PHASENO,PHASENAME=:PHASENAME,PHASEOPINION=:PHASEOPINION,"
						+ "USERID=:USERID,ORGID=:ORGID,USERNAME=:USERNAME,ORGNAME=:ORGNAME,"
						+ "INPUTDATE=:INPUTDATE "+
		               "where TASKSERIALNO=:TASKSERIALNO and FLOWSERIALNO=:FLOWSERIALNO").setParameter("PHASEACTIONTYPE",businessObject.getString("PHASEACTIONTYPE"))
		               .setParameter("PHASENO", businessObject.getString("PHASENO"))
		               .setParameter("PHASENAME", businessObject.getString("PHASENAME"))
		               .setParameter("PHASEOPINION", businessObject.getString("PHASEOPINION"))
		               .setParameter("USERID", businessObject.getString("USERID"))
		               .setParameter("ORGID", businessObject.getString("ORGID"))
		               .setParameter("USERNAME", businessObject.getString("USERNAME"))
		               .setParameter("ORGNAME", businessObject.getString("ORGNAME"))
		               .setParameter("INPUTDATE", businessObject.getString("INPUTDATE"))
		               .setParameter("TASKSERIALNO", TASKSERIALNO).setParameter("FLOWSERIALNO", FLOWSERIALNO).executeUpdate();
		  
		
		/*String objectNo = businessObject.getString("ObjectNo");
		BusinessObject bc=businessProcess.getBusinessObjectManager().keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", objectNo);
		bc.setAttributeValue("CHECKFREQUENCY", sCHECKFREQUENCY);
		businessProcess.getBusinessObjectManager().updateBusinessObject(bc);*/
		return null;
	}

	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
}
