package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * 判断是否行使知情权否决权
 * @author 张万亮
 */
public class GetIsKnowRight implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager,String paraName, String dataType,BusinessObject otherPara) throws Exception {
		String flowSerialNo = otherPara.getString("FlowSerialNo");
		String taskSerialNo = otherPara.getString("TaskSerialNo");
		String flowVersion = otherPara.getString("FlowVersion");
		String flowNo = otherPara.getString("FlowNo");
		PreparedStatement ft = null;
		PreparedStatement scft = null;
		ResultSet fts = null;
		ResultSet scfts = null;
		String value = "";
		try
		{
			ft = bomanager.getConnection().prepareStatement("select * from FLOW_TASK where FlowSerialNo = ? and TaskSerialNo = ?");
			ft.setString(1, flowSerialNo);
			ft.setString(2, taskSerialNo);
			fts = ft.executeQuery();
			if(fts.next()){
				String phaseActionType = fts.getString("PhaseActionType");
				scft = bomanager.getConnection().prepareStatement("select * from FLOW_TASK where FlowSerialNo = ? and PhaseNo in(select PhaseNo from FLOW_MODEL where FlowNo= ? and FlowVersion= ? and PhaseType='0050') order by TaskSerialNo desc");
				scft.setString(1, flowSerialNo);
				scft.setString(2, flowNo);
				scft.setString(3, flowVersion);
				scfts = scft.executeQuery();
				if(scfts.next()){
					String phaseAction1 = scfts.getString("PhaseAction2");
					if(phaseAction1 == null) phaseAction1 = scfts.getString("PhaseAction1");
					if(phaseAction1 == null) phaseAction1 = "";
					Item item = CodeCache.getItem("BPMPhaseAction", phaseAction1);
					if(item != null){
						if("01".equals(phaseActionType)){
							value = item.getItemAttribute();
						}else{
							value = item.getAttribute1();
						}
					}
				}
			}
		}finally
		{
			try{
				if(fts != null ) fts.close();
				if(scfts != null ) fts.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			try{
				if(ft != null ) ft.close();
				if(scft != null ) scft.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
		return value;
	}

}
