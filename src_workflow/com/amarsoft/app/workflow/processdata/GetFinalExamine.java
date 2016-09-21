package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
/**
 * 获取当前处理用户是否有审批权限，如果没有则提交给该机构其他人员。
 * @author xjzhao
 */
public class GetFinalExamine implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager, String paraName, String dataType,BusinessObject otherPara) throws Exception {
		if(bos == null || bos.isEmpty()) return "1";
		String flowSerialNo = otherPara.getString("FlowSerialNo");
		String flowNo = otherPara.getString("FlowNo");
		String flowVersion = otherPara.getString("FlowVersion");
		PreparedStatement ps = null;
		String approveModel="";
		String taskSerialNo="";
		try{
			ps = bomanager.getConnection().prepareStatement("select TaskSerialNo,PhaseAction from FLOW_TASK where FlowSerialNo = ? and PhaseNo in(select PhaseNo from FLOW_MODEL where FlowNo=? and FlowVersion=? and PhaseType=?) order by TaskSerialNo desc ");
			ps.setString(1, flowSerialNo);
			ps.setString(2, flowNo);
			ps.setString(3, flowVersion);
			ps.setString(4, "0050");
			ResultSet rs = ps.executeQuery();
			
			if(rs.next())
			{
				taskSerialNo = rs.getString(1);
				String phaseAction = rs.getString(2);
				if(phaseAction != null && !"".equals(phaseAction))
				{
					Item item = CodeCache.getItem("BPMPhaseAction", phaseAction);
					approveModel = item.getAttribute1();
				}
			}
			rs.close();
			
		}catch(Exception ex)
		{
			throw ex;
		}finally
		{
			if(ps != null) ps.close();
		}

		String flag = otherPara.getString("PhaseAction");
		
		if("0".equals(flag) && ("03".equals(approveModel) || "04".equals(approveModel) || "05".equals(approveModel)))
		{
			try{
				ps = bomanager.getConnection().prepareStatement("select count(1) from FLOW_TASK where FlowSerialNo = ? and PhaseNo in(select PhaseNo from FLOW_MODEL where FlowNo=? and FlowVersion=? and PhaseType=?) and TaskSerialNo > ? ");
				ps.setString(1, flowSerialNo);
				ps.setString(2, flowNo);
				ps.setString(3, flowVersion);
				ps.setString(4, "0060");
				ps.setString(5, taskSerialNo);
				ResultSet rs = ps.executeQuery();
				if(rs.next())
				{
					int cnt = rs.getInt(1);
					if(cnt <= 1) flag = "1";
				}
				rs.close();
			}catch(Exception ex)
			{
				throw ex;
			}finally
			{
				if(ps != null) ps.close();
			}
		}
		
		return flag;
	}

}
