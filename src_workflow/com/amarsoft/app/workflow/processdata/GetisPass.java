package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

/**
 * ÅÐ¶ÏÊÇ·ñÍ¨¹ý
 * @author À×Í¢
 */

public class GetisPass implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager,String paraName, String dataType,BusinessObject otherPara) throws Exception {
		String taskSerialNo = otherPara.getString("TaskSerialNo");
		String flowSerialNo = otherPara.getString("FlowSerialNo");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String phaseActionType = "";
		ps = bomanager.getConnection().prepareStatement("select PhaseActionType from FLOW_TASK where FlowSerialNo = ? and TaskSerialNo = ?");
		ps.setString(1, flowSerialNo);
		ps.setString(2, taskSerialNo);
		rs = ps.executeQuery();
		if(rs.next()){
			phaseActionType = rs.getString("PhaseActionType");
			if(phaseActionType == null) phaseActionType = "";
		}
		ps.close();rs.close();
		if("01".equals(phaseActionType)){
			return "1";
		}else{
			return "0";
		}
		
	}

}
