package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.NumberFormat;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * 获取流程任务优先级
 * @author xjzhao
 */
public class GetBusinessPriority implements IProcess {

	public String process(List<BusinessObject> bos,BusinessObjectManager bomanager,String paraName, String dataType,BusinessObject otherPara) throws Exception {
		String result = "99";
		if(bos == null || bos.isEmpty()) return result;
		
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try
		{
			String businessPriority = "99999";
			ps = bomanager.getConnection().prepareStatement("select orderNo from FLOW_TASKORDER where OrderType = 'jbo.app.BUSINESS_TYPE' and RuleID = ? and IsInUse = '1'");
			for(BusinessObject bo:bos)
			{
				String temp = "99";
				Item item = CodeCache.getItem("BusinessPriority", bo.getString("BusinessPriority"));
				if(item != null)
					temp = item.getAttribute1();
				int no = 999;
				String productID = bo.getString("ProductID");
				if(productID == null || "".equals(productID))
				{
					productID = bo.getString("BusinessType");
				}
				ps.setString(1, productID);
				rs = ps.executeQuery();
				if(rs.next())
				{
					no = rs.getInt(1);
				}
				rs.close();
				rs = null;
				
				NumberFormat nf = NumberFormat.getInstance();
				nf.setMaximumFractionDigits(0);
				nf.setMinimumFractionDigits(0);
				nf.setMaximumIntegerDigits(3);
				nf.setMinimumIntegerDigits(3);
				
				temp += nf.format(no);
				
				if(temp.compareTo(businessPriority) < 0)
				{
					businessPriority = temp;
				}
			}
			
			result = businessPriority;
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
		return result;
	}

}
