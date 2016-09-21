package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.dict.als.cache.CodeCache;

/**
 * 获取两个审批节点意见
 * @author xjzhao
 */
public class GetDoublePhase implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager,String paraName, String dataType,BusinessObject otherPara) throws Exception {
		String taskSerialNo = otherPara.getString("TaskSerialNo");
		PreparedStatement ps = null;
		ResultSet rs = null;
		StringBuffer sb =  new StringBuffer(); 
		//sb.append("<list>");
		try
		{
			ps = bomanager.getConnection().prepareStatement("select * from FLOW_TASK where TaskSerialNo = ?");
			ps.setString(1, taskSerialNo);
			rs = ps.executeQuery();
			while(rs.next())
			{
				String[] paraNames = paraName.split("@");
				String value = rs.getString(paraNames[1]);
				value = CodeCache.getItem(paraNames[0], value).getItemAttribute();
				sb.append("<task");
				sb.append(rs.getString("TaskSerialNo"));
				sb.append(">");
				sb.append(value);
				sb.append("</task");
				sb.append(rs.getString("TaskSerialNo"));
				sb.append(">"); 
			}
			rs.close();
			rs = null;
		}finally
		{
			try{
				if(rs != null ) rs.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			try{
				if(ps != null ) ps.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			
		}
		//sb.append("</list>");
		return sb.toString();
	}

}
