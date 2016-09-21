package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;

/**
 * 组合还款方式校验
 * @author bhxiao
 * @since 2015/04/04
 */
public class ApplyRPTSegmentCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
			for(BusinessObject ba:baList)
			{
				String rptTermID = ba.getString("RptTermID");
				double businesssum = ba.getDouble("BusinessSum");
				int businessterm = ba.getInt("BusinessTerm");
				int businesstermDay = ba.getInt("BusinessTermDay");
				if("RPT-06".equals(rptTermID)){
					
					//1、判断正常录入的分段还款方式信息录入规则
					String selectRPTSql = " objectno=:ObjectNo and objecttype=:ObjectType ";
					List<BusinessObject> rptList = bom.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", selectRPTSql, "ObjectNo", ba.getString("SerialNo"),"ObjectType", "jbo.app.BUSINESS_APPLY");
					if(rptList==null||rptList.size()==0){
						this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，但未录入分段的阶段还款信息！");
					}else{
						if(rptList.size()<2||rptList.size()>8){
							this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，在组合还款方式下，至少应该有2个阶段，最多可以有8个阶段！");
						}
						int segendTermTmp = 0;
						double businessSumTmp = 0d;
						String segRPTTermIDTmp = "";
						for(int i=0;i<rptList.size();i++){
							BusinessObject rptInfo = rptList.get(i);
							
							double segRptAmount = rptInfo.getDouble("SegRPTAmount");
							
							int segEndTerm = rptInfo.getInt("SEGToStage");
							if(segendTermTmp == 0){
								segendTermTmp = segEndTerm;
							}else{
								if(segEndTerm>segendTermTmp)
									segendTermTmp = segEndTerm;
							}
							
							if(segEndTerm<=0){
								this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，第{"+i+"}个分段还款信息，结束期次小于或等于0！");
							}
							
							String segRptTermID = rptInfo.getString("SEGRPTTermID");
							if(segRptTermID==null||segRptTermID.length()==0){
								this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，第{"+i+"}个分段还款信息，还款方式录入不能为空！");
							}
							if("5".equals(segRptTermID)){
								if(segRPTTermIDTmp==null||segRPTTermIDTmp.length()==0){
									segRPTTermIDTmp = segRptTermID;
								}
								if(segRptAmount<=0d){
									this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，第{"+i+"}个分段还款信息，还款方式为“固定本金”时，分段信息中“固定本金”小于或等于0！");
								}
							}
							
							if(!"1".equals(segRptTermID)&&!"2".equals(segRptTermID)){
								businessSumTmp += segRptAmount;
							}
							
						}
						
						for(BusinessObject o:rptList){
							String segRptTermID = o.getString("SEGRPTTermID");
							if(segRPTTermIDTmp!=null&&segRPTTermIDTmp.length()>0
								&&!"5".equals(segRptTermID)&&!"3".equals(segRptTermID)){
								this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，如果分段还款信息存在“固定本金”方式，则组合交易所有的方式都必须是“固定本金方式”或者“分次付息方式”！");
								break;
							}
						}
						
						if(businesssum!=businessSumTmp&&segRPTTermIDTmp!=null&&segRPTTermIDTmp.length()>0){
							this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，分段还款信息，“固定本金”总和必须等于贷款申请金额！");
						}
						
						if((businesstermDay<=0&&businessterm!=segendTermTmp)||(businesstermDay>0&&businessterm!=(segendTermTmp+1))){
							this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，分段还款信息，最大“结束期次”必须等于贷款申请期限！");
						}
					}
					
					//2、判断分段还款组件信息中最后一期的录入规则
					String selectRPTSql2 = " objectno=:ObjectNo and objecttype=:ObjectType order by SEGToStage desc ";
					List<BusinessObject> rptList2 = bom.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", selectRPTSql2, "ObjectNo", ba.getString("SerialNo"),"ObjectType", "jbo.app.BUSINESS_APPLY");
					if(rptList2!=null&&rptList2.size()>0){
						BusinessObject endRptInfo = rptList2.get(0);
						String segRptTermID = endRptInfo.getString("SEGRPTTermID");
						if("3".equals(segRptTermID)){
							this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，分段还款信息，“分次付息”不能作为最后一阶段还款方式！");
						}
						
						double segRptAmount = endRptInfo.getDouble("SegRPTAmount");
						if("4".equals(segRptTermID)&&segRptAmount<=0d){
							this.putMsg("申请{"+ba.getString("contractartificialno")+"},录入的还款方式为组合还款，分段还款信息，最后一阶段的最后一期还款方式若选择一次还本时，,最后一个还款阶段的“固定本金”必须大于0！");
						}
					}
				}
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
