package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

/**
 * 获取流程阶段超时时间
 * @author xjzhao
 */
public class GetTimeOut implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager,String paraName, String dataType,BusinessObject otherPara) throws Exception {
		String result = "40.00";//默认为5个工作日
		if(bos == null || bos.isEmpty()) return result;
		
		
		PreparedStatement ps1 = null,ps2 = null;
		ResultSet rs = null;
		try
		{
			int mi = 0;
			ps1 = bomanager.getConnection().prepareStatement("select TimeOut from FLOW_TIMEOUT where PhaseNo like ? and BusinessType like ?");
			ps2  = bomanager.getConnection().prepareStatement("select TimeOut from FLOW_TIMEOUT where PhaseNo like ? and BusinessType like ? and ProductID like ?");
			for(BusinessObject bo:bos)
			{
				int min = 0;
				String productID = bo.getString("ProductID");
				if(productID == null || "".equals(productID))
				{
					ps1.setString(1, "%"+paraName+"%");
					ps1.setString(2, "%"+bo.getString("BusinessType")+"%");
					rs = ps1.executeQuery();
					if(rs.next())
					{
						min = rs.getInt(1);
					}
					rs.close();
					rs = null;
				}
				else
				{
					ps2.setString(1, "%"+paraName+"%");
					ps2.setString(2, "%"+bo.getString("BusinessType")+"%");
					ps2.setString(3, "%"+bo.getString("ProductID")+"%");
					rs = ps2.executeQuery();
					if(rs.next())
					{
						min = rs.getInt(1);
					}
					rs.close();
					rs = null;
				}
				
				if(min > mi)//取最大
				{
					mi = min;
				}
			}
			if(mi > 0)
				result = mi/60+"."+mi%60;
		}finally
		{
			try{
				if(rs != null ) rs.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			try{
				if(ps1 != null ) ps1.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			try{
				if(ps2 != null ) ps2.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			
		}
		return result;
	}

}
