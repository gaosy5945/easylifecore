package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
/**
 * 获取当前处理机构是否有审批权限
 * @author xjzhao
 */
public class GetParentOrgAuthorize implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager, String paraName, String dataType,BusinessObject otherPara) throws Exception {
		if(bos == null || bos.isEmpty()) return "1";
		
		String flowSerialNo = otherPara.getString("FlowSerialNo");
		String flowNo = otherPara.getString("FlowNo");
		String flowVersion = otherPara.getString("FlowVersion");
		PreparedStatement ps = null;
		String approveModel="01";
		try{
			ps = bomanager.getConnection().prepareStatement("select PhaseAction from FLOW_TASK where FlowSerialNo = ? and PhaseNo in(select PhaseNo from FLOW_MODEL where FlowNo=? and FlowVersion=? and PhaseType=?) order by TaskSerialNo desc ");
			ps.setString(1, flowSerialNo);
			ps.setString(2, flowNo);
			ps.setString(3, flowVersion);
			ps.setString(4, "0050");
			ResultSet rs = ps.executeQuery();
			
			if(rs.next())
			{
				String phaseAction = rs.getString(1);
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
		
		BusinessObject org = SystemDBConfig.getOrg(otherPara.getString("CurOrgID"));
		
		boolean curAuthorize = FlowHelper.ApproveAuth("1",org.getString("RelativeOrgID"), bos,approveModel, bomanager);
		
		return curAuthorize ? "1" : "0";
	}

}
