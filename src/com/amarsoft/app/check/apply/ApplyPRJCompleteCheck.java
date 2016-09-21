package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 数据已加载缓存，本类中无需再SQL加载
 * 业务申请信息完整性检查
 * @author xjzhao
 * @since 2014/12/10
 */

public class ApplyPRJCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet pbi = Sqlca.getResultSet(new SqlObject("select PBI.ProjectType,PBI.ProjectName,PBI.SerialNo from PRJ_RELATIVE O, PRJ_BASIC_INFO PBI where "
						+ "O.ProjectSerialNo = PBI.SerialNo and PBI.PROJECTTYPE = '0110' and O.RelativeType = '01' and O.ObjectType = "
						+ "'jbo.app.BUSINESS_APPLY' and O.OBJECTNO = :ObjectNo").setParameter("ObjectNo", ba.getString("SerialNo")));
				while(pbi.next()){
					//如果关联的合作项目类型是零星期房项目，要校验是否超过设置的最大笔数
					if("0110".equals(pbi.getStringValue("ProjectType"))){
						String serialNo = ba.getString("SerialNo");
						int i = 0;
						//查询零星期房项目关联了多少笔有效的申请（除本笔）
						ASResultSet ra = Sqlca.getResultSet(new SqlObject("select * from PRJ_RELATIVE O, PRJ_BASIC_INFO PBI, BUSINESS_APPLY BA where "
								+ "O.ProjectSerialNo = PBI.SerialNo and PBI.PROJECTTYPE = '0110' and O.RelativeType = '01' and O.ObjectType = "
								+ "'jbo.app.BUSINESS_APPLY' and O.OBJECTNO = BA.SERIALNO and BA.Approvestatus in ('01','02','03') and PBI.SerialNo = "
								+ ":PBISerialNo and BA.SerialNo <> :SerialNo")
								.setParameter("PBISerialNo", pbi.getStringValue("SerialNo"))
								.setParameter("SerialNo", serialNo));
						while(ra.next()){
							i++;
						}
						ra.close();
						//查询设置的最大笔数
						ASResultSet fd = Sqlca.getASResultSet(new SqlObject("select O.MAXBUSINESSNUM from FLOW_DELIVERYHOUSE O where exists (select 1 from ORG_BELONG OB where OB.BelongOrgID = :OrgID and OB.OrgID = O.OrgID)")
						.setParameter("OrgID", ba.getString("OperateOrgID")));
						while(fd.next()){
							int maxBusinessSum = Integer.parseInt(fd.getStringValue("MAXBUSINESSNUM"));
							//如果零星期房项目除本笔就达到最大的设置笔数，则不能再继续申请
							if(i >= maxBusinessSum){
								putMsg("零星期房项目【"+pbi.getStringValue("ProjectName")+"】已超过最大业务笔数不能再做此类业务！");
								break;
							}
						}
						fd.close();
					}
				}
				pbi.close();
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
