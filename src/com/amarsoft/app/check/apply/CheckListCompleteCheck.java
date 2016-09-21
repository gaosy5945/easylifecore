package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * 数据已加载缓存，本类中无需再SQL加载
 * 业务申请信息完整性检查
 * @author xjzhao
 * @since 2014/12/10
 */

public class CheckListCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		BusinessObject fo = (BusinessObject)this.getAttribute("FlowObject");	//获取申请信息
		String phaseNo = (String)this.getAttribute("PhaseNo");//阶段类型

		if(fo == null)
			putMsg("流程基本信息未找到，请检查！");
		else
		{
			List<BusinessObject> fclList = fo.getBusinessObjects("jbo.flow.FLOW_CHECKLIST");
			checkList("申请信息",fclList);
		}
		
		if("loancontrol".equals(phaseNo))
		{
			List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");
			if(baList != null)
			{
				for(BusinessObject ba:baList)
				{
					List<BusinessObject> bcList = ba.getBusinessObjects("jbo.app.BUSINESS_CONTRACT");
					if(bcList != null)
					{
						for(BusinessObject bc:bcList)
						{
							checkList("合同信息",bc.getBusinessObjects("jbo.flow.FLOW_CHECKLIST"));
						}
					}
					
					List<BusinessObject> bpList = ba.getBusinessObjects("jbo.app.BUSINESS_PUTOUT");
					if(bpList != null)
					{
						for(BusinessObject bp:bpList)
						{
							checkList("出账信息",bp.getBusinessObjects("jbo.flow.FLOW_CHECKLIST"));
						}
					}
				}
			}
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
	
	private void checkList(String taskType,List<BusinessObject> fclList) throws Exception
	{
		if(fclList != null)  
		{
			for(BusinessObject fcl:fclList)
			{
				String msg = fcl.getString("CheckItemName");
				if(msg == null) msg = "";
				String status = fcl.getString("Status");
				if("0010".equals(fcl.getString("CheckItem"))){
					if(status == null || "".equals(status)){
						putMsg(taskType+"存在未处理的问题【"+msg.replaceAll("\r", "").replaceAll("\"", "“")+"】，请检查！");
						break;
					}
					Item item = CodeCache.getItem("BPMCheckItemStatus", status);
					if(item == null){
						putMsg(taskType+"存在未处理的问题【"+msg.replaceAll("\r", "").replaceAll("\"", "“")+"】，请检查！");
						break;
					}
					String flag = item.getItemDescribe();
					if(!"true".equalsIgnoreCase(flag)){
						putMsg(taskType+"存在未处理的问题【"+msg.replaceAll("\r", "").replaceAll("\"", "“")+"】，请检查！");
						break;
					}
				}
			}
		}
	}
}
