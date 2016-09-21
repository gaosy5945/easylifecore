package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 押品价值与估值是否一致检查
 * @author T-zhangwl
 *
 */

public class GuarantyConfirmValueCheck extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception {
		
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet arrs = Sqlca.getResultSet(new SqlObject("Select GR.AssetSerialNo from GUARANTY_RELATIVE GR,APPLY_RELATIVE AR where "
						+ "AR.ApplySerialNo=:BASerialNo and AR.ObjectNo=GR.GCSerialNo and AR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and AR.RelativeType='05'").setParameter("BASerialNo", ba.getString("SerialNo")));
				while(arrs.next()){
					String assetSerialNo = arrs.getStringValue("AssetSerialNo");
					String AEConfirmValue = Sqlca.getString(new SqlObject("select ConfirmValue from ASSET_EVALUATE where AssetSerialNo = :AssetSerialNo order by SerialNo desc").setParameter("AssetSerialNo", assetSerialNo));
					String AIConfirmValue = Sqlca.getString(new SqlObject("select ConfirmValue from ASSET_INFO where SerialNo = :SerialNo").setParameter("SerialNo", assetSerialNo));
					String CLRSerialNo = Sqlca.getString(new SqlObject("select CLRSerialNo from ASSET_INFO where SerialNo = :SerialNo").setParameter("SerialNo", assetSerialNo));
					if(CLRSerialNo == null) CLRSerialNo = "";
					if(AIConfirmValue == null) AIConfirmValue = "";
					//增加押品系统编号为空的提示，否则未完成押品估值提示中的押品系统编号为空，提示不友好
					if(StringX.isEmpty(CLRSerialNo)){
						putMsg("押品系统编号为空，请先保存押品信息！");
					}else{
						if(AEConfirmValue == null){
							putMsg("押品系统编号【"+CLRSerialNo+"】还没有完成押品估值");
						}else{
							//将押品价值和押品评估价值转换为double并重新定义后再进行比较，直接放在if中比较有问题
							double AEConfirmValueD = DataConvert.toDouble(AEConfirmValue);
							double AIConfirmValueD = DataConvert.toDouble(AIConfirmValue);
							if(Math.abs(AEConfirmValueD-AIConfirmValueD) > 0.00000001){
								putMsg("押品系统编号【"+CLRSerialNo+"】的录入押品价值【"+DataConvert.toMoney(AIConfirmValue)+"】与押品系统评估价值【"+DataConvert.toMoney(AEConfirmValue)+"】不一致！");
							}
						}
					}
				}
				arrs.close();
			}
		}
    	/** 返回结果处理 **/
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}
