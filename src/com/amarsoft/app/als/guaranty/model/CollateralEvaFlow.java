package com.amarsoft.app.als.guaranty.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * 
 * @author 
 *���ܣ�����ѺƷ��ֵ����
 */
public class CollateralEvaFlow extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{	
		String userID=(String)this.getAttribute("userID");
		String orgID=(String)this.getAttribute("orgID");
		String serialNo=(String)this.getAttribute("SerialNo");

		String objectType = "jbo.app.ASSET_EVALUATE";
		try{
			List<String> objects = new ArrayList<String>();
			objects.add(serialNo);
			
			String flowNo = "S0215.plbs_collateral.Flow_016";
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			String instanceID = "";//FlowHelper.initFlow(objectType, objects,flowNo, flowVersion, userID, orgID,BusinessObject.createBusinessObject(this.getAttributes()), Sqlca.getConnection());
			Sqlca.commit();
			//�����Ƿ�������Ӱ���������ݴ���
			try{
				//OCITransaction trans1 = BPMPInstance.StrtPcsInstnc(instanceID,"N", "", userID, Sqlca.getConnection());
			}catch(Exception ex)
			{
				ex.printStackTrace();
				throw new Exception( "false@"+serialNo +"@ @ @ @ @��������ʧ�ܣ������±��棡");
			}
			
			/*OCITransaction trans = BPMPInstance.PcsInstncRunningTaskQry(instanceID, "Y", 0, 15, Sqlca.getConnection());
			
			Message response = trans.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage();
			List<Message> imessage = response.getFieldByTag("BPMTaskInfoNoCntxt").getFieldArrayValue();
			String phaseNo = imessage.get(0).getFieldValue("AvyDfnId");
			String taskSerialNo = imessage.get(0).getFieldValue("TaskId");
			String functionID = FlowConfig.getFlowModel(flowNo, flowVersion, phaseNo).getString("FunctionID");
			
			return "true@"+serialNo +"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@�����ɹ���";*/
			return "";
		}catch(Exception ex){
			throw ex;
		}
	}
	
}
