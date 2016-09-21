package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class GuarantyHalfYearUsedCheck extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception {
		
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		String today = StringFunction.getTodayNow().substring(0,10);
		String usedSerialNo = "";
		String contractArtificialNo = "";
		String duebillSerialNo = "";
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				contractArtificialNo = ba.getString("CONTRACTARTIFICIALNO");
				duebillSerialNo = ba.getString("DUEBILLSERIALNO");
				ASResultSet arrs = Sqlca.getResultSet(new SqlObject("Select distinct GR.AssetSerialNo as AssetSerialNo from GUARANTY_RELATIVE GR,APPLY_RELATIVE AR where "
						+ "AR.ApplySerialNo=:BASerialNo and AR.ObjectNo=GR.GCSerialNo and AR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and AR.RelativeType='05'").setParameter("BASerialNo", ba.getString("SerialNo")));
				while(arrs.next()){
					String assetSerialNo = arrs.getStringValue("AssetSerialNo");
					ASResultSet asrs = Sqlca.getResultSet(new SqlObject("Select AR.ApplySerialNo as ApplySerialNo,BA.OccurDate as OccurDate from GUARANTY_RELATIVE GR,APPLY_RELATIVE AR,BUSINESS_APPLY BA where "
							+ "GR.AssetSerialNo=:AssetSerialNo and GR.GCSerialNo=AR.ObjectNo and AR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and AR.RelativeType='05' and BA.SerialNo=AR.ApplySerialNo").setParameter("AssetSerialNo", assetSerialNo));
					while(asrs.next()){
						String applySerialNo = asrs.getStringValue("ApplySerialNo");
						String serialNo = ba.getString("SerialNo");
						if(applySerialNo.equals(serialNo)){//除去本笔
							continue;
						}
						int months = (int) Math.floor(DateHelper.getMonths(asrs.getStringValue("OccurDate"), today));
						if(months < 6 && usedSerialNo.indexOf(assetSerialNo+",") < 0)
							usedSerialNo += (assetSerialNo+",");
					}
					asrs.close();
					
					ASResultSet acsrs = Sqlca.getResultSet(new SqlObject("Select CR.ContractSerialNo as ContractSerialNo,BC.OccurDate as OccurDate from GUARANTY_RELATIVE GR,CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC where "
							+ "GR.AssetSerialNo=:AssetSerialNo and GR.GCSerialNo=CR.ObjectNo and CR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and CR.RelativeType='05' and BC.SerialNo=CR.ContractSerialNo").setParameter("AssetSerialNo", assetSerialNo));
					while(acsrs.next()){
						String ContractSerialNo = acsrs.getString("ContractSerialNo");
						String CONTRACTARTIFICIALNO = ba.getString("CONTRACTARTIFICIALNO");
						if(ContractSerialNo.equals(CONTRACTARTIFICIALNO)){//除去本笔
							continue;
						}
						if(usedSerialNo.indexOf(assetSerialNo) > -1){//已经在usedSerialNo中存在的押品不需要重复插入
							continue;
						}
						int months = (int) Math.floor(DateHelper.getMonths(acsrs.getStringValue("OccurDate"), today));
						if(months < 6 && usedSerialNo.indexOf(assetSerialNo+",") < 0)
							usedSerialNo += (assetSerialNo+",");
					}
					acsrs.close();
				}
				arrs.close();
			}
			if(!usedSerialNo.equals("")){
				usedSerialNo = usedSerialNo.substring(0, usedSerialNo.length()-1);
				putMsg("押品["+usedSerialNo+"]在半年内曾发生过贷款申请");
				String [] templist = usedSerialNo.split(",");
				for(String temp : templist){
					ASResultSet assinfo = Sqlca.getASResultSet(new SqlObject("select CLRSERIALNO,ASSETTYPE,ASSETNAME from ASSET_INFO where SerialNo = :SerialNo").setParameter("SerialNo", temp));
					if(assinfo.next()){
						String clrSerialNo = assinfo.getStringValue("CLRSERIALNO");
						String assetType = assinfo.getStringValue("ASSETTYPE");
						String assetName = assinfo.getStringValue("ASSETNAME");
						ASResultSet ifhas = Sqlca.getASResultSet(new SqlObject("select SerialNo from CLTR_CHECK_LOG where CONTRACTSERIALNO = :CONTRACTSERIALNO and CLRSERIALNO = :CLRSERIALNO")
						.setParameter("CONTRACTSERIALNO", contractArtificialNo).setParameter("CLRSERIALNO", clrSerialNo));
						if(!ifhas.next()){
							BizObjectManager ccl = JBOFactory.getBizObjectManager("jbo.guaranty.CLTR_CHECK_LOG");
							BizObject crbo = ccl.newObject();
							
							crbo.setAttributeValue("ASSETTYPE", assetType);
							crbo.setAttributeValue("CLRSERIALNO", clrSerialNo);
							crbo.setAttributeValue("ASSETNAME", assetName);
							crbo.setAttributeValue("CONTRACTSERIALNO", contractArtificialNo);
							crbo.setAttributeValue("DUEBILLSERIALNO", duebillSerialNo);
							crbo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
							crbo.setAttributeValue("INPUTTIME", DateHelper.getBusinessTime());
							ccl.saveObject(crbo);
						}
						ifhas.close();
					}
					assinfo.close();
				}
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
