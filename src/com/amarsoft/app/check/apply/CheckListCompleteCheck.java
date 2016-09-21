package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * �����Ѽ��ػ��棬������������SQL����
 * ҵ��������Ϣ�����Լ��
 * @author xjzhao
 * @since 2014/12/10
 */

public class CheckListCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		BusinessObject fo = (BusinessObject)this.getAttribute("FlowObject");	//��ȡ������Ϣ
		String phaseNo = (String)this.getAttribute("PhaseNo");//�׶�����

		if(fo == null)
			putMsg("���̻�����Ϣδ�ҵ������飡");
		else
		{
			List<BusinessObject> fclList = fo.getBusinessObjects("jbo.flow.FLOW_CHECKLIST");
			checkList("������Ϣ",fclList);
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
							checkList("��ͬ��Ϣ",bc.getBusinessObjects("jbo.flow.FLOW_CHECKLIST"));
						}
					}
					
					List<BusinessObject> bpList = ba.getBusinessObjects("jbo.app.BUSINESS_PUTOUT");
					if(bpList != null)
					{
						for(BusinessObject bp:bpList)
						{
							checkList("������Ϣ",bp.getBusinessObjects("jbo.flow.FLOW_CHECKLIST"));
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
						putMsg(taskType+"����δ��������⡾"+msg.replaceAll("\r", "").replaceAll("\"", "��")+"�������飡");
						break;
					}
					Item item = CodeCache.getItem("BPMCheckItemStatus", status);
					if(item == null){
						putMsg(taskType+"����δ��������⡾"+msg.replaceAll("\r", "").replaceAll("\"", "��")+"�������飡");
						break;
					}
					String flag = item.getItemDescribe();
					if(!"true".equalsIgnoreCase(flag)){
						putMsg(taskType+"����δ��������⡾"+msg.replaceAll("\r", "").replaceAll("\"", "��")+"�������飡");
						break;
					}
				}
			}
		}
	}
}
