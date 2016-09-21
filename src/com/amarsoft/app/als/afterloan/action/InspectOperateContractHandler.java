package com.amarsoft.app.als.afterloan.action;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 将检查频率更新到对应的借据中
 * @author jqliang
 *
 */
public class InspectOperateContractHandler extends ALSBusinessProcess implements BusinessObjectOWUpdater{

	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		
		String serialNo = businessObject.getString("SerialNo");
		String sCHECKFREQUENCY = businessObject.getString("CHECKFREQUENCY");
		if(serialNo==null) serialNo="";
		if(sCHECKFREQUENCY==null) sCHECKFREQUENCY="";
		
		BizObjectManager ir = JBOFactory.getBizObjectManager("jbo.al.INSPECT_RECORD");
		BizObjectQuery q =  ir.createQuery("SerialNo=:IRSerialNo");
		q.setParameter("IRSerialNo", serialNo);
		BizObject boc1 = q.getSingleResult(false);
		String sDuebillSerialNo = boc1.getAttribute("ObjectNo").toString();
		if(sDuebillSerialNo==null) sDuebillSerialNo="";
		
		BizObjectManager bml = JBOFactory.getFactory().getManager("jbo.acct.ACCT_LOAN");
		BizObject bol = bml.createQuery("SerialNo=:SerialNo").
				setParameter("SerialNo", sDuebillSerialNo).getSingleResult(true);
		
		BizObjectManager bmc = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject boc = bmc.createQuery("SerialNo=:SerialNo").
				setParameter("SerialNo", bol.getAttribute("ContractSerialNo").getString()).getSingleResult(true);
		
		boc.setAttributeValue("CHECKFREQUENCY", sCHECKFREQUENCY);
		
		bmc.saveObject(boc);//将检查频率更新到对应的借据中
		
		//保存页面的数据时至数据库
		ir.createQuery("update O set INSPECTACTION=:INSPECTACTION,ISTORISKMANAGER=:ISTORISKMANAGER,OPINION=:OPINION where SerialNo=:SerialNo").
		   setParameter("INSPECTACTION",businessObject.getString("INSPECTACTION")).setParameter("ISTORISKMANAGER", businessObject.getString("ISTORISKMANAGER"))
		   .setParameter("OPINION", businessObject.getString("OPINION")).setParameter("SerialNo", businessObject.getString("SerialNo")).executeUpdate();
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
