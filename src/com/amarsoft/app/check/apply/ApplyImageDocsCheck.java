package com.amarsoft.app.check.apply;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 数据已加载缓存，本类中无需再SQL加载
 * 业务资料检查
 * @author zhangwl
 * @since 2014/03/25
 */

public class ApplyImageDocsCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select treedata from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo").setParameter("ObjectNo", ba.getKeyString()).setParameter("ObjectType", ba.getBizClassName()));
				while(rs.next()){
					String treeData = rs.getString(1);
					if(treeData == null || "".equals(treeData))
					{
						putMsg("申请【"+ba.getString("ContractArtificialNo")+"】未上传影像，请先上传。");
					}
				}
				rs.close();
			}
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
