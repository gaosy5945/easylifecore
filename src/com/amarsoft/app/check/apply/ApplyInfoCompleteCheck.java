package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 数据已加载缓存，本类中无需再SQL加载
 * 业务申请信息完整性检查
 * @author xjzhao
 * @since 2014/12/10
 */

public class ApplyInfoCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		String taskSerialNo = (String)this.getAttribute("TaskSerialNo");
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				//1、暂存标志为必输项是否录入完整的检查标志
				if(!"0".equals(ba.getString("TempSaveFlag"))){
					putMsg("申请【"+ba.getString("CustomerName")+"】-【合同编号："+ba.getString("ContractArtificialNo")+"】基本信息未录入完整");
				}else{
					int businessTerm = ba.getInt("BusinessTerm");
					int businessTermDay = ba.getInt("BusinessTermDay");
					String maturityDate = ba.getString("MaturityDate");
					String VouchType = ba.getString("VouchType");
					String CreditHLFlag = ba.getString("CreditHLFlag");
					if(CreditHLFlag != null && "1".equals(CreditHLFlag)){
						ASResultSet rateFloat = Sqlca.getResultSet(new SqlObject("select RAT.RateFloat,BAP.BusinessTerm from ACCT_RATE_SEGMENT RAT,BUSINESS_APPROVE BAP where RAT.ObjectType = 'jbo.app.BUSINESS_APPROVE' and RAT.ObjectNo = BAP.SerialNo "
																		+ "and RAT.RateTermID = BAP.LoanRateTermID and RAT.RateType = '01' and BAP.ApplySerialNo = :ApplySerialNo and TaskSerialNo = :TaskSerialNo")
																		.setParameter("ApplySerialNo", ba.getString("SerialNo")).setParameter("TaskSerialNo", taskSerialNo));
						if(businessTerm < 12){
							putMsg("申请【"+ba.getString("CustomerName")+"】-【合同编号："+ba.getString("ContractArtificialNo")+"】的期限少于一年，不能同步办理安居贷！");
						}
						if(rateFloat.next()){
							int bapBusinessTerm = rateFloat.getInt("BusinessTerm");
							if(bapBusinessTerm < 12){
								putMsg("申请【"+ba.getString("CustomerName")+"】-【合同编号："+ba.getString("ContractArtificialNo")+"】要同步办理安居贷，所以批准的期限不能少于一年！");
							}
						}
						rateFloat.close();
					}
					
					if(VouchType == null) VouchType = "";
					String glSerialNo = Sqlca.getString(new SqlObject("select ObjectNo from APPLY_RELATIVE where ApplySerialNo = :ApplySerialNo and RelativeType = '04'").setParameter("ApplySerialNo", ba.getString("SerialNo")));
					if(glSerialNo != null && !"".equals(glSerialNo)){
						String vouchType = Sqlca.getString(new SqlObject("select VouchType from BUSINESS_APPLY where SerialNo = :SerialNo").setParameter("SerialNo", glSerialNo));
						if(vouchType == null) vouchType = "";
						if(!vouchType.equals(VouchType)){
							putMsg("申请【"+ba.getString("CustomerName")+"】额度和首笔业务的担保方式不一致请检查！");
						}
					}
					if(maturityDate != null && !"".equals(maturityDate)){
						
						if(maturityDate.compareTo(DateHelper.getBusinessDate()) <= 0)
						{
							putMsg("申请【"+ba.getString("CustomerName")+"】-【合同编号："+ba.getString("ContractArtificialNo")+"】到期日必须大于当前日期【"+DateHelper.getBusinessDate()+"】。");
						}
						if("500".equals(ba.getString("BusinessType")) || "502".equals(ba.getString("BusinessType")) ||"666".equals(ba.getString("BusinessType"))){
							if(businessTerm+businessTermDay <= 0 || businessTermDay < 0 || businessTerm < 0){
								putMsg("申请【"+ba.getString("CustomerName")+"】-【合同编号："+ba.getString("ContractArtificialNo")+"】期限必须大于0！");
							}
						}
					}
					else
					{
						if(businessTerm+businessTermDay <= 0 || businessTermDay < 0 || businessTerm < 0){
							putMsg("申请【"+ba.getString("CustomerName")+"】-【合同编号："+ba.getString("ContractArtificialNo")+"】期限必须大于0！");
						}
					}
					//如果支付方式为贷款专户则至少录一个受益方账户
					String PaymentType = ba.getString("PaymentType");
					if("3".equals(PaymentType) || "502".equals(ba.getString("BusinessType"))){
						String SerialNo = Sqlca.getString(new SqlObject("select SerialNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_APPLY' and ObjectNo = :ObjectNo and AccountIndicator = '07'").setParameter("ObjectNo", ba.getString("SerialNo")));
						if(SerialNo == null || "".equals(SerialNo)){
							putMsg("申请【"+ba.getString("CustomerName")+"】-【合同编号："+ba.getString("ContractArtificialNo")+"】还未录入受益方账户！");
						}
					}
				}
				
				List<BusinessObject> arbaList = ba.getBusinessObjects("jbo.app.BUSINESS_APPLY");
				if(arbaList != null && !arbaList.isEmpty())
				{
					for(BusinessObject arba:arbaList)
					{
						//1、暂存标志为必输项是否录入完整的检查标志
						if(!"0".equals(arba.getString("TempSaveFlag"))){
							putMsg("申请【"+arba.getString("CustomerName")+"】-【合同编号："+arba.getString("ContractArtificialNo")+"】基本信息未录入完整");
						}else{
							int businessTerm = arba.getInt("BusinessTerm");
							int businessTermDay = arba.getInt("BusinessTermDay");
							String maturityDate = arba.getString("MaturityDate");
							String CreditHLFlag = ba.getString("CreditHLFlag");
							if(CreditHLFlag != null && "1".equals(CreditHLFlag)){
								ASResultSet rateFloat = Sqlca.getResultSet(new SqlObject("select RAT.RateFloat,BAP.BusinessTerm from ACCT_RATE_SEGMENT RAT,BUSINESS_APPROVE BAP where RAT.ObjectType = 'jbo.app.BUSINESS_APPROVE' and RAT.ObjectNo = BAP.SerialNo "
																				+ "and RAT.RateTermID = BAP.LoanRateTermID and RAT.RateType = '01' and BAP.ApplySerialNo = :ApplySerialNo and TaskSerialNo = :TaskSerialNo")
																				.setParameter("ApplySerialNo", arba.getString("SerialNo")).setParameter("TaskSerialNo", taskSerialNo));
								if(businessTerm < 12){
									putMsg("申请【"+arba.getString("CustomerName")+"】-【合同编号："+arba.getString("ContractArtificialNo")+"】的期限少于一年，不能同步办理安居贷！");
								}
								if(rateFloat.next()){
									int bapBusinessTerm = rateFloat.getInt("BusinessTerm");
									if(bapBusinessTerm < 12){
										putMsg("申请【"+arba.getString("CustomerName")+"】-【合同编号："+arba.getString("ContractArtificialNo")+"】要同步办理安居贷，所以批准的期限不能少于一年！");
									}
								}
								rateFloat.close();
							}
							
							if(maturityDate != null && !"".equals(maturityDate)){
								
								if(maturityDate.compareTo(DateHelper.getBusinessDate()) <= 0)
								{
									putMsg("申请【"+arba.getString("CustomerName")+"】-【合同编号："+arba.getString("ContractArtificialNo")+"】到期日必须大于当前日期【"+DateHelper.getBusinessDate()+"】。");
								}
								if("500".equals(arba.getString("BusinessType")) || "502".equals(arba.getString("BusinessType")) ||"666".equals(arba.getString("BusinessType"))){
									if(businessTerm+businessTermDay <= 0 || businessTermDay < 0 || businessTerm < 0){
										putMsg("申请【"+arba.getString("CustomerName")+"】-【合同编号："+arba.getString("ContractArtificialNo")+"】期限必须大于0。");
									}
								}
							}
							else
							{
								if(businessTerm+businessTermDay <= 0 || businessTermDay < 0 || businessTerm < 0){
									putMsg("申请【"+arba.getString("CustomerName")+"】-【合同编号："+arba.getString("ContractArtificialNo")+"】期限必须大于0。");
								}
							}
							//如果支付方式为贷款专户则至少录一个受益方账户
							String PaymentType = arba.getString("PaymentType");
							if("3".equals(PaymentType)  || "502".equals(arba.getString("BusinessType"))){
								String SerialNo = Sqlca.getString(new SqlObject("select SerialNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_APPLY' and ObjectNo = :ObjectNo and AccountIndicator = '07'").setParameter("ObjectNo", arba.getString("SerialNo")));
								if(SerialNo == null || "".equals(SerialNo)){
									putMsg("申请【"+arba.getString("CustomerName")+"】-【合同编号："+arba.getString("ContractArtificialNo")+"】还未录入受益方账户！");
								}
							}
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
}
