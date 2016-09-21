package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.guaranty.model.GuarantyObjects;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * 担保方式校验
 * @author xjzhao
 * @since 2014/12/10
 */
public class ApplyGurantyCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet arr = Sqlca.getResultSet(new SqlObject("select GC.SerialNo,GC.ContractNo from APPLY_RELATIVE AR,GUARANTY_CONTRACT GC where "
						+ "AR.APPLYSERIALNO = :ObjectNo AND AR.OBJECTTYPE='jbo.guaranty.GUARANTY_CONTRACT' AND AR.OBJECTNO = GC.SERIALNO "
						+ "and GC.GuarantyType in ('02010','02060','040')").setParameter("ObjectNo", ba.getString("SerialNo")));
				while(arr.next()){
					boolean flag1 = false;
					boolean flag = true;
					ASResultSet gr = Sqlca.getResultSet(new SqlObject("select GuarantyAmount,AssetSerialNo from GUARANTY_RELATIVE where GCSerialNo =:GCSerialNo")
							.setParameter("GCSerialNo", arr.getStringValue("SerialNo")));
					while(gr.next()){
						String guarantyAmout = gr.getStringValue("GuarantyAmount");
						/*String clrSerialNo = Sqlca.getString(new SqlObject("select clrSerialNo from ASSET_INFO where SerialNo=:SerialNo").setParameter("SerialNo", gr.getStringValue("AssetSerialNo")));*/
						/*if(!"".equals(guarantyAmout) && guarantyAmout != null && !"".equals(clrSerialNo) && clrSerialNo != null){*/
						if(!"".equals(guarantyAmout) && guarantyAmout != null){
							flag1 = true;
						}else{
							flag = false;
						}
					}
					if(!flag1 || !flag){
						putMsg("申请【"+ba.getString("CustomerName")+"】的担保【"+arr.getStringValue("ContractNo")+"】的押品信息未保存，请保存。");
					}
					/*if(!flag){
						putMsg("申请【"+ba.getString("CustomerName")+"】的担保【"+arr.getStringValue("ContractNo")+"】的押品信息未保存，请保存。");
					}*/
					gr.close();
				}
				arr.close();
				ASResultSet rs = Sqlca.getResultSet(new SqlObject("select O.GuarantorName,PBI.SerialNo,PBI.CustomerID from GUARANTY_CONTRACT O,APPLY_RELATIVE R,PRJ_BASIC_INFO PBI where"
						+ " R.APPLYSERIALNO = :ObjectNo AND R.OBJECTTYPE='jbo.guaranty.GUARANTY_CONTRACT' AND R.OBJECTNO = O.SERIALNO and O.GuarantyType = '01010' and "
						+ "PBI.CustomerID = O.GUARANTORID and PBI.Status = '13'").setParameter("ObjectNo", ba.getString("SerialNo")));
				while(rs.next()){
					ASResultSet rr = Sqlca.getResultSet(new SqlObject("select PBI.ProjectType,PBI.ProjectName,PBI.SerialNo from PRJ_RELATIVE O, PRJ_BASIC_INFO PBI where "
						+ "O.ProjectSerialNo = PBI.SerialNo and O.RelativeType = '01' and O.ObjectType = 'jbo.app.BUSINESS_APPLY' and O.OBJECTNO = :ObjectNo and "
						+ "PBI.CustomerID = :CustomerID").setParameter("ObjectNo", ba.getString("SerialNo")).setParameter("CustomerID", rs.getStringValue("CustomerID")));
					boolean flagPRJ = false;
					if(rr.next()){
						flagPRJ = true;
					}
					if(!flagPRJ && !"555".equals(ba.getString("BusinessType"))){
						putMsg("申请【"+ba.getString("CustomerName")+"】的担保中的法人保证【"+rs.getStringValue("GuarantorName")+"】项下含有已生效的合作项目，但是在合作项目中未引入，请检查！");
					}
					rr.close();
				}
				rs.close();
				
				
				String guarantyTypeAll = "00000";
				String vouchType = ba.getString("VouchType");
				if(vouchType == null || "".equals(vouchType))
				{
					this.putMsg("担保方式不能为空，请重新录入！");
				}
				else if("D".equals(vouchType)) //信用
				{
					List<BusinessObject> gcList = ba.getBusinessObjects("jbo.guaranty.GUARANTY_CONTRACT");
					if(gcList != null && !gcList.isEmpty())
					{
						putMsg("申请【"+ba.getString("CustomerName")+"】的担保方式【"+CodeCache.getItemName("VouchType", vouchType)+"】不需要录入担保信息，请检查！");
					}
					
					guarantyTypeAll = "10000";
				}
				else{
					Item item = CodeCache.getItem("VouchType", vouchType);
					if(item == null) 
					{
						this.putMsg("担保方式不能为空，请重新录入！");
						continue;
					}
					String guarantyTypes = item.getItemDescribe()==null ? "" : item.getItemDescribe(); //包含担保类型
					
					List<BusinessObject> gcList = ba.getBusinessObjects("jbo.guaranty.GUARANTY_CONTRACT");
					if(gcList == null || gcList.isEmpty())
						putMsg("申请【"+ba.getString("CustomerName")+"】的担保方式【"+CodeCache.getItemName("VouchType", vouchType)+"】未录入担保信息，请检查！");
					else
					{
						boolean flag = true;
						String[] guarantyTypeArray = guarantyTypes.split("@");
						int cnt = 0;
						for(BusinessObject gc:gcList)
						{
							if(guarantyTypes.indexOf(gc.getString("GuarantyType")) <= -1)
							{
								flag = false;
							}
							
							for(int i = 0; i <  guarantyTypeArray.length; i ++)
							{
								if(guarantyTypeArray[i].indexOf(gc.getString("GuarantyType")) >= 0)
								{
									guarantyTypeArray[i] = "";
									cnt ++ ;
									break;
								}
							}
							
							if(gc.getString("GuarantyType") != null && gc.getString("GuarantyType").startsWith("010") && !"01020".equals(gc.getString("GuarantyType"))) //保证
							{
								guarantyTypeAll = guarantyTypeAll.substring(0,1)+"1"+guarantyTypeAll.substring(2);
							}
							else if(gc.getString("GuarantyType") != null && "01020".equals(gc.getString("GuarantyType"))) //保证
							{
								guarantyTypeAll = guarantyTypeAll.substring(0,4)+"1";
							}
							else if(gc.getString("GuarantyType") != null && gc.getString("GuarantyType").startsWith("020"))
							{
								guarantyTypeAll = guarantyTypeAll.substring(0,2)+"1"+guarantyTypeAll.substring(3);
							}
							else if(gc.getString("GuarantyType") != null && gc.getString("GuarantyType").startsWith("040"))
							{
								guarantyTypeAll = guarantyTypeAll.substring(0,3)+"1"+guarantyTypeAll.substring(4);
							}
						}
						
						if(guarantyTypeArray.length > 1 && cnt < 2 || !flag)
						{
							putMsg("申请【"+ba.getString("CustomerName")+"】的担保方式【"+CodeCache.getItemName("VouchType", vouchType)+"】与担保信息录入不一致，请修改。");
						}
					}
				}
				
				Sqlca.executeSQL(new SqlObject("update BUSINESS_APPLY set GuarantyType=:GuarantyType where SerialNo=:SerialNo").setParameter("GuarantyType", guarantyTypeAll).setParameter("SerialNo", ba.getString("SerialNo")));
				Sqlca.executeSQL(new SqlObject("update BUSINESS_APPLY set GuarantyType=:GuarantyType where SerialNo in(select ObjectNo from APPLY_RELATIVE where ApplySerialNo = :SerialNo and ObjectType = 'jbo.app.BUSINESS_APPLY')").setParameter("GuarantyType", guarantyTypeAll).setParameter("SerialNo", ba.getString("SerialNo")));
				
				//金额校验********************begin*********************
				//占用金额不得大于担保主债权之和
				ASResultSet arrs = Sqlca.getResultSet(new SqlObject("select O.SerialNo from GUARANTY_CONTRACT O,APPLY_RELATIVE AR where O.ContractStatus in ('01','02') and"
						+ " AR.APPLYSERIALNO = :ObjectNo AND AR.OBJECTTYPE='jbo.guaranty.GUARANTY_CONTRACT' AND AR.OBJECTNO = O.SERIALNO and AR.RelativeType='05' and "
						+ "O.ContractType = '020' and O.GuarantyType in ('02010','02060','040') ").setParameter("ObjectNo", ba.getString("SerialNo")));
				while(arrs.next()){
					String gcSerialNo = arrs.getStringValue("SerialNo");
					GuarantyObjects go = new GuarantyObjects();
					go.load(Sqlca.getConnection(), "jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
					go.calcBalance();
					if(go.RiskMessage.size()>0){
						putMsg(go.RiskMessage.toString());
					}
					else if(go.AlarmMessage.size()>0){
						putMsg(go.AlarmMessage.toString());
					}
				}
				arrs.close();
				//金额校验*********************end**********************
				
				//担保合同必输项
				ASResultSet arrs1 = Sqlca.getResultSet(new SqlObject("select O.SerialNo,O.ContractNo,O.GuarantyValue from GUARANTY_CONTRACT O,APPLY_RELATIVE AR where O.ContractStatus in ('01','02') and"
						+ " AR.APPLYSERIALNO = :ObjectNo AND AR.OBJECTTYPE='jbo.guaranty.GUARANTY_CONTRACT' AND AR.OBJECTNO = O.SERIALNO and AR.RelativeType='05' ").setParameter("ObjectNo", ba.getString("SerialNo")));
				while(arrs1.next()){
					String value = arrs1.getStringValue("GuarantyValue");
					if(StringX.isEmpty(value)){
						putMsg("申请【"+ba.getString("CustomerName")+"】的担保合同【"+arrs1.getStringValue("ContractNo")+"】未录入合同金额！");
					}
				}
				arrs1.close();
			}
		}
		
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}
